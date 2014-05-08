Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaEHGEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:04:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64781 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaEHGET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:04:19 -0400
Date: Thu, 8 May 2014 08:04:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86, nmi: Add better NMI stats to /proc/interrupts
 and show handlers
Message-ID: <20140508060414.GB31061@gmail.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
 <1399476883-98970-6-git-send-email-dzickus@redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402956F047E7@G4W3202.americas.hpqcorp.net>
 <20140508012814.GW39568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508012814.GW39568@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Wed, May 07, 2014 at 07:50:48PM +0000, Elliott, Robert (Server Storage) wrote:
> > Don Zickus <dzickus@redhat.com> wrote:
> > > The main reason for this patch is because I have a hard time knowing
> > > what NMI handlers are registered on the system when debugging NMI issues.
> > > 
> > > This info is provided in /proc/interrupts for interrupt handlers, so I
> > > added support for NMI stuff too.  As a bonus it provides stat breakdowns
> > > much like the interrupts.
> > 
> > /proc/interrupts only shows online CPUs, while /proc/softirqs shows 
> > all possible CPUs.  Is there any value in this information for all 
> > possible CPUs? Perhaps a /proc/hardirqs could be created alongside.
> 
> Well if they are not online, they probably won't be generating NMIs, so I
> am not sure there is much value there.
> 
> > 
> > > The only ugly issue is how to label NMI subtypes using only 3 letters
> > > and still make it obvious it is part of the NMI.  Adding a /proc/nmi
> > > seemed overkill, so I choose to indent things by one space.  
> > 
> > The list only shows the currently registered handlers, which may
> > differ from the ones that were registered when the NMIs whose counts 
> > are being displayed occurred. You might want to describe these new 
> > rows and mention that in Documentation/filesystems/proc.txt and 
> > the proc(5) manpage.
> 
> Ok, but that is a /proc/interrupts problem not one specific to NMI, no?
> 
> > 
> > > Sample output is below:
> > > 
> > > [root@dhcp71-248 ~]# cat /proc/interrupts
> > >            CPU0       CPU1       CPU2       CPU3
> > >   0:         29          0          0          0  IR-IO-APIC-edge      timer
> > > <snip>
> > > NMI:         20        774      10986       4227   Non-maskable interrupts
> > >  LOC:         21        775      10987       4228  Local     PMI, arch_bt
> > >  EXT:          0          0          0          0  External  plat
> > >  UNK:          0          0          0          0  Unknown
> > >  SWA:          0          0          0          0  Swallowed
> > 
> > Adding the list of NMI handlers in /proc/interrupts is a bit 
> > inconsistent with the other interrupts, which don't describe their 
> > handlers. It would be helpful to distinguish between a handler 
> > list being present, being present but empty, or not being present.
> > 
> > Maybe use parenthesis like this (using Ingo's suggested format):
> >  NMI:         20        774      10986       4227   Non-maskable interrupts
> >  NLC:         21        775      10987       4228   NMI: Local (PMI, arch_bt)
> >  NXT:          0          0          0          0   NMI: External (plat)
> >  NUN:          0          0          0          0   NMI: Unknown ()
> >  NSW:          0          0          0          0   NMI: Swallowed
> >  LOC:      30374      24749      20795      15095   Local timer interrupts
> > 
> 
> Hmm, looking at /proc/interrupts I see
> 
>   1:     858014      29054      23191       9337   IO-APIC-edge      i8042
>   8:          3         24         10          2   IO-APIC-edge      rtc0
>   9:     387555       9219       8308       7944   IO-APIC-fasteoi   acpi
>  12:    9251360     163811     158846     141916   IO-APIC-edge      i8042
>  16:          0          0          0          0   IO-APIC-fasteoi   mmc0
>  17:         14          5          7         10   IO-APIC-fasteoi 
>  19:       6892        367         13         10   IO-APIC-fasteoi ehci_hcd:usb2, ips, firewire_ohci
>  23:    1363281        753         94         94   IO-APIC-fasteoi ehci_hcd:usb1
> 
> Those may not be specific handlers, but they are registered irq 
> names, no? That basically matches what I was trying to accomplish 
> with NMI.
> 
> I guess I don't see how what I did is much different than what 
> already exists.

The parentheses makes the output more readable, especially as with the 
NMI format it's not quite clear what is 'irq type' and what is 
'handler'.

Might make sense to add parentheses for regular irq handlers as well, 
for consistency and readability.

Thanks,

	Ingo
