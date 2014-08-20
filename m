Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaHTJvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:51:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44502 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTJvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:51:45 -0400
From: Wang Long <long.wanglong@huawei.com>
To: <linux@arm.linux.org.uk>, <nicolas.pitre@linaro.org>,
        <ben.dooks@codethink.co.uk>, <taras.kondratiuk@linaro.org>,
        <heiko@sntech.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: avoid corrupts register in mcaro kputc kphex etc.
Date: Wed, 20 Aug 2014 17:50:02 +0800
Message-ID: <1408528202-152139-1-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when use macro 'kputc' kphex' to print the content of
register r0-r3, they will corrupts these registers.

the same as the macro 'debug_reloc_start' and 'debug_reloc_end'.

so using 'push' when enter the macro and 'pop' when leave
the macro to fix it.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/boot/compressed/head.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 413fd94..aa57a09 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -19,6 +19,7 @@
  * 100% relocatable.  Any attempt to do so will result in a crash.
  * Please select one of the following when turning on debugging.
  */
+#define DEBUG
 #ifdef DEBUG
 
 #if defined(CONFIG_DEBUG_ICEDCC)
@@ -69,18 +70,23 @@
 #endif
 
 		.macro	kputc,val
+		push	{r0-r3}
 		mov	r0, \val
 		bl	putc
+		pop	{r0-r3}
 		.endm
 
 		.macro	kphex,val,len
+		push	{r0-r3}
 		mov	r0, \val
 		mov	r1, #\len
 		bl	phex
+		pop	{r0-r3}
 		.endm
 
 		.macro	debug_reloc_start
 #ifdef DEBUG
+		push	{r0-r3}
 		kputc	#'\n'
 		kphex	r6, 8		/* processor id */
 		kputc	#':'
@@ -97,15 +103,18 @@
 		kputc	#'>'
 		kphex	r4, 8		/* kernel execution address */
 		kputc	#'\n'
+		pop	{r0-r3}
 #endif
 		.endm
 
 		.macro	debug_reloc_end
 #ifdef DEBUG
+		push    {r0-r3,r10-r12}
 		kphex	r5, 8		/* end of kernel */
 		kputc	#'\n'
 		mov	r0, r4
 		bl	memdump		/* dump 256 bytes at start of kernel */
+		pop	{r0-r3,r10-r12}
 #endif
 		.endm
 
-- 
1.8.3.4

