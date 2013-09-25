Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3IYAU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3IYAUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 051/117] x86, smap: Handle csum_partial_copy_*_user()
Date: Tue, 24 Sep 2013 17:18:37 -0700
Message-Id: <20130925001746.423484117@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 7263dda41b5a28ae6566fd126d9b06ada73dd721 upstream.

Add SMAP annotations to csum_partial_copy_to/from_user().  These
functions legitimately access user space and thus need to set the AC
flag.

TODO: add explicit checks that the side with the kernel space pointer
really points into kernel space.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-2aps0u00eer658fd5xyanan7@git.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/checksum_32.h |   22 +++++++++++++++++-----
 arch/x86/lib/csum-wrappers_64.c    |   12 ++++++++++--
 2 files changed, 27 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/checksum_32.h
+++ b/arch/x86/include/asm/checksum_32.h
@@ -49,9 +49,15 @@ static inline __wsum csum_partial_copy_f
 						 int len, __wsum sum,
 						 int *err_ptr)
 {
+	__wsum ret;
+
 	might_sleep();
-	return csum_partial_copy_generic((__force void *)src, dst,
-					 len, sum, err_ptr, NULL);
+	stac();
+	ret = csum_partial_copy_generic((__force void *)src, dst,
+					len, sum, err_ptr, NULL);
+	clac();
+
+	return ret;
 }
 
 /*
@@ -176,10 +182,16 @@ static inline __wsum csum_and_copy_to_us
 					   int len, __wsum sum,
 					   int *err_ptr)
 {
+	__wsum ret;
+
 	might_sleep();
-	if (access_ok(VERIFY_WRITE, dst, len))
-		return csum_partial_copy_generic(src, (__force void *)dst,
-						 len, sum, NULL, err_ptr);
+	if (access_ok(VERIFY_WRITE, dst, len)) {
+		stac();
+		ret = csum_partial_copy_generic(src, (__force void *)dst,
+						len, sum, NULL, err_ptr);
+		clac();
+		return ret;
+	}
 
 	if (len)
 		*err_ptr = -EFAULT;
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -6,6 +6,7 @@
  */
 #include <asm/checksum.h>
 #include <linux/module.h>
+#include <asm/smap.h>
 
 /**
  * csum_partial_copy_from_user - Copy and checksum from user space.
@@ -52,8 +53,10 @@ csum_partial_copy_from_user(const void _
 			len -= 2;
 		}
 	}
+	stac();
 	isum = csum_partial_copy_generic((__force const void *)src,
 				dst, len, isum, errp, NULL);
+	clac();
 	if (unlikely(*errp))
 		goto out_err;
 
@@ -82,6 +85,8 @@ __wsum
 csum_partial_copy_to_user(const void *src, void __user *dst,
 			  int len, __wsum isum, int *errp)
 {
+	__wsum ret;
+
 	might_sleep();
 
 	if (unlikely(!access_ok(VERIFY_WRITE, dst, len))) {
@@ -105,8 +110,11 @@ csum_partial_copy_to_user(const void *sr
 	}
 
 	*errp = 0;
-	return csum_partial_copy_generic(src, (void __force *)dst,
-					 len, isum, NULL, errp);
+	stac();
+	ret = csum_partial_copy_generic(src, (void __force *)dst,
+					len, isum, NULL, errp);
+	clac();
+	return ret;
 }
 EXPORT_SYMBOL(csum_partial_copy_to_user);
 


