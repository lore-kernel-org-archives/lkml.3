Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966935AbaFQWYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:24:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54333 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966532AbaFQVuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 159/212] dma: mv_xor: Flush descriptors before activating a channel
Date: Tue, 17 Jun 2014 14:44:13 -0700
Message-Id: <1403041506-13646-160-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

commit 5a9a55bf9157d3490b0c8c4c81d4708602c26e07 upstream.

We need to use writel() instead of writel_relaxed() when starting
a channel, to ensure all the descriptors have been flushed before
the activation.

While at it, remove the unneeded read-modify-write and make the
code simpler.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/dma/mv_xor.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 53fb0c8..29c8a06 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -191,12 +191,10 @@ static void mv_set_mode(struct mv_xor_chan *chan,
 
 static void mv_chan_activate(struct mv_xor_chan *chan)
 {
-	u32 activation;
-
 	dev_dbg(mv_chan_to_devp(chan), " activate chan.\n");
-	activation = readl_relaxed(XOR_ACTIVATION(chan));
-	activation |= 0x1;
-	writel_relaxed(activation, XOR_ACTIVATION(chan));
+
+	/* writel ensures all descriptors are flushed before activation */
+	writel(BIT(0), XOR_ACTIVATION(chan));
 }
 
 static char mv_chan_is_busy(struct mv_xor_chan *chan)
-- 
1.9.1

