Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948Ab3IDQr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:47:27 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48617 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934560Ab3IDQr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:47:26 -0400
Message-ID: <5227641A.40500@gmail.com>
Date: Wed, 04 Sep 2013 10:47:22 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Separate progress bar update when processing
 events
References: <1378312077-28374-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378312077-28374-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/13 10:27 AM, Jiri Olsa wrote:
> Currently when processing events in __perf_session__process_events
> function we we update progress based on the file_size. During the
> same processing we update progress bar from within flush_sample_queue
> which is based on number of samples count.
>
> Having 2 different based updates is causing the progress bar to
> jump heavily back and forth giving not much useful info.
>
> Fixing this by keeping only __perf_session__process_events
> based progress bar update. And turning on flush_sample_queue
> progress bar update only for final flushing.
>
> This reduces the number of times the progress bar update
> function is called and it significantly reduces the loading
> time for TUI, where the progress bar update takes quite a lot
> of time.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>   tools/perf/util/session.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 1fc0c62..4df449c 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -495,7 +495,7 @@ static int perf_session_deliver_event(struct perf_session *session,
>   				      u64 file_offset);
>
>   static int flush_sample_queue(struct perf_session *s,
> -		       struct perf_tool *tool)
> +		       struct perf_tool *tool, bool final)

Why not base it on next_flush = ULLONG_MAX? Then you don't need the 
extra arg.

David
