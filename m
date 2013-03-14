Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab3CNKkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:40:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52106 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab3CNKiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 82/88] Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and security keys
Date: Thu, 14 Mar 2013 10:36:15 +0000
Message-Id: <1363257381-15900-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 8aec0f5d4137532de14e6554fd5dd201ff3a3c49 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/compat.c            | 15 +++++++--------
 mm/process_vm_access.c |  8 --------
 security/keys/compat.c |  4 ++--
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 1bdb350..8e8461e 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -558,6 +558,10 @@ ssize_t compat_rw_copy_check_uvector(int type,
 	}
 	*ret_pointer = iov;
 
+	ret = -EFAULT;
+	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
+		goto out;
+
 	/*
 	 * Single unix specification:
 	 * We should -EINVAL if an element length is not >= 0 and fitting an
@@ -1084,17 +1088,12 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
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
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 926b466..fd26d04 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
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
 
diff --git a/security/keys/compat.c b/security/keys/compat.c
index c92d42b..803525f 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -40,12 +40,12 @@ long compat_keyctl_instantiate_key_iov(
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
1.8.1.2

