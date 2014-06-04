Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaFEADN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:03:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaFDXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3.14 191/228] dma: mv_xor: Flush descriptors before activating a channel
Date: Wed,  4 Jun 2014 16:23:40 -0700
Message-Id: <20140604232354.161723805@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/mv_xor.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -191,12 +191,10 @@ static void mv_set_mode(struct mv_xor_ch
 
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


