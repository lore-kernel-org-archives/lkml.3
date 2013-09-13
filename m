Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3IMMD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:03:28 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55388 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3IMMDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130913080539.GG19211@elgon.mountain>
References: <20130913080539.GG19211@elgon.mountain>
Date: Fri, 13 Sep 2013 14:03:23 +0200
X-Google-Sender-Auth: SbRZMduZcUu8y85RgMdJ9ZSt1u4
Message-ID: <CAMuHMdX88cUEu2dmamEttK=9Lv0TKiZauCtPDLbgKUde+8ufyQ@mail.gmail.com>
Subject: Re: [patch 3/4] skd: use strncpy() as a cleanup
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:05 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> The code here is copying the version to inq.driver_version but we don't
> want it to be NUL terminated.  Instead we pad the rest of the array with
> spaces.  It's fewer lines to use strncpy() and maybe a little nicer.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
> index f892d95..20ad843 100644
> --- a/drivers/block/skd_main.c
> +++ b/drivers/block/skd_main.c
> @@ -2899,9 +2899,7 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
>                                volatile struct fit_comp_error_info *skerr,
>                                uint8_t *cdb, uint8_t *buf)
>  {
> -       unsigned ver_byte;
>         unsigned max_bytes;
> -       char *ver = DRV_VER_COMPL;
>         struct driver_inquiry_data inq;
>         u16 val;
>
> @@ -2945,12 +2943,8 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
>         /* Driver version, fixed lenth, padded with spaces on the right */
>         inq.driver_version_length = sizeof(inq.driver_version);
>         memset(&inq.driver_version, ' ', sizeof(inq.driver_version));
> -       for (ver_byte = 0; ver_byte < sizeof(inq.driver_version); ver_byte++) {
> -               if (ver[ver_byte] != 0)
> -                       inq.driver_version[ver_byte] = ver[ver_byte];
> -               else
> -                       break;
> -       }
> +       strncpy(inq.driver_version, DRV_VER_COMPL,
> +               min(sizeof(inq.driver_version), strlen(DRV_VER_COMPL)));

This does the exact same thing as memcpy(), right? So why not use that?
memcpy() has much simpler semantics than strncpy().

>         inq.page_length = cpu_to_be16((sizeof(inq) - 4));

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
