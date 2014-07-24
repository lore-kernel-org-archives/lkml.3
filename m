Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbaGXGzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:55:07 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:35715 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbaGXGzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:55:03 -0400
MIME-Version: 1.0
In-Reply-To: <1405951409-16953-32-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
	<1405951409-16953-32-git-send-email-richard@sigma-star.at>
Date: Thu, 24 Jul 2014 14:55:02 +0800
Message-ID: <CAMk6uBky=Bbz8nHqDK0ENaBbWQ3QrdRNV7rcXdGb-WJ+59a64Q@mail.gmail.com>
Subject: Re: [PATCH 31/43] blackfin: Use sigsp()
From: Steven Miao <realmz6@gmail.com>
To: Richard Weinberger <richard@sigma-star.at>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        bfin <adi-buildroot-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Steven Miao <realmz6@gmail.com>

Thanks.

On Mon, Jul 21, 2014 at 10:03 PM, Richard Weinberger
<richard@sigma-star.at> wrote:
> From: Richard Weinberger <richard@nod.at>
>
> Use sigsp() instead of the open coded variant.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/blackfin/kernel/signal.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
> index 1389cd3..ef27557 100644
> --- a/arch/blackfin/kernel/signal.c
> +++ b/arch/blackfin/kernel/signal.c
> @@ -135,19 +135,11 @@ static inline int rt_setup_sigcontext(struct sigcontext *sc, struct pt_regs *reg
>         return err;
>  }
>
> -static inline void *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
> +static inline void *get_sigframe(struct ksignal *ksig,
>                                  size_t frame_size)
>  {
> -       unsigned long usp;
> +       unsigned long usp = sigsp(rdusp(), ksig);
>
> -       /* Default to using normal stack.  */
> -       usp = rdusp();
> -
> -       /* This is the X/Open sanctioned signal stack switching.  */
> -       if (ka->sa.sa_flags & SA_ONSTACK) {
> -               if (!on_sig_stack(usp))
> -                       usp = current->sas_ss_sp + current->sas_ss_size;
> -       }
>         return (void *)((usp - frame_size) & -8UL);
>  }
>
> @@ -157,7 +149,7 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
>         struct rt_sigframe *frame;
>         int err = 0;
>
> -       frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
> +       frame = get_sigframe(ksig, sizeof(*frame));
>
>         err |= __put_user((current_thread_info()->exec_domain
>                            && current_thread_info()->exec_domain->signal_invmap
> --
> 1.8.4.5
>
