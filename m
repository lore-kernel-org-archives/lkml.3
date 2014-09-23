Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaIWITb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:19:31 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65340 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaIWIT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:19:28 -0400
Message-ID: <1411460354.25617.3.camel@debian>
Subject: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: bp@alien8.de, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Sep 2014 16:19:14 +0800
In-Reply-To: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

machine_check_poll() will reset IA32_MCi_STATUS register to zero.
So we need to save the content of IA32_MCi_STATUS MSRs before
calling machine_check_poll() for logging threshold interrupt event.

mce_setup() does not gather the content of IA32_MCG_STATUS, so it
should be read explicitly.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f8c56bd..9148b4d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -275,6 +275,12 @@ static void amd_threshold_interrupt(void)
 
 	mce_setup(&m);
 
+	/*
+	 * mce_setup() can't gather the content of IA32_MCG_STATUS,
+	 * so it should be read explicitly.
+	 */
+	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
+
 	/* assume first bank caused it */
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
@@ -305,6 +311,12 @@ static void amd_threshold_interrupt(void)
 			     (high & MASK_LOCKED_HI))
 				continue;
 
+			/*
+			 * machine_check_poll() will reset IA32_MCi_STATUS
+			 * register to zero, save it for use later.
+			 */
+			rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
+
 			/*
 			 * Log the machine check that caused the threshold
 			 * event.
@@ -314,7 +326,6 @@ static void amd_threshold_interrupt(void)
 
 			if (high & MASK_OVERFLOW_HI) {
 				rdmsrl(address, m.misc);
-				rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
 				m.bank = K8_MCE_THRESHOLD_BASE
 				       + bank * NR_BLOCKS
 				       + block;
-- 
1.7.10.4





