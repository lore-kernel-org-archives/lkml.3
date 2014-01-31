Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbaAaPRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:17:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528AbaAaPHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:14 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Casey Leedom <leedom@chelsio.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 09/34] cxgb4vf: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:28 +0100
Message-Id: <bcf76e68c08022d968ef52241e94bbf1c3f65fc3.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   34 +++++++++----------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 509fed9..1d0fe9b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2444,7 +2444,7 @@ static void reduce_ethqs(struct adapter *adapter, int n)
  */
 static int enable_msix(struct adapter *adapter)
 {
-	int i, err, want, need;
+	int i, want, need, nqsets;
 	struct msix_entry entries[MSIX_ENTRIES];
 	struct sge *s = &adapter->sge;
 
@@ -2460,25 +2460,23 @@ static int enable_msix(struct adapter *adapter)
 	 */
 	want = s->max_ethqsets + MSIX_EXTRAS;
 	need = adapter->params.nports + MSIX_EXTRAS;
-	while ((err = pci_enable_msix(adapter->pdev, entries, want)) >= need)
-		want = err;
 
-	if (err == 0) {
-		int nqsets = want - MSIX_EXTRAS;
-		if (nqsets < s->max_ethqsets) {
-			dev_warn(adapter->pdev_dev, "only enough MSI-X vectors"
-				 " for %d Queue Sets\n", nqsets);
-			s->max_ethqsets = nqsets;
-			if (nqsets < s->ethqsets)
-				reduce_ethqs(adapter, nqsets);
-		}
-		for (i = 0; i < want; ++i)
-			adapter->msix_info[i].vec = entries[i].vector;
-	} else if (err > 0) {
-		dev_info(adapter->pdev_dev, "only %d MSI-X vectors left,"
-			 " not using MSI-X\n", err);
+	want = pci_enable_msix_range(adapter->pdev, entries, need, want);
+	if (want < 0)
+		return want;
+
+	nqsets = want - MSIX_EXTRAS;
+	if (nqsets < s->max_ethqsets) {
+		dev_warn(adapter->pdev_dev, "only enough MSI-X vectors"
+			 " for %d Queue Sets\n", nqsets);
+		s->max_ethqsets = nqsets;
+		if (nqsets < s->ethqsets)
+			reduce_ethqs(adapter, nqsets);
 	}
-	return err;
+	for (i = 0; i < want; ++i)
+		adapter->msix_info[i].vec = entries[i].vector;
+
+	return 0;
 }
 
 static const struct net_device_ops cxgb4vf_netdev_ops	= {
-- 
1.7.7.6

