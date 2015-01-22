Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbbAVO2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:28:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbAVO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:28:49 -0500
Date: Thu, 22 Jan 2015 06:28:26 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-6d2d49d2cd0199ce298d111ee7fd405af3344a70@git.kernel.org>
Cc: bp@alien8.de, hpa@zytor.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org, mingo@kernel.org,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: bp@alien8.de, hpa@zytor.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org, mingo@kernel.org,
        tglx@linutronix.de, tony.luck@intel.com
In-Reply-To: <20150115211703.209387598@linutronix.de>
References: <20150115211703.209387598@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/x2apic: Use state information for disable
Git-Commit-ID: 6d2d49d2cd0199ce298d111ee7fd405af3344a70
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

Commit-ID:  6d2d49d2cd0199ce298d111ee7fd405af3344a70
Gitweb:     http://git.kernel.org/tip/6d2d49d2cd0199ce298d111ee7fd405af3344a70
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:27 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/x2apic: Use state information for disable

Use the state information to simplify the disable logic further.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211703.209387598@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0ee96b9..0c554f5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1547,26 +1547,20 @@ void x2apic_setup(void)
 
 static __init void x2apic_disable(void)
 {
-	u64 msr;
-
-	if (!cpu_has_x2apic)
-		return;
-
-	rdmsrl(MSR_IA32_APICBASE, msr);
-	if (msr & X2APIC_ENABLE) {
-		u32 x2apic_id = read_apic_id();
+	u32 x2apic_id;
 
-		if (x2apic_id >= 255)
-			panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
+	if (x2apic_state != X2APIC_ON)
+		goto out;
 
-		__x2apic_disable();
-
-		x2apic_mode = 0;
-
-		register_lapic_address(mp_lapic_addr);
-	}
+	x2apic_id = read_apic_id();
+	if (x2apic_id >= 255)
+		panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
 
+	__x2apic_disable();
+	register_lapic_address(mp_lapic_addr);
+out:
 	x2apic_state = X2APIC_DISABLED;
+	x2apic_mode = 0;
 }
 
 static __init void x2apic_enable(void)
