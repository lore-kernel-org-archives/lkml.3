Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaLAJ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:57:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53237 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaLAJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:57:43 -0500
Date: Mon, 1 Dec 2014 01:57:30 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-02ecc41abcea4ff9291d548f6f846b29b354ddd2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, bp@suse.de
Reply-To: hpa@zytor.com, bp@suse.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1417353999-32236-1-git-send-email-bp@alien8.de>
References: <1417353999-32236-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode:
  Limit the microcode reloading to 64-bit for now
Git-Commit-ID: 02ecc41abcea4ff9291d548f6f846b29b354ddd2
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

Commit-ID:  02ecc41abcea4ff9291d548f6f846b29b354ddd2
Gitweb:     http://git.kernel.org/tip/02ecc41abcea4ff9291d548f6f846b29b354ddd2
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 30 Nov 2014 14:26:39 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 1 Dec 2014 10:55:08 +0100

x86, microcode: Limit the microcode reloading to 64-bit for now

First, there was this: https://bugzilla.kernel.org/show_bug.cgi?id=88001

The problem there was that microcode patches are not being reapplied
after suspend-to-ram. It was important to reapply them, though, because
of for example Haswell's TSX erratum which disabled TSX instructions
with a microcode patch.

A simple fix was fb86b97300d9 ("x86, microcode: Update BSPs microcode
on resume") but, as it is often the case, simple fixes are too
simple. This one causes 32-bit resume to fail:

https://bugzilla.kernel.org/show_bug.cgi?id=88391

Properly fixing this would require more involved changes for which it
is too late now, right before the merge window. Thus, limit this to
64-bit only temporarily.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1417353999-32236-1-git-send-email-bp@alien8.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/microcode/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 2ce9051..08fe6e8 100644
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
