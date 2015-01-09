Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbbAIMTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:19:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35383 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbbAIMTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:19:53 -0500
Date: Fri, 9 Jan 2015 13:19:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
Message-ID: <20150109121950.GD13637@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 05:25:14PM +0100, Denys Vlasenko wrote:
> This is a preparatory patch for change in "struct pt_regs"
> handling in entry_64.S.
> 
> trace_hardirqs thunks were (ab)using a part of pt_regs
> handling code, namely SAVE_ARGS/RESTORE_ARGS macros,
> to save/restore registers across C function calls.
> 
> Since SAVE_ARGS is going to be changed, open-code
> register saving/restoring here.
> 
> Incidentally, this removes a bit of dead code:
> one SAVE_ARGS was used just to emit a CFI annotation,
> but it also generated unreachable assembly insns.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: X86 ML <x86@kernel.org>
> CC: Alexei Starovoitov <ast@plumgrid.com>
> CC: Will Drewry <wad@chromium.org>
> CC: Kees Cook <keescook@chromium.org>
> CC: linux-kernel@vger.kernel.org
> ---
>  arch/x86/lib/thunk_64.S | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)

Hmm, this patch breaks booting my kvm guest: it stops booting at some
point and restarts itself after a couple of seconds.

The monitor says rIP points to ffffffff8167ae30 which is this:

ffffffff8167ae30 <async_page_fault>:
ffffffff8167ae30:       ff 15 fa 62 31 00       callq  *0x3162fa(%rip)        # ffffffff81991130 <pv_irq_ops+0x30>
ffffffff8167ae36:       48 83 ec 78             sub    $0x78,%rsp
ffffffff8167ae3a:       e8 d1 01 00 00          callq  ffffffff8167b010 <error_entry>
ffffffff8167ae3f:       48 89 e7                mov    %rsp,%rdi
ffffffff8167ae42:       48 8b 74 24 78          mov    0x78(%rsp),%rsi
ffffffff8167ae47:       48 c7 44 24 78 ff ff    movq   $0xffffffffffffffff,0x78(%rsp)
ffffffff8167ae4e:       ff ff 
ffffffff8167ae50:       e8 9b 9e 9c ff          callq  ffffffff81044cf0 <do_async_page_fault>
ffffffff8167ae55:       e9 76 02 00 00          jmpq   ffffffff8167b0d0 <error_exit>
ffffffff8167ae5a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
