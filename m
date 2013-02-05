Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3BEDUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 22:20:03 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:30729
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894Ab3BEDUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:20:01 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 1/2] mtd: torturetest: rewrite the erase-write-verify process into one block unit.
Date: Tue, 5 Feb 2013 10:20:19 +0800
Message-ID: <1360030820-21491-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the torture cycle, do the erase-write-verify process in
one block unit, not in several blocks unit.

This patch makes preparations for adding the rand data pattern support.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/tests/mtd_torturetest.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/mtd/tests/mtd_torturetest.c b/drivers/mtd/tests/mtd_torturetest.c
index c4cde1e..516cf66 100644
--- a/drivers/mtd/tests/mtd_torturetest.c
+++ b/drivers/mtd/tests/mtd_torturetest.c
@@ -313,21 +313,18 @@ static int __init tort_init(void)
 		int i;
 		void *patt;
 
-		/* Erase all eraseblocks */
 		for (i = eb; i < eb + ebcnt; i++) {
 			if (bad_ebs[i - eb])
 				continue;
+
+			/* Erase all eraseblocks */
 			err = erase_eraseblock(i);
 			if (err)
 				goto out;
 			cond_resched();
-		}
 
-		/* Check if the eraseblocks contain only 0xFF bytes */
-		if (check) {
-			for (i = eb; i < eb + ebcnt; i++) {
-				if (bad_ebs[i - eb])
-					continue;
+			/* Check if the eraseblocks contain only 0xFF bytes */
+			if (check) {
 				err = check_eraseblock(i, patt_FF);
 				if (err) {
 					pr_info("verify failed"
@@ -336,12 +333,8 @@ static int __init tort_init(void)
 				}
 				cond_resched();
 			}
-		}
 
-		/* Write the pattern */
-		for (i = eb; i < eb + ebcnt; i++) {
-			if (bad_ebs[i - eb])
-				continue;
+			/* Write the pattern */
 			if ((eb + erase_cycles) & 1)
 				patt = patt_5A5;
 			else
@@ -350,17 +343,9 @@ static int __init tort_init(void)
 			if (err)
 				goto out;
 			cond_resched();
-		}
 
-		/* Verify what we wrote */
-		if (check) {
-			for (i = eb; i < eb + ebcnt; i++) {
-				if (bad_ebs[i - eb])
-					continue;
-				if ((eb + erase_cycles) & 1)
-					patt = patt_5A5;
-				else
-					patt = patt_A5A;
+			/* Verify what we wrote */
+			if (check) {
 				err = check_eraseblock(i, patt);
 				if (err) {
 					pr_info("verify failed for %s"
-- 
1.7.0.4


