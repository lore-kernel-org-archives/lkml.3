Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaHULDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:03:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25826 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754687AbaHULDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:03:03 -0400
From: Xiang Wang <wangxfdu@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cxie4@marvell.com>, <wangxfdu@gmail.com>
CC: Xiang Wang <wangx@marvell.com>
Subject: [PATCH] dmaengine: increase privatecnt in dma_get_any_slave_channel
Date: Thu, 21 Aug 2014 19:01:21 +0800
Message-ID: <1408618881-30279-1-git-send-email-wangxfdu@gmail.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-21_04:2014-08-21,2014-08-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408210131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiang Wang <wangx@marvell.com>

There might be such calling sequence for dma channel:
1. register dma device
dma_async_device_register
  -> if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
  	device->privatecnt++;

2. request channel
dma_request_slave_channel
  -> of_dma_request_slave_channel
    -> of_dma_xlate
      -> dma_get_any_slave_channel in dma drivers
note that device->privatecnt is not changed during this.

3. release channel
dma_release_channel
  -> if (--chan->device->privatecnt == 0)
		dma_cap_clear(DMA_PRIVATE,
		chan->device->cap_mask);

So if we request a channel then release it, DMA_PRIVATE will
be cleared unexpectedly. In this patch, we increase privatecnt
in step 2 just like what __dma_request_channel does.

Signed-off-by: Xiang Wang <wangx@marvell.com>
---
 drivers/dma/dmaengine.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index ed610b4..01bb372 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -557,6 +557,9 @@ struct dma_chan *dma_get_any_slave_channel(struct dma_device *device)
 		}
 	}
 
+	if (chan && dma_has_cap(DMA_PRIVATE, device->cap_mask))
+		device->privatecnt++;
+
 	mutex_unlock(&dma_list_mutex);
 
 	return chan;
-- 
1.7.5.4

