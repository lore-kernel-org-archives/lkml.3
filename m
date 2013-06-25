Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3FYSeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3FYSd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 47/95] vxlan: Update vxlan fdb used field after each usage
Date: Tue, 25 Jun 2013 11:32:34 -0700
Message-Id: <20130625182158.944490094@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sridhar Samudrala <sri@us.ibm.com>

[ Upstream commit 014be2c8eac3381e202f684c1f35ae184a8b152b ]

Fix some instances where vxlan fdb 'used' field is not updated after the entry
is used.

v2: rename vxlan_find_mac() as __vxlan_find_mac() and create a new vxlan_find_mac()
that also updates ->used field.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -285,7 +285,7 @@ static inline struct hlist_head *vxlan_f
 }
 
 /* Look up Ethernet address in forwarding table */
-static struct vxlan_fdb *vxlan_find_mac(struct vxlan_dev *vxlan,
+static struct vxlan_fdb *__vxlan_find_mac(struct vxlan_dev *vxlan,
 					const u8 *mac)
 
 {
@@ -300,6 +300,18 @@ static struct vxlan_fdb *vxlan_find_mac(
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
@@ -308,7 +320,7 @@ static int vxlan_fdb_create(struct vxlan
 	struct vxlan_fdb *f;
 	int notify = 0;
 
-	f = vxlan_find_mac(vxlan, mac);
+	f = __vxlan_find_mac(vxlan, mac);
 	if (f) {
 		if (flags & NLM_F_EXCL) {
 			netdev_dbg(vxlan->dev,
@@ -453,7 +465,6 @@ static void vxlan_snoop(struct net_devic
 
 	f = vxlan_find_mac(vxlan, src_mac);
 	if (likely(f)) {
-		f->used = jiffies;
 		if (likely(f->remote_ip == src_ip))
 			return;
 


