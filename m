Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaKROOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:14:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbaKROK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 206/206] x86_64, entry: Fix out of bounds read on sysenter
Date: Tue, 18 Nov 2014 15:09:21 +0100
Message-Id: <2854d767135c3ca131d8658f5b47974d7b067d3b.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 653bc77af60911ead1f423e588f54fc2547c4957 upstream.

Rusty noticed a Really Bad Bug (tm) in my NT fix.  The entry code
reads out of bounds, causing the NT fix to be unreliable.  But, and
this is much, much worse, if your stack is somehow just below the
top of the direct map (or a hole), you read out of bounds and crash.

Excerpt from the crash:

[    1.129513] RSP: 0018:ffff88001da4bf88  EFLAGS: 00010296

  2b:*    f7 84 24 90 00 00 00     testl  $0x4000,0x90(%rsp)

That read is deterministically above the top of the stack.  I
thought I even single-stepped through this code when I wrote it to
check the offset, but I clearly screwed it up.

Fixes: 8c7aa698baca ("x86_64, entry: Filter RFLAGS.NT on entry from userspace")
Reported-by: Rusty Russell <rusty@ozlabs.org>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/ia32/ia32entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 711de084ab57..92a2e9333620 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -157,7 +157,7 @@ ENTRY(ia32_sysenter_target)
 	 * ourselves.  To save a few cycles, we can check whether
 	 * NT was set instead of doing an unconditional popfq.
 	 */
-	testl $X86_EFLAGS_NT,EFLAGS(%rsp)	/* saved EFLAGS match cpu */
+	testl $X86_EFLAGS_NT,EFLAGS-ARGOFFSET(%rsp)
 	jnz sysenter_fix_flags
 sysenter_flags_fixed:
 
-- 
2.1.3

