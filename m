Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab3CHW6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:58:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30406 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3CHWwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:46 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V7 -next 09/33] iov_iter: add a shorten call
Date: Fri,  8 Mar 2013 16:52:04 -0600
Message-Id: <1362783148-22736-10-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

The generic direct write path wants to shorten its memory vector.  It
does this when it finds that it has to perform a partial write due to
LIMIT_FSIZE.  .direct_IO() always performs IO on all of the referenced
memory because it doesn't have an argument to specify the length of the
IO.

We add an iov_iter operation for this so that the generic path can ask
to shorten the memory vector without having to know what kind it is.
We're happy to shorten the kernel copy of the iovec array, but we refuse
to shorten the bio_vec array and return an error in this case.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/iov-iter.c      | 15 +++++++++++++++
 include/linux/fs.h |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 5624e36..ec461c8 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -226,6 +226,11 @@ static size_t ii_bvec_single_seg_count(const struct iov_iter *i)
 		return min(i->count, bvec->bv_len - i->iov_offset);
 }
 
+static int ii_bvec_shorten(struct iov_iter *i, size_t count)
+{
+	return -EINVAL;
+}
+
 struct iov_iter_ops ii_bvec_ops = {
 	.ii_copy_to_user_atomic = ii_bvec_copy_to_user_atomic,
 	.ii_copy_to_user = ii_bvec_copy_to_user,
@@ -234,6 +239,7 @@ struct iov_iter_ops ii_bvec_ops = {
 	.ii_advance = ii_bvec_advance,
 	.ii_fault_in_readable = ii_bvec_fault_in_readable,
 	.ii_single_seg_count = ii_bvec_single_seg_count,
+	.ii_shorten = ii_bvec_shorten,
 };
 EXPORT_SYMBOL(ii_bvec_ops);
 #endif	/* CONFIG_BLOCK */
@@ -384,6 +390,14 @@ static size_t ii_iovec_single_seg_count(const struct iov_iter *i)
 		return min(i->count, iov->iov_len - i->iov_offset);
 }
 
+static int ii_iovec_shorten(struct iov_iter *i, size_t count)
+{
+	struct iovec *iov = (struct iovec *)i->data;
+	i->nr_segs = iov_shorten(iov, i->nr_segs, count);
+	i->count = min(i->count, count);
+	return 0;
+}
+
 struct iov_iter_ops ii_iovec_ops = {
 	.ii_copy_to_user_atomic = ii_iovec_copy_to_user_atomic,
 	.ii_copy_to_user = ii_iovec_copy_to_user,
@@ -392,5 +406,6 @@ struct iov_iter_ops ii_iovec_ops = {
 	.ii_advance = ii_iovec_advance,
 	.ii_fault_in_readable = ii_iovec_fault_in_readable,
 	.ii_single_seg_count = ii_iovec_single_seg_count,
+	.ii_shorten = ii_iovec_shorten,
 };
 EXPORT_SYMBOL(ii_iovec_ops);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a30d174..bd15cdb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -308,6 +308,7 @@ struct iov_iter_ops {
 	void (*ii_advance)(struct iov_iter *, size_t);
 	int (*ii_fault_in_readable)(struct iov_iter *, size_t);
 	size_t (*ii_single_seg_count)(const struct iov_iter *);
+	int (*ii_shorten)(struct iov_iter *, size_t);
 };
 
 static inline size_t iov_iter_copy_to_user_atomic(struct page *page,
@@ -347,6 +348,10 @@ static inline size_t iov_iter_single_seg_count(const struct iov_iter *i)
 {
 	return i->ops->ii_single_seg_count(i);
 }
+static inline int iov_iter_shorten(struct iov_iter *i, size_t count)
+{
+	return i->ops->ii_shorten(i, count);
+}
 
 #ifdef CONFIG_BLOCK
 extern struct iov_iter_ops ii_bvec_ops;
-- 
1.8.1.5

