Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3AVC0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:26:49 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:54274
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755Ab3AVC0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:26:48 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <matthieu.castet@parrot.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2] mtd: fix the wrong timeo for panic_nand_wait()
Date: Tue, 22 Jan 2013 09:30:30 +0800
Message-ID: <1358818230-27037-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <CAMiH66HWn5PtjX20=WT7GMMV=J72rg3jx64iACSBiExjoD+X7A@mail.gmail.com>
References: <CAMiH66HWn5PtjX20=WT7GMMV=J72rg3jx64iACSBiExjoD+X7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In nand_wait(), the timeo for panic_nand_wait() is assigned with
wrong value(jiffies + some delay). The timeo should be set like the
panic_nand_write() does.

This patch fixes it, and also uses the msecs_to_jiffies() to make the
code more readable.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
fix the compiler error in version 1, and add some commits.

---
 drivers/mtd/nand/nand_base.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8323ac9..a8c1fb4 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -825,13 +825,8 @@ static void panic_nand_wait(struct mtd_info *mtd, struct nand_chip *chip,
 static int nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
 {
 
-	unsigned long timeo = jiffies;
 	int status, state = chip->state;
-
-	if (state == FL_ERASING)
-		timeo += (HZ * 400) / 1000;
-	else
-		timeo += (HZ * 20) / 1000;
+	unsigned long timeo = (state == FL_ERASING ? 400 : 20);
 
 	led_trigger_event(nand_led_trigger, LED_FULL);
 
@@ -849,6 +844,7 @@ static int nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
 	if (in_interrupt() || oops_in_progress)
 		panic_nand_wait(mtd, chip, timeo);
 	else {
+		timeo = jiffies + msecs_to_jiffies(timeo);
 		while (time_before(jiffies, timeo)) {
 			if (chip->dev_ready) {
 				if (chip->dev_ready(mtd))
-- 
1.7.0.4


