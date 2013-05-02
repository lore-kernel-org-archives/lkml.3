Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3EBHnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:43:31 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62010 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3EBHn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <1367429751.30667.99.camel@gandalf.local.home>
References: <1367429751.30667.99.camel@gandalf.local.home>
Date: Thu, 2 May 2013 09:43:27 +0200
X-Google-Sender-Auth: s33n7UluVxuNBXxd0HkQolNiFho
Message-ID: <CAMuHMdXguZknoR=A6Cpqoz4VYX6wuPtUWfV4yGhkBiGMQOdaYg@mail.gmail.com>
Subject: Re: [PATCH v2] init: Do not warn on non-zero initcall return
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 7:35 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Commit f91eb62f71 "init: scream bloody murder if interrupts are enabled
> too early" added three new warnings. The first two seemed reasonable,
> but the third included a warning when an initcall returned non-zero.
> Although, the third WARN() does include an imbalanced preempt disabled,
> or irqs disable, it shouldn't warn if it only had an initcall that just
> returns non-zero.
>
> In fact, according to Linus, it shouldn't print at all. As it only
> prints with initcall_debug set, and that already shows enough
> information to fix things.
>
> Link: http://lkml.kernel.org/r/CA+55aFzaBC5SFi7=F2mfm+KWY5qTsBmOqgbbs8E+LUS8JK-sBg@mail.gmail.com
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/init/main.c b/init/main.c
> index bea1287..ceed17a 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -686,11 +686,8 @@ int __init_or_module do_one_initcall(initcall_t fn)
>
>         msgbuf[0] = 0;
>
> -       if (ret && ret != -ENODEV && initcall_debug)
> -               sprintf(msgbuf, "error code %d ", ret);
> -
>         if (preempt_count() != count) {
> -               strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
> +               sprintf(msgbuf, "preemption imbalance ");

snprintf(), please?

JFYI, the v3.9 version already used up all of msgbuf[] in the
worst-case scenario,
and it did have the strlcat() as a parachute:

$ echo -n "error code 1234567890 preemption imbalance disabled
interrupts " | wc -c
63
$

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
