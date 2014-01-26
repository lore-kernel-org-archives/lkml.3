Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaAZK2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:28:39 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35289 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaAZK2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:28:37 -0500
MIME-Version: 1.0
Date: Sun, 26 Jan 2014 11:28:36 +0100
X-Google-Sender-Auth: vEOIjm1jeOrjPPm2L-oyTsZT_tc
Message-ID: <CAMuHMdVh7HMHCH1ZCABck97GVux0ca09rX=7rqTwPdDzN6uv0w@mail.gmail.com>
Subject: =?UTF-8?Q?Staging=3A_dgrp=3A_warning=3A_=E2=80=98buf=E2=80=99_is_used_uninitiali?=
	=?UTF-8?Q?zed_=28Was=3A_Re=3A_Staging=3A_dgrp=3A_Refactor_the_function_dgrp=5Frece?=
	=?UTF-8?Q?ive=28=29_in_drrp=5Fnet=5Fops=2Ec=29?=
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 1:21 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
>     Staging: dgrp: Refactor the function dgrp_receive() in drrp_net_ops.c
>
>     The function dgrp_receive() in dgrp_net_ops.c is too long and can be
>     refactored. It uses various switch statements and goto labels. I have
>     removed a label called data and tried to extract a new function out of
>     it called as handle_data_in_packet().
>
>     This helps to make the code more modularize and simple to read and
>     understand.
>
>     Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/dgrp/dgrp_net_ops.c |  330 ++++++++++++++++++----------------
>  1 files changed, 175 insertions(+), 155 deletions(-)
>
> diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
> index 33ac7fb..1f61b89 100644
> --- a/drivers/staging/dgrp/dgrp_net_ops.c
> +++ b/drivers/staging/dgrp/dgrp_net_ops.c
> @@ -2232,6 +2232,177 @@ done:
>         return rtn;
>  }
>
> +/*
> + * Common Packet Handling code
> + */
> +
> +static void handle_data_in_packet(struct nd_struct *nd, struct ch_struct *ch,
> +                                 long dlen, long plen, int n1, u8 *dbuf)
> +{
> +       char *error;
> +       long n;
> +       long remain;
> +       u8 *buf;

> +       if (remain < plen) {
> +               dlen = plen - remain;
> +               b = buf;

drivers/staging/dgrp/dgrp_net_ops.c: In function ‘handle_data_in_packet’:
drivers/staging/dgrp/dgrp_net_ops.c:2392: warning: ‘buf’ is used
uninitialized in this function

buf is never set in this function.

It is set to nd->nd_iobuf in dgrp_receive(), but this is never passed to
handle_data_in_packet().

> +
> +               b[0] = 0x90 + n1;
> +               put_unaligned_be16(dlen, b + 1);
> +
> +               remain = 3;
> +               if (remain > 0 && b != buf)
> +                       memcpy(buf, b, remain);
> +
> +               nd->nd_remain = remain;
> +               return;
> +       }
> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
