Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbbAROnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:43:12 -0500
Received: from mout.web.de ([212.227.17.11]:60855 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbbAROnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:43:09 -0500
Message-ID: <54BBC675.2030205@users.sourceforge.net>
Date: Sun, 18 Jan 2015 15:43:01 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com,
        linux-scsi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/3] block: Deletion of checks before the function call "iounmap"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BBC3AB.6040207@users.sourceforge.net>
In-Reply-To: <54BBC3AB.6040207@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:8KREvnD40NXoMENkJe4jtKo1ZSTce781XH+mwP+X7AzIxkGs7bi
 AsJC8fnoJM7qDXKO6i+YGFraJCy3Nkz1J2YH8ELgxypKHJtmOaYXt1MhvyQBXGYHhH1ETQ5
 Oz7eYaeHk5h+ZuupSYwiNIS7lWam1ZA2fie4JKvudb9iRyfCsRa/fH6YaoKvJb6HJ93wM4e
 nCryDEA7IMYK10aVkXS7Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 13:33:25 +0100

The iounmap() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/cciss.c    | 18 ++++++------------
 drivers/block/mg_disk.c  |  3 +--
 drivers/block/skd_main.c |  6 ++----
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ff20f19..d13ef0f 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4382,12 +4382,9 @@ err_out_free_res:
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
-	if (h->transtable)
-		iounmap(h->transtable);
-	if (h->cfgtable)
-		iounmap(h->cfgtable);
-	if (h->vaddr)
-		iounmap(h->vaddr);
+	iounmap(h->transtable);
+	iounmap(h->cfgtable);
+	iounmap(h->vaddr);
 	pci_release_regions(h->pdev);
 	return err;
 }
@@ -4939,12 +4936,9 @@ static void cciss_undo_allocations_after_kdump_soft_reset(ctlr_info_t *h)
 	if (h->reply_pool)
 		pci_free_consistent(h->pdev, h->max_commands * sizeof(__u64),
 				h->reply_pool, h->reply_pool_dhandle);
-	if (h->transtable)
-		iounmap(h->transtable);
-	if (h->cfgtable)
-		iounmap(h->cfgtable);
-	if (h->vaddr)
-		iounmap(h->vaddr);
+	iounmap(h->transtable);
+	iounmap(h->cfgtable);
+	iounmap(h->vaddr);
 	unregister_blkdev(h->major, h->devname);
 	cciss_destroy_hba_sysfs_entry(h);
 	pci_release_regions(h->pdev);
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 145ce2a..9f738ee 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -1068,8 +1068,7 @@ static int mg_remove(struct platform_device *plat_dev)
 		gpio_free(host->rst);
 
 	/* unmap io */
-	if (host->dev_base)
-		iounmap(host->dev_base);
+	iounmap(host->dev_base);
 
 	/* free mg_host */
 	kfree(host);
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 1e46eb2..d4c7c4b 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4944,8 +4944,7 @@ err_out_timer:
 
 err_out_iounmap:
 	for (i = 0; i < SKD_MAX_BARS; i++)
-		if (skdev->mem_map[i])
-			iounmap(skdev->mem_map[i]);
+		iounmap(skdev->mem_map[i]);
 
 	if (skdev->pcie_error_reporting_is_enabled)
 		pci_disable_pcie_error_reporting(pdev);
@@ -5108,8 +5107,7 @@ err_out_timer:
 
 err_out_iounmap:
 	for (i = 0; i < SKD_MAX_BARS; i++)
-		if (skdev->mem_map[i])
-			iounmap(skdev->mem_map[i]);
+		iounmap(skdev->mem_map[i]);
 
 	if (skdev->pcie_error_reporting_is_enabled)
 		pci_disable_pcie_error_reporting(pdev);
-- 
2.2.2

