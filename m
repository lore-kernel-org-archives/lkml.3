Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaGIRJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:09:47 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:42922 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610AbaGIRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:09:43 -0400
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ewout van Bekkum <ewout@google.com>,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI banks before reboot.
Date: Wed,  9 Jul 2014 10:09:23 -0700
Message-Id: <1404925766-32253-4-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ewout van Bekkum <ewout@google.com>

The existing CMCI code did not call cmci_clear() on each CPU upon
reboot. This meant that a kexec would leave all the CMCI banks
unclaimable and with polling disabled as the cmci_discover() method
relies on the CMCI enable bit for each bank to determine if they can be
claimed.

Signed-off-by: Ewout van Bekkum <ewout@google.com>
Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index d015daf..36a1948 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -14,6 +14,8 @@
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
+#include <linux/reboot.h>
+#include <linux/atomic.h>
 
 #include "mce-internal.h"
 
@@ -388,6 +390,31 @@ void cmci_disable_bank(int bank)
 	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
+/*
+ * Fully disable CMCI on this CPU in case of shutdown.
+ */
+static void cmci_disable(void *dummy)
+{
+	cmci_clear();
+}
+
+static int cmci_reboot_event(struct notifier_block *this,
+			     unsigned long event, void *ptr)
+{
+	/*
+	 * Disable CMCI on this CPU for all banks it owns so CPUs after the
+	 * reboot can reclaim the banks through rediscovery.
+	 */
+	on_each_cpu(cmci_disable, NULL, 1);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cmci_reboot_notifier = {
+	.notifier_call = cmci_reboot_event,
+};
+
+static bool reboot_notifier_registered;
+
 static void intel_init_cmci(void)
 {
 	int banks;
@@ -395,6 +422,9 @@ static void intel_init_cmci(void)
 	if (!cmci_supported(&banks))
 		return;
 
+	if (!xchg(&reboot_notifier_registered, true))
+		register_reboot_notifier(&cmci_reboot_notifier);
+
 	mce_threshold_vector = intel_threshold_interrupt;
 	cmci_discover(banks);
 	/*
-- 
2.0.0.526.g5318336

