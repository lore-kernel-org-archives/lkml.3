Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231Ab3GSM04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:26:56 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:37683 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3GSM0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:26:54 -0400
Date: Fri, 19 Jul 2013 14:26:53 +0200
From: Andreas Mohr <andi@lisas.de>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Andreas Mohr <andi@lisas.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Re: libata / IDE cs5536: 80c cable detect issue (and worse?)
Message-ID: <20130719122653.GA12554@rhlx01.hs-esslingen.de>
References: <20130718181355.GA31889@rhlx01.hs-esslingen.de>
 <20130718182541.GA30707@rhlx01.hs-esslingen.de>
 <21479812.cJNm40xAqz@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21479812.cJNm40xAqz@amdc1032>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:40:38PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday, July 18, 2013 08:25:41 PM Andreas Mohr wrote:
> > Hi,
> > 
> > forgot to mention that I had already added a libata.force=40c boot
> > after my 80c config issue discovery
> > which did successfully cause the "limiting to UDMA/33 due to 40c foo" dmesg
> > yet where there's now initial but strong confirmation via reports
> > that the resulting UDMA/33 limit did NOT manage to fix corruption issues,
> > thus it's more strongly likely that the "bound to ill-suited pata_amd driver"
> > (due to incorrectly configuring speeds, or due to not configuring speeds
> > at all due to possibly BIOS not providing emulation of PCI register accesses
> > to Geode bus, which would be properly supported by pata_cs5536 OTOH)
> > thing is the actual reason and might fix it (fingers crossed).
> 
> UDMA/66 (and higher) requires 80-wire cable to work (if the vendor states
> that UDMA/66 is supported then UDMA/100 should also work on CS5536). UDMA/33
> should work just fine with 40-wire cable. Therefore this indeed sounds more
> like wrong driver being selected issue than a cable problem.


Hohumm, news flash:

We just found out that such image corruption
(not sure yet whether it's an *identical* case of corruption though)
also can occur when having the CF image written by a premium USB combo writer
on a *completely different machine* (should have done that counter check
somewhat earlier, sorry...).
IOW, this quite likely frees the driver from being the culprit
for our specific case, i.e. we're likely talking about a stupid software issue.

BUT, I'm still suspecting that we have a severe case of having the wrong driver activated:

. lsmod:
sd_mod                 25977  2
snd_cs5535audio         6485  0
ata_generic             2239  0
pata_cs5536             2294  0
pata_amd                6641  1
libata                117483  3 ata_generic,pata_cs5536,pata_amd
scsi_mod              106093  2 sd_mod,libata
cs5535_gpio             1756  0

Pray tell me, this does look like pata_cs5536 gets loaded
due to also containing the PCI ID, yet then fails to bind,
as opposed to pata_amd which does (reference count 1)?

We also tried the pata_cs5536.msr=1 boot parm:

[    0.000000] Kernel command line: [..........] pata_cs5536.msr=1 libata.force=40c [............]

, and that did NOT cause the only recognizeable pata_cs5536-triggered
log message
                printk(KERN_ERR DRV_NAME ": Using MSR regs instead of PCI\n");
to occur in dmesg, IOW this driver *is* inactive.

We only had a

[   68.861778] pata_amd 0000:00:0f.2: version 0.4.1
[   68.864570] scsi0 : pata_amd
[   68.865240] scsi1 : pata_amd



So, AFAICS, this leaves us with up to three (perhaps four?) corrections
that one would want to have:

- remove the woefully improper (forgotten!?!) CS5536 ID from pata_amd
  (this correction is what one would want to have, and this would work fine,
  right? Famous last words...)

- do a cable correction patch for libata side (I do think that indicating
  40c if even one device is 40c-only is the way to go [as long as libata
  cannot handle per-device settings], for safety reasons,
  and if so that's probably also preferrable to advertising an UNK value,
  since UNK would skip towards device-side cable detection
  which might be unreliable in case ATA ID values (i.e., ATA_ID_HW_CONFIG)
  happen to be incorrect,
  e.g. especially in the case of CF cards (OTOH it specifically looks
  for a 0x2000 bit being *set* for 80c indication,
  thus it should be reliable after all since you'd expect ignorant/older
  devices to provide zeroed fields only...)

- and what about cable correction patch for IDE side? Since IDE layer
  cable probing sequence algo appears to be different ("why??"),
  this might require advertising a different cable flag

- perhaps pata_cs5536 DMI quirk for that board, in case UDMA/100
  (BIOS reports cable 0x03 value i.e. both 80c) happens to be too fast,
  but given the advanced state of our discussion (pata_cs5536 driver
  even completely inactive!!) and the DMI recognition issues that I reported
  (empty strings) I don't think that's relevant, at least not now


Thanks,

Andreas Mohr
