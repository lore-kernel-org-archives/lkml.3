Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbaLBTj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:39:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933642AbaLBT0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Fenghua Yu <fenghua.yu@intel.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 110/121] x86, microcode: Update BSPs microcode on resume
Date: Tue,  2 Dec 2014 11:19:49 -0800
Message-Id: <1417548000-1794-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit fb86b97300d930b57471068720c52bfa8622eab7 upstream.

In the situation when we apply early microcode but do *not* apply late
microcode, we fail to update the BSP's microcode on resume because we
haven't initialized the uci->mc microcode pointer. So, in order to
alleviate that, we go and dig out the stashed microcode patch during
early boot. It is basically the same thing that is done on the APs early
during boot so do that too here.

Tested-by: alex.schnaidt@gmail.com
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=88001
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/20141118094657.GA6635@pd.tnic
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/microcode_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 15c9876..1354282 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -462,6 +462,14 @@ static void mc_bp_resume(void)
 
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
+	else if (!uci->mc)
+		/*
+		 * We might resume and not have applied late microcode but still
+		 * have a newer patch stashed from the early loader. We don't
+		 * have it in uci->mc so we have to load it the same way we're
+		 * applying patches early on the APs.
+		 */
+		load_ucode_ap();
 }
 
 static struct syscore_ops mc_syscore_ops = {
-- 
1.9.1

