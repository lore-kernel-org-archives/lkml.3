Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaF1RAD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:00:03 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:60306 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaF1Q77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 12:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <1402996306-6811-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1402996306-6811-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1402996306-6811-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Sat, 28 Jun 2014 09:59:58 -0700
X-Google-Sender-Auth: 52I51FBOPV3XGGNZ1QNyWrgg8nY
Message-ID: <CANeU7QnLad1f4KkLpTGSWB8eD8_La-tACim6rR7DLQ=hggwhOQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] lib.c: skip --param parameters
From: Christopher Li <sparse@chrisli.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I just click send before I type up the reply. Here we go again.

On Tue, Jun 17, 2014 at 2:11 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Very dumb patch to just skip --param allow-store-data-races=0 introduced in
> newer GCC versions.
>
> +static char **handle_param(char *arg, char **next)
> +{
> +       const char *value = NULL;
> +
> +       /* For now just skip any '--param=*' or '--param *' */
> +       value = split_value_from_arg(arg, value);
> +       if (!value)
> +               ++next;
> +
> +       return ++next;
> +}

I think this is problematic.There are three possible input
from args:
1) "--parm", you need to ++next skip to next arg, which is the value for parm.
2) "--parm=x",  you don't need to skip to next arg.
3) "--parm-with-crap", invalid argument. You don't need to skip next arg.

I think the patch is wrong on case 2) and case 3).
In case 2), the patch skip two arguments and make next point
points to out of bound memory.

The split_value_from_arg function is not a good abstraction for this job.
Its return value can only indicate 2 possible out come.
Also, returning the default value force the test against the input
default value. That make the logic a bit complicate.

>  struct switches {
>         const char *name;
>         char **(*fn)(char *, char **);
> @@ -686,13 +698,14 @@ struct switches {
>  static char **handle_long_options(char *arg, char **next)
>  {
>         static struct switches cmd[] = {
> +               { "param", handle_param },
>                 { "version", handle_version },
>                 { NULL, NULL }
>         };
>         struct switches *s = cmd;
>
>         while (s->name) {
> -               if (!strcmp(s->name, arg))
> +               if (!strncmp(arg, s->name, strlen(s->name)))

This will allow "--version-with-crap" as valid arguments.

I think we can have one extra member in "struct switch"
to indicate this option is a prefix rather than a whole word.
For "parm", it need to set that prefix member to non zero.

Please let me know if there is a V3 coming.

Chris
