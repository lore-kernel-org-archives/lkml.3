Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaGCBMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:12:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57555 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaGCBMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:12:05 -0400
Date: Wed, 2 Jul 2014 18:10:59 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] kbuild: explain stack-protector-strong CONFIG logic
Message-ID: <20140703011059.GA6331@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702175635.79d54c44.akpm@linux-foundation.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a hopefully helpful comment above the (seemingly weird)
compiler flag selection logic.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Makefile |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Makefile b/Makefile
index 13175632137f..ea88e68d121e 100644
--- a/Makefile
+++ b/Makefile
@@ -630,6 +630,22 @@ KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
 # Handle stack protector mode.
+#
+# Since kbuild can potentially perform two passes (first with the old
+# .config values and then with updated .config values), we cannot error out
+# if a desired compiler option is unsupported. If we were to error, kbuild
+# could never get to the second pass and actually notice that we changed
+# the option to something that was supported.
+#
+# Additionally, we don't want to fallback and/or silently change which compiler
+# flags will be used, since that leads to producing kernels with different
+# security feature characteristics depending on the compiler used. ("But I
+# selected CC_STACKPROTECTOR_STRONG! Why did it build with _REGULAR?!")
+#
+# The middle ground is to warn here so that the failed option is obvious, but
+# to let the build fail with bad compiler flags so that we can't produce a
+# kernel when there is a CONFIG and compiler mismatch.
+#
 ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   ifeq ($(call cc-option, $(stackp-flag)),)
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
