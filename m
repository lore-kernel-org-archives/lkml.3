Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3ANILy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:11:54 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:4780
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841Ab3ANILx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:11:53 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH] mtd: apply tPROG delay for ONFI nand's page program
Date: Mon, 14 Jan 2013 15:17:33 +0800
Message-ID: <1358147853-31826-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With some latest Micron's onfi nand(such as MT29F64G08CBABAWP),
I find that if we do not apply the tPROG delay as the datasheet tells us,
the page program may fails. You will read out the all 0xff from this page
in this case.

This patch adds the tPROG delay for page program when it is an onfi nand.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_base.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8323ac9..b628dd5 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -841,6 +841,10 @@ static int nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
 	 */
 	ndelay(100);
 
+	/* Apply the tPROG delay for ONFI nand program. */
+	if (chip->onfi_version && state == FL_WRITING)
+		udelay(le16_to_cpu(chip->onfi_params.t_prog));
+
 	if ((state == FL_ERASING) && (chip->options & NAND_IS_AND))
 		chip->cmdfunc(mtd, NAND_CMD_STATUS_MULTI, -1, -1);
 	else
-- 
1.7.0.4


