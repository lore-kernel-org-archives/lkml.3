Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541Ab3DDPyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:54:19 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36859 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762404Ab3DDPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:54:17 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Steffen Persvold <sp@numascale.com>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
Date: Thu,  4 Apr 2013 23:52:00 +0800
Message-Id: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On platforms where all Northbridges may not be visible (due to routing, eg on
NumaConnect systems), prevent oopsing due to stale pointer access when
offlining cores.

Signed-off-by: Steffen Persvold <sp@numascale.com>
Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>

---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 1ac581f..53a58c2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -578,8 +578,11 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	if (shared_bank[bank]) {
 		nb = node_to_amd_nb(amd_get_nb_id(cpu));
 
+		if (WARN_ON_ONCE(!nb))
+			goto out;
+
 		/* threshold descriptor already initialized on this node? */
-		if (nb && nb->bank4) {
+		if (nb->bank4) {
 			/* yes, use it */
 			b = nb->bank4;
 			err = kobject_add(b->kobj, &dev->kobj, name);
@@ -613,10 +616,8 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		atomic_set(&b->cpus, 1);
 
 		/* nb is already initialized, see above */
-		if (nb) {
-			WARN_ON(nb->bank4);
-			nb->bank4 = b;
-		}
+		WARN_ON(nb->bank4);
+		nb->bank4 = b;
 	}
 
 	err = allocate_threshold_blocks(cpu, bank, 0,
-- 
1.7.4.1

