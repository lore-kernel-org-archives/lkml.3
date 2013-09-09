Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3IIDCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:02:20 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54586 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3IIDCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:02:18 -0400
MIME-Version: 1.0
In-Reply-To: <1378693159-8747-4-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-1-git-send-email-davidlohr@hp.com> <1378693159-8747-4-git-send-email-davidlohr@hp.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 08:31:38 +0530
Message-ID: <CALkWK0=MXws8DQKyynRwi02P3Hb83iJGzE16UmJ3rPzWqGS3UQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] perf lock: plug some memleaks
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso wrote:
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index d318862..7784347 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -321,10 +321,12 @@ static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
>
>         new->addr = addr;
>         new->name = zalloc(sizeof(char) * strlen(name) + 1);
> -       if (!new->name)
> +       if (!new->name) {
> +               free(new);
>                 goto alloc_failed;
> -       strcpy(new->name, name);
> +       }

Why is the strcpy() missing indent?

> +       strcpy(new->name, name);
>         new->wait_time_min = ULLONG_MAX;
>
>         list_add(&new->hash_entry, entry);
> @@ -875,7 +877,7 @@ static int __cmd_record(int argc, const char **argv)
>         const char *record_args[] = {
>                 "record", "-R", "-m", "1024", "-c", "1",
>         };
> -       unsigned int rec_argc, i, j;
> +       unsigned int rec_argc, i, j, ret;
>         const char **rec_argv;
>
>         for (i = 0; i < ARRAY_SIZE(lock_tracepoints); i++) {
> @@ -892,7 +894,7 @@ static int __cmd_record(int argc, const char **argv)
>         rec_argc += 2 * ARRAY_SIZE(lock_tracepoints);
>
>         rec_argv = calloc(rec_argc + 1, sizeof(char *));
> -       if (rec_argv == NULL)
> +       if (!rec_argv)

It's better to check explicitly, so we know rec_argv isn't an integer.

>                 return -ENOMEM;
>
>         for (i = 0; i < ARRAY_SIZE(record_args); i++)
> @@ -908,7 +910,9 @@ static int __cmd_record(int argc, const char **argv)
>
>         BUG_ON(i != rec_argc);
>
> -       return cmd_record(i, rec_argv, NULL);
> +       ret = cmd_record(i, rec_argv, NULL);
> +       free(rec_argv);
> +       return ret;
>  }

Patch looks good otherwise; thanks.
