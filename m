Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaHEBzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:55:12 -0400
Received: from mailout.micron.com ([137.201.242.129]:36515 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaHEBzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:55:10 -0400
From: bpqw <bpqw@micron.com>
To: Brian Norris <computersforpeace@gmail.com>, bpqw <bpqw@micron.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "ron@debian.org" <ron@debian.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Thread-Topic: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Thread-Index: AQHPqitVzO92LvhBkUCLfuxs4Da3wpu1DX2AgAxvBoD//87DYA==
Date: Tue, 5 Aug 2014 01:54:07 +0000
Message-ID: <CB9F11E856CFD04BB18EC1C68F2598931B1724@NTXXIAMBX01.xacn.micron.com>
References: <CB9F11E856CFD04BB18EC1C68F2598931B1112@NTXXIAMBX01.xacn.micron.com>
 <20140728061006.GC3095@norris-Latitude-E6410>
 <CB9F11E856CFD04BB18EC1C68F2598931B1342@NTXXIAMBX01.xacn.micron.com>
 <20140804224757.GH3711@ld-irv-0074>
In-Reply-To: <20140804224757.GH3711@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20860.004
X-TM-AS-Result: No--25.604200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0304e9618d8c3ef5360b611f881f1b1bed08be06 Mon Sep 17 00:00:00 2001
From: White Ding <bpqw@micron.com>
Date: Thu, 24 Jul 2014 00:10:45 +0800
Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function

Do nand reset before write protect check.

If we want to check the WP# low or high through STATUS READ and check bit 7,
we must reset the device, other operation (eg.erase/program a locked block) can
also clear the bit 7 of status register.

As we know the status register can be refreshed, if we do some operation to trigger it,
for example if we do erase/program operation to one block that is locked, then READ STATUS,
the bit 7 of READ STATUS will be 0 indicate the device in write protect, then if we do
erase/program operation to another block that is unlocked, the bit 7 of READ STATUS will
be 1 indicate the device is not write protect.
Suppose we checked the bit 7 of READ STATUS is 0 then judge the WP# is low (write protect),
but in this case the WP# maybe high if we do erase/program operation to a locked block, 
so we must reset the device if we want to check the WP# low or high through STATUS READ and 
check bit 7.

Signed-off-by: White Ding <bpqw@micron.com>
---
 drivers/mtd/nand/nand_base.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 41167e9..22dd3aa 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -965,6 +965,15 @@ int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 
 	chip->select_chip(mtd, chipnr);
 
+	/*
+	 * Reset the chip.
+	 * If we want to check the WP through READ STATUS and check the bit 7
+	 * we must reset the chip
+	 * some operation can also clear the bit 7 of status register
+	 * eg. erase/program a locked block
+	 */
+	chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
+
 	/* Check, if it is write protected */
 	if (nand_check_wp(mtd)) {
 		pr_debug("%s: device is write protected!\n",
@@ -1015,6 +1024,15 @@ int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 
 	chip->select_chip(mtd, chipnr);
 
+	/*
+	 * Reset the chip.
+	 * If we want to check the WP through READ STATUS and check the bit 7
+	 * we must reset the chip
+	 * some operation can also clear the bit 7 of status register
+	 * eg. erase/program a locked block
+	 */
+	chip->cmdfunc(mtd, NAND_CMD_RESET, -1, -1);
+
 	/* Check, if it is write protected */
 	if (nand_check_wp(mtd)) {
 		pr_debug("%s: device is write protected!\n",
-- 
1.7.9.5

White

-----Original Message-----
From: Brian Norris [mailto:computersforpeace@gmail.com] 
Sent: Tuesday, August 05, 2014 6:48 AM
To: bpqw
Cc: dwmw2@infradead.org; b32955@freescale.com; artem.bityutskiy@linux.intel.com; ron@debian.org; u.kleine-koenig@pengutronix.de; ezequiel.garcia@free-electrons.com; linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function

Hi,

On Mon, Jul 28, 2014 at 07:46:51AM +0000, bpqw wrote:
> >> Do nand reset before write protect check If we want to check the 
> >> WP# low or high through STATUS READ and check bit 7, we must reset 
> >> the device, other operation (eg.erase/program a locked block) can 
> >> also clear the bit 7 of status register.
> >This description doesn't really tell me why we need this patch.
> If we want to use the lock/unlock function, we must confirm the WP# is high, if the WP# is low, the write protect is provided by WP#, we don't need LOKC/UNLOCK function.
> So before we use the LOCK/UNLOCK function we must confirm the WP# is high.
> We can check the WP# is high or low through READ STATUS and check the bit 7, but this only correct when we READ STATUS directly after RESET or Power On.
> If we don't add this patch, We can't check the WP# high or low just through READ STATUS and check bit7. 
> 
> >First of all, where is the 'lock' sequence specified? I see the commit that introduced nand_lock() (without any users) which says Micron parts support it, but I don't see it documented in the datasheet:
> The LOCK/UNLOCK feature not apply all micron nand, only 1.8V device have this feature.
> 
> >  commit 7d70f334ad2bf1b3aaa1f0699c0f442e14bcc9e0
> >  Author: Vimal Singh <vimal.newwork@gmail.com>
> >  Date:   Mon Feb 8 15:50:49 2010 +0530
> 
> >      mtd: nand: add lock/unlock routines
> 
> >Now, supposing this is documented somewhere, are you seeing some kind 
> >of out-of-spec behavior? Is this a controller quirk you're seeing? 
> >Why should I need to reset the chip? I would presume that
> 
> >  chip->cmdfunc(mtd, NAND_CMD_STATUS, -1, -1);
> 
> >would refresh the status properly. Is that not the case?
> chip->cmdfunc(mtd, NAND_CMD_STATUS, -1, -1) can refresh the status properly, but we must do some operation to trigger it.
> For example if we do rease/program operation to a block that is locked, then READ STATUS, the bit 7 will be 0 that indicate the device is write protect.
> Then if we do erase/program operation to another block that is unlocked, the bit 7 of READ STATUS will be 1 indicate that the device is not write protect.
> 
> Now if we don't do any operation just through chip->cmdfunc(mtd, NAND_CMD_STATUS, -1, -1); to check the WP# is high or low.
> Suppose we check the bit 7 of READ STATUS is 0 then we judge the WP# is low (write protect), but in this case the WP# may be high if we do erase/program operation to a locked block.

Thanks for the explanations. I think the patch is probably OK, then. Can you send a new version with a more complete description in the commit message?

Brian
