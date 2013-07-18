Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab3GRSV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:21:28 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54174 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619Ab3GRSVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:21:23 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jul 2013 14:21:23 EDT
Date: Thu, 18 Jul 2013 20:13:55 +0200
From: Andreas Mohr <andi@lisas.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: libata / IDE cs5536: 80c cable detect issue (and worse?)
Message-ID: <20130718181355.GA31889@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[CC'd further affected/interested(?) people]

rewriting a private mail for public subsequent discussion
(sprinkling Bartlomiej's prior replies in between... - sorry
for the "challenging" quoting!).

====================

While trying to debug a suspected UDMA config issue on PCM-9375
(some images written end up corrupted,
which quite likely is due to the combined evaluation ending up in dmesg as
UDMA/100 whereas sheets of this vendor quite strictly specify up to 66 only
despite CS5536 doing 100 in general),
I happened to stumble on the following semi-related thing:

| Do you mean that PCM-9375 documentation states that only up to UDMA/66
|   is supported?

: Well, not that strictly after all (it doesn't actively speak out
: against > 66, merely mentions 66 only).
: Dito some other internet results.
: And some even mention UDMA/33 for their two primary port devices
: with a soldered-socket CF / ATA-44 combo.



pata_cs5536.c:

static int cs5536_cable_detect(struct ata_port *ap)
{
        struct pci_dev *pdev = to_pci_dev(ap->host->dev);
        u32 cfg;

        cs5536_read(pdev, CFG, &cfg);

        if (cfg & IDE_CFG_CABLE)
                return ATA_CBL_PATA80;
        else
                return ATA_CBL_PATA40;
}


This, AFAICS, is not correct.

| Could you use ATA_CBL_PATA_UNK here and re-try?
|   (This will cause drive-side detection to trigger.)

: Hmmmm, not that easy. I don't have a readily available custom kernel build
: here, that would require some effort to achieve.



I later found that in cs5536.c commit, you had said:

    * Fix cable detection to report 80-wires cable if BIOS set it for any
      device on a port (IDE core will do drive-side cable detection later).

...except it doesn't ;-P

| IDE and libata have some differences in their cable detection codes. :-P

: If you happen to say so... :)



...at least not in libata (where the same cable_detect logic was done):

static int cable_is_40wire(struct ata_port *ap):

        /* If the controller thinks we are 40 wire, we are. */
        if (ap->cbl == ATA_CBL_PATA40)
                return 1;

        /* If the controller thinks we are 80 wire, we are. */
        if (ap->cbl == ATA_CBL_PATA80 || ap->cbl == ATA_CBL_SATA)
                return 0;
.
.
.
        /* If the controller doesn't know, we scan.
         *
         * Note: We look for all 40 wire detects at this point.  Any
         *       80 wire detect is taken to be 80 wire cable because
         * - in many setups only the one drive (slave if present) will
         *   give a valid detect
         * - if you have a non detect capable drive you don't want it
         *   to colour the choice
         */
        ata_for_each_link(link, ap, EDGE) {
                ata_for_each_dev(dev, link, ENABLED) {
                        if (!ata_is_40wire(dev))
                                return 0;
                }
        }


Note that given a prior ATA_CBL_PATA80 .cable_detect() result,
we're long gone here prior to any ata_is_40wire() scan...


I haven't determined yet whether my BIOS does in fact
configure a mixed-config cable value indication (will gain access tomorrow),
but this handling does seem problematic irrespective of that.

