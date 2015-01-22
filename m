Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbbAVO1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:27:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbAVO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:27:45 -0500
Date: Thu, 22 Jan 2015 06:27:20 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-12e189d3cfa4c64de758bde18626184bf32c65fc@git.kernel.org>
Cc: hpa@zytor.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, jiang.liu@linux.intel.com, mingo@kernel.org,
        bp@alien8.de, tglx@linutronix.de
Reply-To: jiang.liu@linux.intel.com, tony.luck@intel.com, bp@alien8.de,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org
In-Reply-To: <20150115211702.955392443@linutronix.de>
References: <20150115211702.955392443@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/x2apic: Add proper state tracking
Git-Commit-ID: 12e189d3cfa4c64de758bde18626184bf32c65fc
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

Commit-ID:  12e189d3cfa4c64de758bde18626184bf32c65fc
Gitweb:     http://git.kernel.org/tip/12e189d3cfa4c64de758bde18626184bf32c65fc
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:22 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/x2apic: Add proper state tracking

Having 3 different variables to track the state is just silly and
error prone. Add a proper state tracking variable which covers the
three possible states: ON/OFF/DISABLED.

We cannot use x2apic_mode for this as this would require to change all
users of x2apic_mode with explicit comparisons for a state value
instead of treating it as boolean.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211702.955392443@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 06b7521..b374b0d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1480,6 +1480,14 @@ static bool nox2apic __initdata;
 #ifdef CONFIG_X86_X2APIC
 int x2apic_mode;
 static int x2apic_disabled;
+
+enum {
+	X2APIC_OFF,
+	X2APIC_ON,
+	X2APIC_DISABLED,
+};
+static int x2apic_state;
+
 static int __init setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -1496,7 +1504,7 @@ static int __init setup_nox2apic(char *str)
 		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 
 	nox2apic = true;
-
+	x2apic_state = X2APIC_DISABLED;
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -1539,6 +1547,7 @@ static __init void disable_x2apic(void)
 	}
 
 	x2apic_disabled = 1;
+	x2apic_state = X2APIC_DISABLED;
 }
 
 void enable_x2apic(void)
@@ -1559,6 +1568,7 @@ void enable_x2apic(void)
 		printk_once(KERN_INFO "Enabling x2apic\n");
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
+	x2apic_state = X2APIC_ON;
 }
 
 static __init void try_to_enable_x2apic(int remap_mode)
@@ -1597,6 +1607,9 @@ void __init check_x2apic(void)
 	if (x2apic_enabled()) {
 		pr_info("x2apic: enabled by BIOS, switching to x2apic ops\n");
 		x2apic_mode = 1;
+		x2apic_state = X2APIC_ON;
+	} else if (!cpu_has_x2apic) {
+		x2apic_state = X2APIC_DISABLED;
 	}
 }
 #else /* CONFIG_X86_X2APIC */
