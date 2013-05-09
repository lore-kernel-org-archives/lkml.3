Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3EIJYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:24:48 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47720 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3EIJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:24:47 -0400
Date: Thu, 9 May 2013 11:24:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: detect loops processing events
Message-ID: <20130509092441.GB21620@gmail.com>
References: <1368026327-4741-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368026327-4741-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> Recovery algorithm in __perf_session__process_events attempts to remap
> a perf.data file with a different file_offset and try again at a new head
> position. Both of these adjustment rely on page_offset. If page_offset is
> 0 then file_offset and head never change which means the remap attempt is
> the same and the fetch_mmaped_event is the same and the processing just
> loops forever.
> 
> Detect this condition and warn the user.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/session.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index cf1fe01..1c4dc45 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1235,6 +1235,12 @@ more:
>  		}
>  
>  		page_offset = page_size * (head / page_size);
> +		/* catch looping where we never make forward progress. */
> +		if (page_offset == 0) {
> +			pr_err("Loop detection processing events. Is file corrupted?\n");
> +			return -1;
> +		}
> +
>  		file_offset += page_offset;
>  		head -= page_offset;
>  		goto remap;

Ah, nice!

Btw., would it make sense to emit a (once-only) warning and optimistically 
fix page_offset up to 1 (or 4096) and let things continue with the next 
set of data - can we recover most of the data in that case?

Thanks,

	Ingo
