Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989Ab3DHKHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:07:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42885 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935779Ab3DHJwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Cong Wang <amwang@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 062/102] 8021q: fix a potential use-after-free
Date: Mon,  8 Apr 2013 10:50:17 +0100
Message-Id: <1365414657-29191-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

commit 4a7df340ed1bac190c124c1601bfc10cde9fb4fb upstream.

vlan_vid_del() could possibly free ->vlan_info after a RCU grace
period, however, we may still refer to the freed memory area
by 'grp' pointer. Found by code inspection.

This patch moves vlan_vid_del() as behind as possible.

Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/8021q/vlan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 9096bcb..8bdc56d 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -86,13 +86,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 
 	grp = &vlan_info->grp;
 
-	/* Take it out of our own structures, but be sure to interlock with
-	 * HW accelerating devices or SW vlan input packet processing if
-	 * VLAN is not 0 (leave it there for 802.1p).
-	 */
-	if (vlan_id)
-		vlan_vid_del(real_dev, vlan_id);
-
 	grp->nr_vlan_devs--;
 
 	if (vlan->flags & VLAN_FLAG_GVRP)
@@ -108,6 +101,13 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 	if (grp->nr_vlan_devs == 0)
 		vlan_gvrp_uninit_applicant(real_dev);
 
+	/* Take it out of our own structures, but be sure to interlock with
+	 * HW accelerating devices or SW vlan input packet processing if
+	 * VLAN is not 0 (leave it there for 802.1p).
+	 */
+	if (vlan_id)
+		vlan_vid_del(real_dev, vlan_id);
+
 	/* Get rid of the vlan's reference to real_dev */
 	dev_put(real_dev);
 }
-- 
1.8.1.2

