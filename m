Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaKLPnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:43:20 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46169 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaKLPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:43:19 -0500
Message-ID: <5463800C.8050404@gmail.com>
Date: Wed, 12 Nov 2014 23:43:08 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jeff Epler <jepler@unpythonic.net>
CC: cmetcalf@tilera.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: kernel: kgdb.c: Use memcpy() instead of pointer
 copy one by one
References: <5454DD70.6060004@gmail.com> <5462C1D3.3010504@gmail.com> <20141112132741.GA53560@unpythonic.net>
In-Reply-To: <20141112132741.GA53560@unpythonic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 09:27 PM, Jeff Epler wrote:
> It seems there's additional background required to understand the
> diagnostic:
> 
> asm/ptrace.h has
>     struct pt_regs {
>         /* tp, sp, and lr must immediately follow regs[] for aliasing. */
>         pt_reg_t regs[53];
>         pt_reg_t tp;            /* aliases regs[TREG_TP] */
>         pt_reg_t sp;            /* aliases regs[TREG_SP] */
>         pt_reg_t lr;            /* aliases regs[TREG_LR] */
> and the intended copy overwites all of regs[], plus tp, sp, and lr.
> 
> It's intended for thread_regs.regs[TREG_TP] to alias to thread_regs.tp,
> though in C this is undefined behavior (it dereferences a pointer past
> the end of the structure).

Yeah.

>>>   arch/tile/kernel/kgdb.c:140:31: warning: iteration 53u invokes undefined behavior [-Waggressive-loop-optimizations]
>>>      *(ptr++) = thread_regs->regs[reg];
> 
> If compilers are beginning to exploit the rule that indexing past the
> end of an array is UB, then the way that these register aliases are
> created may need to be revisited with careful attention to what the C
> standard actually says; I'm just going by memory.

"thread_regs.tp" and "TREG_SP" (not "TREG_TP") are all used, at present.
For me, both of them can let code readable and clearer, and they are not
conflict (variable let address clearer, macro let index clearer).

So for me, only "memcpy() instead of 'for' looping" is engough. Not
consider about compiler's warning, memcpy() can get a little higher
performance and simple code.

>                                                       (I assume the
> compiler could do things like replace an intended load from memory with
> a constant load or even no load at all)
> 

Excuse me, my English is not quite well, I can not understand what you
said above. (If necessary, please help provide more details for it).

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
