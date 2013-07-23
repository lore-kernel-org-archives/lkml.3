Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854Ab3GWWrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:47:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934613Ab3GWW10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Langsdorf <mark.langsdorf@calxeda.com>, Tejun Heo <tj@kernel.org>
Subject: [ 044/103] sata_highbank: increase retry count but shorten duration for Calxeda controller
Date: Tue, 23 Jul 2013 15:25:55 -0700
Message-Id: <20130723220423.481440928@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Langsdorf <mark.langsdorf@calxeda.com>

commit ddfef5de3d716f77bad32dbbba6b280158dfd721 upstream.

Increase the retry count for the hard reset function to 100 but
shorten the time out period to 500 ms. See the comment for
ahci_highbank_hardreset for the reasons why those vaulues were
chosen.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_highbank.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -196,10 +196,26 @@ static int highbank_initialize_phys(stru
 	return 0;
 }
 
+/*
+ * The Calxeda SATA phy intermittently fails to bring up a link with Gen3
+ * Retrying the phy hard reset can work around the issue, but the drive
+ * may fail again. In less than 150 out of 15000 test runs, it took more
+ * than 10 tries for the link to be established (but never more than 35).
+ * Triple the maximum observed retry count to provide plenty of margin for
+ * rare events and to guarantee that the link is established.
+ *
+ * Also, the default 2 second time-out on a failed drive is too long in
+ * this situation. The uboot implementation of the same driver function
+ * uses a much shorter time-out period and never experiences a time out
+ * issue. Reducing the time-out to 500ms improves the responsiveness.
+ * The other timing constants were kept the same as the stock AHCI driver.
+ * This change was also tested 15000 times on 24 drives and none of them
+ * experienced a time out.
+ */
 static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline)
 {
-	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	static const unsigned long timing[] = { 5, 100, 500};
 	struct ata_port *ap = link->ap;
 	struct ahci_port_priv *pp = ap->private_data;
 	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
@@ -207,7 +223,7 @@ static int ahci_highbank_hardreset(struc
 	bool online;
 	u32 sstatus;
 	int rc;
-	int retry = 10;
+	int retry = 100;
 
 	ahci_stop_engine(ap);
 


