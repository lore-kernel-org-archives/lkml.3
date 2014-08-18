Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaHRIiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:38:09 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:57705 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaHRIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:38:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140818082039.GA31171@ulmo>
References: <1407943133-18170-1-git-send-email-geert+renesas@glider.be>
	<20140818082039.GA31171@ulmo>
Date: Mon, 18 Aug 2014 10:38:00 +0200
X-Google-Sender-Auth: d_sNgc2rhcDLgQUgbcjIJSvjNJ8
Message-ID: <CAMuHMdVLA4xRGKrsyGTokZvRWkNAFyNv+_JycavfpibO8GXkkQ@mail.gmail.com>
Subject: Re: [PATCH] pwm: Fix period and polarity in pwm_get() for non-perfect matches
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-pwm@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, Aug 18, 2014 at 10:20 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> Could we achieve the same by storing a pointer to the best match and
> then use that instead of p? Perhaps something like this:
>
>         struct pwm_lookup *entry;
>
>         ...
>
>                 if (match > best) {
>                         chip = pwmchip_find_by_name(p->provider);
>                         entry = p;
>
>                         if (match != 3)
>                                 best = match;
>                         else
>                                 break;
>                 }
>
>         ...
>
>         if (chip)
>                 pwm = pwm_request_from_chip(chip, entry->index,
>                                             con_id ?: dev_id);
>         if (IS_ERR(pwm))
>                 return pwm;
>
>         pwm_set_period(pwm, entry->period);
>         pwm_set_polarity(pwm, entry->polarity);
>
> ?

That's possible. But that will add complexity, as you have to move the
"mutex_unlock(&pwm_lookup_lock);" after the last user of "entry" again,
and add a goto for the IS_ERR(pwm) case.
So I'm not sure it's worth the effort.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
