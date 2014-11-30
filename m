Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaK3N0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 08:26:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54520 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaK3N0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 08:26:43 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, microcode: Limit the microcode reloading to 64-bit for now
Date: Sun, 30 Nov 2014 14:26:39 +0100
Message-Id: <1417353999-32236-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

First, there was this: https://bugzilla.kernel.org/show_bug.cgi?id=88001

The problem there was that microcode patches are not being reapplied
after suspend-to-ram. It was important to reapply them, though, because
of for example Haswell's TSX erratum which disabled TSX instructions
with a microcode patch.

A simple fix was

fb86b97300d9 ("x86, microcode: Update BSPs microcode on resume")

but, as it is often the case, simple fixes are too simple. This one
causes 32-bit resume to fail:

https://bugzilla.kernel.org/show_bug.cgi?id=88391

Properly fixing this would require more involved changes for which it is
too late now, before the merge window. Thus, limit this to 64-bit only
temporarily.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 2ce9051174e6..08fe6e8a726e 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -465,6 +465,7 @@ static void mc_bp_resume(void)
 
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
+#ifdef CONFIG_X86_64
 	else if (!uci->mc)
 		/*
 		 * We might resume and not have applied late microcode but still
@@ -473,6 +474,7 @@ static void mc_bp_resume(void)
 		 * applying patches early on the APs.
 		 */
 		load_ucode_ap();
+#endif
 }
 
 static struct syscore_ops mc_syscore_ops = {
-- 
2.0.0

