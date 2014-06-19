Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaFSB6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:58:41 -0400
Received: from mail-la0-f74.google.com ([209.85.215.74]:35472 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbaFSB6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:58:40 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] x86: tsc: get rid of custom DIV_ROUND
Date: Thu, 19 Jun 2014 03:58:36 +0200
Message-Id: <1403143116-21755-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When invoced for positive values, DIV_ROUND macro defined in
arch/x86/kernel/tsc.c behaves exactly like DIV_ROUND_CLOSEST from
include/linux/kernel.h file, so remove the custom macro in favour
of the shared one.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 arch/x86/kernel/tsc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

 No changes after compilation:

 $ ll tsc.o.*
 -rw------- 1 mpn eng 46497 Jun 19 03:54 tsc.o.after
 -rw------- 1 mpn eng 46497 Jun 19 03:55 tsc.o.before
 $ objdump -d tsc.o.before >tsc.s.before
 $ objdump -d tsc.o.after >tsc.s.after
 $ diff -u tsc.s.before tsc.s.after
 --- tsc.s.before	2014-06-19 03:56:54.880545041 +0200
 +++ tsc.s.after	2014-06-19 03:56:54.884545079 +0200
 @@ -1,5 +1,5 @@
  
 -tsc.o.before:     file format elf64-x86-64
 +tsc.o.after:     file format elf64-x86-64
  
  
  Disassembly of section .text:
 $

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57e5ce1..02f21c0 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -234,9 +234,6 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 	return ns;
 }
 
-/* XXX surely we already have this someplace in the kernel?! */
-#define DIV_ROUND(n, d) (((n) + ((d) / 2)) / (d))
-
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
 	unsigned long long tsc_now, ns_now;
@@ -259,7 +256,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	 * time function is continuous; see the comment near struct
 	 * cyc2ns_data.
 	 */
-	data->cyc2ns_mul = DIV_ROUND(NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR, cpu_khz);
+	data->cyc2ns_mul = DIV_ROUND_CLOSEST(
+		NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR, cpu_khz);
 	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
 	data->cyc2ns_offset = ns_now -
 		mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
-- 
2.0.0.526.g5318336

