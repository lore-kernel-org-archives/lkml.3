Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbbAJOXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 09:23:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56371 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbbAJOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:23:39 -0500
Date: Sat, 10 Jan 2015 15:23:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
Message-ID: <20150110142336.GC12218@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
 <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 07:54:08PM +0100, Denys Vlasenko wrote:
> In order to narrow it down, can you, instead of my patch, try
> just deleting this one line, and see whether breakage appears?

Yep, this works:

---
Index: b/arch/x86/lib/thunk_64.S
===================================================================
--- a/arch/x86/lib/thunk_64.S	2015-01-10 15:03:10.262716858 +0100
+++ b/arch/x86/lib/thunk_64.S	2015-01-10 15:12:53.502730396 +0100
@@ -47,7 +47,6 @@
 
 	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
 	CFI_STARTPROC
-	SAVE_ARGS
 restore:
 	RESTORE_ARGS
 	ret
--

Bah, I see it. This nasty '$' gets forgotten a lot, maybe we should have
a check for that in some scripts :-)

Here's the fix:

---
Index: b/arch/x86/lib/thunk_64.S
===================================================================
--- a/arch/x86/lib/thunk_64.S	2015-01-10 15:18:04.418737613 +0100
+++ b/arch/x86/lib/thunk_64.S	2015-01-10 15:17:18.882736556 +0100
@@ -67,7 +67,7 @@ restore:
 	movq_cfi_restore 6*8, rdx
 	movq_cfi_restore 7*8, rsi
 	movq_cfi_restore 8*8, rdi
-	addq 9*8, %rsp
+	addq $9*8, %rsp
 	CFI_ADJUST_CFA_OFFSET -9*8
 	ret
 	CFI_ENDPROC
---

That boots!

:-D

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
