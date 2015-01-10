Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbbAJWgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:36:20 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33432 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbbAJWgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:36:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx54dhF7mU6NUTuCW2gP2XQt55XG-a3iDttSmijmdzbyw@mail.gmail.com>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
 <1420927210-19738-4-git-send-email-dvlasenk@redhat.com> <CA+55aFx54dhF7mU6NUTuCW2gP2XQt55XG-a3iDttSmijmdzbyw@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Sat, 10 Jan 2015 23:35:58 +0100
Message-ID: <CAK1hOcNgnZcF5fZjSSMr+RQQWLGBSjitErd4gj7JxgTMZPGTzQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 11:07 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Jan 10, 2015 at 2:00 PM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>> +       pushq_cfi %rdi
>> +       CFI_REL_OFFSET rdi, 0
>> +       pushq_cfi %rsi
>> +       CFI_REL_OFFSET rsi, 0
>> +       pushq_cfi %rdx
>> +       CFI_REL_OFFSET rdx, 0
> ..
> Ugh.
>
> This is too ugly, it needs to die.
>
> Why doesn't pushq_cfi do that CFI_REL_OFFSET thing?

I don't know either... it seems to be used after push_cfi
*sometimes*, not always:

.macro op_safe_regs op
ENTRY(\op\()_safe_regs)
        CFI_STARTPROC
        pushl_cfi %ebx
        pushl_cfi %ebp
        pushl_cfi %esi
        pushl_cfi %edi

but

ENTRY(csum_partial)
        CFI_STARTPROC
        pushl_cfi %esi
        CFI_REL_OFFSET esi, 0
        pushl_cfi %ebx
        CFI_REL_OFFSET ebx, 0

We need an expert to enlighten us.
