Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3EHGyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:54:52 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:34136 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3EHGyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:54:51 -0400
Date: Wed, 8 May 2013 08:54:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf record: handle death by SIGTERM
Message-ID: <20130508065447.GB5378@gmail.com>
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com>
 <CABPqkBTj6Jt82mvVJKJxXaGnbD5GbW5mo4L71StOZuA=8MwDdw@mail.gmail.com>
 <20130507062947.GB17705@gmail.com>
 <51896A71.8010007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51896A71.8010007@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 5/7/13 12:29 AM, Ingo Molnar wrote:
> >
> >* Stephane Eranian <eranian@google.com> wrote:
> >
> >>This is a good fix. I have run into this infinite loop in perf report
> >>many times.
> >
> >Hm, perf record should really not assume much about the perf.data and
> >should avoid infinite loops ...
> >
> >So while making perf.data more consistent on SIGTERM is a nice fix, perf
> >report should be fixed as well to detect loops and such.
> >
> >Thanks,
> >
> >	Ingo
> >
> 
> This seems to do the trick:
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 326068a..e82646f 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2802,6 +2802,17 @@ int perf_session__read_header(struct
> perf_session *session, int fd)
>     if (perf_file_header__read(&f_header, header, fd) < 0)
>         return -EINVAL;
> 
> +   /*
> +    * sanity check that perf.data was written cleanly: data size
> +    * is initialized to 0 and updated only if the on_exit function
> +    * is run. If data size is still 0 then the file cannot be
> +    * processed.
> +    */
> +   if (f_header.data.size == 0) {
> +       pr_err("data size is 0. Was record properly terminated?\n");
> +       return -1;
> +   }

Hm, this detects the condition - but where does the looping come from?

Can it happen with a perf.data that 'seems' clean but is corrupted 
(because not fully written, buggy kernel just crashed, etc.).

In essence it would be _very_ nice if someone reproduced the looping and 
checked what to do to fix the looping itself. Or does the above
data.size == 0 check fully fix the looping under every possible state of a 
perf.data?

Thanks,

	Ingo
