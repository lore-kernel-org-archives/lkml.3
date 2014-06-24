Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaFXUcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:32:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaFXUck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:32:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 38/65] dma: mv_xor: Flush descriptors before activating a channel
Date: Tue, 24 Jun 2014 13:29:58 -0700
Message-Id: <1403641825-12825-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/dma/mv_xor.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index e17fad0..f7f1028 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -224,12 +224,10 @@ static void mv_set_mode(struct mv_xor_chan *chan,
 
 static void mv_chan_activate(struct mv_xor_chan *chan)
 {
-	u32 activation;
-
 	dev_dbg(mv_chan_to_devp(chan), " activate chan.\n");
-	activation = __raw_readl(XOR_ACTIVATION(chan));
-	activation |= 0x1;
-	__raw_writel(activation, XOR_ACTIVATION(chan));
+
+	/* writel ensures all descriptors are flushed before activation */
+	writel(BIT(0), XOR_ACTIVATION(chan));
 }
 
 static char mv_chan_is_busy(struct mv_xor_chan *chan)
-- 
1.9.1

