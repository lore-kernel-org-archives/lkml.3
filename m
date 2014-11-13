Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaKMJPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:15:35 -0500
Received: from ozlabs.org ([103.22.144.67]:41974 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaKMJP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:15:29 -0500
Date: Thu, 13 Nov 2014 20:15:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix thinko in iov_iter_single_seg_count
Message-ID: <20141113091523.GC26910@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The branches of the if (i->type & ITER_BVEC) statement in
iov_iter_single_seg_count() are the wrong way around; if ITER_BVEC is
clear then we use i->bvec, when we should be using i->iov.  This fixes
it.

In my case, the symptom that this caused was that a KVM guest doing
filesystem operations on a virtual disk would result in one of qemu's
threads on the host going into an infinite loop in
generic_perform_write().  The loop would hit the copied == 0 case and
call iov_iter_single_seg_count() to reduce the number of bytes to try
to process, but because of the error, iov_iter_single_seg_count()
would just return i->count and the loop made no progress and continued
forever.

Cc: stable@vger.kernel.org # 3.16+
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index eafcf60..e34a3cb 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -911,9 +911,9 @@ size_t iov_iter_single_seg_count(const struct iov_iter *i)
 	if (i->nr_segs == 1)
 		return i->count;
 	else if (i->type & ITER_BVEC)
-		return min(i->count, i->iov->iov_len - i->iov_offset);
-	else
 		return min(i->count, i->bvec->bv_len - i->iov_offset);
+	else
+		return min(i->count, i->iov->iov_len - i->iov_offset);
 }
 EXPORT_SYMBOL(iov_iter_single_seg_count);
 
