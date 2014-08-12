Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaHLJuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:50:06 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:51823 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaHLJuF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Tue, 12 Aug 2014 05:50:05 -0400
Message-Id: <53E9FF6A020000780002B7B7@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Tue, 12 Aug 2014 10:50:02 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Denys Vlasenko" <dvlasenk@redhat.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "Kees Cook" <keescook@chromium.org>, "Will Drewry" <wad@chromium.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Denys Vlasenko" <vda.linux@googlemail.com>, "X86 ML" <x86@kernel.org>,
        "Alexei Starovoitov" <ast@plumgrid.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete
 "struct pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
 <20140801231929.GB26491@localhost.localdomain>
 <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com>
 <20140811004559.GA2656@lerouge>
 <53E89DA3020000780002B00B@mail.emea.novell.com>
 <53E8C476.8000800@redhat.com>
 <53E8EC9F020000780002B383@mail.emea.novell.com>
 <53E8D905.7030809@zytor.com>
 <53E8F87B020000780002B41D@mail.emea.novell.com>
 <53E8DD8D.3060500@zytor.com> <53E9DEDB.1080608@redhat.com>
In-Reply-To: <53E9DEDB.1080608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.08.14 at 11:31, <dvlasenk@redhat.com> wrote:
> Jan, Pater, does this look correct _and_ human-understandable?
> 
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -652,10 +652,14 @@ END(interrupt)
>         cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
>         CFI_DEF_CFA_REGISTER    rsi
>         pushq %rsi
> +       /*
> +        * For debugger:
> +        * "CFA (Current Frame Address) is the value on stack + offset"
> +        */
>         CFI_ESCAPE      0x0f /* DW_CFA_def_cfa_expression */, 6, \
> -                       0x77 /* DW_OP_breg7 */, 0, \
> +                       0x77 /* DW_OP_breg7 (rsp) */, 0, \

I'm fine with the changes above.

>                         0x06 /* DW_OP_deref */, \
> -                       0x08 /* DW_OP_const1u */, SS+8-RBP, \
> +                       0x08 /* DW_OP_const1u */, SIZEOF_PTREGS-RBP, \

But I'd rather not see this one alone changed - either change all
similar uses of SS, or leave the one here alone.

Jan

