Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaIWCgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:36:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:37577 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbaIWCfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:35:09 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arjun Sreedharan <arjun024@gmail.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 09/45] pata_scc: propagate return value of scc_wait_after_reset
Date: Tue, 23 Sep 2014 10:31:11 +0800
Message-Id: <1411439507-30391-9-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjun Sreedharan <arjun024@gmail.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 4dc7c76cd500fa78c64adfda4b070b870a2b993c upstream.

scc_bus_softreset not necessarily should return zero.
Propagate the error code.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/ata/pata_scc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index e265f83..19759d3 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -586,7 +586,7 @@ static int scc_wait_after_reset(struct ata_link *link, unsigned int devmask,
  *	Note: Original code is ata_bus_softreset().
  */
 
-static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
+static int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
                                       unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
@@ -600,9 +600,7 @@ static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
 	udelay(20);
 	out_be32(ioaddr->ctl_addr, ap->ctl);
 
-	scc_wait_after_reset(&ap->link, devmask, deadline);
-
-	return 0;
+	return scc_wait_after_reset(&ap->link, devmask, deadline);
 }
 
 /**
@@ -619,7 +617,8 @@ static int scc_softreset(struct ata_link *link, unsigned int *classes,
 {
 	struct ata_port *ap = link->ap;
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
-	unsigned int devmask = 0, err_mask;
+	unsigned int devmask = 0;
+	int rc;
 	u8 err;
 
 	DPRINTK("ENTER\n");
@@ -635,9 +634,9 @@ static int scc_softreset(struct ata_link *link, unsigned int *classes,
 
 	/* issue bus reset */
 	DPRINTK("about to softreset, devmask=%x\n", devmask);
-	err_mask = scc_bus_softreset(ap, devmask, deadline);
-	if (err_mask) {
-		ata_port_err(ap, "SRST failed (err_mask=0x%x)\n", err_mask);
+	rc = scc_bus_softreset(ap, devmask, deadline);
+	if (rc) {
+		ata_port_err(ap, "SRST failed (err_mask=0x%x)\n", rc);
 		return -EIO;
 	}
 
-- 
1.7.9.5

