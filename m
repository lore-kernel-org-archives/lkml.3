Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3BCB2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:28:55 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40489 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3BCBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:29 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 38/62] i2c: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:39 -0800
Message-Id: <1359854463-2538-39-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/net/macvtap.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 0f0f9ce..2497f6f 100644
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

