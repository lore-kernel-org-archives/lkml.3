Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaF3MV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:21:27 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:44816 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaF3MVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:21:24 -0400
MIME-Version: 1.0
In-Reply-To: <1404100934-7490-1-git-send-email-xerofoify@gmail.com>
References: <1404100934-7490-1-git-send-email-xerofoify@gmail.com>
Date: Mon, 30 Jun 2014 08:21:24 -0400
X-Google-Sender-Auth: E6rAWhVpyP74IAI5ChMTp8vxU7o
Message-ID: <CA+5PVA7WOiSBSzZZ=H19X7KdUAZJWhe8Fm=sHzsXOgeVz7Po=g@mail.gmail.com>
Subject: Re: [PATCH] Fixes return issues in uic_init_one
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: paulus <paulus@samba.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 12:02 AM, Nicholas Krause <xerofoify@gmail.com> wrote:
> This patch fixes the FIXME messages for returning a ENOMEM error
> if uic is not allocated and if uic->irqhost is not allocated a
> IRQ domain that is linear returns EIO.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

NAK.

You didn't actually fix anything here.  In fact, you changed the
semantics of what uic_init_one returns and the function that calls
doesn't change for negative return codes.  You also didn't do similar
changes for the rest of the error conditions in within the same
function, making it inconsistent with itself.

NULL is the appropriate return for errors in this function.  The FIXME
about panicing is because without a UIC, the boards can't service
interrupts at all.  A board that doesn't work might as well panic, but
that panic is actually done in uic_init_tree appropriately.  If you're
going to change anything, just remove the comment.

josh

> ---
>  arch/powerpc/sysdev/uic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
> index 9203393..f95010a 100644
> --- a/arch/powerpc/sysdev/uic.c
> +++ b/arch/powerpc/sysdev/uic.c
> @@ -239,7 +239,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
>
>         uic = kzalloc(sizeof(*uic), GFP_KERNEL);
>         if (! uic)
> -               return NULL; /* FIXME: panic? */
> +               return -ENOMEM;
>
>         raw_spin_lock_init(&uic->lock);
>         indexp = of_get_property(node, "cell-index", &len);
> @@ -261,7 +261,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
>         uic->irqhost = irq_domain_add_linear(node, NR_UIC_INTS, &uic_host_ops,
>                                              uic);
>         if (! uic->irqhost)
> -               return NULL; /* FIXME: panic? */
> +               return -EIO;
>
>         /* Start with all interrupts disabled, level and non-critical */
>         mtdcr(uic->dcrbase + UIC_ER, 0);
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
