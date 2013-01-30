Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3A3DCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:02:08 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:52022
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab3A3DCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:02:05 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <matthieu.castet@parrot.com>,
        <ffainelli@freebox.fr>, <gabriel.matni@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v3] mtd: fix the wrong timeo for panic_nand_wait()
Date: Wed, 30 Jan 2013 10:03:56 +0800
Message-ID: <1359511436-12107-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201301292200.14622.ffainelli@freebox.fr>
References: <201301292200.14622.ffainelli@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The panic_nand_wait() expects the timeo in ms and not in jiffies.
But in nand_wait(), the timeo for panic_nand_wait() is assigned with
wrong value(jiffies + some delay). The timeo should be set like the
panic_nand_write() does.

This patch passes timeo in ms to panic_nand_wait().
And this patch also passes timeo in jiffies(converted by msecs_to_jiffies)
to time_before() which makes the code more readable.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
v1 --> v2:
	fixed a compiler error.

v2 --> v3:
	add more comments.
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


