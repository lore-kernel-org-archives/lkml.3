Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab3EHGRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:17:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64676 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3EHGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:17:08 -0400
X-AuditID: 9c930179-b7bb6ae000001131-17-5189edde5d9e
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf record: handle death by SIGTERM
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com>
	<CABPqkBTj6Jt82mvVJKJxXaGnbD5GbW5mo4L71StOZuA=8MwDdw@mail.gmail.com>
	<20130507062947.GB17705@gmail.com> <51896A71.8010007@gmail.com>
Date: Wed, 08 May 2013 15:17:02 +0900
In-Reply-To: <51896A71.8010007@gmail.com> (David Ahern's message of "Tue, 07
	May 2013 14:56:17 -0600")
Message-ID: <87wqra6lnl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 07 May 2013 14:56:17 -0600, David Ahern wrote:
> On 5/7/13 12:29 AM, Ingo Molnar wrote:
>>
>> * Stephane Eranian <eranian@google.com> wrote:
>>
>>> This is a good fix. I have run into this infinite loop in perf report
>>> many times.
>>
>> Hm, perf record should really not assume much about the perf.data and
>> should avoid infinite loops ...
>>
>> So while making perf.data more consistent on SIGTERM is a nice fix, perf
>> report should be fixed as well to detect loops and such.
>>
>> Thanks,
>>
>> 	Ingo
>>
>
> This seems to do the trick:

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

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
> +
>     nr_attrs = f_header.attrs.size / f_header.attr_size;
>     lseek(fd, f_header.attrs.offset, SEEK_SET);
