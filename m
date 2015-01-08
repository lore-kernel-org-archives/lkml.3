Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbbAHOYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:24:43 -0500
Received: from www.osadl.org ([62.245.132.105]:42106 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbbAHOYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:24:42 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Rashika <rashika.kheria@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2] ioat: fail self-test if wait_for_completion times out
Date: Thu,  8 Jan 2015 15:16:35 +0100
Message-Id: <1420726595-29152-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_for_completion_timeout reaching timeout was being ignored,
fail the self-test if timeout condition occurs.

v2: fixup of coding style issues.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

this was only compile tested with
x86_64_defconfig + CONFIG_DMA_ENGINE=y + CONFIG_INTEL_IOATDMA=m

patch is against linux-next 3.19.0-rc3 -next-20150108

 drivers/dma/ioat/dma_v3.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index be307182..a26882e 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1311,7 +1311,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
+	if (tmo == 0 ||
+	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
 		dev_err(dev, "Self-test xor timed out\n");
 		err = -ENODEV;
 		goto dma_unmap;
@@ -1377,7 +1378,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
+	if (tmo == 0 ||
+	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
 		dev_err(dev, "Self-test validate timed out\n");
 		err = -ENODEV;
 		goto dma_unmap;
@@ -1429,7 +1431,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
+	if (tmo == 0 ||
+	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
 		dev_err(dev, "Self-test 2nd validate timed out\n");
 		err = -ENODEV;
 		goto dma_unmap;
-- 
1.7.10.4

