Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbaIRTWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:22:31 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63361 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbaIRTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:22:27 -0400
Message-ID: <1411068135.5121.10.camel@localhost.localdomain>
Subject: [PATCH] x86: Avoid showing repetitive message from
 intel_init_thermal().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 19 Sep 2014 01:22:15 +0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 (3.10.2-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 intel_init_thermal() is called from a) at the time of system initializing
and b) at the time of system resume to initialize thermal monitoring.
In case when thermal monitoring is handled by SMI, we get to know it via
printk(). Currently it gives the message at both cases, but its okay if we
get it only once and no need to get the same message at every time system
resumes. So, limit showing this message only at system boot time by avoid
showing at system resume and reduce abusing kernel log buffer.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 36a1bb6..c8a8e45 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -498,8 +498,9 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 

 	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
+		if (system_state == SYSTEM_BOOTING)
+			printk(KERN_DEBUG
+			"CPU%d: Thermal monitoring handled by SMI\n", cpu);
 		return;
 	}
 



