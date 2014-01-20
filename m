Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaATVXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:23:01 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:43565 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaATVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:22:20 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: libunwind-devel <libunwind-devel@nongnu.org>
Cc: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/3] Add support for different binary target address sizes
Date: Mon, 20 Jan 2014 22:22:00 +0100
Message-Id: <1390252922-25889-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
References: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of unwinding the debug info from a binary that has a different
address size than the current native platform, it is needed to record
it in the address space struct, in order to correctly parse the debug
info later. This mode is known as compat mode.

This is the case on e.g. profiling an ARMv7 binary that runs on an
ARMv8 (aka AARCH64) platform.

Add the target_addr_size field in the unw_addr_space struct and provide
the 32 and 64 bit macros for use in the code.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 include/libunwind_i.h              | 7 +++++++
 include/tdep-aarch64/libunwind_i.h | 1 +
 include/tdep-arm/libunwind_i.h     | 1 +
 include/tdep-hppa/libunwind_i.h    | 1 +
 include/tdep-ia64/libunwind_i.h    | 1 +
 include/tdep-mips/libunwind_i.h    | 1 +
 include/tdep-ppc32/libunwind_i.h   | 1 +
 include/tdep-ppc64/libunwind_i.h   | 1 +
 include/tdep-sh/libunwind_i.h      | 1 +
 include/tdep-x86/libunwind_i.h     | 1 +
 include/tdep-x86_64/libunwind_i.h  | 1 +
 11 files changed, 17 insertions(+)

diff --git a/include/libunwind_i.h b/include/libunwind_i.h
index 0be551f..859ae03 100644
--- a/include/libunwind_i.h
+++ b/include/libunwind_i.h
@@ -345,6 +345,13 @@ static inline void invalidate_edi (struct elf_dyn_info *edi)
 # define PT_ARM_EXIDX		0x70000001	/* ARM unwind segment */
 #endif /* !PT_ARM_EXIDX */
 
+/* Define binary target address size */
+enum {
+    TARGET_ADDR_SIZE_DEFAULT,
+    TARGET_ADDR_SIZE_32,
+    TARGET_ADDR_SIZE_64
+};
+
 #include "tdep/libunwind_i.h"
 
 #ifndef tdep_get_func_addr
diff --git a/include/tdep-aarch64/libunwind_i.h b/include/tdep-aarch64/libunwind_i.h
index b162271..5341118 100644
--- a/include/tdep-aarch64/libunwind_i.h
+++ b/include/tdep-aarch64/libunwind_i.h
@@ -61,6 +61,7 @@ struct unw_addr_space
   {
     struct unw_accessors acc;
     int big_endian;
+    int target_addr_size;		/* target binary: 32/64 bit */
     unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
     AO_t cache_generation;
diff --git a/include/tdep-arm/libunwind_i.h b/include/tdep-arm/libunwind_i.h
index 291b101..7353f82 100644
--- a/include/tdep-arm/libunwind_i.h
+++ b/include/tdep-arm/libunwind_i.h
@@ -46,6 +46,7 @@ struct unw_addr_space
   {
     struct unw_accessors acc;
     int big_endian;
+    int target_addr_size;		/* target binary: 32/64 bit */
     unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
     AO_t cache_generation;
diff --git a/include/tdep-hppa/libunwind_i.h b/include/tdep-hppa/libunwind_i.h
index b5bbcec..7e2ebd7 100644
--- a/include/tdep-hppa/libunwind_i.h
+++ b/include/tdep-hppa/libunwind_i.h
@@ -45,6 +45,7 @@ unw_tdep_frame_t;
 struct unw_addr_space
   {
     struct unw_accessors acc;
+    int target_addr_size;		/* target binary: 32/64 bit */
     unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
     AO_t cache_generation;
diff --git a/include/tdep-ia64/libunwind_i.h b/include/tdep-ia64/libunwind_i.h
index 2bea830..20dd999 100644
--- a/include/tdep-ia64/libunwind_i.h
+++ b/include/tdep-ia64/libunwind_i.h
@@ -96,6 +96,7 @@ struct unw_addr_space
     struct unw_accessors acc;
     int big_endian;
     int abi;	/* abi < 0 => unknown, 0 => SysV, 1 => HP-UX, 2 => Windows */
+    int target_addr_size;		/* target binary: 32/64 bit */
     unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
     AO_t cache_generation;
diff --git a/include/tdep-mips/libunwind_i.h b/include/tdep-mips/libunwind_i.h
index 3ef1cef..c7a0c16 100644
--- a/include/tdep-mips/libunwind_i.h
+++ b/include/tdep-mips/libunwind_i.h
@@ -52,6 +52,7 @@ struct unw_addr_space
     int big_endian;
     mips_abi_t abi;
     unsigned int addr_size;
+    int target_addr_size;		/* target binary: 32/64 bit */
 
     unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
diff --git a/include/tdep-ppc32/libunwind_i.h b/include/tdep-ppc32/libunwind_i.h
index 06c0023..3c67454 100644
--- a/include/tdep-ppc32/libunwind_i.h
+++ b/include/tdep-ppc32/libunwind_i.h
@@ -51,6 +51,7 @@ unw_tdep_frame_t;
 struct unw_addr_space
 {
   struct unw_accessors acc;
+  int target_addr_size;		/* target binary: 32/64 bit */
   unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
   AO_t cache_generation;
diff --git a/include/tdep-ppc64/libunwind_i.h b/include/tdep-ppc64/libunwind_i.h
index 6024455..faf6483 100644
--- a/include/tdep-ppc64/libunwind_i.h
+++ b/include/tdep-ppc64/libunwind_i.h
@@ -53,6 +53,7 @@ struct unw_addr_space
   struct unw_accessors acc;
   int big_endian;
   ppc64_abi_t abi;
+  int target_addr_size;		/* target binary: 32/64 bit */
   unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
   AO_t cache_generation;
diff --git a/include/tdep-sh/libunwind_i.h b/include/tdep-sh/libunwind_i.h
index 51234d1..c731001 100644
--- a/include/tdep-sh/libunwind_i.h
+++ b/include/tdep-sh/libunwind_i.h
@@ -46,6 +46,7 @@ struct unw_addr_space
   {
     struct unw_accessors acc;
     int big_endian;
+    int target_addr_size;		/* target binary: 32/64 bit */
     unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
     AO_t cache_generation;
diff --git a/include/tdep-x86/libunwind_i.h b/include/tdep-x86/libunwind_i.h
index f59a3cf..7f5be18 100644
--- a/include/tdep-x86/libunwind_i.h
+++ b/include/tdep-x86/libunwind_i.h
@@ -45,6 +45,7 @@ unw_tdep_frame_t;
 struct unw_addr_space
   {
     struct unw_accessors acc;
+    int target_addr_size;		/* target binary: 32/64 bit */
     unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
     AO_t cache_generation;
diff --git a/include/tdep-x86_64/libunwind_i.h b/include/tdep-x86_64/libunwind_i.h
index 8c9cd05..623416b 100644
--- a/include/tdep-x86_64/libunwind_i.h
+++ b/include/tdep-x86_64/libunwind_i.h
@@ -62,6 +62,7 @@ unw_tdep_frame_t;
 struct unw_addr_space
   {
     struct unw_accessors acc;
+    int target_addr_size;		/* target binary: 32/64 bit */
     unw_caching_policy_t caching_policy;
 #ifdef HAVE_ATOMIC_OPS_H
     AO_t cache_generation;
-- 
1.7.11.7

