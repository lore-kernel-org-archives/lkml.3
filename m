Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaDYQZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:25:32 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:43926 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaDYQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:25:28 -0400
Date: Fri, 25 Apr 2014 18:25:23 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: rw_copy_check_uvector() - free iov on error
Message-ID: <20140425162523.GG10187@tucsk.piliscsaba.szeredi.hu>
References: <20140415145749.GF10187@tucsk.piliscsaba.szeredi.hu>
 <20140416180422.GA20907@redhat.com>
 <20140421155020.GB13709@redhat.com>
 <CAJfpegs9cgVgxbYZSM=SxyJqj=N1QA5npp7ic6i80CMec+3sZw@mail.gmail.com>
 <20140422133835.GA32718@redhat.com>
 <20140423050639.GA2755@zzz.student-wireless07.macalester.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423050639.GA2755@zzz.student-wireless07.macalester.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:06:39AM -0500, Eric Biggers wrote:
> The proposed patch doesn't work because in compat_rw_copy_check_uvector(),
> 'iov' is incremented in the loop before it is freed or returned.  This
> probably should be changed to indexing with 'seg', like in the non-compat
> version...

Do'h, I am indeed blind.

Updated patch below.

Thanks,
Miklos
----

Subject: vfs: rw_copy_check_uvector() - free iov on error
From: Miklos Szeredi <mszeredi@suse.cz>

Some callers (aio_run_iocb, vmsplice_to_user) forget to free the iov on
error.  This seems to be a recurring problem, with most callers being buggy
initially.

So instead of fixing the callers, fix the semantics: free the allocated iov
on error, so callers don't have to.

We could return either fast_pointer or NULL for the error case.  I've opted
for NULL.

Found by Coverity Scan.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/compat.c     |   24 +++++++++++++++---------
 fs/read_write.c |   13 ++++++++++---
 2 files changed, 25 insertions(+), 12 deletions(-)

--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -689,7 +689,7 @@ ssize_t rw_copy_check_uvector(int type,
 	}
 	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
 		ret = -EFAULT;
-		goto out;
+		goto out_free;
 	}
 
 	/*
@@ -710,12 +710,12 @@ ssize_t rw_copy_check_uvector(int type,
 		 * it's about to overflow ssize_t */
 		if (len < 0) {
 			ret = -EINVAL;
-			goto out;
+			goto out_free;
 		}
 		if (type >= 0
 		    && unlikely(!access_ok(vrfy_dir(type), buf, len))) {
 			ret = -EFAULT;
-			goto out;
+			goto out_free;
 		}
 		if (len > MAX_RW_COUNT - ret) {
 			len = MAX_RW_COUNT - ret;
@@ -726,6 +726,13 @@ ssize_t rw_copy_check_uvector(int type,
 out:
 	*ret_pointer = iov;
 	return ret;
+
+out_free:
+	if (iov != fast_pointer) {
+		kfree(iov);
+		iov = NULL;
+	}
+	goto out;
 }
 
 static ssize_t do_readv_writev(int type, struct file *file,
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -549,7 +549,7 @@ ssize_t compat_rw_copy_check_uvector(int
 		struct iovec **ret_pointer)
 {
 	compat_ssize_t tot_len;
-	struct iovec *iov = *ret_pointer = fast_pointer;
+	struct iovec *iov = fast_pointer;
 	ssize_t ret = 0;
 	int seg;
 
@@ -570,11 +570,10 @@ ssize_t compat_rw_copy_check_uvector(int
 		if (iov == NULL)
 			goto out;
 	}
-	*ret_pointer = iov;
 
 	ret = -EFAULT;
 	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
-		goto out;
+		goto out_free;
 
 	/*
 	 * Single unix specification:
@@ -593,27 +592,34 @@ ssize_t compat_rw_copy_check_uvector(int
 		if (__get_user(len, &uvector->iov_len) ||
 		   __get_user(buf, &uvector->iov_base)) {
 			ret = -EFAULT;
-			goto out;
+			goto out_free;
 		}
 		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
-			goto out;
+			goto out_free;
 		if (type >= 0 &&
 		    !access_ok(vrfy_dir(type), compat_ptr(buf), len)) {
 			ret = -EFAULT;
-			goto out;
+			goto out_free;
 		}
 		if (len > MAX_RW_COUNT - tot_len)
 			len = MAX_RW_COUNT - tot_len;
 		tot_len += len;
-		iov->iov_base = compat_ptr(buf);
-		iov->iov_len = (compat_size_t) len;
+		iov[seg].iov_base = compat_ptr(buf);
+		iov[seg].iov_len = (compat_size_t) len;
 		uvector++;
-		iov++;
 	}
 	ret = tot_len;
 
 out:
+	*ret_pointer = iov;
 	return ret;
+
+out_free:
+	if (iov != fast_pointer) {
+		kfree(iov);
+		iov = NULL;
+	}
+	goto out;
 }
 
 static inline long
