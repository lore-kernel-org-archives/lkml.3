Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab3BFT6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:58:52 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:50098 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3BFTuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:51 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 54/77] macvtap: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:26 -0800
Message-Id: <1360179649-22465-55-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/macvtap.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index b181dfb..1814cfe 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -279,28 +279,17 @@ static int macvtap_receive(struct sk_buff *skb)
 static int macvtap_get_minor(struct macvlan_dev *vlan)
 {
 	int retval = -ENOMEM;
-	int id;
 
 	mutex_lock(&minor_lock);
-	if (idr_pre_get(&minor_idr, GFP_KERNEL) == 0)
-		goto exit;
-
-	retval = idr_get_new_above(&minor_idr, vlan, 1, &id);
-	if (retval < 0) {
-		if (retval == -EAGAIN)
-			retval = -ENOMEM;
-		goto exit;
-	}
-	if (id < MACVTAP_NUM_DEVS) {
-		vlan->minor = id;
-	} else {
+	retval = idr_alloc(&minor_idr, vlan, 1, MACVTAP_NUM_DEVS, GFP_KERNEL);
+	if (retval >= 0) {
+		vlan->minor = retval;
+	} else if (retval == -ENOSPC) {
 		printk(KERN_ERR "too many macvtap devices\n");
 		retval = -EINVAL;
-		idr_remove(&minor_idr, id);
 	}
-exit:
 	mutex_unlock(&minor_lock);
-	return retval;
+	return retval < 0 ? retval : 0;
 }
 
 static void macvtap_free_minor(struct macvlan_dev *vlan)
-- 
1.8.1

