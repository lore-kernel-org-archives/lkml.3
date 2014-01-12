Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaALELO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 23:11:14 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:47149 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaALELH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 23:11:07 -0500
From: Sander Eikelenboom <linux@eikelenboom.it>
To: Dave Airlie <airlied@redhat.com>,
        Eiichiro Oiwa <eiichiro.oiwa.nm@hitachi.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>
Subject: In "pci_fixup_video" check if this is or should be the primary video device to prevent setting the IORESOURCE_ROM_SHADOW flag on a secondary VGA card
Date: Sun, 12 Jan 2014 05:10:40 +0100
Message-Id: <1389499841-6097-1-git-send-email-linux@eikelenboom.it>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eiichiro / Dave / Greg,

While trying to get secondary PCI/VGA passthrough of a AMD 6570 card to a Xen guest with the radeon driver and modesetting
i'm running into the problem that the driver says the BIOS is a COMBIOS while it expects a ATOMBIOS for the cards.

So the Guest uses both it's normal emulated VGA card provided by Qemu (f.e. cirrus logic) and a real VGA card via
PCI passthrough.

While debugging it turned out that the bios that the driver read was not the AMD bios, but the bios from the emulated card.
(so it wasn't a COMBIOS either ..)

I first thought the culprit was with Xen, Seabios or Qemu ..
So it took quite a while and debugging, but finally my eye fell on this in the guest dmesg:

[    2.545728] pci 0000:00:00.0: calling quirk_natoma+0x0/0x40
[    2.545730] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.558998] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
[    2.559121] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.572412] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x40
[    2.572415] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.586527] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xd0
[    2.586609] pci 0000:00:03.0: Boot video device
[    2.586696] pci 0000:00:05.0: calling pci_fixup_video+0x0/0xd0
[    2.586827] pci 0000:00:05.0: Boot video device
[    2.586928] pci 0000:00:06.0: calling quirk_e100_interrupt+0x0/0x1c0

It's calling the "pci_fixup_video" quirk ... and it's calling it twice ..
which if i read the comment correctly .. shouldn't be the case:

 /*
 * Fixup to mark boot BIOS video selected by BIOS before it changes
 *
 * From information provided by "Jon Smirl" <jonsmirl@gmail.com>
 *
 * The standard boot ROM sequence for an x86 machine uses the BIOS
 * to select an initial video card for boot display. This boot video
 * card will have it's BIOS copied to C0000 in system RAM.
 * IORESOURCE_ROM_SHADOW is used to associate the boot video
 * card with this copy. On laptops this copy has to be used since
 * the main ROM may be compressed or combined with another image.
 * See pci_map_rom() for use of this flag. IORESOURCE_ROM_SHADOW
 * is marked here since the boot video device will be the only enabled
 * video device at this point.
 */


But the code doesn't check if it's actually the only enabled (or first) video device at that point ..
and it's setting 2 boot video devices and setting both to use the IORESOURCE_ROM_SHADOW at C000 ..
which happens to be the bios from the emulated card.

With this patch applied the passthrough of the card works fine in the guest and dmesg reports:

[    2.167076] pci 0000:00:00.0: calling quirk_natoma+0x0/0x40
[    2.167078] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.179807] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
[    2.179953] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.192953] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x40
[    2.192955] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.206543] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xe0
[    2.206623] pci 0000:00:03.0: Boot video device
[    2.206710] pci 0000:00:05.0: calling pci_fixup_video+0x0/0xe0
[    2.206842] pci 0000:00:06.0: calling quirk_e100_interrupt+0x0/0x1c0

--
Sander

Sander Eikelenboom (1):
  In "pci_fixup_video" check if this is or should be the primary video
    device to prevent setting the IORESOURCE_ROM_SHADOW flag on a
    secondary VGA card

 arch/x86/pci/fixup.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
1.7.10.4

