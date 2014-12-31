Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaLaLeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 06:34:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaLaLeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 06:34:19 -0500
Date: Wed, 31 Dec 2014 12:33:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 07/37] perf tools: Do not use
 __perf_session__process_events() directly
Message-ID: <20141231113354.GC1256@krava.brq.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419405333-27952-8-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:15:03PM +0900, Namhyung Kim wrote:
> It's only used for perf record to process build-id because its file
> size it's not fixed at this time due to remaining header features.
> However data offset and size is available so that we can use the
> perf_session__process_events() once we set the file size as the
> current offset like for now.
> 
> It turns out that we can staticize the function again as it's the only
> user and add multi file support in a single place.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@kernel.org>

> ---
>  tools/perf/builtin-record.c | 7 +++----
>  tools/perf/util/session.c   | 6 +++---
>  tools/perf/util/session.h   | 3 ---
>  3 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 8c91f25b81f6..4f97657f14e7 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -196,12 +196,13 @@ static int process_buildids(struct record *rec)
>  {
>  	struct perf_data_file *file  = &rec->file;
>  	struct perf_session *session = rec->session;
> -	u64 start = session->header.data_offset;
>  
>  	u64 size = lseek(perf_data_file__fd(file), 0, SEEK_CUR);
>  	if (size == 0)
>  		return 0;
>  
> +	file->size = size;
> +
>  	/*
>  	 * During this process, it'll load kernel map and replace the
>  	 * dso->long_name to a real pathname it found.  In this case
> @@ -213,9 +214,7 @@ static int process_buildids(struct record *rec)
>  	 */
>  	symbol_conf.ignore_vmlinux_buildid = true;
>  
> -	return __perf_session__process_events(session, start,
> -					      size - start,
> -					      size, &build_id__mark_dso_hit_ops);
> +	return perf_session__process_events(session, &build_id__mark_dso_hit_ops);
>  }
>  
>  static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 6ac62ae6b8fa..88aa2f09df93 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1252,9 +1252,9 @@ fetch_mmaped_event(struct perf_session *session,
>  #define NUM_MMAPS 128
>  #endif
>  
> -int __perf_session__process_events(struct perf_session *session,
> -				   u64 data_offset, u64 data_size,
> -				   u64 file_size, struct perf_tool *tool)
> +static int __perf_session__process_events(struct perf_session *session,
> +					  u64 data_offset, u64 data_size,
> +					  u64 file_size, struct perf_tool *tool)
>  {
>  	int fd = perf_data_file__fd(session->file);
>  	u64 head, page_offset, file_offset, file_pos, size;
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index dc26ebf60fe4..6d663dc76404 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -49,9 +49,6 @@ int perf_session__peek_event(struct perf_session *session, off_t file_offset,
>  			     union perf_event **event_ptr,
>  			     struct perf_sample *sample);
>  
> -int __perf_session__process_events(struct perf_session *session,
> -				   u64 data_offset, u64 data_size, u64 size,
> -				   struct perf_tool *tool);
>  int perf_session__process_events(struct perf_session *session,
>  				 struct perf_tool *tool);
>  
> -- 
> 2.1.3
> 
