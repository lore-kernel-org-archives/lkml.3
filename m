Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab3CLWdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3CLWdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Geoff Levand <geoff@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 091/100] powerpc: Apply early paca fixups to boot_paca and the boot cpus paca
Date: Tue, 12 Mar 2013 15:32:16 -0700
Message-Id: <20130312223132.683274577@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit 25e138149c19fa0680147b825be475f5fd57f155 upstream.

In commit 466921c we added a hack to set the paca data_offset to zero so
that per-cpu accesses would work on the boot cpu prior to per-cpu areas
being setup. This fixed a problem with lockdep touching per-cpu areas
very early in boot.

However if we combine CONFIG_LOCK_STAT=y with any of the PPC_EARLY_DEBUG
options, we can hit the same problem in udbg_early_init(). To avoid that
we need to set the data_offset of the boot_paca also. So factor out the
fixup logic and call it for both the boot_paca, and "the paca of the
boot cpu".

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Tested-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/setup_64.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -156,6 +156,15 @@ early_param("smt-enabled", early_smt_ena
 #define check_smt_enabled()
 #endif /* CONFIG_SMP */
 
+/** Fix up paca fields required for the boot cpu */
+static void fixup_boot_paca(void)
+{
+	/* The boot cpu is started */
+	get_paca()->cpu_start = 1;
+	/* Allow percpu accesses to work until we setup percpu data */
+	get_paca()->data_offset = 0;
+}
+
 /*
  * Early initialization entry point. This is called by head.S
  * with MMU translation disabled. We rely on the "feature" of
@@ -185,6 +194,7 @@ void __init early_setup(unsigned long dt
 	/* Assume we're on cpu 0 for now. Don't write to the paca yet! */
 	initialise_paca(&boot_paca, 0);
 	setup_paca(&boot_paca);
+	fixup_boot_paca();
 
 	/* Initialize lockdep early or else spinlocks will blow */
 	lockdep_init();
@@ -205,11 +215,7 @@ void __init early_setup(unsigned long dt
 
 	/* Now we know the logical id of our boot cpu, setup the paca. */
 	setup_paca(&paca[boot_cpuid]);
-
-	/* Fix up paca fields required for the boot cpu */
-	get_paca()->cpu_start = 1;
-	/* Allow percpu accesses to "work" until we setup percpu data */
-	get_paca()->data_offset = 0;
+	fixup_boot_paca();
 
 	/* Probe the machine type */
 	probe_machine();


