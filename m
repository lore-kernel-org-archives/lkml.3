Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3LIG22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:28:28 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41203 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3LIG21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:28:27 -0500
MIME-Version: 1.0
In-Reply-To: <1386567251-22751-10-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-10-git-send-email-namhyung@kernel.org>
Date: Mon, 9 Dec 2013 01:28:26 -0500
X-Google-Sender-Auth: WpN_cl_ocoqXRJGCICL4h-1BRhY
Message-ID: <CAKb7Uvhhg2siBURLxTb2jgW_-5AUeK_yqRpEJgi0HW12zQTMyg@mail.gmail.com>
Subject: Re: [PATCH 09/14] tools lib traceevent: Get rid of die() in add_right()
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 12:34 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/parse-filter.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index 5efe66a682bd..a1ad609a860f 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -583,12 +583,18 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
>                         op->str.type = op_type;
>                         op->str.field = left->field.field;
>                         op->str.val = strdup(str);
> -                       if (!op->str.val)
> -                               die("malloc string");
> +                       if (!op->str.val) {
> +                               show_error(error_str, "Failed to allocate string filter");
> +                               return -1;
> +                       }
>                         /*
>                          * Need a buffer to copy data for tests
>                          */
> -                       op->str.buffer = malloc_or_die(op->str.field->size + 1);
> +                       op->str.buffer = malloc(op->str.field->size + 1);
> +                       if (op->str.buffer) {

That should probably be

if (!op->str.buffer)

Also, should you free op->str.val? Perhaps the surrounding code takes
care of that.

> +                               show_error(error_str, "Failed to allocate string filter");
> +                               return -1;
> +                       }
>                         /* Null terminate this buffer */
>                         op->str.buffer[op->str.field->size] = 0;
>
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
