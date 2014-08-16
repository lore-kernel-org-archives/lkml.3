Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaHPKRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 06:17:34 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61656 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaHPKRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 06:17:32 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: propagate return value of scc_wait_after_reset
Date: Sat, 16 Aug 2014 15:47:17 +0530
Message-Id: <1408184238-1733-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scc_bus_softreset not necessarily should return zero.
Propagate the error code.
Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/ata/pata_scc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 4e006d7..5618c4518 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -585,7 +585,7 @@ static int scc_wait_after_reset(struct ata_link *link, unsigned int devmask,
  *	Note: Original code is ata_bus_softreset().
  */
 
-static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
+static int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
                                       unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
@@ -599,9 +599,7 @@ static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
 	udelay(20);
 	out_be32(ioaddr->ctl_addr, ap->ctl);
 
-	scc_wait_after_reset(&ap->link, devmask, deadline);
-
-	return 0;
+	return scc_wait_after_reset(&ap->link, devmask, deadline);
 }
 
 /**
@@ -618,7 +616,8 @@ static int scc_softreset(struct ata_link *link, unsigned int *classes,
 {
 	struct ata_port *ap = link->ap;
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
-	unsigned int devmask = 0, err_mask;
+	unsigned int devmask = 0;
+	int err_mask;
 	u8 err;
 
 	DPRINTK("ENTER\n");
-- 
1.7.11.7

