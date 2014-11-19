Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbaKSWWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:22:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbaKSUyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.17 075/141] Fix thinko in iov_iter_single_seg_count
Date: Wed, 19 Nov 2014 12:51:38 -0800
Message-Id: <20141119205153.127266902@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/iov_iter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -699,9 +699,9 @@ size_t iov_iter_single_seg_count(const s
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
 


