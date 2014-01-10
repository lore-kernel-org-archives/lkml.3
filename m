Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaAJAJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:09:10 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:33826 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaAJAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:09:08 -0500
MIME-Version: 1.0
In-Reply-To: <1387816927-4313-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1387816927-4313-1-git-send-email-taras.kondratiuk@linaro.org>
Date: Thu, 9 Jan 2014 16:09:06 -0800
Message-ID: <CAA3XUr0A2jK0y-kfkpGE4mDNOCAhDi7AY0y9Fvmu5dgNygXXQQ@mail.gmail.com>
Subject: Re: [LNG] [PATCH] ARM: traps: fix opcode endianness when read from
 user memory
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taras, it looks good. Did you submit it into Russell's patch system? It
would be good to have this fix in main line tree.

Anyone, is there any concerns about this patch? It is quite simple
change.

Thanks,
Victor

On 23 December 2013 08:42, Taras Kondratiuk <taras.kondratiuk@linaro.org> wrote:
> Currently code has an inverted logic: opcode from user memory
> is swapped to a proper endianness only in case of read error.
> While normally opcode should be swapped only if it was read
> correctly from user memory.
>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---
>  arch/arm/kernel/traps.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 7940241..36a844e 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -425,9 +425,10 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
>                         instr2 = __mem_to_opcode_thumb16(instr2);
>                         instr = __opcode_thumb32_compose(instr, instr2);
>                 }
> -       } else if (get_user(instr, (u32 __user *)pc)) {
> +       } else {
> +               if (get_user(instr, (u32 __user *)pc))
> +                       goto die_sig;
>                 instr = __mem_to_opcode_arm(instr);
> -               goto die_sig;
>         }
>
>         if (call_undef_hook(regs, instr) == 0)
> --
> 1.7.9.5
>
> --
> You received this message because you are subscribed to the Google Groups "Linaro Networking" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linaro-networking+unsubscribe@linaro.org.
> To post to this group, send email to linaro-networking@linaro.org.
