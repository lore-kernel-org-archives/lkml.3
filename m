Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaLJANc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 19:13:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaLJANb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 19:13:31 -0500
Date: Wed, 10 Dec 2014 01:12:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v3] CPU hotplug: active_writer not woken up in some
	cases - deadlock
Message-ID: <20141210001239.GA516@redhat.com>
References: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry if this was already discussed, I ignored most of my emails
 I got this week)

On 12/09, David Hildenbrand wrote:
>
> @@ -116,7 +118,13 @@ void put_online_cpus(void)
>  	if (cpu_hotplug.active_writer == current)
>  		return;
>  	if (!mutex_trylock(&cpu_hotplug.lock)) {
> +		/* inc before testing for active_writer to not lose wake ups */
>  		atomic_inc(&cpu_hotplug.puts_pending);
> +		spin_lock(&cpu_hotplug.awr_lock);
> +		/* we might be the last one */
> +		if (unlikely(cpu_hotplug.active_writer))
> +			wake_up_process(cpu_hotplug.active_writer);
> +		spin_unlock(&cpu_hotplug.awr_lock);

Not sure I understand. awr_lock can only ensure that active_writer
can't go away.

Why active_writer should see .puts_pending != 0 if this is called
right after cpu_hotplug_begin() takes cpu_hotplug.lock but before
it sets TASK_UNINTERRUPTIBLE?

IOW,

>  void cpu_hotplug_begin(void)
>  {
> +	spin_lock(&cpu_hotplug.awr_lock);
>  	cpu_hotplug.active_writer = current;
> +	spin_unlock(&cpu_hotplug.awr_lock);
>  
>  	cpuhp_lock_acquire();
>  	for (;;) {
>  		mutex_lock(&cpu_hotplug.lock);
> +		__set_current_state(TASK_UNINTERRUPTIBLE);

don't we need set_current_state() here ?

Oleg.

