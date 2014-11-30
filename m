Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaK3QcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:32:23 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43547 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaK3QcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:32:22 -0500
MIME-Version: 1.0
In-Reply-To: <1417316668-23538-1-git-send-email-xerofoify@gmail.com>
References: <1417316668-23538-1-git-send-email-xerofoify@gmail.com>
Date: Sun, 30 Nov 2014 11:32:21 -0500
X-Google-Sender-Auth: xYxhkTOr0PZgy2arZp22Z3i06A0
Message-ID: <CAOcJUbyjmUGOiAAQTc=O9OMk7vw8A6sYQg9svKNVw_zCyt5Jcg@mail.gmail.com>
Subject: Re: [PATCH] drivers:media: Add proper sanity checking for register
 setting to variable in lg2160.c
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 10:04 PM, Nicholas Krause <xerofoify@gmail.com> wrote:
> Fixs issue with setting the variable value of val in the functionm,lg2161_set_output_interface
> and not sanity checking if the value has been correctly set with the correct value of the struct
> state of type lg216x_state passed to the function by the calling code.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/media/dvb-frontends/lg2160.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
> index 5fd14f8..9aec63a 100644
> --- a/drivers/media/dvb-frontends/lg2160.c
> +++ b/drivers/media/dvb-frontends/lg2160.c
> @@ -459,7 +459,9 @@ static int lg2161_set_output_interface(struct lg216x_state *state)
>                 goto fail;
>
>         val &= ~0x07;
> -       val |= state->cfg->output_if; /* FIXME: needs sanity check */
> +       val |= state->cfg->output_if;
> +       if (lg_fail(val))
> +               goto fail;
>
>         ret = lg216x_write_reg(state, 0x0014, val);
>         lg_fail(ret);
> --
> 2.1.0
>


NACK.

Thank you for the patch, Nicholas, but the change that you propose
won't actually help here -- val is a u8, and the lg_fail() macro tests
for negative values.  val can never be negative, and that's why I
didn't add the "lg_fail()" test myself when I wrote this function.

What's actually happening in this function is that the value is first
set when reading register 0014, we take that value, unset the three
lowest bits, then we raise the bits in state->cfg->output_if, and
write it back to the same register.

In fact, the FIXME comment should be removed -- this is not a bug
anymore and the sanity check is built-in.  That FIXME comment is a
remnant of an older version of this function :-P

If you want to send a patch that just removes the FIXME comment, that
would be accepted, but this patch should not be merged.

Cheers,

Michael Ira Krufky
