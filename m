Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbbAVO3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:29:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57967 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbbAVO3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:29:47 -0500
Date: Thu, 22 Jan 2015 06:29:24 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a46f5c89274245e42834dc976896444efd53ccdc@git.kernel.org>
Cc: hpa@zytor.com, bp@alien8.de, linux-kernel@vger.kernel.org, joro@8bytes.org,
        tony.luck@intel.com, tglx@linutronix.de, jiang.liu@linux.intel.com,
        mingo@kernel.org
Reply-To: mingo@kernel.org, jiang.liu@linux.intel.com, tglx@linutronix.de,
        tony.luck@intel.com, joro@8bytes.org, bp@alien8.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <20150115211703.490719938@linutronix.de>
References: <20150115211703.490719938@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/ioapic: Add proper checks to setp/
 enable_IO_APIC()
Git-Commit-ID: a46f5c89274245e42834dc976896444efd53ccdc
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

Commit-ID:  a46f5c89274245e42834dc976896444efd53ccdc
Gitweb:     http://git.kernel.org/tip/a46f5c89274245e42834dc976896444efd53ccdc
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:32 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/ioapic: Add proper checks to setp/enable_IO_APIC()

No point to have the same checks at every call site. Add them to the
functions, so they can be called unconditionally.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211703.490719938@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e5e00f5..f4dc246 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1507,7 +1507,10 @@ void __init enable_IO_APIC(void)
 	int i8259_apic, i8259_pin;
 	int apic, pin;
 
-	if (!nr_legacy_irqs())
+	if (skip_ioapic_setup)
+		nr_ioapics = 0;
+
+	if (!nr_legacy_irqs() || !nr_ioapics)
 		return;
 
 	for_each_ioapic_pin(apic, pin) {
@@ -2373,9 +2376,9 @@ void __init setup_IO_APIC(void)
 {
 	int ioapic;
 
-	/*
-	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
-	 */
+	if (skip_ioapic_setup || !nr_ioapics)
+		return;
+
 	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
