Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaIZJyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:54:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbaIZJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arjun Sreedharan <arjun024@gmail.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 137/142] pata_scc: propagate return value of scc_wait_after_reset
Date: Fri, 26 Sep 2014 11:45:48 +0200
Message-Id: <6cd2641b22e6dd70ae3fded86aa42128c84c3afc.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjun Sreedharan <arjun024@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4dc7c76cd500fa78c64adfda4b070b870a2b993c upstream.

scc_bus_softreset not necessarily should return zero.
Propagate the error code.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/pata_scc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index f35f15f4d83e..f7badaa39eb6 100644
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
2.1.0

