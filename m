Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3GBPC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:02:57 -0400
Received: from multi.imgtec.com ([194.200.65.239]:13620 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab3GBPCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:02:55 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] metag: move EXPORT_SYMBOLs in libs to metag_ksyms.c
Date: Tue, 2 Jul 2013 15:07:54 +0100
Message-ID: <1372774074-18553-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_02_16_00_57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all EXPORT_SYMBOLs in libs-y directories (arch/metag/{lib,tbx})
into metag_ksyms.c so that they don't get omitted by the static linker
if they're not used by any other statically linked code, which can
result in undefined symbols when building modules.

For example a randconfig caused the following error:
ERROR: "csum_partial" [fs/reiserfs/reiserfs.ko] undefined!

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
Unless there are any objections I'll apply this patch for v3.11. I'm
assuming *_ksyms.c is the way that this problem is normally worked
around.

 arch/metag/kernel/metag_ksyms.c | 32 ++++++++++++++++++++++++++++++++
 arch/metag/lib/checksum.c       |  5 -----
 arch/metag/lib/delay.c          |  4 ----
 arch/metag/lib/usercopy.c       | 12 ------------
 arch/metag/tbx/tbistring.c      |  1 -
 5 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/arch/metag/kernel/metag_ksyms.c b/arch/metag/kernel/metag_ksyms.c
index ec872ef..f14e653 100644
--- a/arch/metag/kernel/metag_ksyms.c
+++ b/arch/metag/kernel/metag_ksyms.c
@@ -1,10 +1,14 @@
 #include <linux/export.h>
+#include <linux/types.h>
 
+#include <asm/checksum.h>
+#include <asm/delay.h>
 #include <asm/div64.h>
 #include <asm/ftrace.h>
 #include <asm/page.h>
 #include <asm/string.h>
 #include <asm/tbx.h>
+#include <asm/uaccess.h>
 
 EXPORT_SYMBOL(clear_page);
 EXPORT_SYMBOL(copy_page);
@@ -15,11 +19,39 @@ EXPORT_SYMBOL(max_pfn);
 EXPORT_SYMBOL(min_low_pfn);
 #endif
 
+/* Network checksum functions */
+EXPORT_SYMBOL(ip_fast_csum);
+EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(ip_compute_csum);
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+EXPORT_SYMBOL(csum_partial_copy);
+
+/* Delay functions */
+EXPORT_SYMBOL(__delay);
+EXPORT_SYMBOL(__const_udelay);
+EXPORT_SYMBOL(__udelay);
+EXPORT_SYMBOL(__ndelay);
+
+/* Userspace copying functions */
+EXPORT_SYMBOL(__copy_user);
+EXPORT_SYMBOL(__copy_user_zeroing);
+EXPORT_SYMBOL(__do_clear_user);
+EXPORT_SYMBOL(__get_user_asm_b);
+EXPORT_SYMBOL(__get_user_asm_w);
+EXPORT_SYMBOL(__get_user_asm_d);
+EXPORT_SYMBOL(__put_user_asm_b);
+EXPORT_SYMBOL(__put_user_asm_w);
+EXPORT_SYMBOL(__put_user_asm_d);
+EXPORT_SYMBOL(__put_user_asm_l);
+EXPORT_SYMBOL(strnlen_user);
+EXPORT_SYMBOL(__strncpy_from_user);
+
 /* TBI symbols */
 EXPORT_SYMBOL(__TBI);
 EXPORT_SYMBOL(__TBIFindSeg);
 EXPORT_SYMBOL(__TBIPoll);
 EXPORT_SYMBOL(__TBITimeStamp);
+EXPORT_SYMBOL(__TBITransStr);
 
 #define DECLARE_EXPORT(name) extern void name(void); EXPORT_SYMBOL(name)
 
diff --git a/arch/metag/lib/checksum.c b/arch/metag/lib/checksum.c
index 44d2e19..1793719 100644
--- a/arch/metag/lib/checksum.c
+++ b/arch/metag/lib/checksum.c
@@ -99,7 +99,6 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 out:
 	return result;
 }
