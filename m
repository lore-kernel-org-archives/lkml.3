Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbaAGAJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:09:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbaAFWiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 035/144] iser-target: fix error return code in isert_create_device_ib_res()
Date: Mon,  6 Jan 2014 14:36:36 -0800
Message-Id: <20140106223746.328636568@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 94a7111043d99819cd0a72d9b3174c7054adb2a0 upstream.

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -263,21 +263,29 @@ isert_create_device_ib_res(struct isert_
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
 


