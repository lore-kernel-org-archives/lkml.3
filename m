Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbbALJUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:20:10 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27669 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbbALJUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:20:05 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-dd-54b391c15d0c
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] kernfs: convert node name allocation to kstrdup_const
Date: Mon, 12 Jan 2015 10:18:40 +0100
Message-id: <1421054323-14430-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xK7oHJ24OMZi3Qdvi1rpzrBZz1q9h
	szhy7Tu7xeV/b1gszja9AbJ2zWGzuLfmP6vF2iN32S2eTrjIZnH+73FWBy6P+Ts/Mnps+jSJ
	3ePOtT1sHidm/GbxWHJTzaNvyypGj8+b5Dw2PXnLFMARxWWTkpqTWZZapG+XwJXxd+sVtoKn
	/BV3emawNTDe4+li5OSQEDCRuD7hPyOELSZx4d56ti5GLg4hgaWMErdfTWSFcPqYJB79v8YO
	UsUmoCnxd/NNNhBbBKjj45nLzCBFzAInmCTW/2pkAkkIC3hJ7J55HKyBRUBV4v2HnWAreAWc
	JXpvbINaJydx8thkVhCbU8BF4uLOt8wgthBQzdWD55knMPIuYGRYxSiaWppcUJyUnmuoV5yY
	W1yal66XnJ+7iRESkl92MC4+ZnWIUYCDUYmHd4LM5hAh1sSy4srcQ4wSHMxKIryuZUAh3pTE
	yqrUovz4otKc1OJDjEwcnFINjCbtMzRNS/J+Xnu+gnnNmuiMA9+1ha9NnGGZEiwtdaU886t/
	d/lR24keTOrLetddMhM3EeQv2fVoZXTBok9f9n/+kfVogYc4j6/d288TfmszC8npbNgn/cBZ
	ta5yeW2BRPDEX5odK+7IM/rbFO08ct68bpL1rOa+mEfimyU27lQ70V+w+UKQgRJLcUaioRZz
	UXEiAMqHjIcnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs frequently performs duplication of strings located
in read-only memory section. Replacing kstrdup by kstrdup_const
allows to avoid such operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 fs/kernfs/dir.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 37989f0..259e92a 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -408,7 +408,7 @@ void kernfs_put(struct kernfs_node *kn)
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
 	if (!(kn->flags & KERNFS_STATIC_NAME))
-		kfree(kn->name);
+		kfree_const(kn->name);
 	if (kn->iattr) {
 		if (kn->iattr->ia_secdata)
 			security_release_secctx(kn->iattr->ia_secdata,
@@ -502,12 +502,12 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 					     const char *name, umode_t mode,
 					     unsigned flags)
 {
-	char *dup_name = NULL;
+	const char *dup_name = NULL;
 	struct kernfs_node *kn;
 	int ret;
 
 	if (!(flags & KERNFS_STATIC_NAME)) {
-		name = dup_name = kstrdup(name, GFP_KERNEL);
+		name = dup_name = kstrdup_const(name, GFP_KERNEL);
 		if (!name)
 			return NULL;
 	}
@@ -534,7 +534,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
  err_out2:
 	kmem_cache_free(kernfs_node_cache, kn);
  err_out1:
-	kfree(dup_name);
+	kfree_const(dup_name);
 	return NULL;
 }
 
@@ -1260,7 +1260,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	/* rename kernfs_node */
 	if (strcmp(kn->name, new_name) != 0) {
 		error = -ENOMEM;
-		new_name = kstrdup(new_name, GFP_KERNEL);
+		new_name = kstrdup_const(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
 	} else {
@@ -1293,7 +1293,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	kernfs_link_sibling(kn);
 
 	kernfs_put(old_parent);
-	kfree(old_name);
+	kfree_const(old_name);
 
 	error = 0;
  out:
-- 
1.9.1

