Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaJCWTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:19:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaJCWTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:19:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arjun Sreedharan <arjun024@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 012/143] pata_scc: propagate return value of scc_wait_after_reset
Date: Fri,  3 Oct 2014 14:33:27 -0700
Message-Id: <20141003213314.852947722@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arjun Sreedharan <arjun024@gmail.com>

commit 4dc7c76cd500fa78c64adfda4b070b870a2b993c upstream.

scc_bus_softreset not necessarily should return zero.
Propagate the error code.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/pata_scc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -586,7 +586,7 @@ static int scc_wait_after_reset(struct a
  *	Note: Original code is ata_bus_softreset().
  */
 
-static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
+static int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
                                       unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
@@ -600,9 +600,7 @@ static unsigned int scc_bus_softreset(st
 	udelay(20);
 	out_be32(ioaddr->ctl_addr, ap->ctl);
 
-	scc_wait_after_reset(&ap->link, devmask, deadline);
-
-	return 0;
+	return scc_wait_after_reset(&ap->link, devmask, deadline);
 }
 
 /**
@@ -619,7 +617,8 @@ static int scc_softreset(struct ata_link
 {
 	struct ata_port *ap = link->ap;
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
-	unsigned int devmask = 0, err_mask;
+	unsigned int devmask = 0;
+	int rc;
 	u8 err;
 
 	DPRINTK("ENTER\n");
@@ -635,9 +634,9 @@ static int scc_softreset(struct ata_link
 
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
 


