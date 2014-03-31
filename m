Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaCaM4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:56:10 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35708 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaCaM4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:56:08 -0400
MIME-Version: 1.0
In-Reply-To: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
Date: Mon, 31 Mar 2014 14:56:07 +0200
Message-ID: <CAOMGZ=FmOPcL=d3POVM=VEA1Wu-ojUFqJuQ5KxgKB-iPfk1aiA@mail.gmail.com>
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
From: Vegard Nossum <vegard.nossum@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2014 11:56, Vegard Nossum <vegard.nossum@oracle.com> wrote:
> Both the in-kernel and BSD strlcpy() require that the source string is
> NUL terminated. We could use strncpy() + explicitly terminate the result,
> but this relies on src and dest having the same size, so the safest thing
> to do seems to explicitly terminate the source string before doing the
> strlcpy().
>
> Fixes: f9a23c84486ed35 ("isdnloop: use strlcpy() instead of strcpy()")
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  drivers/isdn/isdnloop/isdnloop.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
> index 02125e6..50cd348 100644
> --- a/drivers/isdn/isdnloop/isdnloop.c
> +++ b/drivers/isdn/isdnloop/isdnloop.c
> @@ -1070,6 +1070,14 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
>                 return -EBUSY;
>         if (copy_from_user((char *) &sdef, (char *) sdefp, sizeof(sdef)))
>                 return -EFAULT;
> +
> +       /*
> +        * Null terminate strings from userspace so we don't have to worry
> +        * about this later on.
> +        */
> +       for (i = 0; i < 3; i++)
> +               sdef.num[i][sizeof(sdef.num[0]) - 1] = '\0';
> +
>         spin_lock_irqsave(&card->isdnloop_lock, flags);
>         switch (sdef.ptype) {
>         case ISDN_PTYPE_EURO:

Ping, Dave? Just making sure this doesn't fall through the cracks. I
don't see the patch applied anywhere yet and without this patch we
still have a valid security concern IMO.


Vegard
