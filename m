Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaEHB2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 21:28:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbaEHB2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 21:28:41 -0400
Date: Wed, 7 May 2014 21:28:14 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86, nmi: Add better NMI stats to /proc/interrupts
 and show handlers
Message-ID: <20140508012814.GW39568@redhat.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
 <1399476883-98970-6-git-send-email-dzickus@redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402956F047E7@G4W3202.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956F047E7@G4W3202.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 07:50:48PM +0000, Elliott, Robert (Server Storage) wrote:
> Don Zickus <dzickus@redhat.com> wrote:
> > The main reason for this patch is because I have a hard time knowing
> > what NMI handlers are registered on the system when debugging NMI issues.
> > 
> > This info is provided in /proc/interrupts for interrupt handlers, so I
> > added support for NMI stuff too.  As a bonus it provides stat breakdowns
> > much like the interrupts.
> 
> /proc/interrupts only shows online CPUs, while /proc/softirqs shows 
> all possible CPUs.  Is there any value in this information for all 
> possible CPUs? Perhaps a /proc/hardirqs could be created alongside.

Well if they are not online, they probably won't be generating NMIs, so I
am not sure there is much value there.

> 
> > The only ugly issue is how to label NMI subtypes using only 3 letters
> > and still make it obvious it is part of the NMI.  Adding a /proc/nmi
> > seemed overkill, so I choose to indent things by one space.  
> 
> The list only shows the currently registered handlers, which may
> differ from the ones that were registered when the NMIs whose counts 
> are being displayed occurred. You might want to describe these new 
> rows and mention that in Documentation/filesystems/proc.txt and 
> the proc(5) manpage.

Ok, but that is a /proc/interrupts problem not one specific to NMI, no?

> 
> > Sample output is below:
> > 
> > [root@dhcp71-248 ~]# cat /proc/interrupts
> >            CPU0       CPU1       CPU2       CPU3
> >   0:         29          0          0          0  IR-IO-APIC-edge      timer
> > <snip>
> > NMI:         20        774      10986       4227   Non-maskable interrupts
> >  LOC:         21        775      10987       4228  Local     PMI, arch_bt
> >  EXT:          0          0          0          0  External  plat
> >  UNK:          0          0          0          0  Unknown
> >  SWA:          0          0          0          0  Swallowed
> 
> Adding the list of NMI handlers in /proc/interrupts is a bit 
> inconsistent with the other interrupts, which don't describe their 
> handlers. It would be helpful to distinguish between a handler 
> list being present, being present but empty, or not being present.
> 
> Maybe use parenthesis like this (using Ingo's suggested format):
>  NMI:         20        774      10986       4227   Non-maskable interrupts
>  NLC:         21        775      10987       4228   NMI: Local (PMI, arch_bt)
>  NXT:          0          0          0          0   NMI: External (plat)
>  NUN:          0          0          0          0   NMI: Unknown ()
>  NSW:          0          0          0          0   NMI: Swallowed
>  LOC:      30374      24749      20795      15095   Local timer interrupts
> 

Hmm, looking at /proc/interrupts I see

  1:     858014      29054      23191       9337   IO-APIC-edge      i8042
  8:          3         24         10          2   IO-APIC-edge      rtc0
  9:     387555       9219       8308       7944   IO-APIC-fasteoi   acpi
 12:    9251360     163811     158846     141916   IO-APIC-edge      i8042
 16:          0          0          0          0   IO-APIC-fasteoi   mmc0
 17:         14          5          7         10   IO-APIC-fasteoi 
 19:       6892        367         13         10   IO-APIC-fasteoi ehci_hcd:usb2, ips, firewire_ohci
 23:    1363281        753         94         94   IO-APIC-fasteoi ehci_hcd:usb1

Those may not be specific handlers, but they are registered irq names, no?
That basically matches what I was trying to accomplish with NMI. 

I guess I don't see how what I did is much different than what already
exists.


> > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> > index d99f31d..520359c 100644
> > --- a/arch/x86/kernel/irq.c
> > +++ b/arch/x86/kernel/irq.c
> ...
> > +void nmi_show_interrupts(struct seq_file *p, int prec)
> > +{
> > +	int j;
> > +	int indent = prec + 1;
> > +
> > +#define get_nmi_stats(j)	(&per_cpu(nmi_stats, j))
> > +
> > +	seq_printf(p, "%*s: ", indent, "LOC");
> > +	for_each_online_cpu(j)
> > +		seq_printf(p, "%10u ", get_nmi_stats(j)->normal);
> > +	seq_printf(p, " %-8s", "Local");
> > +
> > +	print_nmi_action_name(p, NMI_LOCAL);
> > +
> > +	seq_printf(p, "%*s: ", indent, "EXT");
> > +	for_each_online_cpu(j)
> > +		seq_printf(p, "%10u ", get_nmi_stats(j)->external);
> > +	seq_printf(p, " %-8s", "External");
> > +
> > +	print_nmi_action_name(p, NMI_EXT);
> > +
> > +	seq_printf(p, "%*s: ", indent, "UNK");
> > +	for_each_online_cpu(j)
> > +		seq_printf(p, "%10u ", get_nmi_stats(j)->unknown);
> > +	seq_printf(p, " %-8s", "Unknown");
> > +
> > +	print_nmi_action_name(p, NMI_UNKNOWN);
> > +
> 
> The NMI handler types are in arch/c86/include/asm/nmi.h:
> enum {
>         NMI_LOCAL=0,
>         NMI_UNKNOWN,
>         NMI_SERR,
>         NMI_IO_CHECK,
>         NMI_MAX
> };
> 
> The new code only prints the registered handlers for NMI_LOCAL, 
> NMI_UNKNOWN, and the new NMI_EXT.  Consider adding counters 
> for NMI_SERR and NMI_IO_CHECK and printing their handlers too.
> 
> drivers/watchdog/hpwdt.c is the only code currently in 
> the kernel registering handlers for them.

Yeah, I guess I was trying to remove NMI_SERR and NMI_IO_CHECK.  I forgot
if I accomplished that with this patch set or not.  Instead I had hpwdt do
the ioport read directly instead of having do_default_nmi do it.  I can
look at it again.

Cheers,
Don
