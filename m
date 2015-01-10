Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbbAJWAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:00:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52331 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbbAJWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:00:51 -0500
Date: Sat, 10 Jan 2015 23:00:42 +0100
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
Message-ID: <20150110220042.GG12218@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
 <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
 <20150110142336.GC12218@pd.tnic>
 <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 09:14:03PM +0100, Denys Vlasenko wrote:
> From 2f636e0a92db898f2bdb592027aa302fcb32a326 Mon Sep 17 00:00:00 2001
> From: Denys Vlasenko <dvlasenk@redhat.com>
> To: linux-kernel@vger.kernel.org
> Subject: [PATCH 3/4] x86: open-code register save/restore in trace_hardirqs thunks
> 
> This is a preparatory patch for change in "struct pt_regs"
> handling in entry_64.S.
> 
> trace_hardirqs thunks were (ab)using a part of pt_regs
> handling code, namely SAVE_ARGS/RESTORE_ARGS macros,
> to save/restore registers across C function calls.
> 
> Since SAVE_ARGS is going to be changed, open-code
> register saving/restoring here. Take a page from thunk_32.S
> and use push/pop insns instead of movq, they are far shorter:
> 1 or 2 bytes versus 5, and no need for insns to adjust %rsp:
> 
>    text	   data	    bss	    dec	    hex	filename
>     333	     40	      0	    373	    175	thunk_64_movq.o
>     104	     40	      0	    144	     90	thunk_64_push_pop.o
> 
> Incidentally, this removes a bit of dead code:
> one SAVE_ARGS was used just to emit a CFI annotation,
> but it also generated unreachable assembly insns.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: X86 ML <x86@kernel.org>
> CC: Alexei Starovoitov <ast@plumgrid.com>
> CC: Will Drewry <wad@chromium.org>
> CC: Kees Cook <keescook@chromium.org>
> CC: linux-kernel@vger.kernel.org
> ---
>  arch/x86/lib/thunk_64.S | 46 ++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
> index b30b5eb..8ec443a 100644
> --- a/arch/x86/lib/thunk_64.S
> +++ b/arch/x86/lib/thunk_64.S
> @@ -17,9 +17,27 @@
>  	CFI_STARTPROC
>  
>  	/* this one pushes 9 elems, the next one would be %rIP */
> -	SAVE_ARGS
> +	pushq_cfi %rdi
> +	CFI_REL_OFFSET rdi, 0

Btw, why the second CFI annotation?

pushq_cfi does already CFI_ADJUST_CFA_OFFSET 8. Can't we use one and
hide it in the macro?

Btw, patch boots fine in the guest.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
