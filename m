Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbbALJU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:20:58 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31764 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbbALJUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:20:16 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-1d-54b391ce13b9
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] fs/namespace: convert devname allocation to kstrdup_const
Date: Mon, 12 Jan 2015 10:18:43 +0100
Message-id: <1421054323-14430-6-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xK7rnJm4OMZj3xtri1rpzrBZz1q9h
	szhy7Tu7xeV/b1gszja9AbJ2zWGzuLfmP6vF2iN32S2eTrjIZnH+73FWBy6P+Ts/Mnps+jSJ
	3ePOtT1sHidm/GbxWHJTzaNvyypGj8+b5Dw2PXnLFMARxWWTkpqTWZZapG+XwJVxYdJ/poJF
	nBWndsxjb2A8z97FyMkhIWAi8WnnOiYIW0ziwr31bF2MXBxCAksZJdZOfALl9DFJLPu+AayK
	TUBT4u/mm2wgtghQx8czl5lBipgFTjBJrP/VCFYkLOAn0XPtNTOIzSKgKrHs6BKwOK+As8SC
	eRPYINbJSZw8NpkVxOYUcJG4uPMtWL0QUM3Vg+eZJzDyLmBkWMUomlqaXFCclJ5rqFecmFtc
	mpeul5yfu4kREpJfdjAuPmZ1iFGAg1GJh3eCzOYQIdbEsuLK3EOMEhzMSiK8rmVAId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYyh9jPXhUb8d5go9EhZPVwx9MSRL84LnGRjhUt6bz2J3Vsn5pqU
	zG59aK/2nbeL6yWql8XLuuXxxWhnBSyo9StuXJu3pphj19QNzRcl+8XT7jV/vn28/8kC18l6
	JZNDvzeGnVK4P7k2VkX5vr7Wxotq/xPdr51jWe2+79X6435MR16nVrQseK3EUpyRaKjFXFSc
	CADjw2CVJwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFS frequently performs duplication of strings located
in read-only memory section. Replacing kstrdup by kstrdup_const
allows to avoid such operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 fs/namespace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index cd1e968..6dae553 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -201,7 +201,7 @@ static struct mount *alloc_vfsmnt(const char *name)
 			goto out_free_cache;
 
 		if (name) {
-			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
+			mnt->mnt_devname = kstrdup_const(name, GFP_KERNEL);
 			if (!mnt->mnt_devname)
 				goto out_free_id;
 		}
@@ -234,7 +234,7 @@ static struct mount *alloc_vfsmnt(const char *name)
 
 #ifdef CONFIG_SMP
 out_free_devname:
-	kfree(mnt->mnt_devname);
+	kfree_const(mnt->mnt_devname);
 #endif
 out_free_id:
 	mnt_free_id(mnt);
@@ -568,7 +568,7 @@ int sb_prepare_remount_readonly(struct super_block *sb)
 
 static void free_vfsmnt(struct mount *mnt)
 {
-	kfree(mnt->mnt_devname);
+	kfree_const(mnt->mnt_devname);
 #ifdef CONFIG_SMP
 	free_percpu(mnt->mnt_pcp);
 #endif
-- 
1.9.1

