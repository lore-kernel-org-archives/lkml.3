Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3AaWoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:44:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab3AaWoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:44:11 -0500
Date: Thu, 31 Jan 2013 14:43:55 -0800
From: tip-bot for Boris Ostrovsky <boris.ostrovsky@amd.com>
Message-ID: <tip-6bf08a8dcd1ef13e542f08fc3b1ce6cf64ae63b6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359495136-23244-1-git-send-email-ostr@amd64.org>
References: <1359495136-23244-1-git-send-email-ostr@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD: Clean up init_amd()
Git-Commit-ID: 6bf08a8dcd1ef13e542f08fc3b1ce6cf64ae63b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:44:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bf08a8dcd1ef13e542f08fc3b1ce6cf64ae63b6
Gitweb:     http://git.kernel.org/tip/6bf08a8dcd1ef13e542f08fc3b1ce6cf64ae63b6
Author:     Boris Ostrovsky <boris.ostrovsky@amd.com>
AuthorDate: Tue, 29 Jan 2013 16:32:16 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:35:32 -0800

x86, AMD: Clean up init_amd()

Clean up multiple declarations of variable used for rd/wrmsr.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Link: http://lkml.kernel.org/r/1359495136-23244-1-git-send-email-ostr@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/amd.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 15239ff..dd4a5b6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -518,10 +518,9 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
-
-#ifdef CONFIG_SMP
 	unsigned long long value;
 
+#ifdef CONFIG_SMP
 	/*
 	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
 	 * bit 6 of msr C001_0015
@@ -559,12 +558,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * (AMD Erratum #110, docId: 25759).
 		 */
 		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
-			u64 val;
-
 			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
-			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
-				val &= ~(1ULL << 32);
-				wrmsrl_amd_safe(0xc001100d, val);
+			if (!rdmsrl_amd_safe(0xc001100d, &value)) {
+				value &= ~(1ULL << 32);
+				wrmsrl_amd_safe(0xc001100d, value);
 			}
 		}
 
@@ -617,13 +614,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if ((c->x86 == 0x15) &&
 	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
 	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
-		u64 val;
 
-		if (!rdmsrl_safe(0xc0011005, &val)) {
-			val |= 1ULL << 54;
-			wrmsrl_safe(0xc0011005, val);
-			rdmsrl(0xc0011005, val);
-			if (val & (1ULL << 54)) {
+		if (!rdmsrl_safe(0xc0011005, &value)) {
+			value |= 1ULL << 54;
+			wrmsrl_safe(0xc0011005, value);
+			rdmsrl(0xc0011005, value);
+			if (value & (1ULL << 54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
 				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
 				  "disabled Topology Extensions Support\n");
@@ -637,11 +633,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	 */
 	if ((c->x86 == 0x15) &&
 	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
-		u64 val;
 
-		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
-			val |= 0x1E;
-			wrmsrl_safe(0xc0011021, val);
+		if (!rdmsrl_safe(0xc0011021, &value) && !(value & 0x1E)) {
+			value |= 0x1E;
+			wrmsrl_safe(0xc0011021, value);
 		}
 	}
 
