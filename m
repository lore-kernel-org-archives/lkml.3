Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaLIW5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:57:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37460 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaLIWuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:50:39 -0500
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/25] iov_iter.c: get rid of bvec_copy_page_{to,from}_iter()
Date: Tue,  9 Dec 2014 22:50:20 +0000
Message-Id: <1418165438-2205-7-git-send-email-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20141209224928.GL22149@ZenIV.linux.org.uk>
References: <20141209224928.GL22149@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Just have copy_page_{to,from}_iter() fall back to kmap_atomic +
copy_{to,from}_iter() + kunmap_atomic() in ITER_BVEC case.  As
the matter of fact, that's what we want to do for any iov_iter
kind that isn't blocking - e.g. ITER_KVEC will also go that way
once we recognize it on iov_iter.c primitives level

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/iov_iter.c | 60 ++++++++++++++++++++++++-----------------------------------
 1 file changed, 24 insertions(+), 36 deletions(-)

diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index 39ad713..17b7144 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -486,30 +486,33 @@ static size_t copy_from_iter_bvec(void *to, size_t bytes, struct iov_iter *i)
 	return wanted;
 }
 
-static size_t copy_page_to_iter_bvec(struct page *page, size_t offset,
-					size_t bytes, struct iov_iter *i)
+size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
-	void *kaddr = kmap_atomic(page);
-	size_t wanted = copy_to_iter_bvec(kaddr + offset, bytes, i);
-	kunmap_atomic(kaddr);
-	return wanted;
+	if (i->type & ITER_BVEC)
+		return copy_to_iter_bvec(addr, bytes, i);
+	else
+		return copy_to_iter_iovec(addr, bytes, i);
 }
+EXPORT_SYMBOL(copy_to_iter);
 
-static size_t copy_page_from_iter_bvec(struct page *page, size_t offset,
-					size_t bytes, struct iov_iter *i)
+size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
-	void *kaddr = kmap_atomic(page);
-	size_t wanted = copy_from_iter_bvec(kaddr + offset, bytes, i);
-	kunmap_atomic(kaddr);
-	return wanted;
+	if (i->type & ITER_BVEC)
+		return copy_from_iter_bvec(addr, bytes, i);
+	else
+		return copy_from_iter_iovec(addr, bytes, i);
 }
+EXPORT_SYMBOL(copy_from_iter);
 
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
-	if (i->type & ITER_BVEC)
-		return copy_page_to_iter_bvec(page, offset, bytes, i);
-	else
+	if (i->type & (ITER_BVEC|ITER_KVEC)) {
+		void *kaddr = kmap_atomic(page);
+		size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
+		kunmap_atomic(kaddr);
+		return wanted;
+	} else
 		return copy_page_to_iter_iovec(page, offset, bytes, i);
 }
 EXPORT_SYMBOL(copy_page_to_iter);
@@ -517,31 +520,16 @@ EXPORT_SYMBOL(copy_page_to_iter);
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
-	if (i->type & ITER_BVEC)
-		return copy_page_from_iter_bvec(page, offset, bytes, i);
-	else
+	if (i->type & ITER_BVEC) {
+		void *kaddr = kmap_atomic(page);
+		size_t wanted = copy_from_iter(kaddr + offset, bytes, i);
+		kunmap_atomic(kaddr);
+		return wanted;
+	} else
 		return copy_page_from_iter_iovec(page, offset, bytes, i);
 }
 EXPORT_SYMBOL(copy_page_from_iter);
 
-size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
-{
-	if (i->type & ITER_BVEC)
-		return copy_to_iter_bvec(addr, bytes, i);
-	else
-		return copy_to_iter_iovec(addr, bytes, i);
-}
-EXPORT_SYMBOL(copy_to_iter);
-
-size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
-{
-	if (i->type & ITER_BVEC)
-		return copy_from_iter_bvec(addr, bytes, i);
-	else
-		return copy_from_iter_iovec(addr, bytes, i);
-}
-EXPORT_SYMBOL(copy_from_iter);
-
 size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
 {
 	if (unlikely(bytes > i->count))
-- 
2.1.3

