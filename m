Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaAGTyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:54:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:54296 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbaAGTyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:54:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,620,1384329600"; 
   d="scan'208";a="455026767"
From: ville.syrjala@linux.intel.com
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] x86: Drop casts from __copy_{from,to}_user_inatomic
Date: Tue,  7 Jan 2014 21:54:21 +0200
Message-Id: <1389124461-31650-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The casts in __copy_{from,to}_user_inatomic lead to sparse warnings.
Drop the casts to get rid of the warnings.

Example:
  CHECK   drivers/gpu/drm/i915/i915_gem.c
arch/x86/include/asm/uaccess_64.h:213:40: warning: incorrect type in argument 1 (different address spaces)
arch/x86/include/asm/uaccess_64.h:213:40:    expected void [noderef] <asn:1>*dst
arch/x86/include/asm/uaccess_64.h:213:40:    got void *<noident>

The warnings got introduced by this commit:
 commit ff47ab4ff3cddfa7bc1b25b990e24abe2ae474ff
 Author: Andi Kleen <ak@linux.intel.com>
 Date:   Fri Aug 16 14:17:19 2013 -0700

    x86: Add 1/2/4/8 byte optimization to 64bit __copy_{from,to}_user_inatomic

Cc: Andi Kleen <ak@linux.intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 arch/x86/include/asm/uaccess_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 190413d..12a26b9 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -204,13 +204,13 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
-	return __copy_from_user_nocheck(dst, (__force const void *)src, size);
+	return __copy_from_user_nocheck(dst, src, size);
 }
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 {
-	return __copy_to_user_nocheck((__force void *)dst, src, size);
+	return __copy_to_user_nocheck(dst, src, size);
 }
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
-- 
1.8.3.2

