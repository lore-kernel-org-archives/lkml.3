Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaJXFWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:22:08 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:50953 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaJXFWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:22:04 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/16] perf session: Add perf_session__deliver_synth_event()
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
	<1414061124-26830-4-git-send-email-adrian.hunter@intel.com>
Date: Fri, 24 Oct 2014 14:22:03 +0900
In-Reply-To: <1414061124-26830-4-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Thu, 23 Oct 2014 13:45:11 +0300")
Message-ID: <87tx2uca9w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 13:45:11 +0300, Adrian Hunter wrote:
> Add a function to deliver synthesized events from
> within a session.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/session.c | 14 ++++++++++++++
>  tools/perf/util/session.h |  5 +++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index d70e37d..09635d1 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -907,6 +907,20 @@ static s64 perf_session__process_user_event(struct perf_session *session,
>  	}
>  }
>  
> +int perf_session__deliver_synth_event(struct perf_session *session,
> +				      union perf_event *event,
> +				      struct perf_sample *sample,
> +				      struct perf_tool *tool)
> +{
> +	events_stats__inc(&session->stats, event->header.type);
> +
> +	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
> +		return perf_session__process_user_event(session, event, tool,
> +							0);
> +
> +	return perf_session__deliver_event(session, event, sample, tool, 0);
> +}

It seems that it's basically same as what perf_session__process_event()
does.  So it might deserve a comment or better changelog why it's needed.

Thanks,
Namhyung


> +
>  static void event_swap(union perf_event *event, bool sample_id_all)
>  {
>  	perf_event__swap_op swap;
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index d8521ac..dc26ebf 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -127,6 +127,11 @@ extern volatile int session_done;
>  
>  #define session_done()	ACCESS_ONCE(session_done)
>  
> +int perf_session__deliver_synth_event(struct perf_session *session,
> +				      union perf_event *event,
> +				      struct perf_sample *sample,
> +				      struct perf_tool *tool);
> +
>  int perf_event__process_id_index(struct perf_tool *tool,
>  				 union perf_event *event,
>  				 struct perf_session *session);
