Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161636AbaJaBZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:25:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39602 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369AbaJaBZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:25:34 -0400
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, ak@linux.intel.com, gong.chen@linux.intel.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH 1/2] x86, mce: apply MCE MSR wrappers to AMD platform for testing threshold interrupt handler
Date: Fri, 31 Oct 2014 09:24:06 +0800
Message-Id: <1414718648-7766-2-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
References: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, the `mce-inject' mechanism does not support error injection
for threshold interrupt event in AMD platform.

This patch aims to apply MCE MSR wrappers to AMD-specific threshold
interrupt handler for supporting mce-inject.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/include/asm/mce.h           |    4 ++++
 arch/x86/kernel/cpu/mcheck/mce.c     |   25 +++++++++++++++++++++++--
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    6 +++---
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 276392f..3a430ad 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -185,6 +185,10 @@ enum mcp_flags {
 };
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
+u64 mce_rdmsrl(u32 msr);
+void mce_wrmsrl(u32 msr, u64 v);
+int mce_rdmsr_safe(u32 msr, u32 *low, u32 *high);
+
 int mce_notify_irq(void);
 void mce_notify_process(void);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668ce..b8fe5ae 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -391,7 +391,7 @@ static int msr_to_offset(u32 msr)
 }
 
 /* MSR access wrappers used for error injection */
-static u64 mce_rdmsrl(u32 msr)
+u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
 
@@ -416,7 +416,7 @@ static u64 mce_rdmsrl(u32 msr)
 	return v;
 }
 
-static void mce_wrmsrl(u32 msr, u64 v)
+void mce_wrmsrl(u32 msr, u64 v)
 {
 	if (__this_cpu_read(injectm.finished)) {
 		int offset = msr_to_offset(msr);
@@ -428,6 +428,27 @@ static void mce_wrmsrl(u32 msr, u64 v)
 	wrmsrl(msr, v);
 }
 
+int mce_rdmsr_safe(u32 msr, u32 *low, u32 *high) 
+{
+	int err = -1;
+	u64 val;
+
+	if (__this_cpu_read(injectm.finished)) {
+		int offset = msr_to_offset(msr);
+
+		if (offset < 0)
+			val = 0;
+		val = *(u64 *)((char *)&__get_cpu_var(injectm) + offset);
+		err = 0;
+	} else
+		err = rdmsrl_safe(msr, &val);
+
+	(*low) = (u32)val;
+	(*high) = (u32)(val >> 32);
+
+	return err;
+}
+
 /*
  * Collect all global (w.r.t. this processor) status about this machine
  * check into our "mce" struct so that we can use it later to assess
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 6606523..926e8a3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -292,7 +292,7 @@ static void amd_threshold_interrupt(void)
 				++address;
 			}
 
-			if (rdmsr_safe(address, &low, &high))
+			if (mce_rdmsr_safe(address, &low, &high))
 				break;
 
 			if (!(high & MASK_VALID_HI)) {
@@ -318,12 +318,12 @@ static void amd_threshold_interrupt(void)
 
 log:
 	mce_setup(&m);
-	rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
+	m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(bank));
 	m.misc = ((u64)high << 32) | low;
 	m.bank = bank;
 	mce_log(&m);
 
-	wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
+	mce_wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
 }
 
 /*
-- 
1.7.10.4

