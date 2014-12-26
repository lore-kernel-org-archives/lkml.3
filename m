Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaLZQay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 11:30:54 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51739 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaLZQax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 11:30:53 -0500
Message-ID: <549D8D39.6040000@gmail.com>
Date: Fri, 26 Dec 2014 09:30:49 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/37] perf tools: Use perf_data_file__fd() consistently
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-4-git-send-email-namhyung@kernel.org>
In-Reply-To: <1419405333-27952-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/14 12:14 AM, Namhyung Kim wrote:

> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 84df2deed988..d8b13407594d 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -375,8 +375,10 @@ static int __cmd_inject(struct perf_inject *inject)
>   		}
>   	}
>

How about a local variable to make this more readable?
fd = perf_data_file__fd(file_out)

> -	if (!file_out->is_pipe)
> -		lseek(file_out->fd, session->header.data_offset, SEEK_SET);
> +	if (!file_out->is_pipe) {
> +		lseek(perf_data_file__fd(file_out), session->header.data_offset,
> +		      SEEK_SET);
> +	}
>
>   	ret = perf_session__process_events(session, &inject->tool);
>
> @@ -385,7 +387,8 @@ static int __cmd_inject(struct perf_inject *inject)
>   			perf_header__set_feat(&session->header,
>   					      HEADER_BUILD_ID);
>   		session->header.data_size = inject->bytes_written;
> -		perf_session__write_header(session, session->evlist, file_out->fd, true);
> +		perf_session__write_header(session, session->evlist,
> +					   perf_data_file__fd(file_out), true);
>   	}
>
>   	return ret;
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index aa5fa6aabb31..054c6e57d3b9 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -196,7 +196,7 @@ static int process_buildids(struct record *rec)
>   	struct perf_session *session = rec->session;
>   	u64 start = session->header.data_offset;
>
> -	u64 size = lseek(file->fd, 0, SEEK_CUR);
> +	u64 size = lseek(perf_data_file__fd(file), 0, SEEK_CUR);
>   	if (size == 0)
>   		return 0;
>
> @@ -360,12 +360,12 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
>   		perf_header__clear_feat(&session->header, HEADER_GROUP_DESC);

Similarly in this function.

>
>   	if (file->is_pipe) {
> -		err = perf_header__write_pipe(file->fd);
> +		err = perf_header__write_pipe(perf_data_file__fd(file));
>   		if (err < 0)
>   			goto out_child;
>   	} else {
>   		err = perf_session__write_header(session, rec->evlist,
> -						 file->fd, false);
> +						 perf_data_file__fd(file), false);
>   		if (err < 0)
>   			goto out_child;
>   	}
> @@ -397,8 +397,10 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
>   			 * return this more properly and also
>   			 * propagate errors that now are calling die()
>   			 */
> -			err = perf_event__synthesize_tracing_data(tool, file->fd, rec->evlist,
> -								  process_synthesized_event);
> +			err = perf_event__synthesize_tracing_data(tool,
> +						perf_data_file__fd(file),
> +						rec->evlist,
> +						process_synthesized_event);
>   			if (err <= 0) {
>   				pr_err("Couldn't record tracing data.\n");
>   				goto out_child;
> @@ -541,7 +543,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
>   		if (!rec->no_buildid)
>   			process_buildids(rec);
>   		perf_session__write_header(rec->session, rec->evlist,
> -					   file->fd, true);
> +					   perf_data_file__fd(&rec->file), true);
>   	}
>
>   out_delete_session:

David

