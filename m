Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3EPWXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:23:47 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39344 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3EPWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <1368731067-31404-4-git-send-email-cminyard@mvista.com>
References: <1368731067-31404-1-git-send-email-cminyard@mvista.com> <1368731067-31404-4-git-send-email-cminyard@mvista.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 May 2013 15:23:24 -0700
Message-ID: <CALCETrXu2At7pRWReYpdFa6OgY79M4KiEKXR=beH+5FcTOL6zg@mail.gmail.com>
Subject: Re: [PATCH 3/4] ipmi: Improve error messages on failed irq enable
To: Corey Minyard <cminyard@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 12:04 PM, Corey Minyard <cminyard@mvista.com> wrote:
> When the interrupt enable message returns an error, the messages are
> not entirely accurate nor helpful.  So improve them.
>
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> ---
>  drivers/char/ipmi/ipmi_si_intf.c |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 313538a..af4b23f 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -663,8 +663,10 @@ static void handle_transaction_done(struct smi_info *smi_info)
>                 /* We got the flags from the SMI, now handle them. */
>                 smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
>                 if (msg[2] != 0) {
> -                       dev_warn(smi_info->dev, "Could not enable interrupts"
> -                                ", failed get, using polled mode.\n");
> +                       dev_warn(smi_info->dev,
> +                                "Couldn't get irq info: %x.\n", msg[2]);
> +                       dev_warn(smi_info->dev,
> +                                "Maybe ok, but ipmi might run very slowly.\n");
>                         smi_info->si_state = SI_NORMAL;
>                 } else {
>                         msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
> @@ -685,10 +687,12 @@ static void handle_transaction_done(struct smi_info *smi_info)
>
>                 /* We got the flags from the SMI, now handle them. */
>                 smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
> -               if (msg[2] != 0)
> -                       dev_warn(smi_info->dev, "Could not enable interrupts"
> -                                ", failed set, using polled mode.\n");
> -               else
> +               if (msg[2] != 0) {
> +                       dev_warn(smi_info->dev,
> +                                "Couldn't set irq info: %x.\n", msg[2]);
> +                       dev_warn(smi_info->dev,
> +                                "Maybe ok, but ipmi might run very slowly.\n");
> +               } else

Minor nit: it would be nice if these warnings were collapsed into a
single printk -- that would save me a whitelist entry of acceptable
KERN_WARNING messages :)

My Dell 12g server says:

[97627.407724] ipmi_si ipmi_si.0: Using irq 10
[97627.421369] ipmi_si ipmi_si.0: Couldn't set irq info: cc.
[97627.427389] ipmi_si ipmi_si.0: Maybe ok, but ipmi might run very slowly.

Tested-by: Andy Lutomirski <luto@amacapital.net>

--Andy
