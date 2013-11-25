Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab3KYTkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:40:42 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:50211 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3KYTkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:40:39 -0500
Date: Mon, 25 Nov 2013 16:40:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] perf inject: Handle output file via perf_data_file
 object
Message-ID: <20131125194032.GC27323@ghostprotocols.net>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385130268-10664-4-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 22, 2013 at 03:24:28PM +0100, Jiri Olsa escreveu:
> Using the perf_data_file object to handle output
> file processing.
> 
> No functional change intended.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/builtin-inject.c | 71 ++++++++++++++++++++-------------------------
>  1 file changed, 31 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 6a25085..654a33e 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -22,14 +22,13 @@
>  #include <linux/list.h>
>  
>  struct perf_inject {
> -	struct perf_tool tool;
> -	bool		 build_ids;
> -	bool		 sched_stat;
> -	const char	 *input_name;
> -	int		 pipe_output,
> -			 output;
> -	u64		 bytes_written;
> -	struct list_head samples;
> +	struct perf_tool	 tool;
> +	bool			 build_ids;
> +	bool			 sched_stat;
> +	const char		*input_name;
> +	struct perf_data_file	 output;
> +	u64			 bytes_written;
> +	struct list_head	 samples;
>  };
>  
>  struct event_entry {
> @@ -42,21 +41,14 @@ static int perf_event__repipe_synth(struct perf_tool *tool,
>  				    union perf_event *event)
>  {
>  	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
> -	uint32_t size;
> -	void *buf = event;
> +	ssize_t size;
>  
> -	size = event->header.size;
> -
> -	while (size) {
> -		int ret = write(inject->output, buf, size);
> -		if (ret < 0)
> -			return -errno;
> -
> -		size -= ret;
> -		buf += ret;
> -		inject->bytes_written += ret;
> -	}
> +	size = perf_data_file__write(&inject->output, event,
> +				     event->header.size);
> +	if (size < 0)
> +		return -errno;
>  
> +	inject->bytes_written += size;
>  	return 0;
>  }
>  
> @@ -80,7 +72,7 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
>  	if (ret)
>  		return ret;
>  
> -	if (!inject->pipe_output)
> +	if (!perf_data_file__is_pipe(&inject->output))
>  		return 0;
>  
>  	return perf_event__repipe_synth(tool, event);
> @@ -351,10 +343,12 @@ static int __cmd_inject(struct perf_inject *inject)
>  {
>  	struct perf_session *session;
>  	int ret = -EINVAL;
> -	struct perf_data_file file = {
> +	struct perf_data_file file_in = {

Why don't leave it as 'file', and on a follow up patch _then_ rename it
to file_in? This way patch review gets easier, i.e. try avoiding doing
multiple things per patch.

>  		.path = inject->input_name,
>  		.mode = PERF_DATA_MODE_READ,
>  	};
> +	struct perf_data_file *file_out = &inject->output;
> +	int out_fd = perf_data_file__fd(file_out);
>  
>  	signal(SIGINT, sig_handler);
>  
> @@ -365,7 +359,7 @@ static int __cmd_inject(struct perf_inject *inject)
>  		inject->tool.tracing_data = perf_event__repipe_tracing_data;
>  	}
>  
> -	session = perf_session__new(&file, true, &inject->tool);
> +	session = perf_session__new(&file_in, true, &inject->tool);

This hunk, for example, wouldn't be here, the this patch would be
shorter, easier to review.

>  	if (session == NULL)
>  		return -ENOMEM;
>  
> @@ -391,14 +385,15 @@ static int __cmd_inject(struct perf_inject *inject)
>  		}
>  	}
>  
> -	if (!inject->pipe_output)
> -		lseek(inject->output, session->header.data_offset, SEEK_SET);
> +	if (!perf_data_file__is_pipe(file_out))
> +		lseek(out_fd, session->header.data_offset, SEEK_SET);

Couldn't this be left as:

-	if (!inject->pipe_output)
-		lseek(inject->output, session->header.data_offset, SEEK_SET);
+	if (!perf_data_file__is_pipe(file_out))
+		lseek(inject->output->fd, session->header.data_offset, SEEK_SET);

I.e. why wrap access to the fd like that?

>  
>  	ret = perf_session__process_events(session, &inject->tool);
>  
> -	if (!inject->pipe_output) {
> +	if (!perf_data_file__is_pipe(file_out)) {
>  		session->header.data_size = inject->bytes_written;
> -		perf_session__write_header(session, session->evlist, inject->output, true);
> +		perf_session__write_header(session, session->evlist, out_fd,
> +					   true);

Why a line for 'true' all by itself?

>  	}
>  
>  	perf_session__delete(session);
> @@ -427,14 +422,17 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
>  		},
>  		.input_name  = "-",
>  		.samples = LIST_HEAD_INIT(inject.samples),
> +		.output = {
> +			.path = "-",
> +			.mode = PERF_DATA_MODE_WRITE,
> +		},
>  	};
> -	const char *output_name = "-";
>  	const struct option options[] = {
>  		OPT_BOOLEAN('b', "build-ids", &inject.build_ids,
>  			    "Inject build-ids into the output stream"),
>  		OPT_STRING('i', "input", &inject.input_name, "file",
>  			   "input file name"),
> -		OPT_STRING('o', "output", &output_name, "file",
> +		OPT_STRING('o', "output", &inject.output.path, "file",

see, here you directly access a perf_data_file member instead of having
another wrapper :-)

>  			   "output file name"),
>  		OPT_BOOLEAN('s', "sched-stat", &inject.sched_stat,
>  			    "Merge sched-stat and sched-switch for getting events "
> @@ -456,16 +454,9 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
>  	if (argc)
>  		usage_with_options(inject_usage, options);
>  
> -	if (!strcmp(output_name, "-")) {
> -		inject.pipe_output = 1;
> -		inject.output = STDOUT_FILENO;
> -	} else {
> -		inject.output = open(output_name, O_CREAT | O_WRONLY | O_TRUNC,
> -						  S_IRUSR | S_IWUSR);
> -		if (inject.output < 0) {
> -			perror("failed to create output file");
> -			return -1;
> -		}
> +	if (perf_data_file__open(&inject.output)) {
> +		perror("failed to create output file");
> +		return -1;
>  	}
>  
>  	if (symbol__init() < 0)
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
