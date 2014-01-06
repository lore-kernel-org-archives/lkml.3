Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaAFWif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbaAFWi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 038/144] iser-target: Move INIT_WORK setup into isert_create_device_ib_res
Date: Mon,  6 Jan 2014 14:36:39 -0800
Message-Id: <20140106223746.412399469@linuxfoundation.org>
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

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 2853c2b6671509591be09213954d7249ca6ff224 upstream.

This patch moves INIT_WORK setup for cq_desc->cq_[rx,tx]_work into
isert_create_device_ib_res(), instead of being done each callback
invocation in isert_cq_[rx,tx]_callback().

This also fixes a 'INFO: trying to register non-static key' warning
when cancel_work_sync() is called before INIT_WORK has setup the
struct work_struct.

Reported-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -206,7 +206,9 @@ isert_free_rx_descriptors(struct isert_c
 	isert_conn->conn_rx_descs = NULL;
 }
 
+static void isert_cq_tx_work(struct work_struct *);
 static void isert_cq_tx_callback(struct ib_cq *, void *);
+static void isert_cq_rx_work(struct work_struct *);
 static void isert_cq_rx_callback(struct ib_cq *, void *);
 
 static int
@@ -258,6 +260,7 @@ isert_create_device_ib_res(struct isert_
 		cq_desc[i].device = device;
 		cq_desc[i].cq_index = i;
 
+		INIT_WORK(&cq_desc[i].cq_rx_work, isert_cq_rx_work);
 		device->dev_rx_cq[i] = ib_create_cq(device->ib_device,
 						isert_cq_rx_callback,
 						isert_cq_event_callback,
@@ -269,6 +272,7 @@ isert_create_device_ib_res(struct isert_
 			goto out_cq;
 		}
 
+		INIT_WORK(&cq_desc[i].cq_tx_work, isert_cq_tx_work);
 		device->dev_tx_cq[i] = ib_create_cq(device->ib_device,
 						isert_cq_tx_callback,
 						isert_cq_event_callback,
@@ -1694,7 +1698,6 @@ isert_cq_tx_callback(struct ib_cq *cq, v
 {
 	struct isert_cq_desc *cq_desc = (struct isert_cq_desc *)context;
 
-	INIT_WORK(&cq_desc->cq_tx_work, isert_cq_tx_work);
 	queue_work(isert_comp_wq, &cq_desc->cq_tx_work);
 }
 
@@ -1738,7 +1741,6 @@ isert_cq_rx_callback(struct ib_cq *cq, v
 {
 	struct isert_cq_desc *cq_desc = (struct isert_cq_desc *)context;
 
-	INIT_WORK(&cq_desc->cq_rx_work, isert_cq_rx_work);
 	queue_work(isert_rx_wq, &cq_desc->cq_rx_work);
 }
 


