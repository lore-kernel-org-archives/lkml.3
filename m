Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaFGBrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:47:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35956 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lior Amsalem" <alior@marvell.com>,
        "Ezequiel Garcia" <ezequiel.garcia@free-electrons.com>,
        "Dan Williams" <dan.j.williams@intel.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.393624387@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 84/92] dma: mv_xor: Flush descriptors before
 activating a channel
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: it was using __raw_readl() and __raw_writel()
 which are just as wrong]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/dma/mv_xor.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -218,12 +218,10 @@ static void mv_set_mode(struct mv_xor_ch
 
 static void mv_chan_activate(struct mv_xor_chan *chan)
 {
-	u32 activation;
-
 	dev_dbg(chan->device->common.dev, " activate chan.\n");
-	activation = __raw_readl(XOR_ACTIVATION(chan));
-	activation |= 0x1;
-	__raw_writel(activation, XOR_ACTIVATION(chan));
+
+	/* writel ensures all descriptors are flushed before activation */
+	writel(BIT(0), XOR_ACTIVATION(chan));
 }
 
 static char mv_chan_is_busy(struct mv_xor_chan *chan)

