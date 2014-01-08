Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaAHLVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:21:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55332 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaAHLV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:21:26 -0500
From: David Woodhouse <David.Woodhouse@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvmlinux@lists.linuxfoundation.org
Subject: [PATCH 4/4] x86, boot: Work around clang PR18415.
Date: Wed,  8 Jan 2014 11:21:23 +0000
Message-Id: <1389180083-23249-4-git-send-email-David.Woodhouse@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
References: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clang's intrinsics ignore -mregparm=3 when they fall back to calling the
out-of-line implementations. Putting the args on the stack when memcpy()
expects them in registers is not a recipe for a happy kernel.

This bites with -m32 too, so clang is presumably catastrophically
broken for the i386 kernel until this is fixed, unless I'm missing
something.

For information/testing only; do not apply. With this, I can use
'clang -m16' to build all the kernel's 16-bit code and get a successful
boot.

Not-signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/x86/boot/boot.h   | 2 ++
 arch/x86/boot/memory.c | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index ef72bae..1182dc9 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -232,8 +232,10 @@ void *copy_from_gs(void *dst, addr_t src, size_t len);
 void *memcpy(void *dst, void *src, size_t len);
 void *memset(void *dst, int c, size_t len);
 
+#ifndef __clang__ /* PR18415 */
 #define memcpy(d,s,l) __builtin_memcpy(d,s,l)
 #define memset(d,c,l) __builtin_memset(d,c,l)
+#endif
 
 /* a20.c */
 int enable_a20(void);
diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index db75d07..7af6504 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -63,8 +63,13 @@ static int detect_memory_e820(void)
 			count = 0;
 			break;
 		}
-
+#ifdef __clang__
+		/* PR18415 */
+		memcpy(desc, &buf, sizeof(*desc));
+		desc++;
+#else
 		*desc++ = buf;
+#endif
 		count++;
 	} while (ireg.ebx && count < ARRAY_SIZE(boot_params.e820_map));
 
-- 
1.8.4.2

