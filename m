Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3DOP7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:59:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:52327 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab3DOP7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:59:22 -0400
Date: Mon, 15 Apr 2013 10:59:19 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Bulk CPU Hotplug (Was Re: [PATCH] Do not force shutdown/reboot
 to boot cpu.)
Message-ID: <20130415155919.GZ3658@sgi.com>
References: <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130411053106.GA9042@drongo>
 <5166B05E.8010904@linux.vnet.ibm.com>
 <20130411134837.GE3672@sgi.com>
 <20130412053718.GC3887@gmail.com>
 <5167A52F.6020503@linux.vnet.ibm.com>
 <20130412093149.GT3658@sgi.com>
 <20130415101644.GC18024@gmail.com>
 <20130415120216.GX3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415120216.GX3658@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the patches sort-of finished.  The patch set starts by
moving the halt/shutdown/reboot functions over to a new
kernel/reboot.c, next patch gets a checkpatch.pl cleanup to
work, third patch is essentially the below patch against the
new file, and the fourth patch introduces a kernel boot parameter.

That said, I don't like them because of the 'stable' marking for
these patches.  I think I am going submit them with the
existing patch first in the series, then introduce the kernel parameter,
then move them to kernel/reboot.c, and finally pass checkpatch.pl.

Does that sound alright?

Robin

On Mon, Apr 15, 2013 at 07:02:16AM -0500, Robin Holt wrote:
> On Mon, Apr 15, 2013 at 12:16:44PM +0200, Ingo Molnar wrote:
> > 
> > * Robin Holt <holt@sgi.com> wrote:
> > 
> > > From 1767003c943325e52ac78cac6fdbaf2ab638888d Mon Sep 17 00:00:00 2001
> > > From: Robin Holt <holt@sgi.com>
> > > Date: Wed, 3 Apr 2013 13:52:00 -0500
> > > Subject: [PATCH] Migrate shutdown/reboot to boot cpu.
> > > 
> > > We recently noticed that reboot of a 1024 cpu machine takes approx 16
> > > minutes of just stopping the cpus.  The slowdown was tracked to commit
> > > f96972f.
> > > 
> > > The current implementation does all the work of hot removing the cpus
> > > before halting the system.  We are switching to just migrating to the
> > > boot cpu and then calling continuing with shutdown/reboot.
> > > 
> > > This also has the effect of not breaking x86's command line parameter for
> > > specifying the reboot cpu.  Note, this code was shamelessly copied from
> > > arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
> > > command line parameter.
> > > 
> > > Signed-off-by: Robin Holt <holt@sgi.com>
> > > To: Shawn Guo <shawn.guo@linaro.org>
> > > To: Ingo Molnar <mingo@redhat.com>
> > > To: Russ Anderson <rja@sgi.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > > Cc: Michel Lespinasse <walken@google.com>
> > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Robin Holt <holt@sgi.com>
> > > Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: the arch/x86 maintainers <x86@kernel.org>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: <stable@vger.kernel.org>
> > > ---
> > >  kernel/sys.c | 17 +++++++++++++++--
> > >  1 file changed, 15 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/sys.c b/kernel/sys.c
> > > index 0da73cf..4d1047d 100644
> > > --- a/kernel/sys.c
> > > +++ b/kernel/sys.c
> > > @@ -357,6 +357,19 @@ int unregister_reboot_notifier(struct notifier_block *nb)
> > >  }
> > >  EXPORT_SYMBOL(unregister_reboot_notifier);
> > >  
> > > +void migrate_to_boot_cpu(void)
> > > +{
> > > +	/* The boot cpu is always logical cpu 0 */
> > > +	int reboot_cpu_id = 0;
> > > +
> > > +	/* Make certain the cpu I'm about to reboot on is online */
> > > +	if (!cpu_online(reboot_cpu_id))
> > > +		reboot_cpu_id = smp_processor_id();
> > > +
> > > +	/* Make certain I only run on the appropriate processor */
> > > +	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
> > > +}
> > 
> > I guess you suspect what I'm going to suggest next? :-)
> > 
> > While I think something like this commit would be acceptable as a minimal 
> > regression fix, it would be really lovely to add a second patch as well, which 
> > removes the same code from arch/x86/kernel/reboot.c:native_machine_shutdown() and 
> > merged it with the kernel/sys.c version? That way all platforms gained a 
> > reboot_cpu command line, and we'd have less code duplication as well. Win-win.
> > 
> > ( While at it, it might make sense to move the reboot/shutdown related bits from 
> >   kernel/sys.c to a new kernel/shutdown.c or kernel/reboot.c file or so. )
> 
> That all sounds good.  I will work on that this morning.
> 
> Robin
