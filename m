Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbbAVUy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:54:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbbAVUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:54:57 -0500
Date: Thu, 22 Jan 2015 12:54:43 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-3669ef9fa7d35f573ec9c0e0341b29251c2734a7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, tglx@linutronix.de,
        mingo@kernel.org, hpa@zytor.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, luto@amacapital.net
In-Reply-To: <0cb251abe1ff0958b8e468a9a9a905b80ae3a746.1421954363.git.luto@amacapital.net>
References: <0cb251abe1ff0958b8e468a9a9a905b80ae3a746.1421954363.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, tls:
  Interpret an all-zero struct user_desc as "no segment"
Git-Commit-ID: 3669ef9fa7d35f573ec9c0e0341b29251c2734a7
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

Commit-ID:  3669ef9fa7d35f573ec9c0e0341b29251c2734a7
Gitweb:     http://git.kernel.org/tip/3669ef9fa7d35f573ec9c0e0341b29251c2734a7
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 22 Jan 2015 11:27:59 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 21:45:07 +0100

x86, tls: Interpret an all-zero struct user_desc as "no segment"

The Witcher 2 did something like this to allocate a TLS segment index:

        struct user_desc u_info;
        bzero(&u_info, sizeof(u_info));
        u_info.entry_number = (uint32_t)-1;

        syscall(SYS_set_thread_area, &u_info);

Strictly speaking, this code was never correct.  It should have set
read_exec_only and seg_not_present to 1 to indicate that it wanted
to find a free slot without putting anything there, or it should
have put something sensible in the TLS slot if it wanted to allocate
a TLS entry for real.  The actual effect of this code was to
allocate a bogus segment that could be used to exploit espfix.

The set_thread_area hardening patches changed the behavior, causing
set_thread_area to return -EINVAL and crashing the game.

This changes set_thread_area to interpret this as a request to find
a free slot and to leave it empty, which isn't *quite* what the game
expects but should be close enough to keep it working.  In
particular, using the code above to allocate two segments will
allocate the same segment both times.

According to FrostbittenKing on Github, this fixes The Witcher 2.

If this somehow still causes problems, we could instead allocate
a limit==0 32-bit data segment, but that seems rather ugly to me.

Fixes: 41bdc78544b8 x86/tls: Validate TLS entries to protect espfix
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: stable@vger.kernel.org
Cc: torvalds@linux-foundation.org
Link: http://lkml.kernel.org/r/0cb251abe1ff0958b8e468a9a9a905b80ae3a746.1421954363.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/desc.h | 13 +++++++++++++
 arch/x86/kernel/tls.c       | 25 +++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index fc237fd..a94b82e 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -262,6 +262,19 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 	 (info)->seg_not_present	== 1	&&	\
 	 (info)->useable		== 0)
 
+/* Lots of programs expect an all-zero user_desc to mean "no segment at all". */
+static inline bool LDT_zero(const struct user_desc *info)
+{
+	return (info->base_addr		== 0 &&
+		info->limit		== 0 &&
+		info->contents		== 0 &&
+		info->read_exec_only	== 0 &&
+		info->seg_32bit		== 0 &&
+		info->limit_in_pages	== 0 &&
+		info->seg_not_present	== 0 &&
+		info->useable		== 0);
+}
+
 static inline void clear_LDT(void)
 {
 	set_ldt(NULL, 0);
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 4e942f3..7fc5e84 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -29,7 +29,28 @@ static int get_free_idx(void)
 
 static bool tls_desc_okay(const struct user_desc *info)
 {
-	if (LDT_empty(info))
+	/*
+	 * For historical reasons (i.e. no one ever documented how any
+	 * of the segmentation APIs work), user programs can and do
+	 * assume that a struct user_desc that's all zeros except for
+	 * entry_number means "no segment at all".  This never actually
+	 * worked.  In fact, up to Linux 3.19, a struct user_desc like
+	 * this would create a 16-bit read-write segment with base and
+	 * limit both equal to zero.
+	 *
+	 * That was close enough to "no segment at all" until we
+	 * hardened this function to disallow 16-bit TLS segments.  Fix
+	 * it up by interpreting these zeroed segments the way that they
+	 * were almost certainly intended to be interpreted.
+	 *
+	 * The correct way to ask for "no segment at all" is to specify
+	 * a user_desc that satisfies LDT_empty.  To keep everything
+	 * working, we accept both.
+	 *
+	 * Note that there's a similar kludge in modify_ldt -- look at
+	 * the distinction between modes 1 and 0x11.
+	 */
+	if (LDT_empty(info) || LDT_zero(info))
 		return true;
 
 	/*
@@ -71,7 +92,7 @@ static void set_tls_desc(struct task_struct *p, int idx,
 	cpu = get_cpu();
 
 	while (n-- > 0) {
-		if (LDT_empty(info))
+		if (LDT_empty(info) || LDT_zero(info))
 			desc->a = desc->b = 0;
 		else
 			fill_ldt(desc, info);
