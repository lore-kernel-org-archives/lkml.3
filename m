Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbbAISyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:54:31 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:43669 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110AbbAISy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:54:29 -0500
MIME-Version: 1.0
In-Reply-To: <20150109121950.GD13637@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com> <20150109121950.GD13637@pd.tnic>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 9 Jan 2015 19:54:08 +0100
Message-ID: <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav, thank you for testing and finding it.

On Fri, Jan 9, 2015 at 1:19 PM, Borislav Petkov <bp@alien8.de> wrote:
> Hmm, this patch breaks booting my kvm guest: it stops booting at some
> point and restarts itself after a couple of seconds.
>
> The monitor says rIP points to ffffffff8167ae30 which is this:
>
> ffffffff8167ae30 <async_page_fault>:
> ffffffff8167ae30:       ff 15 fa 62 31 00       callq  *0x3162fa(%rip)        # ffffffff81991130 <pv_irq_ops+0x30>
> ffffffff8167ae36:       48 83 ec 78             sub    $0x78,%rsp
> ffffffff8167ae3a:       e8 d1 01 00 00          callq  ffffffff8167b010 <error_entry>
> ffffffff8167ae3f:       48 89 e7                mov    %rsp,%rdi
> ffffffff8167ae42:       48 8b 74 24 78          mov    0x78(%rsp),%rsi
> ffffffff8167ae47:       48 c7 44 24 78 ff ff    movq   $0xffffffffffffffff,0x78(%rsp)
> ffffffff8167ae4e:       ff ff
> ffffffff8167ae50:       e8 9b 9e 9c ff          callq  ffffffff81044cf0 <do_async_page_fault>
> ffffffff8167ae55:       e9 76 02 00 00          jmpq   ffffffff8167b0d0 <error_exit>
> ffffffff8167ae5a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)

I just looked at disassembly of thunk_64.o
before and after the patch. Here's what I see:

Before:

Disassembly of section .text:
0000000000000000 <restore-0x30>:
   0:   48 83 ec 48             sub    $0x48,%rsp
   4:   48 89 7c 24 40          mov    %rdi,0x40(%rsp)
   9:   48 89 74 24 38          mov    %rsi,0x38(%rsp)
   e:   48 89 54 24 30          mov    %rdx,0x30(%rsp)
  13:   48 89 4c 24 28          mov    %rcx,0x28(%rsp)
  18:   48 89 44 24 20          mov    %rax,0x20(%rsp)
  1d:   4c 89 44 24 18          mov    %r8,0x18(%rsp)
  22:   4c 89 4c 24 10          mov    %r9,0x10(%rsp)
  27:   4c 89 54 24 08          mov    %r10,0x8(%rsp)
  2c:   4c 89 1c 24             mov    %r11,(%rsp)
0000000000000030 <restore>:
  30:   4c 8b 1c 24             mov    (%rsp),%r11
  34:   4c 8b 54 24 08          mov    0x8(%rsp),%r10
  39:   4c 8b 4c 24 10          mov    0x10(%rsp),%r9
  3e:   4c 8b 44 24 18          mov    0x18(%rsp),%r8
  43:   48 8b 44 24 20          mov    0x20(%rsp),%rax
  48:   48 8b 4c 24 28          mov    0x28(%rsp),%rcx
  4d:   48 8b 54 24 30          mov    0x30(%rsp),%rdx
  52:   48 8b 74 24 38          mov    0x38(%rsp),%rsi
  57:   48 8b 7c 24 40          mov    0x40(%rsp),%rdi
  5c:   48 83 c4 48             add    $0x48,%rsp
  60:   c3                      retq

After:

Disassembly of section .text:
0000000000000000 <restore>:
   0:   4c 8b 1c 24             mov    (%rsp),%r11
   4:   4c 8b 54 24 08          mov    0x8(%rsp),%r10
   9:   4c 8b 4c 24 10          mov    0x10(%rsp),%r9
   e:   4c 8b 44 24 18          mov    0x18(%rsp),%r8
  13:   48 8b 44 24 20          mov    0x20(%rsp),%rax
  18:   48 8b 4c 24 28          mov    0x28(%rsp),%rcx
  1d:   48 8b 54 24 30          mov    0x30(%rsp),%rdx
  22:   48 8b 74 24 38          mov    0x38(%rsp),%rsi
  27:   48 8b 7c 24 40          mov    0x40(%rsp),%rdi
  2c:   48 03 24 25 48 00 00    add    0x48,%rsp
  33:   00
  34:   c3                      retq

IOW, my patch, on the level of generated assembly, results only in removal
of unreachable "SAVE_ARGS" thing.

I looked into git history all the way back to 2005. The part

+       /* SAVE_ARGS below is used only for the .cfi directives it contains. */
+       CFI_STARTPROC
+       SAVE_ARGS
+restore:

was there in the very first git commit.

I don't see how this SAVE_ARGS can affect anything. It *is* unreachable,
right?

Does kvm guest code really parse and use CFI data in its operation?
That's the only way the breakage can be explained.

In order to narrow it down, can you, instead of my patch, try
just deleting this one line, and see whether breakage appears?

Thanks!
-- 
vda
