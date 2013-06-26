Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab3FZDPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:15:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FZDPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:15:34 -0400
Date: Wed, 26 Jun 2013 11:15:27 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] ceph: Reconstruct the func ceph_reserve_caps.
X-Priority: 3
X-GUID: F902CAEB-0E08-4FD8-B02E-87353B707EB6
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201306261115191951258@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5Q3FfFT003095

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/ceph/caps.c  | 21 +++++++--------------
 fs/ceph/super.h |  2 +-
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index da0f9b8..6d2655c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -147,7 +147,7 @@ void ceph_adjust_min_caps(struct ceph_mds_client *mdsc, int delta)
 	spin_unlock(&mdsc->caps_list_lock);
 }
 
-int ceph_reserve_caps(struct ceph_mds_client *mdsc,
+void ceph_reserve_caps(struct ceph_mds_client *mdsc,
 		      struct ceph_cap_reservation *ctx, int need)
 {
 	int i;
@@ -155,7 +155,6 @@ int ceph_reserve_caps(struct ceph_mds_client *mdsc,
 	int have;
 	int alloc = 0;
 	LIST_HEAD(newcaps);
-	int ret = 0;
 
 	dout("reserve caps ctx=%p need=%d\n", ctx, need);
 
@@ -174,14 +173,15 @@ int ceph_reserve_caps(struct ceph_mds_client *mdsc,
 
 	for (i = have; i < need; i++) {
 		cap = kmem_cache_alloc(ceph_cap_cachep, GFP_NOFS);
-		if (!cap) {
-			ret = -ENOMEM;
-			goto out_alloc_count;
-		}
+		if (!cap)
+			break;
 		list_add(&cap->caps_item, &newcaps);
 		alloc++;
 	}
-	BUG_ON(have + alloc != need);
+	/* we didn't manage to reserve as much as we needed */
+	if (have + alloc != need)
+		pr_warn("reserve caps ctx=%p ENOMEM need=%d got=%d\n",
+			ctx, need, have + alloc);
 
 	spin_lock(&mdsc->caps_list_lock);
 	mdsc->caps_total_count += alloc;
@@ -197,13 +197,6 @@ int ceph_reserve_caps(struct ceph_mds_client *mdsc,
 	dout("reserve caps ctx=%p %d = %d used + %d resv + %d avail\n",
 	     ctx, mdsc->caps_total_count, mdsc->caps_use_count,
 	     mdsc->caps_reserve_count, mdsc->caps_avail_count);
-	return 0;
-
-out_alloc_count:
-	/* we didn't manage to reserve as much as we needed */
-	pr_warning("reserve caps ctx=%p ENOMEM need=%d got=%d\n",
-		   ctx, need, have);
-	return ret;
 }
 
 int ceph_unreserve_caps(struct ceph_mds_client *mdsc,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 7ccfdb4..dfbb729 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -534,7 +534,7 @@ extern int __ceph_caps_mds_wanted(struct ceph_inode_info *ci);
 extern void ceph_caps_init(struct ceph_mds_client *mdsc);
 extern void ceph_caps_finalize(struct ceph_mds_client *mdsc);
 extern void ceph_adjust_min_caps(struct ceph_mds_client *mdsc, int delta);
-extern int ceph_reserve_caps(struct ceph_mds_client *mdsc,
+extern void ceph_reserve_caps(struct ceph_mds_client *mdsc,
 			     struct ceph_cap_reservation *ctx, int need);
 extern int ceph_unreserve_caps(struct ceph_mds_client *mdsc,
 			       struct ceph_cap_reservation *ctx);
-- 
1.8.1.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
