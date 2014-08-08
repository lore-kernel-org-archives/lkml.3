Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaHHHVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:21:42 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:61689 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbaHHHVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvxi80hNNFwquvF6veX23m_ph1UC9m1onLK5eNjrzu5DKA@mail.gmail.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-17-git-send-email-lftan@altera.com>
	<CAFLxGvxi80hNNFwquvF6veX23m_ph1UC9m1onLK5eNjrzu5DKA@mail.gmail.com>
Date: Fri, 8 Aug 2014 15:21:36 +0800
X-Google-Sender-Auth: g_TZ3s9ZJ2Qv2Be8N2AMd8quFkg
Message-ID: <CAFiDJ599JbMv97GdEV6vyXQ4ThXb6n5VXn==+Zr-gEBm9gp7iQ@mail.gmail.com>
Subject: Re: [PATCH v2 16/29] nios2: Signal handling support
From: Ley Foon Tan <lftan@altera.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 4:04 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:

>> +
>> +#include <asm/ucontext.h>
>> +#include <asm/cacheflush.h>
>> +
>> +#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
>> +
>> +static int do_signal(struct pt_regs *regs, int in_syscall);
>
> Do you really need this prototype?
Yes, we don't need this. Will remove this.



>> +
>> +asmlinkage int do_rt_sigreturn(struct switch_stack *sw)
>> +{
>> +       struct pt_regs *regs = (struct pt_regs *)(sw + 1);
>> +       /* Verify, can we follow the stack back */
>> +       struct rt_sigframe *frame = (struct rt_sigframe *) regs->sp;
>> +       sigset_t set;
>> +       int rval;
>> +
>> +       if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
>> +               goto badframe;
>> +
>> +       if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
>> +               goto badframe;
>> +
>> +       sigdelsetmask(&set, ~_BLOCKABLE);
>> +       spin_lock_irq(&current->sighand->siglock);
>> +       current->blocked = set;
>> +       recalc_sigpending();
>> +       spin_unlock_irq(&current->sighand->siglock);
>
> Why aren't you using set_current_blocked() here?
Okay, will change to use set_current_blocked().

>> +static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
>> +                         struct pt_regs *regs)
>> +{
>> +       struct rt_sigframe *frame;
>> +       int err = 0;
>> +
>> +       frame = get_sigframe(ksig, regs, sizeof(*frame));
>> +
>> +       if (ksig->ka.sa.sa_flags & SA_SIGINFO)
>> +               err |= copy_siginfo_to_user(&frame->info, &ksig->info);
>> +
>> +       /* Create the ucontext.  */
>> +       err |= __put_user(0, &frame->uc.uc_flags);
>> +       err |= __put_user(0, &frame->uc.uc_link);
>> +       err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
>> +       err |= rt_setup_ucontext(&frame->uc, regs);
>> +       err |= copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
>
> You neither check nor propagate this error code.
Okay, will add error handling here.

Thanks.

Regards
Ley Foon
