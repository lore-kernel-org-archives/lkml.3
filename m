Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3EaP1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:27:35 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:39025 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399Ab3EaP1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:27:32 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: tj@kernel.org, timur@tabi.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, clemens@ladisch.de,
        sergei.shtylyov@cogentembedded.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH v3] ata: increase retry count but shorten duration for Calxeda controller
Date: Fri, 31 May 2013 10:27:26 -0500
Message-Id: <1370014046-5202-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369842679-9680-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1369842679-9680-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Calxeda SATA phy intermittently fails to bring up a link with Gen3
Retrying the phy hard reset can work around the issue, but the drive
may fail again. In less than 150 out of 15000 test runs, it took more
than 10 tries for the link to be established (but never more than 35).
Triple the maximum observed retry count to provide plenty of margin for
rare events and to guarantee that the link is established.

Also, the default 2 second time-out on a failed drive is too long in
this situation. The uboot implementation of the same driver function
uses a much shorter time-out period and never experiences a time out
issue. Shorten the Linux time-out value for this driver to 500 ms and
keep the other timing constants the same as the stock AHCI driver. This
change was also tested 15000 times on 24 drives and none of them
experienced a time out.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v2
	Add static to the timing variable definition
Changes from v1
        Add const to the timing variable definition
        Added more detail in why the various numbers were chosen

 drivers/ata/sata_highbank.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index b20aa96..46ccc1c 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -199,7 +199,7 @@ static int highbank_initialize_phys(struct device *dev, void __iomem *addr)
 static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline)
 {
-	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	static const unsigned long timing[] = { 5, 100, 500};
 	struct ata_port *ap = link->ap;
 	struct ahci_port_priv *pp = ap->private_data;
 	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
@@ -207,7 +207,7 @@ static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 	bool online;
 	u32 sstatus;
 	int rc;
-	int retry = 10;
+	int retry = 100;
 
 	ahci_stop_engine(ap);
 
-- 
1.8.1.2

