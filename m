Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaKXElw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:41:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38621 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaKXElv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:41:51 -0500
Date: Mon, 24 Nov 2014 04:41:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] reduce the amount of boilerplate in iov_iter.c
Message-ID: <20141124044149.GC7996@ZenIV.linux.org.uk>
References: <20141124010953.GB7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124010953.GB7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 01:09:54AM +0000, Al Viro wrote:
> Specifically, it allows to add a new kind of iovecs (ITER_KVEC using
> straight memcpy instead of going through copy_..._user) at the cost of
> mere 74 extra lines (see the next patch) and allows to add the things
> like csum_and_copy_{from,to}_iter() without arseloads of extra code (also
> written, but I'd prefer to clean it up a bit more first).

FWIW, the current variant of csum_and_copy_..._iter (completely untested,
without any code in net/* that would use it, etc.) is this:

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 6e16945..28ed2d9 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -124,6 +124,8 @@ static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 {
 	i->count = count;
 }
+size_t csum_and_copy_to_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
+size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 
 int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 int memcpy_toiovec(struct iovec *iov, unsigned char *kdata, int len);
diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index 89ed7cd..fa03b8d 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -3,6 +3,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <net/checksum.h>
 
 #define iterate_iovec(i, n, __v, __p, skip, STEP) {	\
 	size_t left;					\
@@ -577,6 +578,76 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 }
 EXPORT_SYMBOL(iov_iter_get_pages_alloc);
 
+size_t copy_and_csum_from_iter(void *addr, size_t bytes, __wsum *csum,
+			       struct iov_iter *i)
+{
+	char *to = addr;
+	__wsum sum;
+	if (unlikely(bytes > i->count))
+		bytes = i->count;
+
+	if (unlikely(!bytes))
+		return 0;
+
+	sum = *csum;
+	iterate_all_kinds_shift(i, bytes, v, ({
+		int err = 0;
+		__wsum next;
+		next = csum_and_copy_from_user(v.iov_base, 
+					       (to += v.iov_len) - v.iov_len,
+					       v.iov_len, sum, &err);
+		err ? v.iov_len : (sum = next, 0);
+	}), ({
+		char *p = kmap_atomic(v.bv_page);
+		sum = csum_partial_copy_nocheck(p + v.bv_offset,
+						(to += v.bv_len) - v.bv_len,
+						v.bv_len, sum);
+		kunmap_atomic(p);
+	}),
+		sum = csum_partial_copy_nocheck(v.iov_base,
+						(to += v.iov_len) - v.iov_len,
+						v.iov_len, sum)
+	)
+	*csum = sum;
+	return bytes;
+}
+EXPORT_SYMBOL(csum_and_copy_from_iter);
+
+size_t copy_and_csum_to_iter(void *addr, size_t bytes, __wsum *csum,
+			     struct iov_iter *i)
+{
+	char *from = addr;
+	__wsum sum;
+	if (unlikely(bytes > i->count))
+		bytes = i->count;
+
+	if (unlikely(!bytes))
+		return 0;
+
+	sum = *csum;
+	iterate_all_kinds_shift(i, bytes, v, ({
+		int err = 0;
+		__wsum next;
+		next = csum_and_copy_to_user((from += v.iov_len) - v.iov_len,
+					     v.iov_base, 
+					     v.iov_len, sum, &err);
+		err ? v.iov_len : (sum = next, 0);
+	}), ({
+		char *p = kmap_atomic(v.bv_page);
+		sum = csum_partial_copy_nocheck((from += v.bv_len) - v.bv_len,
+						p + v.bv_offset,
+						v.bv_len, sum);
+		kunmap_atomic(p);
+	}),
+		sum = csum_partial_copy_nocheck((from += v.iov_len) - v.iov_len,
+						v.iov_base,
+						v.iov_len, sum)
+	)
+	*csum = sum;
+	return bytes;
+}
+EXPORT_SYMBOL(csum_and_copy_to_iter);
+
 int iov_iter_npages(const struct iov_iter *i, int maxpages)
 {
 	size_t size = i->count;
