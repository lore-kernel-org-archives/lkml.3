Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaFUOcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 10:32:08 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33817 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaFUOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 10:32:06 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86_32,signal: Fix vdso rt_sigreturn
Date: Sat, 21 Jun 2014 07:31:55 -0700
Message-Id: <1eb40ad923acde2e18357ef2832867432e70ac42.1403361010.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <CA+5PVA61wwmnstiBdDemufGvXvSu4RL3WHds3NSstH-rVx7tYg@mail.gmail.com>
References: <CA+5PVA61wwmnstiBdDemufGvXvSu4RL3WHds3NSstH-rVx7tYg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:

    commit 6f121e548f83674ab4920a4e60afb58d4f61b829
    Author: Andy Lutomirski <luto@amacapital.net>
    Date:   Mon May 5 12:19:34 2014 -0700

        x86, vdso: Reimplement vdso.so preparation in build-time C

Contained this obvious typo:

-               restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
+               restorer = current->mm->context.vdso +
+                       selected_vdso32->sym___kernel_sigreturn;

Note the missing 'rt_' in the new code.  Fix it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Compile-tested only.  I bet that someone will test it here far more quickly
than I can figure out how to test it:

https://bugzilla.redhat.com/show_bug.cgi?id=1110968

 arch/x86/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index a0da58d..2851d63 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -363,7 +363,7 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 
 		/* Set up to return from userspace.  */
 		restorer = current->mm->context.vdso +
-			selected_vdso32->sym___kernel_sigreturn;
+			selected_vdso32->sym___kernel_rt_sigreturn;
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
 			restorer = ksig->ka.sa.sa_restorer;
 		put_user_ex(restorer, &frame->pretcode);
-- 
1.9.3

