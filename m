Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaKRRlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:41:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaKRRlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:41:12 -0500
Date: Tue, 18 Nov 2014 09:40:23 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-fb86b97300d930b57471068720c52bfa8622eab7@git.kernel.org>
Cc: hmh@hmh.eng.br, fenghua.yu@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, bp@suse.de, tglx@linutronix.de,
        mingo@kernel.org
Reply-To: fenghua.yu@intel.com, hmh@hmh.eng.br, bp@suse.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <20141118094657.GA6635@pd.tnic>
References: <20141118094657.GA6635@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode: Update BSPs microcode on resume
Git-Commit-ID: fb86b97300d930b57471068720c52bfa8622eab7
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

Commit-ID:  fb86b97300d930b57471068720c52bfa8622eab7
Gitweb:     http://git.kernel.org/tip/fb86b97300d930b57471068720c52bfa8622eab7
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 18 Nov 2014 10:46:57 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 18:32:24 +0100

x86, microcode: Update BSPs microcode on resume

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
Cc: <stable@vger.kernel.org> # v3.9
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/20141118094657.GA6635@pd.tnic
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/microcode/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index dd9d619..2ce9051 100644
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
