Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaKQNsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:48:51 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52667 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaKQNst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:48:49 -0500
MIME-Version: 1.0
In-Reply-To: <2a3a5417-48fb-4d4f-a410-566783d2283c@EXC01-ATKLA.omicron.at>
References: <2a3a5417-48fb-4d4f-a410-566783d2283c@EXC01-ATKLA.omicron.at>
Date: Mon, 17 Nov 2014 14:48:48 +0100
X-Google-Sender-Auth: EtPOuUmGHXY5CaQtZP3UJb0PjLQ
Message-ID: <CABkLObqwPdXMkFmZvS-mGEDtiFZgsGkYWA+JrT1xPxT9=+tZqQ@mail.gmail.com>
Subject: Re: [RFC PATCH] n_tty: Add memory barriers where required for
 lock-less circular buffer
From: Christian Riesch <christian.riesch@omicron.at>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Christian Riesch <christian.riesch@omicron.at>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 1:27 PM, Christian Riesch
<christian.riesch@omicron.at> wrote:
> Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
> Cc: Peter Hurley <peter@hurleysoftware.com>
[...]

> [2] https://lkml.org/lkml/2014/11/11/77

Uupps, [2] should point to https://lkml.org/lkml/2014/11/13/1 instead.
v3 instead of v2. Sorry.

>
>  drivers/tty/n_tty.c |   93 +++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 64 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 47ca0f3..656d868 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c

[...]

> @@ -165,14 +180,18 @@ static int receive_room(struct tty_struct *tty)
>  {
>         struct n_tty_data *ldata = tty->disc_data;
>         int left;
> +       size_t head, tail;
> +
> +       head = ldata->read_head;
> +       tail = ACCESS_ONCE(ldata->read_tail);

I just noticed that this is probably wrong, since receive_room is
called from both the consumer and producer paths.

>
>         if (I_PARMRK(tty)) {
> -               /* Multiply read_cnt by 3, since each byte might take up to
> -                * three times as many spaces when PARMRK is set (depending on
> -                * its flags, e.g. parity error). */
> -               left = N_TTY_BUF_SIZE - read_cnt(ldata) * 3 - 1;

BTW does this make sense? When the data is in the buffer, it is
already expanded by the PARMRK feature. Only new data could be
expanded by a factor of 3 when PARMRK is set.
Shouldn't that be (N_TTY_BUF_SIZE - read_cnt(ldata) - 1)/3 ?

Regards, Christian
