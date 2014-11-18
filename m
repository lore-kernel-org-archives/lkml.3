Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaKRJrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:47:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaKRJrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:47:00 -0500
Date: Tue, 18 Nov 2014 10:46:57 +0100
From: Borislav Petkov <bp@suse.de>
To: x86-ml <x86@kernel.org>
Cc: alex.schnaidt@gmail.com, Fenghua Yu <fenghua.yu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, microcode: Update BSP's microcode on resume
Message-ID: <20141118094657.GA6635@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here's one more fix for x86/urgent.

Please apply,
thanks.

---
In the situation when we apply early microcode but do *not* apply late
microcode, we fail to update the BSP's microcode on resume because we
haven't initialized the uci->mc microcode pointer. So, in order to
alleviate that, we go and dig out the stashed microcode patch during
early boot. It is basically the same thing that is done on the APs early
during boot so do that too here.

Tested-by: alex.schnaidt@gmail.com
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=88001
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@vger.kernel.org> # v3.9
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index dd9d6190b08d..2ce9051174e6 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -465,6 +465,14 @@ static void mc_bp_resume(void)
 
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
2.0.0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
