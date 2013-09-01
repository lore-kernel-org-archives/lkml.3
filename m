Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3IAVqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 17:46:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48427 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3IAVqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 17:46:02 -0400
Date: Sun, 1 Sep 2013 14:45:46 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-2aps0u00eer658fd5xyanan7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, smap: Handle csum_partial_copy_*_user()
Git-Commit-ID: 7263dda41b5a28ae6566fd126d9b06ada73dd721
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 01 Sep 2013 14:45:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7263dda41b5a28ae6566fd126d9b06ada73dd721
Gitweb:     http://git.kernel.org/tip/7263dda41b5a28ae6566fd126d9b06ada73dd721
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 30 Aug 2013 15:43:03 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 1 Sep 2013 14:09:48 -0700

x86, smap: Handle csum_partial_copy_*_user()

Add SMAP annotations to csum_partial_copy_to/from_user().  These
functions legitimately access user space and thus need to set the AC
flag.

TODO: add explicit checks that the side with the kernel space pointer
really points into kernel space.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-2aps0u00eer658fd5xyanan7@git.kernel.org
Cc: <stable@vger.kernel.org> # v3.7+
---
 arch/x86/include/asm/checksum_32.h | 22 +++++++++++++++++-----
 arch/x86/lib/csum-wrappers_64.c    | 12 ++++++++++--
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/checksum_32.h b/arch/x86/include/asm/checksum_32.h
index 46fc474..f50de69 100644
--- a/arch/x86/include/asm/checksum_32.h
+++ b/arch/x86/include/asm/checksum_32.h
@@ -49,9 +49,15 @@ static inline __wsum csum_partial_copy_from_user(const void __user *src,
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
@@ -176,10 +182,16 @@ static inline __wsum csum_and_copy_to_user(const void *src,
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
diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index 25b7ae8..7609e0e 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -6,6 +6,7 @@
  */
 #include <asm/checksum.h>
 #include <linux/module.h>
+#include <asm/smap.h>
 
 /**
  * csum_partial_copy_from_user - Copy and checksum from user space.
@@ -52,8 +53,10 @@ csum_partial_copy_from_user(const void __user *src, void *dst,
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
@@ -105,8 +110,11 @@ csum_partial_copy_to_user(const void *src, void __user *dst,
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
 
