Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbaGQTMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:12:55 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9952 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbaGQTMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:12:54 -0400
X-IronPort-AV: E=Sophos;i="5.01,679,1400025600"; 
   d="scan'208";a="153868248"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH for stable 3.15 4/4] xen-netback: Fix pointer incrementation to avoid incorrect logging
Date: Thu, 17 Jul 2014 20:10:29 +0100
Message-ID: <1405624229-21817-4-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405624229-21817-1-git-send-email-zoltan.kiss@citrix.com>
References: <1405624229-21817-1-git-send-email-zoltan.kiss@citrix.com>
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
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 7a36ecf..36fb4ff 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1020,7 +1020,6 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
 
 	/* Check status of header. */
 	err = (*gopp_copy)->status;
-	(*gopp_copy)++;
 	if (unlikely(err)) {
 		if (net_ratelimit())
 			netdev_dbg(vif->dev,
@@ -1030,6 +1029,7 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
 				   (*gopp_copy)->source.u.ref);
 		xenvif_idx_release(vif, first_pending_idx, XEN_NETIF_RSP_ERROR);
 	}
+	(*gopp_copy)++;
 
 check_frags:
 	for (i = 0; i < nr_frags; i++, gop_map++) {
