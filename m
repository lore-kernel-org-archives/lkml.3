Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3KAOYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:24:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52697 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3KAOYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:24:09 -0400
Date: Fri, 1 Nov 2013 15:24:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, mingo@kernel.org, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] fix race between stop_two_cpus and stop_cpus
Message-ID: <20131101142404.GG19466@laptop.lan>
References: <20131031163144.0fd27457@annuminas.surriel.com>
 <20131101110825.GX2400@suse.de>
 <52739244.3060209@redhat.com>
 <20131101134424.GA32685@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101134424.GA32685@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 01:44:24PM +0000, Mel Gorman wrote:
> Ok, I see your point now but still wonder if this is too specialised
> for what we are trying to do.  Could it have been done with a read-write
> semaphore with the global stop_cpus taking it for write and stop_two_cpus
> taking it for read?

rwsem for read is still global state.. That said it should be fairly
easy to use lglock for this.

Or write it with spinlocks like:

DEFINE_PER_CPU(spinlock_t, local_lock);
DEFINE_PER_CPU(int, have_global);
spinlock_t global_lock;

void local_lock(void)
{
	preempt_disable();
	spin_lock(this_cpu_ptr(&local_lock));
	if (spin_is_locked(&global_lock)) {
		spin_unlock(this_cpu_ptr(&local_lock));
		spin_lock(&global_lock);
		this_cpu_write(have_global, true);
		spin_lock(this_cpu_ptr(&local_lock));
	}
}

void local_unlock(void)
{
	spin_unlock(this_cpu_ptr(&local_lock));
	if (this_cpu_read(have_global)) {
		this_cpu_write(have_global, false);
		spin_unlock(&global_lock);
	}
}

void global_lock(void)
{
	int cpu;

	spin_lock(&global_lock);
	for_each_possible_cpu(cpu)
		spin_unlock_wait(&per_cpu(local_lock, cpu));
}

void global_unlock(void)
{
	spin_unlock(&global_lock);
}

Or possibly make the global_lock a mutex, plenty variants possible.
