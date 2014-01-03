Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaACRI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:08:28 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50985 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaACRI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:08:26 -0500
MIME-Version: 1.0
In-Reply-To: <201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
References: <1388507067.2259.24.camel@joe-AO722>
	<201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
	<1388555362.2259.38.camel@joe-AO722>
	<201401011902.JEF43770.FSOVFFOHOtQLJM@I-love.SAKURA.ne.jp>
	<1388626389.2259.57.camel@joe-AO722>
	<201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
Date: Fri, 3 Jan 2014 09:08:25 -0800
X-Google-Sender-Auth: eL_IbYXLDV0lDskvDfqnkRsL2J4
Message-ID: <CAGXu5jL7RunQuAw1MjnUMgWeYMX35+YcGeaZYCx6dhND3YUmsQ@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Kees Cook <keescook@chromium.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 1, 2014 at 8:49 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 2 Jan 2014 13:37:14 +0900
> Subject: [PATCH v3] lib/vsprintf: support built-in tokens
>
> The vast majority of ->comm accesses are accessing current->comm, for
> debug reasons. I'm counting 350-odd sites. At all these sites it's
> pointless passing `current' to the printk function at all!
>
> This patch introduces a set of vsprintf tokens for embedding globally visible
> arguments into the format string, so that we can reduce text size a bit (and
> in the future make reading of task_struct->comm consistent) by stop generating
> the code to pass an argument which the callee already has access to, with an
> assumption that currently we are not using the 0x1A byte within the format
> string.
>
> Some examples are shown below.
>
>   pr_info("comm=%s\n", current->comm);
>           => pr_info("comm=" EMBED_CURRENT_COMM "\n");
>
>   pr_info("pid=%d\n", current->pid);
>           => pr_info("pid=" EMBED_CURRENT_PID "\n");
>
>   pr_info("%s(%d)\n", current->comm, current->pid);
>           => pr_info(EMBED_CURRENT_COMM "(" EMBED_CURRENT_PID ")\n");
>
>   pr_info("[%-6.6s]\n", current->comm);
>           => pr_info(EMBED_FORMAT "-6.6" EMBED_CURRENT_COMM "\n");
>
> Since this patch does not use get_task_comm(), you should not convert from
> get_task_comm(current) to built-in tokens if you want constsistent reading.
>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  include/linux/kernel.h |   17 ++++++++
>  lib/vsprintf.c         |  101 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 116 insertions(+), 2 deletions(-)
> [...]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 10909c5..b05217d 100644
> @@ -1423,7 +1512,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
>         spec->type = FORMAT_TYPE_NONE;
>
>         for (; *fmt ; ++fmt) {
> -               if (*fmt == '%')
> +               if (*fmt == '%' || *fmt == 0x1A)
>                         break;
>         }
>

I'm on board with the idea of embedding comm/pid/whatever, but I
either missed or do not understand why a second format-start character
is being added. I think this will complicate audits and maybe trigger
weird info leaks (imagine printing a string that was %-escaped, but
not 0x1A-escaped?)

Why not use % followed by 0x1A to be the start code, instead of just 0x1A?

-Kees

-- 
Kees Cook
Chrome OS Security
