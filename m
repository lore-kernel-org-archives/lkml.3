Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab3DHQ3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:29:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3DHQ3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:29:31 -0400
Date: Mon, 8 Apr 2013 09:28:33 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-982f33db626e7b42f44e0d404ebb110bf139c18b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1365436666-9837-4-git-send-email-bp@alien8.de>
References: <1365436666-9837-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD: Correct {rd,wr}msr_amd_safe warnings
Git-Commit-ID: 982f33db626e7b42f44e0d404ebb110bf139c18b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 09:28:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  982f33db626e7b42f44e0d404ebb110bf139c18b
Gitweb:     http://git.kernel.org/tip/982f33db626e7b42f44e0d404ebb110bf139c18b
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 8 Apr 2013 17:57:45 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 8 Apr 2013 09:07:17 -0700

x86, AMD: Correct {rd,wr}msr_amd_safe warnings

The idea with those routines is to slowly phase them out and not call
them on anything else besides K8. They even have a check for that which,
when called too early, fails. Let me explain:

It gets the cpuinfo_x86 pointer from the per_cpu array and when this
happens for cpu0, before its boot_cpu_data has been copied back to the
per_cpu array in smp_store_boot_cpu_info(), we get an empty struct and
thus the check fails.

Use boot_cpu_data directly instead.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1365436666-9837-4-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9a2a716..cea02d7 100644
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
