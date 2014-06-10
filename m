Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaFJV5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:57:42 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:49850 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFJV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:57:40 -0400
Date: Tue, 10 Jun 2014 22:57:36 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Don Zickus <dzickus@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch V4 11/42] x86, ioapic: kill unused global variable
 timer_through_8259
In-Reply-To: <53967992.2020808@linux.intel.com>
Message-ID: <alpine.LFD.2.11.1406100651500.14982@eddie.linux-mips.org>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com> <1402302011-23642-12-git-send-email-jiang.liu@linux.intel.com> <alpine.LFD.2.11.1406091538320.14982@eddie.linux-mips.org> <53967992.2020808@linux.intel.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Jiang Liu wrote:

> >> index d4aba16e6bbf..94a56c233e87 100644
> >> --- a/arch/x86/kernel/apic/io_apic.c
> >> +++ b/arch/x86/kernel/apic/io_apic.c
> >> @@ -2638,8 +2638,6 @@ static int __init disable_timer_pin_setup(char *arg)
> >>  }
> >>  early_param("disable_timer_pin_1", disable_timer_pin_setup);
> >>  
> >> -int timer_through_8259 __initdata;
> >> -
> >>  /*
> >>   * This code may look a bit paranoid, but it's supposed to cooperate with
> >>   * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
> >> @@ -2744,7 +2742,6 @@ static inline void __init check_timer(void)
> >>  		legacy_pic->unmask(0);
> >>  		if (timer_irq_works()) {
> >>  			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
> >> -			timer_through_8259 = 1;
> >>  			goto out;
> >>  		}
> >>  		/*
> > 
> >  So how does the new NMI watchdog handle systems that use this '8259A 
> > Virtual Wire' mode, pretty common on pre-P6 computers?
> Hi Maciej,
> 	We just kill the useless variable "timer_through_8259", 8259 virtual
> wire mode is still supported.

 No doubt it is useless, the question is why it is unused.  If you tracked 
it down, you'd come up with this change of mine:

commit 35542c5ebced864776d90d83d1e255016fd4c084
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Wed May 21 22:10:22 2008 +0100

    x86: I/O APIC: clean up the 8259A on a NMI watchdog failure

    There is no point in keeping the 8259A enabled if the I/O APIC NMI
    watchdog has failed and the 8259A is not used to pass through regular
    timer interrupts.  This fixes problems with some systems where some logic
    gets confused.

    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

that introduced that variable.  And to answer myself:

commit 072b198a4ad48bd722ec6d203d65422a4698eae7
Author: Don Zickus <dzickus@redhat.com>
Date:   Fri Nov 12 11:22:24 2010 -0500

    x86, nmi_watchdog: Remove all stub function calls from old nmi_watchdog

    Now that the bulk of the old nmi_watchdog is gone, remove all
    the stub variables and hooks associated with it.

    This touches lots of files mainly because of how the io_apic
    nmi_watchdog was implemented.  Now that the io_apic nmi_watchdog
    is forever gone, remove all its fingers.

    Most of this code was not being exercised by virtue of
    nmi_watchdog != NMI_IO_APIC, so there shouldn't be anything to
    risky here.

    Signed-off-by: Don Zickus <dzickus@redhat.com>
    Cc: fweisbec@gmail.com
    Cc: gorcunov@openvz.org
    LKML-Reference: <1289578944-28564-3-git-send-email-dzickus@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

So the I/O APIC watchdog is gone and '8259A Virtual Wire' mode systems are 
not handled anymore.  Well, I guess it was a useful hack for its days, but 
I understand that maintaining that rather hairy code to support a 
minuscule set of old SMP systems (P5 or even i486 UP systems virtually 
never had an I/O APIC, unless you just didn't populate additional 
processor sockets; P5 SMPs were usually only DP though) still in existence 
(mine is still all right, thanks, after 17 years; even the original boxed 
CPU fans work great :) ) was considered not worth it.  Oh well...

 In that case though I think we should clean up some stale comment 
references to that watchdog in arch/x86/kernel/apic/io_apic.c too.  It may 
be worthwhile if code was scrutinised at that time too WRT implicit 
hardware setup dependencies as indicated by these comments, as these 
comments having been left behind clearly indicate that such a step has 
never been made.

 And for the record, your clean-up logically belongs to this change:

commit 5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a
Author: Don Zickus <dzickus@redhat.com>
Date:   Fri Nov 12 11:22:23 2010 -0500

    x86, nmi_watchdog: Remove the old nmi_watchdog

    Now that we have a new nmi_watchdog that is more generic and
    sits on top of the perf subsystem, we really do not need the old
    nmi_watchdog any more.

    In addition, the old nmi_watchdog doesn't really work if you are
    using the default clocksource, hpet.  The old nmi_watchdog code
    relied on local apic interrupts to determine if the cpu is still
    alive.  With hpet as the clocksource, these interrupts don't
    increment any more and the old nmi_watchdog triggers false
    postives.

    This piece removes the old nmi_watchdog code and stubs out any
    variables and functions calls.  The stubs are the same ones used
    by the new nmi_watchdog code, so it should be well tested.

    Signed-off-by: Don Zickus <dzickus@redhat.com>
    Cc: fweisbec@gmail.com
    Cc: gorcunov@openvz.org
    LKML-Reference: <1289578944-28564-2-git-send-email-dzickus@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

that removed the lone use of `timer_through_8259'.  So it's been lingering 
out there for some 3.5 years.  Thanks for sorting this out.

  Maciej
