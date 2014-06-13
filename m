Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaFMLwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:52:03 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44545 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaFMLwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:52:00 -0400
Subject: Re: [PATCH 01/17] perf tools: Always force
 PERF_RECORD_FINISHED_ROUND event
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1402610913-19059-2-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
	 <1402610913-19059-2-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 20:51:54 +0900
Message-ID: <1402660314.2178.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> The PERF_RECORD_FINISHED_ROUND governs queue flushing in
> reporting, so it needs to be stored for any kind of event.
> 
> Forcing the PERF_RECORD_FINISHED_ROUND event to be stored any
> time we finish the round and wrote at least one event.
> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/builtin-record.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 378b85b..4869050 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -238,6 +238,7 @@ static struct perf_event_header finished_round_event = {
>  
>  static int record__mmap_read_all(struct record *rec)
>  {
> +	u64 bytes_written = rec->bytes_written;
>  	int i;
>  	int rc = 0;
>  
> @@ -250,7 +251,11 @@ static int record__mmap_read_all(struct record *rec)
>  		}
>  	}
>  
> -	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
> +	/*
> +	 * Mark the round finished in case we wrote
> +	 * at least one event.
> +	 */
> +	if (bytes_written != rec->bytes_written)
>  		rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));

Hmm.. what was the rational behind the original code?  Why did it flush
the events only if session has tracepoint events?  Frederic?

I guess this change alone can impact the performance in your case.
Jiri, do you have a test result of it?

Thanks,
Namhyung


