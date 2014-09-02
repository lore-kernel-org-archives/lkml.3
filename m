Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaIBFBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 01:01:49 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:45142 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaIBFBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 01:01:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140825180806.GA22193@redhat.com>
References: <20140822171142.GA14812@redhat.com>
	<20140825180806.GA22193@redhat.com>
Date: Mon, 1 Sep 2014 22:01:46 -0700
Message-ID: <CALmL7E_5Tn7s5Bd03nRiec8LkmMfpyMOh_Rp8BHK2BjitzHc4A@mail.gmail.com>
Subject: Re: [PATCH] x86, fpu: __restore_xstate_sig()->math_state_restore()
 needs preempt_disable()
From: Suresh Siddha <sbsiddha@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 11:08 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Add preempt_disable() + preempt_enable() around math_state_restore() in
> __restore_xstate_sig(). Otherwise __switch_to() after __thread_fpu_begin()
> can overwrite fpu->state we are going to restore.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/xsave.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index 453343c..c52eb9c 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -397,8 +397,11 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
>                         set_used_math();
>                 }
>
> -               if (use_eager_fpu())
> +               if (use_eager_fpu()) {
> +                       preempt_disable();
>                         math_state_restore();
> +                       preempt_enable();
> +               }
>
>                 return err;
>         } else {
>

oops. looks good to me.

Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
