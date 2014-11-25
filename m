Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaKYKnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbaKYKnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Mackerras <paulus@samba.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 205/254] Fix thinko in iov_iter_single_seg_count
Date: Tue, 25 Nov 2014 10:39:15 +0000
Message-Id: <1416912004-5928-206-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit ad0eab9293485d1c06237e9249f6d4dfa3d93d4d upstream.

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

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/iov_iter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index 9a09f2034fcc..141dcf796d28 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -699,9 +699,9 @@ size_t iov_iter_single_seg_count(const struct iov_iter *i)
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
 
-- 
2.1.0

