Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaLVLuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:50:14 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35744 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaLVLuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:10 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 09/17] block: refactor iov_count_pages() from bio_{copy,map}_user_iov()
Date: Mon, 22 Dec 2014 12:48:36 +0100
Message-Id: <d42dae3d2a64fa4c3a0893f1af963151b31869e3.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Refactor the common part in bio_copy_user_iov() and
__bio_map_user_iov() to separate out iov_count_pages() into the general
iov_iter API, instead of open coding iov iterations as done previously.

This commit should contain only literal replacements, without
functional changes.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 block/bio.c         | 43 ++++++-------------------------------------
 include/linux/uio.h |  2 ++
 lib/iovec.c         | 30 ++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 524b401..2adb68b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1110,24 +1110,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	unsigned int len;
 	unsigned int offset = map_data ? map_data->offset & ~PAGE_MASK : 0;
 
-	for (i = 0; i < iter->nr_segs; i++) {
-		unsigned long uaddr;
-		unsigned long end;
-		unsigned long start;
-
-		uaddr = (unsigned long) iter->iov[i].iov_base;
-		end = (uaddr + iter->iov[i].iov_len + PAGE_SIZE - 1)
-			>> PAGE_SHIFT;
-		start = uaddr >> PAGE_SHIFT;
-
-		/*
-		 * Overflow, abort
-		 */
-		if (end < start)
-			return ERR_PTR(-EINVAL);
-
-		nr_pages += end - start;
-	}
+	nr_pages = iov_count_pages(iter, 0);
+	if (nr_pages < 0)
+		return ERR_PTR(nr_pages);
 
 	if (offset)
 		nr_pages++;
@@ -1257,25 +1242,9 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	struct iov_iter i;
 	struct iovec iov;
 
-	iov_for_each(iov, i, *iter) {
-		unsigned long uaddr = (unsigned long) iov.iov_base;
-		unsigned long len = iov.iov_len;
-		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		unsigned long start = uaddr >> PAGE_SHIFT;
-
-		/*
-		 * Overflow, abort
-		 */
-		if (end < start)
-			return ERR_PTR(-EINVAL);
-
-		nr_pages += end - start;
-		/*
-		 * buffer must be aligned to at least hardsector size for now
-		 */
-		if (uaddr & queue_dma_alignment(q))
-			return ERR_PTR(-EINVAL);
-	}
+	nr_pages = iov_count_pages(iter, queue_dma_alignment(q));
+	if (nr_pages < 0)
+		return ERR_PTR(nr_pages);
 
 	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 1c5e453..142ff1b 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -72,6 +72,8 @@ static inline struct iovec iov_iter_iovec(const struct iov_iter *iter)
 
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
 
+int iov_count_pages(const struct iov_iter *iter, unsigned align);
+
 size_t iov_iter_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
diff --git a/lib/iovec.c b/lib/iovec.c
index 2d99cb4..2e75086 100644
--- a/lib/iovec.c
+++ b/lib/iovec.c
@@ -1,5 +1,7 @@
 #include <linux/uaccess.h>
 #include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
 #include <linux/uio.h>
 
 /*
@@ -85,3 +87,31 @@ int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 	return 0;
 }
 EXPORT_SYMBOL(memcpy_fromiovecend);
+
+int iov_count_pages(const struct iov_iter *iter, unsigned align)
+{
+	struct iov_iter i = *iter;
+	int nr_pages = 0;
+
+	while (iov_iter_count(&i)) {
+		unsigned long uaddr = (unsigned long) i.iov->iov_base +
+			i.iov_offset;
+		unsigned long len = i.iov->iov_len - i.iov_offset;
+
+		if ((uaddr & align) || (len & align))
+			return -EINVAL;
+
+		/*
+		 * Overflow, abort
+		 */
+		if (uaddr + len < uaddr)
+			return -EINVAL;
+
+		nr_pages += DIV_ROUND_UP(len + offset_in_page(uaddr),
+					 PAGE_SIZE);
+		iov_iter_advance(&i, len);
+	}
+
+	return nr_pages;
+}
+EXPORT_SYMBOL(iov_count_pages);
-- 
2.1.0

