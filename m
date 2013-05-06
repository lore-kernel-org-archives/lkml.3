Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3EFSp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:45:28 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45485 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3EFSp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:45:27 -0400
Message-ID: <5187FA43.80304@gmail.com>
Date: Mon, 06 May 2013 12:45:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: handle death by SIGTERM
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1367864663-1309-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/13 12:24 PM, David Ahern wrote:
> perf data files cannot be processed until the header file is update

yuk, that is supposed to say "until the header is updated"

David

> which is done via an on_exit handler. If perf is killed due to a SIGTERM
> it does not run the on_exit hooks leaving the perf.data file in a
> random state which perf-report will happily spin on trying to read. As
> noted by Mike an easy reproducer is:
>    perf record -a -g & sleep 1; killall perf
>
> Fix by catching SIGTERM like it does SIGINT.  Also need to remove the
> kill which was added via commit f7b7c26e.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>   tools/perf/builtin-record.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index cdf58ec..fff985c 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -198,7 +198,6 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
>   		return;
>
>   	signal(signr, SIG_DFL);
> -	kill(getpid(), signr);
>   }
>
>   static bool perf_evlist__equal(struct perf_evlist *evlist,
> @@ -404,6 +403,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>   	signal(SIGCHLD, sig_handler);
>   	signal(SIGINT, sig_handler);
>   	signal(SIGUSR1, sig_handler);
> +	signal(SIGTERM, sig_handler);
>
>   	if (!output_name) {
>   		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
>

