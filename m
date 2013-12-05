Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3LEAJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:09:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:33902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab3LEAJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:09:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,829,1378882800"; 
   d="scan'208";a="447063161"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH] x86/apic: Justification for disabling IO APIC before Local APIC
Date: Wed,  4 Dec 2013 16:07:49 -0800
Message-Id: <1386202069-51515-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Since erratum AVR31 in "Intel Atom Processor C2000 Product Family
Specification Update" is published, I add a justification comment for
disabling IO APIC before Local APIC (commit 522e6646).

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/reboot.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index da3c599..c752cb4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -558,6 +558,17 @@ void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_X86_IO_APIC
+	/*
+	 * Disabling IO APIC before local APIC is a workaround for
+	 * erratum AVR31 in "Intel Atom Processor C2000 Product Family
+	 * Specification Update". In this situation, interrupts that target
+	 * a Logical Processor whose Local APIC is either in the process of
+	 * being hardware disabled or software disabled are neither delivered
+	 * nor discarded. When this erratum occurs, the processor may hang.
+	 *
+	 * Even without the erratum, it still makes sense to quiet IO APIC
+	 * before disabling Local APIC.
+	 */
 	disable_IO_APIC();
 #endif
 
-- 
1.8.1.2

