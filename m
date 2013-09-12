Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3ILR7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:59:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3ILR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/46] bridge: Use the correct bit length for bitmap functions in the VLAN code
Date: Thu, 12 Sep 2013 10:58:35 -0700
Message-Id: <20130912175723.639507594@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

[ Upstream commit ef40b7ef181b7b1a24df2ef2d1ef84956bffa635 ]

The VLAN code needs to know the length of the per-port VLAN bitmap to
perform its most basic operations (retrieving VLAN informations, removing
VLANs, forwarding database manipulation, etc). Unfortunately, in the
current implementation we are using a macro that indicates the bitmap
size in longs in places where the size in bits is expected, which in
some cases can cause what appear to be random failures.
Use the correct macro.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_fdb.c     |   10 +++++-----
 net/bridge/br_netlink.c |    4 ++--
 net/bridge/br_vlan.c    |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -161,7 +161,7 @@ void br_fdb_change_mac_address(struct ne
 	if (!pv)
 		return;
 
-	for_each_set_bit_from(vid, pv->vlan_bitmap, BR_VLAN_BITMAP_LEN) {
+	for_each_set_bit_from(vid, pv->vlan_bitmap, VLAN_N_VID) {
 		f = __br_fdb_get(br, br->dev->dev_addr, vid);
 		if (f && f->is_local && !f->dst)
 			fdb_delete(br, f);
@@ -725,7 +725,7 @@ int br_fdb_add(struct ndmsg *ndm, struct
 		/* VID was specified, so use it. */
 		err = __br_fdb_add(ndm, p, addr, nlh_flags, vid);
 	} else {
-		if (!pv || bitmap_empty(pv->vlan_bitmap, BR_VLAN_BITMAP_LEN)) {
+		if (!pv || bitmap_empty(pv->vlan_bitmap, VLAN_N_VID)) {
 			err = __br_fdb_add(ndm, p, addr, nlh_flags, 0);
 			goto out;
 		}
@@ -734,7 +734,7 @@ int br_fdb_add(struct ndmsg *ndm, struct
 		 * specify a VLAN.  To be nice, add/update entry for every
 		 * vlan on this port.
 		 */
-		for_each_set_bit(vid, pv->vlan_bitmap, BR_VLAN_BITMAP_LEN) {
+		for_each_set_bit(vid, pv->vlan_bitmap, VLAN_N_VID) {
 			err = __br_fdb_add(ndm, p, addr, nlh_flags, vid);
 			if (err)
 				goto out;
@@ -812,7 +812,7 @@ int br_fdb_delete(struct ndmsg *ndm, str
 
 		err = __br_fdb_delete(p, addr, vid);
 	} else {
-		if (!pv || bitmap_empty(pv->vlan_bitmap, BR_VLAN_BITMAP_LEN)) {
+		if (!pv || bitmap_empty(pv->vlan_bitmap, VLAN_N_VID)) {
 			err = __br_fdb_delete(p, addr, 0);
 			goto out;
 		}
@@ -822,7 +822,7 @@ int br_fdb_delete(struct ndmsg *ndm, str
 		 * vlan on this port.
 		 */
 		err = -ENOENT;
-		for_each_set_bit(vid, pv->vlan_bitmap, BR_VLAN_BITMAP_LEN) {
+		for_each_set_bit(vid, pv->vlan_bitmap, VLAN_N_VID) {
 			err &= __br_fdb_delete(p, addr, vid);
 		}
 	}
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -128,7 +128,7 @@ static int br_fill_ifinfo(struct sk_buff
 		else
 			pv = br_get_vlan_info(br);
 
-		if (!pv || bitmap_empty(pv->vlan_bitmap, BR_VLAN_BITMAP_LEN))
+		if (!pv || bitmap_empty(pv->vlan_bitmap, VLAN_N_VID))
 			goto done;
 
 		af = nla_nest_start(skb, IFLA_AF_SPEC);
@@ -136,7 +136,7 @@ static int br_fill_ifinfo(struct sk_buff
 			goto nla_put_failure;
 
 		pvid = br_get_pvid(pv);
-		for_each_set_bit(vid, pv->vlan_bitmap, BR_VLAN_BITMAP_LEN) {
+		for_each_set_bit(vid, pv->vlan_bitmap, VLAN_N_VID) {
 			vinfo.vid = vid;
 			vinfo.flags = 0;
 			if (vid == pvid)
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -108,7 +108,7 @@ static int __vlan_del(struct net_port_vl
 
 	clear_bit(vid, v->vlan_bitmap);
 	v->num_vlans--;
-	if (bitmap_empty(v->vlan_bitmap, BR_VLAN_BITMAP_LEN)) {
+	if (bitmap_empty(v->vlan_bitmap, VLAN_N_VID)) {
 		if (v->port_idx)
 			rcu_assign_pointer(v->parent.port->vlan_info, NULL);
 		else
@@ -122,7 +122,7 @@ static void __vlan_flush(struct net_port
 {
 	smp_wmb();
 	v->pvid = 0;
-	bitmap_zero(v->vlan_bitmap, BR_VLAN_BITMAP_LEN);
+	bitmap_zero(v->vlan_bitmap, VLAN_N_VID);
 	if (v->port_idx)
 		rcu_assign_pointer(v->parent.port->vlan_info, NULL);
 	else