: [no, it doesn't - it has a 0x03 value, i.e. both ports BIOS-advertised as 80c]



Current very experimental commit found below (any comments?
And obviously this would probably have to be corrected in IDE as well...).


In addition to this fix I'm planning to add a DMI quirk to restrict
PCM-9375 to UDMA/66 if this would happen to be an actually most precise way
to successfully fix the observed corruption.

| If the vendor specifies that only UDMA/66 is supported this is a good
| idea.

: This turned out to become more difficult since dmidecode result is... awful
: (merely empty strings for all system ID entries of this box).


| (OTOH the patch below seems to be too restrictive.)

: Let me respectfully and tactfully disagree with that ;)
: I believe we do have an "insufficient API" issue with libata
: since for this controller, speed settings are per-device rather than per-port.
: Thus IMHO we *should* return the combined conservative setting
: (40c in case *any* device is 40c only)
: in order to not end up with an excessively fast setting.
: (OTOH your ATA_CBL_PATA_UNK value suggestion perhaps is more suitable indeed,
: since this then eventually shifts processing to device-side cable detect
: which might be the best handling (though certainly less flexibly complete)
: given current libata limitations.


: BTW, today I discovered even bigger black holes:
: 
: $ grep PCI.*CS5536 *.c
: pata_amd.c:     { PCI_VDEVICE(AMD,      PCI_DEVICE_ID_AMD_CS5536_IDE),
: 9 },
: pata_cs5536.c:  { PCI_VDEVICE(AMD,      PCI_DEVICE_ID_AMD_CS5536_IDE),
: },
: 
: I got hinted at this by an lspci output log which shockingly listed
: that CS5536 IDE was "claimed" by **pata_amd** (only!), on a 2.6.32 kernel,
: i.e. a kernel long after the CS5536-specific pata_cs5536.c was added
: in addition to the prior generic pata_amd.c.
: I don't have lsmod output of that machine yet, but even now it strongly looks
: like this config there does have both drivers and binds to the
: **wrong** one (which quite likely is the actual reason for the
: major data corruption screwup here, when reading between the lines of
: the original patch thread at
: http://www.mail-archive.com/linux-ide@vger.kernel.org/msg11033.html
: (pata_amd most likely will not configure timings correctly,
: which seems to have been the original reason for writing pata_cs5536.c).
: Or would this be merely a limitation of that lspci version listing
: claims for a single module only, yet both modules actually being
: (correctly/rightfully?) loaded?
: I'm planning to *somehow* (even on this hard-coded and older setup)
: achieve getting pata_amd blacklisted tomorrow (blacklisting mechanisms
: are/were very inconvenient and inconsistent),
: to see whether indeed it's a very painful unremoved duplicate PCI ID issue
: (existing since 2007 - I seem to have a good hand for uncovering
: awfully long-standing issues ;-P).
:
: BTW 9272dcc2 "pata_cs5536: Add support for non-X86_32 platforms"
: happened to also mention "pata_amd also supports cs5536 IDE controller"
: - probably someone ought to have managed to realize to voice a complaint
: at that time already ;)



| PS Could we please move this discussion to
| [2]linux-ide@vger.kernel.org
| mailing list if possible?

: Indeed, I should just have done that. I had intended it to be a
: preliminary private inquiry, but the usual consequences of that
: (an ugly rewrite) are just too "challenging".
: I chose to completely rewrite the mail since the reply contained
: some weird non-ASCII indent operations (perhaps weird MUA?).

Thanks!


>From 374506ab6c3a57bd8890b5192b2047d7b96cb542 Mon Sep 17 00:00:00 2001
From: Andreas Mohr <andim2@users.sf.net>
Date: Wed, 17 Jul 2013 18:49:58 +0200
Subject: [PATCH] CS5536: fix overly optimistic cable detect (handle libata
 API imprecision).

We unconditionally indicated 80-pin cable capability
in case *any* of Master/Slave devices had 80c cable presence
configure-indicated by the BIOS.
This, however, does not seem at all appropriate since CS5536
does manage its primary IDE's master/slave devices independently,
both in cable detect and timing programming.
Since libata does not offer API support for such per-device
configurations yet, we really need to restrict things to the lowest
common denominator.

Signed-off-by: Andreas Mohr <andim2@users.sf.net>
---
 drivers/ata/pata_cs5536.c | 34 +++++++++++++++++++++++++++++++---
 1 Datei geändert, 31 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 0448860..f58bf04 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -146,10 +146,38 @@ static int cs5536_cable_detect(struct ata_port *ap)
 
 	cs5536_read(pdev, CFG, &cfg);
 
-	if (cfg & IDE_CFG_CABLE)
-		return ATA_CBL_PATA80;
-	else
+	/*
+	 * FIXME libata API limitation:
+	 * CS5536 data sheet says
+	 * "The IDE interface timing is completely programmable.
+	 * Timing control covers the command active and recover pulse
+	 * widths, and command block register accesses. The IDE
+	 * data transfer speed for each device on each channel can
+	 * be independently programmed allowing high speed IDE
+	 * peripherals to co-exist on the same channel as older,
+	 * compatible devices." and it does have per-drive-separate
+	 * cable detect and timing programming bits for primary Master/Slave
+	 * and in fact some devices (e.g. PCM-9375) do have e.g.
+	 * directly-soldered (read: ~80c) CompactFlash primary Master
+	 * and a 44pin (read: 40c) IDE primary Slave.
+	 * However, libata only offers whole-ata_port cable detect callback
+	 * that's arguably too imprecise for such hardware capabilities.
+	 * Given this imprecision, we arguably are required for now
+	 * to indicate the lowest common denominator, i.e. 40c in case
+	 * *any* of Master/Slave does not indicate 80c support,
+	 * in order to avoid imposing incorrect timing to the
+	 * per-device-separate timing programming.
+	 * This care seems especially important given evidence of
+	 * existing other timing issues of CS5536:
+	 * see errata 47 "UDMA Mode 5 stability issues" in PDF
+	 * "AMD Geode (tm) CS5536 Companion Device Silicon Revision B1
+	 * Specification Update".
+	 */
+	bool have_any_40c_only_device = (cfg & IDE_CFG_CABLE) < IDE_CFG_CABLE;
+	if (have_any_40c_only_device)
 		return ATA_CBL_PATA40;
+	else
+		return ATA_CBL_PATA80;
 }
 
 /**
-- 
1.7.11.7

