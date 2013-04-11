Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140Ab3DKVVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:21:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935453Ab3DKUsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:54 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Q761YPIU7s0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HWS7tkbDvQ8A:10 a=20KFwNOVAAAA:8 a=d4lxWNCCAAAA:8 a=J1Y8HTJGAAAA:8 a=1XWaLZrsAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jEp0ucaQiEUA:10 a=1jcDQfjXLUsA:10 a=4N9Db7Z2_RYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=iLQoDhwokxv6VTiL:21 a=DDK-h-5D8FPRIW2g:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202611.044858142@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Cong Wang <amwang@redhat.com>, Eric Dumazet <edumazet@google.com>
Subject: [ 151/171 ] 8021q: fix a potential use-after-free
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0151-8021q-fix-a-potential-use-after-free.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit 4a7df340ed1bac190c124c1601bfc10cde9fb4fb ]

vlan_vid_del() could possibly free ->vlan_info after a RCU grace
period, however, we may still refer to the freed memory area
by 'grp' pointer. Found by code inspection.

This patch moves vlan_vid_del() as behind as possible.

Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/8021q/vlan.c |   14 +++++++-------
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
1.7.10.4


