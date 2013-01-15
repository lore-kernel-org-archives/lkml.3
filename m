Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab3AOWx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:53:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:47280 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933835Ab3AOWxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 152/171] libceph: fix osdmap decode error paths
Date: Tue, 15 Jan 2013 14:45:17 -0800
Message-Id: <20130115224324.305951358@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sage Weil <sage@inktank.com>

Ensure that we set the err value correctly so that we do not pass a 0
value to ERR_PTR and confuse the calling code.  (In particular,
osd_client.c handle_map() will BUG(!newmap)).

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(cherry picked from commit 0ed7285e0001b960c888e5455ae982025210ed3d)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -613,10 +613,12 @@ struct ceph_osdmap *osdmap_decode(void *
 	ceph_decode_32_safe(p, end, max, bad);
 	while (max--) {
 		ceph_decode_need(p, end, 4 + 1 + sizeof(pi->v), bad);
+		err = -ENOMEM;
 		pi = kzalloc(sizeof(*pi), GFP_NOFS);
 		if (!pi)
 			goto bad;
 		pi->id = ceph_decode_32(p);
+		err = -EINVAL;
 		ev = ceph_decode_8(p); /* encoding version */
 		if (ev > CEPH_PG_POOL_VERSION) {
 			pr_warning("got unknown v %d > %d of ceph_pg_pool\n",
@@ -632,8 +634,13 @@ struct ceph_osdmap *osdmap_decode(void *
 		__insert_pg_pool(&map->pg_pools, pi);
 	}
 
-	if (version >= 5 && __decode_pool_names(p, end, map) < 0)
-		goto bad;
+	if (version >= 5) {
+		err = __decode_pool_names(p, end, map);
+		if (err < 0) {
+			dout("fail to decode pool names");
+			goto bad;
+		}
+	}
 
 	ceph_decode_32_safe(p, end, map->pool_max, bad);
 
@@ -713,7 +720,7 @@ struct ceph_osdmap *osdmap_decode(void *
 	return map;
 
 bad:
-	dout("osdmap_decode fail\n");
+	dout("osdmap_decode fail err %d\n", err);
 	ceph_osdmap_destroy(map);
 	return ERR_PTR(err);
 }
@@ -807,6 +814,7 @@ struct ceph_osdmap *osdmap_apply_increme
 		if (ev > CEPH_PG_POOL_VERSION) {
 			pr_warning("got unknown v %d > %d of ceph_pg_pool\n",
 				   ev, CEPH_PG_POOL_VERSION);
+			err = -EINVAL;
 			goto bad;
 		}
 		pi = __lookup_pg_pool(&map->pg_pools, pool);
@@ -823,8 +831,11 @@ struct ceph_osdmap *osdmap_apply_increme
 		if (err < 0)
 			goto bad;
 	}
-	if (version >= 5 && __decode_pool_names(p, end, map) < 0)
-		goto bad;
+	if (version >= 5) {
+		err = __decode_pool_names(p, end, map);
+		if (err < 0)
+			goto bad;
+	}
 
 	/* old_pool */
 	ceph_decode_32_safe(p, end, len, bad);
@@ -900,15 +911,13 @@ struct ceph_osdmap *osdmap_apply_increme
 			(void) __remove_pg_mapping(&map->pg_temp, pgid);
 
 			/* insert */
-			if (pglen > (UINT_MAX - sizeof(*pg)) / sizeof(u32)) {
-				err = -EINVAL;
+			err = -EINVAL;
+			if (pglen > (UINT_MAX - sizeof(*pg)) / sizeof(u32))
 				goto bad;
-			}
+			err = -ENOMEM;
 			pg = kmalloc(sizeof(*pg) + sizeof(u32)*pglen, GFP_NOFS);
-			if (!pg) {
-				err = -ENOMEM;
+			if (!pg)
 				goto bad;
-			}
 			pg->pgid = pgid;
 			pg->len = pglen;
 			for (j = 0; j < pglen; j++)


