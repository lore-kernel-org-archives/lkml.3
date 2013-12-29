Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3L2V4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:56:19 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31758 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935Ab3L2Vv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:56 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832538"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/25] mtd: nand: fix error return code
Date: Sun, 29 Dec 2013 23:47:33 +0100
Message-Id: <1388357260-4843-19-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/mtd/nand/fsmc_nand.c    |    3 +++
 drivers/mtd/tests/oobtest.c     |    1 +
 drivers/mtd/tests/pagetest.c    |    1 +
 drivers/mtd/tests/subpagetest.c |    1 +
 4 files changed, 6 insertions(+)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 8b27522..6f8c4f5 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -1040,12 +1040,15 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 				pdata->read_dma_priv);
 		if (!host->read_dma_chan) {
 			dev_err(&pdev->dev, "Unable to get read dma channel\n");
+			ret = -EBUSY;
 			goto err_req_read_chnl;
 		}
 		host->write_dma_chan = dma_request_channel(mask, filter,
 				pdata->write_dma_priv);
 		if (!host->write_dma_chan) {
 			dev_err(&pdev->dev, "Unable to get write dma channel\n");
+
+			ret = -EBUSY;
 			goto err_req_write_chnl;
 		}
 		nand->read_buf = fsmc_read_buf_dma;
diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
index 2e9e2d1..26688e9 100644
--- a/drivers/mtd/tests/oobtest.c
+++ b/drivers/mtd/tests/oobtest.c
@@ -291,6 +291,7 @@ static int __init mtd_oobtest_init(void)
 
 	if (!mtd_type_is_nand(mtd)) {
 		pr_info("this test requires NAND flash\n");
+		err = -ENODEV;
 		goto out;
 	}
 
diff --git a/drivers/mtd/tests/pagetest.c b/drivers/mtd/tests/pagetest.c
index ed2d3f6..9a84460 100644
--- a/drivers/mtd/tests/pagetest.c
+++ b/drivers/mtd/tests/pagetest.c
@@ -355,6 +355,7 @@ static int __init mtd_pagetest_init(void)
 
 	if (!mtd_type_is_nand(mtd)) {
 		pr_info("this test requires NAND flash\n");
+		err = -ENODEV;
 		goto out;
 	}
 
diff --git a/drivers/mtd/tests/subpagetest.c b/drivers/mtd/tests/subpagetest.c
index a876371..2baa93d 100644
--- a/drivers/mtd/tests/subpagetest.c
+++ b/drivers/mtd/tests/subpagetest.c
@@ -301,6 +301,7 @@ static int __init mtd_subpagetest_init(void)
 
 	if (!mtd_type_is_nand(mtd)) {
 		pr_info("this test requires NAND flash\n");
+		err = -ENODEV;
 		goto out;
 	}
 

