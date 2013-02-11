Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3BKMha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:37:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab3BKMh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:37:27 -0500
Date: Mon, 11 Feb 2013 04:37:11 -0800
From: tip-bot for Stoney Wang <song-bo.wang@hp.com>
Message-ID: <tip-cb214ede7657db458fd0b2a25ea0b28dbf900ebc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, song-bo.wang@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        song-bo.wang@hp.com, yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <1360263182-16226-1-git-send-email-yinghai@kernel.org>
References: <1360263182-16226-1-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/apic:
  Work around boot failure on HP ProLiant DL980 G7 Server systems
Git-Commit-ID: cb214ede7657db458fd0b2a25ea0b28dbf900ebc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:37:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb214ede7657db458fd0b2a25ea0b28dbf900ebc
Gitweb:     http://git.kernel.org/tip/cb214ede7657db458fd0b2a25ea0b28dbf900ebc
Author:     Stoney Wang <song-bo.wang@hp.com>
AuthorDate: Thu, 7 Feb 2013 10:53:02 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 11:13:00 +0100

x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems

When a HP ProLiant DL980 G7 Server boots a regular kernel,
there will be intermittent lost interrupts which could
result in a hang or (in extreme cases) data loss.

The reason is that this system only supports x2apic physical
mode, while the kernel boots with a logical-cluster default
setting.

This bug can be worked around by specifying the "x2apic_phys" or
"nox2apic" boot option, but we want to handle this system
without requiring manual workarounds.

The BIOS sets ACPI_FADT_APIC_PHYSICAL in FADT table.
As all apicids are smaller than 255, BIOS need to pass the
control to the OS with xapic mode, according to x2apic-spec,
chapter 2.9.

Current code handle x2apic when BIOS pass with xapic mode
enabled:

When user specifies x2apic_phys, or FADT indicates PHYSICAL:

1. During madt oem check, apic driver is set with xapic logical
   or xapic phys driver at first.

2. enable_IR_x2apic() will enable x2apic_mode.

3. if user specifies x2apic_phys on the boot line, x2apic_phys_probe()
   will install the correct x2apic phys driver and use x2apic phys mode.
   Otherwise it will skip the driver will let x2apic_cluster_probe to
   take over to install x2apic cluster driver (wrong one) even though FADT
   indicates PHYSICAL, because x2apic_phys_probe does not check
   FADT PHYSICAL.

Add checking x2apic_fadt_phys in x2apic_phys_probe() to fix the
problem.

Signed-off-by: Stoney Wang <song-bo.wang@hp.com>
[ updated the changelog and simplified the code ]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/1360263182-16226-1-git-send-email-yinghai@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/x2apic_phys.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index e03a1e1..562a76d 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -20,18 +20,19 @@ static int set_x2apic_phys_mode(char *arg)
 }
 early_param("x2apic_phys", set_x2apic_phys_mode);
 
-static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static bool x2apic_fadt_phys(void)
 {
-	if (x2apic_phys)
-		return x2apic_enabled();
-	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
-		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
-		x2apic_enabled()) {
+	if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
 		printk(KERN_DEBUG "System requires x2apic physical mode\n");
-		return 1;
+		return true;
 	}
-	else
-		return 0;
+	return false;
+}
+
+static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return x2apic_enabled() && (x2apic_phys || x2apic_fadt_phys());
 }
 
 static void
@@ -82,7 +83,7 @@ static void init_x2apic_ldr(void)
 
 static int x2apic_phys_probe(void)
 {
-	if (x2apic_mode && x2apic_phys)
+	if (x2apic_mode && (x2apic_phys || x2apic_fadt_phys()))
 		return 1;
 
 	return apic == &apic_x2apic_phys;
