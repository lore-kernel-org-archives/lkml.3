Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbaLJK4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:56:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38447 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbaLJK4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:56:15 -0500
X-AuditID: cbfee61a-f79c06d000004e71-c9-548826cee90f
From: Robert Baldyga <r.baldyga@samsung.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, lars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        l.czerwinski@samsung.com, padma.kvr@gmail.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 2/2] dma: pl330: add DMA_PAUSE feature
Date: Wed, 10 Dec 2014 11:55:18 +0100
Message-id: <1418208918-28127-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418208918-28127-1-git-send-email-r.baldyga@samsung.com>
References: <1418208918-28127-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd1zah0hBqcPaFhMn3qB0WL11L+s
	Fq9fGFqcbXrDbvFr2iQ2iyWT57NaXN41h81i7ZG77Bbty+awWjw4vJPd4mXffhYHbo+ds+6y
	eyze85LJY8mbQ6wefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlfGhq5ex4DFvxcaLX9kaGHdw
	dzFyckgImEg8autnhrDFJC7cW88GYgsJTGeU+Dkpt4uRC8huZ5Jou/4UrIhNQEdiy/cJjCC2
	iICExPZnfewgRcwCE5kk+vdfAusWFrCUWHbzPFgDi4CqxPRLM8BsXgFXidWX30Ntk5M4eWwy
	K4jNKeAmcfL+CXaIza4SjTuuMU5g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzj4
	nkntYFzZYHGIUYCDUYmHN+Bye4gQa2JZcWXuIUYJDmYlEd43kh0hQrwpiZVVqUX58UWlOanF
	hxilOViUxHmV7NtChATSE0tSs1NTC1KLYLJMHJxSDYzKsXn3g3xMIsRrMjn91p5e7htVtMll
	XkX8Ho0Hj3/t2nlfuWav4w6urj0X1UomWLSGmq9ax/XuscOPJt5vfMc1ZH9W2z186237fl/1
	k0krEvsfPD8c/k/1YPQsh56T/k1qJz6zcgsuCvp7wZCLOejXu0cT3giVHG+5ekFK974C0zaF
	hJKeBGElluKMREMt5qLiRADzWybGOgIAAA==
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
index 2f4d561..ead4369 100644
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
+		pm_runtime_mark_last_busy(pl330->ddma.dev);
+		pm_runtime_put_autosuspend(pl330->ddma.dev);
+		break;
 	case DMA_SLAVE_CONFIG:
 		slave_config = (struct dma_slave_config *)arg;
 
-- 
1.9.1

