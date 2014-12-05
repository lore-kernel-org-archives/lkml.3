Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaLEI0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:26:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61328 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaLEI0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:26:18 -0500
X-AuditID: cbfee61a-f79c06d000004e71-a5-54816c298954
From: Robert Baldyga <r.baldyga@samsung.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, lars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, padma.kvr@gmail.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 2/2] dma: pl330: add DMA_PAUSE feature
Date: Fri, 05 Dec 2014 09:25:55 +0100
Message-id: <1417767955-5480-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417767955-5480-1-git-send-email-r.baldyga@samsung.com>
References: <1417767955-5480-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAV3NnMYQgy27+SymT73AaLF66l9W
	i9cvDC3ONr1ht/g1bRKbxZLJ81ktLu+aw2ax9shddov2ZXNYLR4c3slu8bJvP4sDt8fOWXfZ
	PRbvecnkseTNIVaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyth5uZm14AZvxfPOHqYGxrXc
	XYycHBICJhIHt15mgrDFJC7cW8/WxcjFISSwiFFi8/cF7BBOO5NE04SbzCBVbAI6Elu+T2AE
	sUUEJCS2P+sDK2IWmMgksbb/IhtIQljAUmLh5wesIDaLgKrEybtdYDavgIvEz6ezmCHWyUmc
	PDYZLM4p4Cpx4ekysF4hoJoHkxqZJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	HH7PpHYwrmywOMQowMGoxMO7QqIxRIg1say4MvcQowQHs5IIb6EiUIg3JbGyKrUoP76oNCe1
	+BCjNAeLkjjvjZu5IUIC6YklqdmpqQWpRTBZJg5OqQZGofpat2mVCj+v+5bcu+PUGXeFS6tj
	hkss82uLILWQ80w6zea5JWk+j+67d7458c52wanZKlGzZ52bknblfcg2+YjXy7e0FXV03kn9
	MHf2Q0lmNZ6LH/x51r0OaS+9lJvJ6eCSmLlt7q3lJ559/P271CPFWvryd53c3CmLNc7Iy+08
	s3spR+prJZbijERDLeai4kQAm2bYZDsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_PAUSE command is used for halting DMA transfer on chosen channel.
It can be useful when we want to safely read residue before terminating
all requests on channel. Otherwise there can be situation when some data
is transferred before channel termination but after reading residue,
which obviously results with data loss. To avoid this situation we can
pause channel, read residue and then terminate all requests.
This scenario is common, for example, in serial port drivers.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/dma/pl330.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 04487de..7ebf7e6 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2137,6 +2137,25 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 		pm_runtime_mark_last_busy(pl330->ddma.dev);
 		pm_runtime_put_autosuspend(pl330->ddma.dev);
 		break;
+	case DMA_PAUSE:
+		/*
+		 * We don't support DMA_RESUME command because of hardware
+		 * limitations, so after pausing the channel we cannot restore
+		 * it to active state. We have to terminate channel and setup
+		 * DMA transfer again. This pause feature was implemented to
+		 * allow safely read residue before channel termination.
+		 */
+		pm_runtime_get_sync(pl330->ddma.dev);
+		spin_lock_irqsave(&pch->lock, flags);
+
+		spin_lock(&pl330->lock);
+		_stop(pch->thread);
+		spin_unlock(&pl330->lock);
+
+		spin_unlock_irqrestore(&pch->lock, flags);
+		pm_runtime_put(pl330->ddma.dev);
+		pm_runtime_put_autosuspend(pl330->ddma.dev);
+		break;
 	case DMA_SLAVE_CONFIG:
 		slave_config = (struct dma_slave_config *)arg;
 
-- 
1.9.1

