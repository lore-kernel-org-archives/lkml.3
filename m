Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbaHFTbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:31:07 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46516 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbaHFTbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:31:05 -0400
MIME-Version: 1.0
Date: Wed, 6 Aug 2014 21:31:02 +0200
X-Google-Sender-Auth: 8dyZZjKDKEK_W2x_kB6FIq6oYpY
Message-ID: <CAMuHMdVPzkgJCPXBbFYc44T4JiyRN+r1nrcd0oPhW0vBy82LoQ@mail.gmail.com>
Subject: =?UTF-8?Q?dib7000p=5Fget=5Fstats=3A_=E2=80=98i=E2=80=99_is_used_uninitialized_=28w?=
	=?UTF-8?Q?as=3A_Re=3A_=5Bmedia=5D_dib7000p=3A_Add_DVBv5_stats_support=29?=
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wed, Aug 6, 2014 at 2:03 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=041ad449683bb2d54a7f082d78ec15bbc958a175
> Commit:     041ad449683bb2d54a7f082d78ec15bbc958a175
> Parent:     d44913c1e547df19b2dc0b527f92a4b4354be23a
> Refname:    refs/heads/master
> Author:     Mauro Carvalho Chehab <m.chehab@samsung.com>
> AuthorDate: Thu May 29 14:44:56 2014 -0300
> Committer:  Mauro Carvalho Chehab <m.chehab@samsung.com>
> CommitDate: Tue Jun 17 12:04:50 2014 -0300
>
>     [media] dib7000p: Add DVBv5 stats support
>
>     Adds DVBv5 stats support. For now, just mimic whatever dib8000
>     does, as they're very similar, with regards to statistics.
>
>     However, dib7000p_get_time_us() likely require some
>     adjustments, as I didn't actually reviewed the formula
>     for it to work with DVB-T. Still, better than nothing,
>     as latter patches can improve it.

Yes, it does, as its "layer" parameter is not used....

> diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> index d36fa0d..c41f90d 100644
> --- a/drivers/media/dvb-frontends/dib7000p.c
> +++ b/drivers/media/dvb-frontends/dib7000p.c

> +/* FIXME: may require changes - this one was borrowed from dib8000 */
> +static u32 dib7000p_get_time_us(struct dvb_frontend *demod, int layer)
> +{

[...]

> +}

> +static int dib7000p_get_stats(struct dvb_frontend *demod, fe_status_t stat)
> +{
> +       struct dib7000p_state *state = demod->demodulator_priv;
> +       struct dtv_frontend_properties *c = &demod->dtv_property_cache;
> +       int i;

[...]

> +       /* Get PER measures */
> +       if (show_per_stats) {
> +               dib7000p_read_unc_blocks(demod, &val);
> +
> +               c->block_error.stat[0].scale = FE_SCALE_COUNTER;
> +               c->block_error.stat[0].uvalue += val;
> +
> +               time_us = dib7000p_get_time_us(demod, i);

drivers/media/dvb-frontends/dib7000p.c: In function ‘dib7000p_get_stats’:
drivers/media/dvb-frontends/dib7000p.c:1972: warning: ‘i’ is used
uninitialized in this function

So far this is harmless, as the "layer" parameter isn't used, but this
deserves some cleanup.

> +               if (time_us) {
> +                       blocks = 1250000ULL * 1000000ULL;
> +                       do_div(blocks, time_us * 8 * 204);
> +                       c->block_count.stat[0].scale = FE_SCALE_COUNTER;
> +                       c->block_count.stat[0].uvalue += blocks;
> +               }
> +       }
> +       return 0;
> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
