Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaEDPll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaEDPld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>, Francesco Fusco <ffusco@redhat.com>,
        Thomas Graf <tgraf@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.14 056/158] x86, hash: Fix build failure with older binutils
Date: Sun,  4 May 2014 11:39:25 -0400
Message-Id: <20140504154037.575672774@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 06325190bd577e11429444d54f454b9d13f560c9 upstream.

Just like for other ISA extension instruction uses we should check
whether the assembler actually supports them. The fallback here simply
is to encode an instruction  with fixed operands (%eax and %ecx).

[ hpa: tagging for -stable as a build fix ]

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/530F0996020000780011FBE7@nat28.tlf.novell.com
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile   |    1 +
 arch/x86/lib/hash.c |    4 ++++
 2 files changed, 5 insertions(+)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -152,6 +152,7 @@ cfi-sections := $(call as-instr,.cfi_sec
 
 # does binutils support specific instructions?
 asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
+asinstr += $(call as-instr,crc32l %eax$(comma)%eax,-DCONFIG_AS_CRC32=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
 avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
 
--- a/arch/x86/lib/hash.c
+++ b/arch/x86/lib/hash.c
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
 


