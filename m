Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaL2Ouf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:50:35 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28938 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaL2OuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:50:13 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e5-54a16a2451c3
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/4] mm/slab: use kstrdup_const for allocating cache names
Date: Mon, 29 Dec 2014 15:48:30 +0100
Message-id: <1419864510-24834-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
References: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xq7oqWQtDDNonG1vcWneO1eLyrjls
	FvfW/Ge1WHvkLrsDi8emT5PYPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvjzZc9TAVTOCs2
	3f7A3MC4nb2LkZNDQsBEYvGJHVC2mMSFe+vZuhi5OIQEljJKHH/yGMrpY5KY/XIlG0gVm4Cm
	xN/NN8FsEaCOj2cuM3cxcnAwC5RI3DorBhIWFvCTOLq7D6yERUBV4sid2WA2r4CzxMONyxkh
	lslJnDw2mRWklVPAReJvVxxIWAio5OeSKewTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dL
	zs/dxAgJkK87GJceszrEKMDBqMTDm3BiQYgQa2JZcWXuIUYJDmYlEV5py4UhQrwpiZVVqUX5
	8UWlOanFhxiZODilGhj5Xcx2xHics2FbvzPOY/PnjHk3dM79OmyfvG0lv+SE9Ca2FXo5Bqv/
	t9YX7Vi+Oni9bs30VWFrmF9mFMY8Cuu6l37Gc32zcl1sy2QtdgdZxl430VO3Mu5nSt2+k/NO
	d8ID00P1e/nUGmf4zJC9vSvPiX3D2upH3+d6b7u/8a5cs+rKd0wxFzYrsRRnJBpqMRcVJwIA
	hFDYke4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slab frequently performs duplication of strings located
in read-only memory section. Replacing kstrdup by kstrdup_const
allows to avoid such operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 mm/slab_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index e03dd6f..2d94d1a 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -390,7 +390,7 @@ kmem_cache_create(const char *name, size_t size, size_t align,
 	if (s)
 		goto out_unlock;
 
-	cache_name = kstrdup(name, GFP_KERNEL);
+	cache_name = kstrdup_const(name, GFP_KERNEL);
 	if (!cache_name) {
 		err = -ENOMEM;
 		goto out_unlock;
@@ -401,7 +401,7 @@ kmem_cache_create(const char *name, size_t size, size_t align,
 				 flags, ctor, NULL, NULL);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
-		kfree(cache_name);
+		kfree_const(cache_name);
 	}
 
 out_unlock:
@@ -494,7 +494,7 @@ static int memcg_cleanup_cache_params(struct kmem_cache *s)
 
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
-	kfree(s->name);
+	kfree_const(s->name);
 	kmem_cache_free(kmem_cache, s);
 }
 
-- 
1.9.1

