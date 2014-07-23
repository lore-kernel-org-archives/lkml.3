Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbaGWOpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:45:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:46832 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705AbaGWOp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:45:28 -0400
Date: Wed, 23 Jul 2014 11:45:22 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 21/52] perf session: Add ability to skip 4GiB or more
Message-ID: <20140723144522.GO20303@kernel.org>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-22-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406035081-14301-22-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 22, 2014 at 04:17:30PM +0300, Adrian Hunter escreveu:
> A session can be made to skip portions of the input
> file.  Do not limit that size to 32-bits.

Aren't there two changes here? One that is described in the changelog,
another that makes the value returned by perf_session__process_event to
be properly used if > 0?

Can you please split and provide relevant changeset comments?

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/session.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 8aa1be1..708e1c1 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1026,8 +1026,10 @@ static int perf_session_deliver_event(struct perf_session *session,
>  	}
>  }
>  
> -static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
> -					    struct perf_tool *tool, u64 file_offset)
> +static s64 perf_session__process_user_event(struct perf_session *session,
> +					    union perf_event *event,
> +					    struct perf_tool *tool,
> +					    u64 file_offset)
>  {
>  	int fd = perf_data_file__fd(session->file);
>  	int err;
> @@ -1073,7 +1075,7 @@ static void event_swap(union perf_event *event, bool sample_id_all)
>  		swap(event, sample_id_all);
>  }
>  
> -static int perf_session__process_event(struct perf_session *session,
> +static s64 perf_session__process_event(struct perf_session *session,
>  				       union perf_event *event,
>  				       struct perf_tool *tool,
>  				       u64 file_offset)
> @@ -1184,7 +1186,7 @@ static int __perf_session__process_pipe_events(struct perf_session *session,
>  	union perf_event *event;
>  	uint32_t size, cur_size = 0;
>  	void *buf = NULL;
> -	int skip = 0;
> +	s64 skip = 0;
>  	u64 head;
>  	ssize_t err;
>  	void *p;
> @@ -1313,13 +1315,13 @@ int __perf_session__process_events(struct perf_session *session,
>  				   u64 file_size, struct perf_tool *tool)
>  {
>  	int fd = perf_data_file__fd(session->file);
> -	u64 head, page_offset, file_offset, file_pos;
> +	u64 head, page_offset, file_offset, file_pos, size;
>  	int err, mmap_prot, mmap_flags, map_idx = 0;
>  	size_t	mmap_size;
>  	char *buf, *mmaps[NUM_MMAPS];
>  	union perf_event *event;
> -	uint32_t size;
>  	struct ui_progress prog;
> +	s64 skip;
>  
>  	perf_tool__fill_defaults(tool);
>  
> @@ -1380,7 +1382,8 @@ more:
>  	size = event->header.size;
>  
>  	if (size < sizeof(struct perf_event_header) ||
> -	    perf_session__process_event(session, event, tool, file_pos) < 0) {
> +	    (skip = perf_session__process_event(session, event, tool, file_pos))
> +									< 0) {
>  		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
>  		       file_offset + head, event->header.size,
>  		       event->header.type);
> @@ -1388,6 +1391,9 @@ more:
>  		goto out_err;
>  	}
>  
> +	if (skip)
> +		size += skip;
> +

I.e. the above 

>  	head += size;
>  	file_pos += size;
>  
> -- 
> 1.8.3.2
