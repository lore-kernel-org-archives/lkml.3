Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3F1Sya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:54:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3F1Sy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:54:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 067/105] vxlan: Update vxlan fdb 'used' field after each usage
Date: Fri, 28 Jun 2013 11:51:29 -0700
Message-Id: <1372445527-24414-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sridhar Samudrala <sri@us.ibm.com>

[ Upstream commit 014be2c8eac3381e202f684c1f35ae184a8b152b ]

Fix some instances where vxlan fdb 'used' field is not updated after the entry
is used.

v2: rename vxlan_find_mac() as __vxlan_find_mac() and create a new vxlan_find_mac()
that also updates ->used field.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/vxlan.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 6993bfa..9b2cc0c 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -284,7 +284,7 @@ static inline struct hlist_head *vxlan_fdb_head(struct vxlan_dev *vxlan,
 }
 
 /* Look up Ethernet address in forwarding table */
-static struct vxlan_fdb *vxlan_find_mac(struct vxlan_dev *vxlan,
+static struct vxlan_fdb *__vxlan_find_mac(struct vxlan_dev *vxlan,
 					const u8 *mac)
 
 {
@@ -300,6 +300,18 @@ static struct vxlan_fdb *vxlan_find_mac(struct vxlan_dev *vxlan,
 	return NULL;
 }
 
+static struct vxlan_fdb *vxlan_find_mac(struct vxlan_dev *vxlan,
+					const u8 *mac)
+{
+	struct vxlan_fdb *f;
+
+	f = __vxlan_find_mac(vxlan, mac);
+	if (f)
+		f->used = jiffies;
+
+	return f;
+}
+
 /* Add new entry to forwarding table -- assumes lock held */
 static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 			    const u8 *mac, __be32 ip,
@@ -308,7 +320,7 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 	struct vxlan_fdb *f;
 	int notify = 0;
 
-	f = vxlan_find_mac(vxlan, mac);
+	f = __vxlan_find_mac(vxlan, mac);
 	if (f) {
 		if (flags & NLM_F_EXCL) {
 			netdev_dbg(vxlan->dev,
@@ -453,7 +465,6 @@ static void vxlan_snoop(struct net_device *dev,
 
 	f = vxlan_find_mac(vxlan, src_mac);
 	if (likely(f)) {
-		f->used = jiffies;
 		if (likely(f->remote_ip == src_ip))
 			return;
 
-- 
1.8.1.2

