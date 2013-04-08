Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936824Ab3DHP6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:58:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43458 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936736Ab3DHP6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:58:12 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/4] x86, AMD: Correct {rd,wr}msr_amd_safe warnings
Date: Mon,  8 Apr 2013 17:57:45 +0200
Message-Id: <1365436666-9837-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
In-Reply-To: <1365436666-9837-1-git-send-email-bp@alien8.de>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The idea with those routines is to slowly phase them out and not call
them on anything else besides K8. They even have a check for that which,
when called too early, fails. Let me explain:

It gets the cpuinfo_x86 pointer from the per_cpu array and when this
happens for cpu0, before its boot_cpu_data has been copied back to the
per_cpu array in smp_store_boot_cpu_info(), we get an empty struct and
thus the check fails.

Use boot_cpu_data directly instead.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/amd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9a2a71669c5d..cea02d703bca 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -20,11 +20,11 @@
 
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 	u32 gprs[8] = { 0 };
 	int err;
 
-	WARN_ONCE((c->x86 != 0xf), "%s should only be used on K8!\n", __func__);
+	WARN_ONCE((boot_cpu_data.x86 != 0xf),
+		  "%s should only be used on K8!\n", __func__);
 
 	gprs[1] = msr;
 	gprs[7] = 0x9c5a203a;
@@ -38,10 +38,10 @@ static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 
 static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 	u32 gprs[8] = { 0 };
 
-	WARN_ONCE((c->x86 != 0xf), "%s should only be used on K8!\n", __func__);
+	WARN_ONCE((boot_cpu_data.x86 != 0xf),
+		  "%s should only be used on K8!\n", __func__);
 
 	gprs[0] = (u32)val;
 	gprs[1] = msr;
-- 
1.8.2.135.g7b592fa

