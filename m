Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaEaPIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:08:06 -0400
Received: from mout.gmx.net ([212.227.17.22]:62189 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaEaPIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:08:04 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: kevin.curtis@farsite.co.uk
Cc: davem@davemloft.net, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] wan: Use usleep_range()
Date: Sat, 31 May 2014 17:07:51 +0200
Message-Id: <1401548871-12352-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <E603DC592C92B54A89CEF6B0919A0B1CAFDE223C6D@SOLO.hq.farsitecommunications.com>
References: <E603DC592C92B54A89CEF6B0919A0B1CAFDE223C6D@SOLO.hq.farsitecommunications.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:ge0ulzAcUguwdAHtplv7cYp4l1Uiyf6xakEXmMIOcjGT6R5LLeC
 Xio/g7+QsC0YV5FkGVNqkiZfNEsvjoqo87fhMuhNSXi73NHFQ/xgQfQ0e6gPUof3uw5AqGb
 JSoWl7eTBh5uq6rGWOYha17Eii0BUHCwP/ft66U24ybVhbij+b1jfCn5yQan8Etd1GdPKPN
 269+rE9bNJntGd2HsT0kQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using a jiffies hack we can use the standard api for delays.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/wan/farsync.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index bcfff0d..02f6d1c 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -26,6 +26,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 #include <linux/if.h>
 #include <linux/hdlc.h>
 #include <asm/io.h>
@@ -678,7 +679,6 @@ static inline void
 fst_cpureset(struct fst_card_info *card)
 {
 	unsigned char interrupt_line_register;
-	unsigned long j = jiffies + 1;
 	unsigned int regval;
 
 	if (card->family == FST_FAMILY_TXU) {
@@ -696,16 +696,12 @@ fst_cpureset(struct fst_card_info *card)
 		/*
 		 * We are delaying here to allow the 9054 to reset itself
 		 */
-		j = jiffies + 1;
-		while (jiffies < j)
-			/* Do nothing */ ;
+		usleep_range(10, 20);
 		outw(0x240f, card->pci_conf + CNTRL_9054 + 2);
 		/*
 		 * We are delaying here to allow the 9054 to reload its eeprom
 		 */
-		j = jiffies + 1;
-		while (jiffies < j)
-			/* Do nothing */ ;
+		usleep_range(10, 20);
 		outw(0x040f, card->pci_conf + CNTRL_9054 + 2);
 
 		if (pci_write_config_byte
-- 
1.7.10.4

