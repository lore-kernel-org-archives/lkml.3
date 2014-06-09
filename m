Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936536AbaFIJbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:31:07 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933261AbaFIJ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Dan Williams <dan.j.williams@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 124/146] dma: mv_xor: Flush descriptors before activating a channel
Date: Mon,  9 Jun 2014 10:50:59 +0200
Message-Id: <1a49b8f670286dd9c0b708df9445ebd1655d6e44.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5a9a55bf9157d3490b0c8c4c81d4708602c26e07 upstream.

We need to use writel() instead of writel_relaxed() when starting
a channel, to ensure all the descriptors have been flushed before
the activation.

While at it, remove the unneeded read-modify-write and make the
code simpler.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/dma/mv_xor.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 536dcb8ba5fd..dea771435a19 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -205,12 +205,10 @@ static void mv_set_mode(struct mv_xor_chan *chan,
 
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
1.9.3

