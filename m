Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaCNWtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:49:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaCNWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:49:22 -0400
Date: Fri, 14 Mar 2014 15:48:38 -0700
Message-Id: <201403142248.s2EMmcuv027594@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.14-rc7
Cc: <stable@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Daniel J Blueman <daniel@numascale.com>,
        George Spelvin <linux@horizon.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Steffen Persvold <sp@numascale.com>,
        Suresh Siddha <sbsiddha@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two x86 fixes: Suresh's eager FPU fix, and a fix to the NUMA quirk for
AMD northbridges.

This only includes Suresh's fix patch, not the "mostly a cleanup"
patch which had __init issues.

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 847d7970defb45540735b3fb4e88471c27cacd85:

  x86/amd/numa: Fix northbridge quirk to assign correct NUMA node (2014-03-14 11:05:36 +0100)

----------------------------------------------------------------
Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Suresh Siddha (1):
      x86, fpu: Check tsk_used_math() in kernel_fpu_end() for eager FPU

 arch/x86/kernel/i387.c   | 15 ++++++++++++---
 arch/x86/kernel/quirks.c |  2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index e8368c6dd2a2..d5dd80814419 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -86,10 +86,19 @@ EXPORT_SYMBOL(__kernel_fpu_begin);
 
 void __kernel_fpu_end(void)
 {
-	if (use_eager_fpu())
-		math_state_restore();
-	else
+	if (use_eager_fpu()) {
+		/*
+		 * For eager fpu, most the time, tsk_used_math() is true.
+		 * Restore the user math as we are done with the kernel usage.
+		 * At few instances during thread exit, signal handling etc,
+		 * tsk_used_math() is false. Those few places will take proper
+		 * actions, so we don't need to restore the math here.
+		 */
+		if (likely(tsk_used_math(current)))
+			math_state_restore();
+	} else {
 		stts();
+	}
 }
 EXPORT_SYMBOL(__kernel_fpu_end);
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 7c6acd4b8995..ff898bbf579d 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -529,7 +529,7 @@ static void quirk_amd_nb_node(struct pci_dev *dev)
 		return;
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
-	node = val & 7;
+	node = pcibus_to_node(dev->bus) | (val & 7);
 	/*
 	 * Some hardware may return an invalid node ID,
 	 * so check it first:
