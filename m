Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaBUKcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:32:54 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:45191 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaBUKcx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 21 Feb 2014 05:32:53 -0500
Message-Id: <53073962020000780011E2DE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 21 Feb 2014 10:32:50 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <davem@davemloft.net>, <dborkman@redhat.com>, <ffusco@redhat.com>,
        <tgraf@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86/hash: fix build failure with older binutils
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like for other ISA extension instruction uses we should check
whether the assembler actually supports them. The fallback here simply
is to encode an instruction  with fixed operands (%eax and %ecx).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/x86/Makefile   |    1 +
 arch/x86/lib/hash.c |    4 ++++
 2 files changed, 5 insertions(+)

--- 3.14-rc3-x86-hash-crc32.orig/arch/x86/Makefile
+++ 3.14-rc3-x86-hash-crc32/arch/x86/Makefile
@@ -152,6 +152,7 @@ cfi-sections := $(call as-instr,.cfi_sec
 
 # does binutils support specific instructions?
 asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
+asinstr += $(call as-instr,crc32l %eax$(comma)%eax,-DCONFIG_AS_CRC32=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
 avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
 
--- 3.14-rc3-x86-hash-crc32.orig/arch/x86/lib/hash.c
+++ 3.14-rc3-x86-hash-crc32/arch/x86/lib/hash.c
@@ -39,7 +39,11 @@
 
 static inline u32 crc32_u32(u32 crc, u32 val)
 {
+#ifdef CONFIG_AS_CRC32
 	asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));
+#else
+	asm (".byte 0xf2, 0x0f, 0x38, 0xf1, 0xc1" : "+a" (crc) : "c" (val));
+#endif
 	return crc;
 }
 



