Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaBZTJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:09:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:20204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbaBZTJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:09:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="490301600"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/4] x86: Add support for clflushopt
Date: Wed, 26 Feb 2014 12:06:49 -0700
Message-Id: <1393441612-19729-2-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new clflushopt instruction.  This instruction was
announced in the document "Intel Architecture Instruction Set Extensions
Programming Reference" with Ref # 319433-018.

http://download-software.intel.com/sites/default/files/managed/50/1a/319433-018.pdf

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/cpufeature.h    |    1 +
 arch/x86/include/asm/special_insns.h |    8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 89270b4..bfad1ad 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -219,6 +219,7 @@
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_CLFLSHOPT   (9*32+23) /* "clflushopt" CLFLUSHOPT instruction */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 645cad2..617389a 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -191,6 +191,14 @@ static inline void clflush(volatile void *__p)
 	asm volatile("clflush %0" : "+m" (*(volatile char __force *)__p));
 }
 
+static inline void clflushopt(volatile void *__p)
+{
+	alternative_io(".byte " __stringify(NOP_DS_PREFIX) "; clflush %P0",
+		       ".byte 0x66; clflush %P0",
+		       X86_FEATURE_CLFLSHOPT,
+		       "+m" (*(volatile char __force *)__p));
+}
+
 #define nop() asm volatile ("nop")
 
 
-- 
1.7.10.4

