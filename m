Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaB0Q1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:27:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaB0Q1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:27:40 -0500
Date: Thu, 27 Feb 2014 08:27:26 -0800
From: tip-bot for Ross Zwisler <tipbot@zytor.com>
Message-ID: <tip-171699f7630c92d0a928f83e5fb3aeabe35398c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1393441612-19729-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1393441612-19729-2-git-send-email-ross.zwisler@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86:
  Add support for the clflushopt instruction
Git-Commit-ID: 171699f7630c92d0a928f83e5fb3aeabe35398c0
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

Commit-ID:  171699f7630c92d0a928f83e5fb3aeabe35398c0
Gitweb:     http://git.kernel.org/tip/171699f7630c92d0a928f83e5fb3aeabe35398c0
Author:     Ross Zwisler <ross.zwisler@linux.intel.com>
AuthorDate: Wed, 26 Feb 2014 12:06:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Feb 2014 08:23:28 -0800

x86: Add support for the clflushopt instruction

Add support for the new clflushopt instruction.  This instruction was
announced in the document "Intel Architecture Instruction Set Extensions
Programming Reference" with Ref # 319433-018.

http://download-software.intel.com/sites/default/files/managed/50/1a/319433-018.pdf

[ hpa: changed the feature flag to simply X86_FEATURE_CLFLUSHOPT - if
  that is what we want to report in /proc/cpuinfo anyway... ]

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Link: http://lkml.kernel.org/r/1393441612-19729-2-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h    | 1 +
 arch/x86/include/asm/special_insns.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 5f12968..bc507d7 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -221,6 +221,7 @@
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_CLFLUSHOPT	(9*32+23) /* CLFLUSHOPT instruction */
 #define X86_FEATURE_AVX512PF	(9*32+26) /* AVX-512 Prefetch */
 #define X86_FEATURE_AVX512ER	(9*32+27) /* AVX-512 Exponential and Reciprocal */
 #define X86_FEATURE_AVX512CD	(9*32+28) /* AVX-512 Conflict Detection */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 645cad2..e820c08 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -191,6 +191,14 @@ static inline void clflush(volatile void *__p)
 	asm volatile("clflush %0" : "+m" (*(volatile char __force *)__p));
 }
 
+static inline void clflushopt(volatile void *__p)
+{
+	alternative_io(".byte " __stringify(NOP_DS_PREFIX) "; clflush %P0",
+		       ".byte 0x66; clflush %P0",
+		       X86_FEATURE_CLFLUSHOPT,
+		       "+m" (*(volatile char __force *)__p));
+}
+
 #define nop() asm volatile ("nop")
 
 
