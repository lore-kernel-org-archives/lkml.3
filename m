Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313Ab3CMV7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:59:10 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41057 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab3CMV7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <1363164430-19118-3-git-send-email-kishon@ti.com>
References: <1363164430-19118-1-git-send-email-kishon@ti.com>
	<1363164430-19118-3-git-send-email-kishon@ti.com>
Date: Wed, 13 Mar 2013 23:59:07 +0200
Message-ID: <CANOLnOPG9Rbj=XNXtyeReoEzHpegSuZT0QKhEy7QdbVjO4OUPw@mail.gmail.com>
Subject: Re: [PATCH 2/5] usb: musb: omap: always glue have the correct vbus/id status
From: Grazvydas Ignotas <notasas@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 10:47 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> In the case where omap glue is loaded and musb core is not, glue->status
> wont have a valid status if the phy drivers call omap_musb_mailbox. So
> fixed the conditions here.

There already seems to be another patch named "usb: musb: omap2430:
fix omap_musb_mailbox glue check again" on it's way to mainline that
does mostly the same as first part of this patch.

>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/musb/omap2430.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index 78bfc50..28a0220 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -236,13 +236,10 @@ void omap_musb_mailbox(enum omap_musb_vbus_id_status status)
>  {
>         struct omap2430_glue    *glue = _glue;
>
> -       if (glue && glue_to_musb(glue)) {
> -               glue->status = status;
> -       } else {
> -               pr_err("%s: musb core is not yet ready\n", __func__);
> +       if (!glue)
>                 return;
> -       }
>
> +       glue->status = status;
>         schedule_work(&glue->omap_musb_mailbox_work);
>  }
>  EXPORT_SYMBOL_GPL(omap_musb_mailbox);
> @@ -307,7 +304,9 @@ static void omap_musb_mailbox_work(struct work_struct *mailbox_work)
>  {
>         struct omap2430_glue *glue = container_of(mailbox_work,
>                                 struct omap2430_glue, omap_musb_mailbox_work);
> -       omap_musb_set_mailbox(glue);
> +
> +       if (glue_to_musb(glue))
> +               omap_musb_set_mailbox(glue);
>  }
>
>  static irqreturn_t omap2430_musb_interrupt(int irq, void *__hci)
> --
> 1.7.10.4
>

-- 
Gražvydas
