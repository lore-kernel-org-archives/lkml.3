Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3AMRt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:49:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35039 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455Ab3AMRpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:39 -0500
Message-Id: <20130113174305.640122629@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 47/49] RDMA/nes: Fix for terminate timer crash
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>

commit 7bfcfa51c35cdd2d37e0d70fc11790642dd11fb3 upstream.

The terminate timer needs to be initialized just once.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/nes/nes.h       |    1 +
 drivers/infiniband/hw/nes/nes_hw.c    |    9 ++-------
 drivers/infiniband/hw/nes/nes_verbs.c |    4 +++-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 5cac29e..33cc589 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -532,6 +532,7 @@ void nes_iwarp_ce_handler(struct nes_device *, struct nes_hw_cq *);
 int nes_destroy_cqp(struct nes_device *);
 int nes_nic_cm_xmit(struct sk_buff *, struct net_device *);
 void nes_recheck_link_status(struct work_struct *work);
+void nes_terminate_timeout(unsigned long context);
 
 /* nes_nic.c */
 struct net_device *nes_netdev_init(struct nes_device *, void __iomem *);
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index fe7965e..67647e2 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -75,7 +75,6 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 static void process_critical_error(struct nes_device *nesdev);
 static void nes_process_mac_intr(struct nes_device *nesdev, u32 mac_number);
 static unsigned int nes_reset_adapter_ne020(struct nes_device *nesdev, u8 *OneG_Mode);
-static void nes_terminate_timeout(unsigned long context);
 static void nes_terminate_start_timer(struct nes_qp *nesqp);
 
 #ifdef CONFIG_INFINIBAND_NES_DEBUG
@@ -3520,7 +3519,7 @@ static void nes_terminate_received(struct nes_device *nesdev,
 }
 
 /* Timeout routine in case terminate fails to complete */
-static void nes_terminate_timeout(unsigned long context)
+void nes_terminate_timeout(unsigned long context)
 {
 	struct nes_qp *nesqp = (struct nes_qp *)(unsigned long)context;
 
@@ -3530,11 +3529,7 @@ static void nes_terminate_timeout(unsigned long context)
 /* Set a timer in case hw cannot complete the terminate sequence */
 static void nes_terminate_start_timer(struct nes_qp *nesqp)
 {
-	init_timer(&nesqp->terminate_timer);
-	nesqp->terminate_timer.function = nes_terminate_timeout;
-	nesqp->terminate_timer.expires = jiffies + HZ;
-	nesqp->terminate_timer.data = (unsigned long)nesqp;
-	add_timer(&nesqp->terminate_timer);
+	mod_timer(&nesqp->terminate_timer, (jiffies + HZ));
 }
 
 /**
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index cd0ecb2..c47ec25 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1404,6 +1404,9 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	}
 
 	nesqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR);
+	init_timer(&nesqp->terminate_timer);
+	nesqp->terminate_timer.function = nes_terminate_timeout;
+	nesqp->terminate_timer.data = (unsigned long)nesqp;
 
 	/* update the QP table */
 	nesdev->nesadapter->qp_table[nesqp->hwqp.qp_id-NES_FIRST_QPN] = nesqp;
@@ -1413,7 +1416,6 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	return &nesqp->ibqp;
 }
 
-
 /**
  * nes_clean_cq
  */


