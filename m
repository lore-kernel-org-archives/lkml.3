Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbaLNTVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 14:21:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLNTVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 14:21:47 -0500
Date: Sun, 14 Dec 2014 20:20:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v4] CPU hotplug: active_writer not woken up in some
	cases - deadlock
Message-ID: <20141214192048.GA6372@redhat.com>
References: <1418217721-42919-1-git-send-email-dahi@linux.vnet.ibm.com> <20141210175055.GA11802@redhat.com> <20141212094636.754ab1f8@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212094636.754ab1f8@thinkpad-w530>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12, David Hildenbrand wrote:
>
> > This is subjective, but how about
> >
> > 	static bool xxx(void)
> > 	{
> > 		mutex_lock(&cpu_hotplug.lock);
> > 		if (atomic_read(&cpu_hotplug.refcount) == 0)
> > 			return true;
> > 		mutex_unlock(&cpu_hotplug.lock);
> > 		return false;
> > 	}
> >
> > 	void cpu_hotplug_begin(void)
> > 	{
> > 		cpu_hotplug.active_writer = current;
> >
> > 		cpuhp_lock_acquire();
> > 		wait_event(&cpu_hotplug.wq, xxx());
> > 	}
> >
> > instead?
> >
> > Oleg.
> >
>
> [   50.662459] do not call blocking ops when !TASK_RUNNING; state=2 set at [<000000000017340e>] prepare_to_wait_event+0x7a/0x124
> [   50.662472] ------------[ cut here ]------------
> [   50.662475] WARNING: at kernel/sched/core.c:7301
> [   50.662477] Modules linked in:
> [   50.662482] CPU: 5 PID: 225 Comm: cpu_start_stop. Not tainted 3.18.0+ #59
> [   50.662485] task: 0000000001f94b20 ti: 0000000001ffc000 task.ti: 0000000001ffc000
> ...
>
> Looks like your suggestion won't work. We can only set the task to
> TASK_UNINTERRUPTIBLE after taking the lock.

Yeees, this warning (and wait_woken() helpers) was specially added
to catch/fix the problem like this, sorry for confusion.

Easy to fix, just

	-	mutex_lock(&cpu_hotplug.lock);
	+	if (!mutex_trylock(&cpu_hotplug.lock))
	+		return false;

If .lock is locked then it is hold by get_online_cpus(), and it is going
to increment the counter.

I would like to say that this is what I actually meant but now I can not
recall if this is true ;)

But please ignore. Your next version looks simple/clear enough.

Oleg.

