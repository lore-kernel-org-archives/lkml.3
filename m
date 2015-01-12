Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbbALJUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:20:18 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27809 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbbALJUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:20:13 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ff-54b391cae480
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] mm/slab: convert cache name allocations to kstrdup_const
Date: Mon, 12 Jan 2015 10:18:42 +0100
Message-id: <1421054323-14430-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xK7qnJm4OMVh6V8bi1rpzrBZz1q9h
	szhy7Tu7xeV/b1gszja9AbJ2zWGzuLfmP6vF2iN32S2eTrjIZnH+73FWBy6P+Ts/Mnps+jSJ
	3ePOtT1sHidm/GbxWHJTzaNvyypGj8+b5Dw2PXnLFMARxWWTkpqTWZZapG+XwJXx5ssepoIp
	nBWbbn9gbmDczt7FyMkhIWAisWT5VjYIW0ziwr31QDYXh5DAUkaJlYuOMEI4fUwSJzsvMYJU
	sQloSvzdfBOsQwSo4+OZy8wgRcwCJ5gk1v9qZAJJCAv4SszdtJ0ZxGYRUJWYsmE/UDMHB6+A
	s8TFSYUQ2+QkTh6bzApicwq4SFzc+RasXAio5OrB88wTGHkXMDKsYhRNLU0uKE5KzzXUK07M
	LS7NS9dLzs/dxAgJyC87GBcfszrEKMDBqMTDO0Fmc4gQa2JZcWXuIUYJDmYlEV7XMqAQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGRgs/dS5L6xXlV9sFchLfJV/S+rtTr/X3D5m5JrNSFX5NKNaq
	2NT5cvaFXp5D9x+nf8qaZ+ek+ae1RF/YdffZBU1tl4X/bD6fdqKn/bNUrnXetFnXz1ybuFX1
	xYKrT4TO59zM2HW39LTRvIk/JJhsTlZozk57HLF9jsTzsguJVey1Opq274MCNiuxFGckGmox
	FxUnAgDvS6IhJgIAAA==
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

