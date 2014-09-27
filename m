Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaI0I67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:58:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38687 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbaI0I4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:56:46 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/9] dmaengine: Add device_terminate_all callback
Date: Sat, 27 Sep 2014 10:54:41 +0200
Message-Id: <1411808085-27792-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the terminate_all command from device_control to a dma_device
callback. In order to preserve backward capability, still rely on
device_control if no such callback has been implemented.

Eventually, this will allow to create a generic dma_slave_caps callback.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 include/linux/dmaengine.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b89c8004fcd8..4d0294ec3567 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -616,6 +616,8 @@ struct dma_tx_state {
  *	0 or an error code
  * @device_resume: Resumes any transfer on a channel previously
  *	paused. Returns 0 or an error code
+ * @device_terminate_all: Aborts all transfers on a channel. Returns 0
+ *	or an error code
  * @device_tx_status: poll for transaction completion, the optional
  *	txstate parameter can be supplied with a pointer to get a
  *	struct with auxiliary transfer status information, otherwise the call
@@ -686,6 +688,7 @@ struct dma_device {
 			      unsigned long arg);
 	int (*device_pause)(struct dma_chan *chan);
 	int (*device_resume)(struct dma_chan *chan);
+	int (*device_terminate_all)(struct dma_chan *chan);
 	enum dma_status (*device_tx_status)(struct dma_chan *chan,
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *txstate);
@@ -784,6 +787,9 @@ static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_cap
 
 static inline int dmaengine_terminate_all(struct dma_chan *chan)
 {
+	if (chan->device->device_terminate_all)
+		return chan->device->device_terminate_all(chan);
+
 	return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
 }
 
-- 
2.1.0

