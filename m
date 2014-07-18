Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422901AbaGRSIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:08:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16605 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422830AbaGRSIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:08:25 -0400
X-IronPort-AV: E=Sophos;i="5.01,686,1400025600"; 
   d="scan'208";a="153763656"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH net 4/4 v2] xen-netback: Fix pointer incrementation to avoid incorrect logging
Date: Fri, 18 Jul 2014 19:08:05 +0100
Message-ID: <1405706885-16763-5-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405706885-16763-1-git-send-email-zoltan.kiss@citrix.com>
References: <1405706885-16763-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to this pointer is increased prematurely, the error log contains rubbish.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Reported-by: Armin Zentai <armin.zentai@ezit.hu>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
---
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index cca82de..72d8a6b 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1045,7 +1045,6 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 
 	/* Check status of header. */
 	err = (*gopp_copy)->status;
-	(*gopp_copy)++;
 	if (unlikely(err)) {
 		if (net_ratelimit())
 			netdev_dbg(queue->vif->dev,
@@ -1058,6 +1057,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 			xenvif_idx_release(queue, pending_idx,
 					   XEN_NETIF_RSP_ERROR);
 	}
+	(*gopp_copy)++;
 
 check_frags:
 	for (i = 0; i < nr_frags; i++, gop_map++) {
