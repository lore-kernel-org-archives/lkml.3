Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbaFSQei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:34:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42173 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709AbaFSQef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <1403189380-25134-1-git-send-email-xypron.glpk@gmx.de>
References: <CAGXu5jLJGpPhycff9OSMGu6wduLGQWhsu2mkGeM7R0O9CQZ7pg@mail.gmail.com>
	<1403189380-25134-1-git-send-email-xypron.glpk@gmx.de>
Date: Thu, 19 Jun 2014 09:34:34 -0700
X-Google-Sender-Auth: TGzjywoJnfZfolFtfAlq7TtNJfE
Message-ID: <CAGXu5jJCqJpAX0gbyK+GOW2fntr7LTEGHxhEk-dEQrhi9oSX4w@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] media: dib9000: avoid out of bound access
From: Kees Cook <keescook@chromium.org>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 7:49 AM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> This updated patch also fixes out of bound access to b[].
>
> In dib9000_risc_apb_access_write() an out of bound access to mb[].
>
> The current test to avoid out of bound access to mb[] is insufficient.
> For len = 19 non-existent mb[10] will be accessed.
>
> For odd values of len b[] is accessed out of bounds.
>
> For large values of len an of bound access to mb[] may occur in
> dib9000_mbx_send_attr.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  drivers/media/dvb-frontends/dib9000.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
> index e540cfb..f75dec4 100644
> --- a/drivers/media/dvb-frontends/dib9000.c
> +++ b/drivers/media/dvb-frontends/dib9000.c
> @@ -1040,13 +1040,18 @@ static int dib9000_risc_apb_access_write(struct dib9000_state *state, u32 addres
>         if (address >= 1024 || !state->platform.risc.fw_is_running)
>                 return -EINVAL;
>
> +       if (len > 18)
> +               return -EINVAL;
> +
>         /* dprintk( "APB access thru wr fw %d %x", address, attribute); */
>
> -       mb[0] = (unsigned short)address;
> -       for (i = 0; i < len && i < 20; i += 2)
> -               mb[1 + (i / 2)] = (b[i] << 8 | b[i + 1]);
> +       mb[0] = (u16)address;
> +       for (i = 0; i + 1 < len; i += 2)
> +               mb[1 + i / 2] = b[i] << 8 | b[i + 1];
> +       if (len & 1)
> +               mb[1 + len / 2] = b[len - 1] << 8;
>
> -       dib9000_mbx_send_attr(state, OUT_MSG_BRIDGE_APB_W, mb, 1 + len / 2, attribute);
> +       dib9000_mbx_send_attr(state, OUT_MSG_BRIDGE_APB_W, mb, (3 + len) / 2, attribute);
>         return dib9000_mbx_get_message_attr(state, IN_MSG_END_BRIDGE_APB_RW, mb, &s, attribute) == 1 ? 0 : -EINVAL;
>  }
>
> --
> 2.0.0
>

That looks great, thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees


-- 
Kees Cook
Chrome OS Security
