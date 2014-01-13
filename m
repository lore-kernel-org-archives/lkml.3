Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaAMQCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaAMQB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/208] iser-target: fix error return code in isert_create_device_ib_res()
Date: Mon, 13 Jan 2014 15:58:03 +0000
Message-Id: <1389628849-1614-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 94a7111043d99819cd0a72d9b3174c7054adb2a0 upstream.

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 3f62041..e0a95b8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -242,21 +242,29 @@ isert_create_device_ib_res(struct isert_device *device)
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
 						ISER_MAX_RX_CQ_LEN, i);
-		if (IS_ERR(device->dev_rx_cq[i]))
+		if (IS_ERR(device->dev_rx_cq[i])) {
+			ret = PTR_ERR(device->dev_rx_cq[i]);
+			device->dev_rx_cq[i] = NULL;
 			goto out_cq;
+		}
 
 		device->dev_tx_cq[i] = ib_create_cq(device->ib_device,
 						isert_cq_tx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
 						ISER_MAX_TX_CQ_LEN, i);
-		if (IS_ERR(device->dev_tx_cq[i]))
+		if (IS_ERR(device->dev_tx_cq[i])) {
+			ret = PTR_ERR(device->dev_tx_cq[i]);
+			device->dev_tx_cq[i] = NULL;
 			goto out_cq;
+		}
 
-		if (ib_req_notify_cq(device->dev_rx_cq[i], IB_CQ_NEXT_COMP))
+		ret = ib_req_notify_cq(device->dev_rx_cq[i], IB_CQ_NEXT_COMP);
+		if (ret)
 			goto out_cq;
 
-		if (ib_req_notify_cq(device->dev_tx_cq[i], IB_CQ_NEXT_COMP))
+		ret = ib_req_notify_cq(device->dev_tx_cq[i], IB_CQ_NEXT_COMP);
+		if (ret)
 			goto out_cq;
 	}
 
-- 
1.8.3.2