-EXPORT_SYMBOL(ip_fast_csum);
 
 /*
  * computes the checksum of a memory block at buff, length len,
@@ -124,7 +123,6 @@ __wsum csum_partial(const void *buff, int len, __wsum wsum)
 		result += 1;
 	return (__force __wsum)result;
 }
-EXPORT_SYMBOL(csum_partial);
 
 /*
  * this routine is used for miscellaneous IP-like checksums, mainly
@@ -134,7 +132,6 @@ __sum16 ip_compute_csum(const void *buff, int len)
 {
 	return (__force __sum16)~do_csum(buff, len);
 }
-EXPORT_SYMBOL(ip_compute_csum);
 
 /*
  * copy from fs while checksumming, otherwise like csum_partial
@@ -154,7 +151,6 @@ csum_partial_copy_from_user(const void __user *src, void *dst, int len,
 
 	return csum_partial(dst, len, sum);
 }
-EXPORT_SYMBOL(csum_partial_copy_from_user);
 
 /*
  * copy from ds while checksumming, otherwise like csum_partial
@@ -165,4 +161,3 @@ csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
 	memcpy(dst, src, len);
 	return csum_partial(dst, len, sum);
 }
-EXPORT_SYMBOL(csum_partial_copy);
diff --git a/arch/metag/lib/delay.c b/arch/metag/lib/delay.c
index 0b308f4..e6df8af 100644
--- a/arch/metag/lib/delay.c
+++ b/arch/metag/lib/delay.c
@@ -34,23 +34,19 @@ void __delay(unsigned long loops)
 		rdtimer(now);
 	} while ((now-bclock) < loops);
 }
-EXPORT_SYMBOL(__delay);
 
 inline void __const_udelay(unsigned long xloops)
 {
 	u64 loops = (u64)xloops * (u64)loops_per_jiffy * HZ;
 	__delay(loops >> 32);
 }
-EXPORT_SYMBOL(__const_udelay);
 
 void __udelay(unsigned long usecs)
 {
 	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
 }
-EXPORT_SYMBOL(__udelay);
 
 void __ndelay(unsigned long nsecs)
 {
 	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
 }
-EXPORT_SYMBOL(__ndelay);
diff --git a/arch/metag/lib/usercopy.c b/arch/metag/lib/usercopy.c
index b3ebfe9..19e5f92 100644
--- a/arch/metag/lib/usercopy.c
+++ b/arch/metag/lib/usercopy.c
@@ -611,7 +611,6 @@ unsigned long __copy_user(void __user *pdst, const void *psrc,
 
 	return retn;
 }
-EXPORT_SYMBOL(__copy_user);
 
 #define __asm_copy_from_user_1(to, from, ret) \
 	__asm_copy_user_cont(to, from, ret,	\
@@ -938,7 +937,6 @@ unsigned long __copy_user_zeroing(void *pdst, const void __user *psrc,
 
 	return retn + n;
 }
-EXPORT_SYMBOL(__copy_user_zeroing);
 
 #define __asm_clear_8x64(to, ret) \
 	asm volatile (					\
@@ -1092,7 +1090,6 @@ unsigned long __do_clear_user(void __user *pto, unsigned long pn)
 
 	return retn;
 }
-EXPORT_SYMBOL(__do_clear_user);
 
 unsigned char __get_user_asm_b(const void __user *addr, long *err)
 {
@@ -1116,7 +1113,6 @@ unsigned char __get_user_asm_b(const void __user *addr, long *err)
 		: "D0FrT");
 	return x;
 }
-EXPORT_SYMBOL(__get_user_asm_b);
 
 unsigned short __get_user_asm_w(const void __user *addr, long *err)
 {
@@ -1140,7 +1136,6 @@ unsigned short __get_user_asm_w(const void __user *addr, long *err)
 		: "D0FrT");
 	return x;
 }
-EXPORT_SYMBOL(__get_user_asm_w);
 
 unsigned int __get_user_asm_d(const void __user *addr, long *err)
 {
@@ -1164,7 +1159,6 @@ unsigned int __get_user_asm_d(const void __user *addr, long *err)
 		: "D0FrT");
 	return x;
 }
-EXPORT_SYMBOL(__get_user_asm_d);
 
 long __put_user_asm_b(unsigned int x, void __user *addr)
 {
@@ -1188,7 +1182,6 @@ long __put_user_asm_b(unsigned int x, void __user *addr)
 		: "D0FrT");
 	return err;
 }
-EXPORT_SYMBOL(__put_user_asm_b);
 
 long __put_user_asm_w(unsigned int x, void __user *addr)
 {
@@ -1212,7 +1205,6 @@ long __put_user_asm_w(unsigned int x, void __user *addr)
 		: "D0FrT");
 	return err;
 }
-EXPORT_SYMBOL(__put_user_asm_w);
 
 long __put_user_asm_d(unsigned int x, void __user *addr)
 {
@@ -1236,7 +1228,6 @@ long __put_user_asm_d(unsigned int x, void __user *addr)
 		: "D0FrT");
 	return err;
 }
-EXPORT_SYMBOL(__put_user_asm_d);
 
 long __put_user_asm_l(unsigned long long x, void __user *addr)
 {
@@ -1260,7 +1251,6 @@ long __put_user_asm_l(unsigned long long x, void __user *addr)
 		: "D0FrT");
 	return err;
 }
-EXPORT_SYMBOL(__put_user_asm_l);
 
 long strnlen_user(const char __user *src, long count)
 {
@@ -1297,7 +1287,6 @@ long strnlen_user(const char __user *src, long count)
 
 	return res;
 }
-EXPORT_SYMBOL(strnlen_user);
 
 long __strncpy_from_user(char *dst, const char __user *src, long count)
 {
@@ -1351,4 +1340,3 @@ long __strncpy_from_user(char *dst, const char __user *src, long count)
 
 	return res;
 }
-EXPORT_SYMBOL(__strncpy_from_user);
diff --git a/arch/metag/tbx/tbistring.c b/arch/metag/tbx/tbistring.c
index f90cd08..ea537dd 100644
--- a/arch/metag/tbx/tbistring.c
+++ b/arch/metag/tbx/tbistring.c
@@ -111,4 +111,3 @@ const void *__TBITransStr(const char *str, int len)
 	/* Return base address of translation data or NULL */
 	return res;
 }
-EXPORT_SYMBOL(__TBITransStr);
-- 
1.8.1.2


