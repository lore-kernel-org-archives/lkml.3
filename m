Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab3BYPUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:20:42 -0500
Received: from mail.openrapids.net ([64.15.138.104]:32974 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754305Ab3BYPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:20:39 -0500
Date: Mon, 25 Feb 2013 10:20:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Security Officers <security@kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix: compat_rw_copy_check_uvector() misuse in aio, readv,
	writev, and security keys
Message-ID: <20130225152036.GA3405@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at mm/process_vm_access.c:process_vm_rw() and comparing it to
compat_process_vm_rw() shows that the compatibility code requires an
explicit "access_ok()" check before calling
compat_rw_copy_check_uvector(). The same difference seems to appear when
we compare fs/read_write.c:do_readv_writev() to
fs/compat.c:compat_do_readv_writev().

This subtle difference between the compat and non-compat requirements
should probably be debated, as it seems to be error-prone. In fact,
there are two others sites that use this function in the Linux kernel,
and they both seem to get it wrong:

Now shifting our attention to fs/aio.c, we see that aio_setup_iocb()
also ends up calling compat_rw_copy_check_uvector() through
aio_setup_vectored_rw(). Unfortunately, the access_ok() check appears to
be missing. Same situation for
security/keys/compat.c:compat_keyctl_instantiate_key_iov().

I propose that we add the access_ok() check directly into
compat_rw_copy_check_uvector(), so callers don't have to worry about it,
and it therefore makes the compat call code similar to its non-compat
counterpart. Place the access_ok() check in the same location where
copy_from_user() can trigger a -EFAULT error in the non-compat code, so
the ABI behaviors are alike on both compat and non-compat.

While we are here, fix compat_do_readv_writev() so it checks for
compat_rw_copy_check_uvector() negative return values.

And also, fix a memory leak in compat_keyctl_instantiate_key_iov() error
handling.

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 fs/compat.c            |   15 +++++++--------
 mm/process_vm_access.c |    8 --------
 security/keys/compat.c |    4 ++--
 3 files changed, 9 insertions(+), 18 deletions(-)

Index: linux/fs/compat.c
===================================================================
--- linux.orig/fs/compat.c
+++ linux/fs/compat.c
@@ -558,6 +558,10 @@ ssize_t compat_rw_copy_check_uvector(int
 	}
 	*ret_pointer = iov;
 
+	ret = -EFAULT;
+	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
+		goto out;
+
 	/*
 	 * Single unix specification:
 	 * We should -EINVAL if an element length is not >= 0 and fitting an
@@ -1080,17 +1084,12 @@ static ssize_t compat_do_readv_writev(in
 	if (!file->f_op)
 		goto out;
 
-	ret = -EFAULT;
-	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
-		goto out;
-
-	tot_len = compat_rw_copy_check_uvector(type, uvector, nr_segs,
+	ret = compat_rw_copy_check_uvector(type, uvector, nr_segs,
 					       UIO_FASTIOV, iovstack, &iov);
-	if (tot_len == 0) {
-		ret = 0;
+	if (ret <= 0)
 		goto out;
-	}
 
+	tot_len = ret;
 	ret = rw_verify_area(type, file, pos, tot_len);
 	if (ret < 0)
 		goto out;
Index: linux/mm/process_vm_access.c
===================================================================
--- linux.orig/mm/process_vm_access.c
+++ linux/mm/process_vm_access.c
@@ -429,12 +429,6 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (flags != 0)
 		return -EINVAL;
 
-	if (!access_ok(VERIFY_READ, lvec, liovcnt * sizeof(*lvec)))
-		goto out;
-
-	if (!access_ok(VERIFY_READ, rvec, riovcnt * sizeof(*rvec)))
-		goto out;
-
 	if (vm_write)
 		rc = compat_rw_copy_check_uvector(WRITE, lvec, liovcnt,
 						  UIO_FASTIOV, iovstack_l,
@@ -459,8 +453,6 @@ free_iovecs:
 		kfree(iov_r);
 	if (iov_l != iovstack_l)
 		kfree(iov_l);
-
-out:
 	return rc;
 }
 
Index: linux/security/keys/compat.c
===================================================================
--- linux.orig/security/keys/compat.c
+++ linux/security/keys/compat.c
@@ -40,12 +40,12 @@ static long compat_keyctl_instantiate_ke
 					   ARRAY_SIZE(iovstack),
 					   iovstack, &iov);
 	if (ret < 0)
-		return ret;
+		goto err;
 	if (ret == 0)
 		goto no_payload_free;
 
 	ret = keyctl_instantiate_key_common(id, iov, ioc, ret, ringid);
-
+err:
 	if (iov != iovstack)
 		kfree(iov);
 	return ret;
-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
