Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaC0G5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 02:57:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:47416 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbaC0G5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 02:57:48 -0400
Message-ID: <1395903457.5569.89.camel@pasglop>
Subject: Bad DMA from Marvell 9230
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 27 Mar 2014 17:57:37 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks !

Do that ring any bell ?

I've been trying a 9230 on a power box here (a 9235 on the same machine
works fine) and it blows up with an IOMMU violation early during init.

>From what I can tell the scenario is:

- So we still haven't issued any command per-se, all our DMA command
buffers etc... are all 0's at the point of the error.

 - The core libata calls the AHCI driver's ahci_hardreset() for each
port in a separate thread. They all call sata_link_hardreset().

 - This in turns calls sata_link_resume() which write to the SCR_CONTROL
register as follow:

                scontrol = (scontrol & 0x0f0) | 0x300;
                if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
{
                        printk(" -> sata_link_resume FAIL 2\n");
                        return rc;
                }

                /*
                 * Some PHYs react badly if SStatus is pounded
                 * immediately after resuming.  Delay 200ms before
                 * debouncing.
                 */
                ata_msleep(link->ap, 200);

I get the interrupt from the IOMMU about 2ms after the write to
SCR_CONTROL.

Now, pending misinterpretation of some bits on my side, it looks like
the bad DMA is a DMA *read* from address 0 (which we never map,
typically to catch driver bugs).

I went through a few theories with this one but so far none held. I
don't think it's a D2H FIS issue since the DMA pointers for that appear
to be setup properly, the memory mapped, etc...

I though the chip might incorrectly/inadvertently try to (pre)fetch a
command. At that point all 32 command slots are all 0's, so if it
ignored the size it might try to fetch from command address 0.

So I added a loop to fill all 32 slots with a valid command address
in ahci_hardreset:

+	for (i = 0; i < 32; i++)
+		ahci_fill_cmd_slot(pp, i, 0);
 	rc = sata_link_hardreset(link, timing, deadline, &online,
 				 ahci_check_ready);

But that had basically no effect.

I've contacted Marvell, but I was wondering if anybody here had already
experienced something similar or has an idea of what else the chip
might be doing wrong so we can try to find a workaround ?

Cheers,
Ben.


