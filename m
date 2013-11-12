Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3KLHKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:10:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3KLHJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:09:58 -0500
Date: Mon, 11 Nov 2013 23:09:44 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-e8236c4d9338d52d0f2fcecc0b792ac0542e4ee9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de
In-Reply-To: <20131111222839.GA28616@www.outflux.net>
References: <20131111222839.GA28616@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr:
  Add a circular multiply for better bit diffusion
Git-Commit-ID: e8236c4d9338d52d0f2fcecc0b792ac0542e4ee9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 23:09:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8236c4d9338d52d0f2fcecc0b792ac0542e4ee9
Gitweb:     http://git.kernel.org/tip/e8236c4d9338d52d0f2fcecc0b792ac0542e4ee9
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 11 Nov 2013 22:45:20 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 11 Nov 2013 23:05:49 -0800

x86, kaslr: Add a circular multiply for better bit diffusion

If we don't have RDRAND (in which case nothing else *should* matter),
most sources have a highly biased entropy distribution.  Use a
circular multiply to diffuse the entropic bits.  A circular multiply
is a good operation for this: it is cheap on standard hardware and
because it is symmetric (unlike an ordinary multiply) it doesn't
introduce its own bias.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/20131111222839.GA28616@www.outflux.net
---
 arch/x86/boot/compressed/aslr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 8746487..38a07cc 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -64,6 +64,11 @@ static unsigned long get_random_boot(void)
 
 static unsigned long get_random_long(void)
 {
+#ifdef CONFIG_X86_64
+	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
+#else
+	const unsigned long mix_const = 0x3f39e593UL;
+#endif
 	unsigned long raw, random = get_random_boot();
 	bool use_i8254 = true;
 
@@ -90,6 +95,12 @@ static unsigned long get_random_long(void)
 		random ^= i8254();
 	}
 
+	/* Circular multiply for better bit diffusion */
+	asm("mul %3"
+	    : "=a" (random), "=d" (raw)
+	    : "a" (random), "rm" (mix_const));
+	random += raw;
+
 	debug_putstr("...\n");
 
 	return random;
