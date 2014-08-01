Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaHASJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:09:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41104 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHASJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
	<1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
Date: Fri, 1 Aug 2014 11:09:05 -0700
Message-ID: <CAMEtUuwmqT3LFEqR6yONCNFthrHgWsg9UsGF5MS4y42GraNBnw@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
From: Alexei Starovoitov <ast@plumgrid.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 7:48 AM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> 64-bit code was using six stack slots fewer by not saving/restoring
> registers which a callee-preserved according to C ABI,
> and not allocating space for them.
>
> Only when syscall needed a complete "struct pt_regs",
> the complete area was allocated and filled in.
>
> This proved to be a source of significant obfuscation and subtle bugs.
> For example, stub_fork had to pop the return address,
> extend the struct, save registers, and push return address back. Ugly.
> ia32_ptregs_common pops return address and "returns" via jmp insn,
> throwing a wrench into CPU return stack cache.
>
> This patch changes code to always allocate a complete "struct pt_regs".
> The saving of registers is still done lazily.
>
> Macros which manipulate "struct pt_regs" on stack are reworked:
> ALLOC_PTREGS_ON_STACK allocates the structure.
> SAVE_C_REGS saves to it those registers which are clobbered by C code.
> SAVE_EXTRA_REGS saves to it all other registers.
> Corresponding RESTORE_* and REMOVE_PTREGS_FROM_STACK macros reverse it.

Looks like a nice cleanup at the cost of extra 48 byte stack gap for fast path.
I'm guessing the gap shouldn't affect performance, but would be nice
to see performance numbers before/after.
