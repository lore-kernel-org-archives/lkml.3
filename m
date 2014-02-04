Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaBDP3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:29:36 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:38060 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaBDP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:29:33 -0500
Date: Tue, 4 Feb 2014 16:29:32 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [REPORT] i8042 keyboard IRQ lockup (non-permanent!), on 3.8.0-34
 (Ubuntu LTS) x86_64
Message-ID: <20140204152931.GA3785@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

got a Dell Optiplex 9010 i5 here, with ancient HP KB-0133 PS/2 keyboard:

Linux [HOSTNAME] 3.8.0-34-generic #49~precise1-Ubuntu SMP Wed Nov 13 18:05:00 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

which incidentally I'm always suspending to RAM (which may e.g. cause
some quirky I/O register values).

After an uptime of 47 days (equalling perhaps 40 suspends)
it just happened that after some quite possibly frantic (mis-directed)
typing activity in X.Org
keyboard processing locked up, full stop
(with Caps Lock LED accidentally activated, BTW).

Caps Lock was NOT intentional (IOW, pretty much activated right the moment
that it locked up),
so it might be that special (i.e., somewhat non-hotpath)
keyboard mode kernel handling caused IRQ-related things to go haywire
(please also note that this is quad-core SMP).

Symptoms were that i8042 IRQ was NOT incrementing any more,
yet with USB-based mouse still working,
and with i8042 IRQ counts very similar to the current post-lockup status:

# cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  0:         15          0          0          0  IR-IO-APIC-edge      timer
  1:    3731516          1          2          1  IR-IO-APIC-edge      i8042
  4:          2          0          0          0  IR-IO-APIC-edge    
  8:          0          0          0          1  IR-IO-APIC-edge      rtc0
  9:         44          0          0          0  IR-IO-APIC-fasteoi   acpi
 16:        848         51         46          6  IR-IO-APIC-fasteoi   ehci_hcd:usb1
 23:       1030         21         28         27  IR-IO-APIC-fasteoi   ehci_hcd:usb2
 40:          0          0          0          0  DMAR_MSI-edge      dmar0
 41:          0          0          0          0  DMAR_MSI-edge      dmar1
 42:    4706685          4      19241          1  IR-PCI-MSI-edge      xhci_hcd
 43:         26          0          0          0  IR-PCI-MSI-edge      mei
 44:   11758582       1031        737        407  IR-PCI-MSI-edge      ahci
 45:       8634          0          0          0  IR-PCI-MSI-edge      eth0
 46:   16395534    1172456     434192    3091691  IR-PCI-MSI-edge      i915
 47:        149          0          0          0  IR-PCI-MSI-edge      snd_hda_intel
NMI:       4358     191563     192436     199591   Non-maskable interrupts
LOC:   54195238   49071989   50750421   51893922   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:       4358     191563     192436     199591   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:   24539990   11668206    5062037    4591010   Rescheduling interrupts
CAL:        306        729        671        649   Function call interrupts
TLB:    3450457    3374213    3213836    3361641   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:       2957       2942       2942       2942   Machine check polls



Manual pm-suspend via ssh remote login then MANAGED TO FIX IT!

(please also note that Caps Lock stayed lit while suspended,
and then got switched off soon - BIOS-initiated? - during resuming!!)

According to https://bugs.launchpad.net/ubuntu/+source/pm-utils/+bug/23497
a simple unbind/rebind of i8042 instead of a full pm-suspend
might possibly have helped, too (will do further experimentation next time).

Useful ways for more detailed investigation on semi-running system?
(i8042 register dump, etc.)

Will try to have some more "mis-directed frantic typing" joy, perhaps it's
reproducable.

Not demanding much useful discussion given this non-current and non-mainline
kernel version - mainly submitting this as a "data item"
for other people to research and possibly extend
(and not even sure whether this is a kernel issue,
or rather a hardware mishap instead).

keywords: kernel i8042 apic irq lockup keyboard optiplex dell

Thanks,

Andreas Mohr
