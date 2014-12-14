Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbaLNTag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 14:30:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbaLNTa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 14:30:28 -0500
Date: Sun, 14 Dec 2014 20:29:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v5] CPU hotplug: active_writer not woken up in some
	cases - deadlock
Message-ID: <20141214192931.GB6372@redhat.com>
References: <1418375504-28715-1-git-send-email-dahi@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418375504-28715-1-git-send-email-dahi@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12, David Hildenbrand wrote:
>
>  void get_online_cpus(void)
>  {
> @@ -103,8 +95,7 @@ void get_online_cpus(void)
>  		return;
>  	cpuhp_lock_acquire_read();
>  	mutex_lock(&cpu_hotplug.lock);
> -	apply_puts_pending(65536);
> -	cpu_hotplug.refcount++;
> +	atomic_inc(&cpu_hotplug.refcount);
>  	mutex_unlock(&cpu_hotplug.lock);

I think the patch is fine.

I am wondering if it makes sense to add

	if (atomic_inc_not_zero(&cpu_hotplug.refcount))
		return;

before mutex_lock(). But even if I am right we can do this later.

Oleg.

