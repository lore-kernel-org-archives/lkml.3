Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbaCSXs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:48:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbaCSXs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:48:56 -0400
Date: Wed, 19 Mar 2014 16:48:36 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-706b158559e41ba8d8ea83f3e468466e64769058@git.kernel.org>
Cc: ffusco@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dborkman@redhat.com, jbeulich@suse.com,
        davem@davemloft.net, tgraf@redhat.com, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ffusco@redhat.com, dborkman@redhat.com, jbeulich@suse.com,
        davem@davemloft.net, tgraf@redhat.com, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <530F0996020000780011FBE7@nat28.tlf.novell.com>
References: <530F0996020000780011FBE7@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hash] x86, hash: Fix build failure with older binutils
Git-Commit-ID: 706b158559e41ba8d8ea83f3e468466e64769058
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  706b158559e41ba8d8ea83f3e468466e64769058
Gitweb:     http://git.kernel.org/tip/706b158559e41ba8d8ea83f3e468466e64769058
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 27 Feb 2014 08:47:02 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 Mar 2014 16:25:03 -0700

x86, hash: Fix build failure with older binutils

Just like for other ISA extension instruction uses we should check
whether the assembler actually supports them. The fallback here simply
is to encode an instruction  with fixed operands (%eax and %ecx).

[ hpa: tagging for -stable as a build fix ]

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/530F0996020000780011FBE7@nat28.tlf.novell.com
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> # v3.14
---
 arch/x86/Makefile   | 1 +
 arch/x86/lib/hash.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eeda43a..f8842c4 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -152,6 +152,7 @@ cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTI
 
 # does binutils support specific instructions?
 asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
+asinstr += $(call as-instr,crc32l %eax$(comma)%eax,-DCONFIG_AS_CRC32=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
 avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
 
diff --git a/arch/x86/lib/hash.c b/arch/x86/lib/hash.c
index 3056702..060cc44 100644
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
 
