Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935848Ab3DPQWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:22:42 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35451 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab3DPQWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:22:41 -0400
Date: Tue, 16 Apr 2013 11:22:38 -0500
From: Robin Holt <holt@sgi.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130416162238.GT3658@sgi.com>
References: <20130416095827.GJ3672@sgi.com>
 <20130416113256.GA10452@gmail.com>
 <20130416120624.GO3658@sgi.com>
 <516D72B7.2040608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516D72B7.2040608@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 09:18:07PM +0530, Srivatsa S. Bhat wrote:
> On 04/16/2013 05:36 PM, Robin Holt wrote:
> > On Tue, Apr 16, 2013 at 01:32:56PM +0200, Ingo Molnar wrote:
> >>
> >> * Robin Holt <holt@sgi.com> wrote:
> >>
> >>> We recently noticed that reboot of a 1024 cpu machine takes approx 16
> >>> minutes of just stopping the cpus.  The slowdown was tracked to commit
> >>> f96972f.
> >>>
> >>> The current implementation does all the work of hot removing the cpus
> >>> before halting the system.  We are switching to just migrating to the
> >>> boot cpu and then continuing with shutdown/reboot.
> >>>
> >>> This also has the effect of not breaking x86's command line parameter for
> >>> specifying the reboot cpu.  Note, this code was shamelessly copied from
> >>> arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
> >>> command line parameter.
> >>>
> >>> Signed-off-by: Robin Holt <holt@sgi.com>
> >>> Tested-by: Shawn Guo <shawn.guo@linaro.org>
> >>> To: Ingo Molnar <mingo@redhat.com>
> >>> To: Russ Anderson <rja@sgi.com>
> >>> To: Oleg Nesterov <oleg@redhat.com>
> >>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >>> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> >>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> >>> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> >>> Cc: Michel Lespinasse <walken@google.com>
> >>> Cc: Oleg Nesterov <oleg@redhat.com>
> >>> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >>> Cc: Paul Mackerras <paulus@samba.org>
> >>> Cc: Peter Zijlstra <peterz@infradead.org>
> >>> Cc: Robin Holt <holt@sgi.com>
> >>> Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
> >>> Cc: Tejun Heo <tj@kernel.org>
> >>> Cc: the arch/x86 maintainers <x86@kernel.org>
> >>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>> Cc: <stable@vger.kernel.org>
> >>>
> >>> ---
> >>>
> >>> Changes since -v1.
> >>> - Set PF_THREAD_BOUND before migrating to eliminate potential race.
> >>> - Modified kernel_power_off to also migrate instead of using
> >>>   disable_nonboot_cpus().
> >>> ---
> >>>  kernel/sys.c | 22 +++++++++++++++++++---
> >>>  1 file changed, 19 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/kernel/sys.c b/kernel/sys.c
> >>> index 0da73cf..5ef7aa2 100644
> >>> --- a/kernel/sys.c
> >>> +++ b/kernel/sys.c
> >>> @@ -357,6 +357,22 @@ int unregister_reboot_notifier(struct notifier_block *nb)
> >>>  }
> >>>  EXPORT_SYMBOL(unregister_reboot_notifier);
> >>>  
> >>> +void migrate_to_reboot_cpu(void)
> >>
> >> It appears to be file-scope, so should be static I guess?
> > 
> > Done.
> > 
> >>> +{
> >>> +	/* The boot cpu is always logical cpu 0 */
> >>> +	int reboot_cpu_id = 0;
> >>> +
> >>> +	/* Make certain the cpu I'm about to reboot on is online */
> >>> +	if (!cpu_online(reboot_cpu_id))
> >>> +		reboot_cpu_id = smp_processor_id();
> >>
> >> Shouldn't we pick the first online CPU instead, to make it deterministic?
> > 
> > Done.
> > 
> > 		reboot_cpu_id = cpumask_first(cpu_online_mask);
> > 
> 
> Let me ask again: if CPU 0 (or whatever the preferred reboot cpu is)
> is offline, then why should we even bother pinning the task to (another)
> CPU? Why not just proceed with the reboot?

No idea.  I copied it from the arch/x86 code.  I can not defend it.

Robin
