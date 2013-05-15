Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab3EOVVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab3EOVVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:21:16 -0400
Date: Wed, 15 May 2013 23:20:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/15] perf ftrace: Add 'record' sub-command
Message-ID: <20130515212052.GA5814@krava.redhat.com>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
 <1368526439-31966-10-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368526439-31966-10-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:13:53PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The ftrace record command is for saving raw ftrace buffer contents
> which can be get from per_cpu/cpuX/trace_pipe_raw.
> 
> Since ftrace events are generated very frequently so single thread for
> recording mostly resulted in buffer overruns.  Thus it uses per-cpu
> recorder thread to prevent such cases and they save the contents to
> their own files.
> 

SNIP

> +
> +	/* synthesize sample data */
> +	list_for_each_entry(fra, &recorders, node) {
> +		struct perf_evsel *evsel = perf_evlist__first(ftrace->evlist);
> +		union perf_event event = {
> +			.sample = {
> +				.header = {
> +					.type = PERF_RECORD_SAMPLE,
> +					.misc = PERF_RECORD_MISC_KERNEL,
> +					.size = sizeof(event.sample.header) +
> +						evsel->sample_size,
> +				},
> +			},
> +		};
> +		struct perf_sample sample = {
> +			.cpu = fra->cpu,
> +			.period = 1,
> +		};
> +		void *raw_data;
> +		u32 raw_size;
> +		int orig_size;
> +
> +		if (fra->state != RECORD_STATE__DONE) {
> +			pr_warning("recorder failed for some reason on cpu%d\n",
> +				   fra->cpu);
> +			continue;
> +		}
> +
> +		perf_event__synthesize_sample(&event, evsel->attr.sample_type,
> +					      &sample, false);
> +
> +		raw_data = synthesize_raw_data(evsel);
> +		if (raw_data == NULL) {
> +			pr_err("synthesizing raw sample failed\n");
> +			goto out_fra;
> +		}
> +
> +		/*
> +		 * start of raw data is the size of raw data excluding itself.
> +		 */
> +		raw_size = sizeof(u32) + (*(u32 *) raw_data);
> +
> +		orig_size = event.sample.header.size;
> +		event.sample.header.size += raw_size;
> +
> +		err = write(perf_fd, &event.sample, orig_size);
> +		if (err != orig_size) {
> +			pr_err("write error occurred\n");
> +			goto out_fra;
> +		}
> +
> +		err = write(perf_fd, raw_data, raw_size);
> +		if (err != (int)raw_size) {
> +			pr_err("write error occurred\n");
> +			goto out_fra;
> +		}

missing free(raw_data) ?

jirka

> +
> +		session->header.data_size += event.sample.header.size;
> +	}
> +
> +	perf_session__write_header(session, ftrace->evlist, perf_fd, true);
> +
> +out_fra:
> +	list_for_each_entry_safe(fra, tmp, &recorders, node) {
> +		list_del(&fra->node);
> +		free(fra);
> +	}
> +out_session:
> +	free(session);
> +out_close:
> +	close(perf_fd);
> +out_reset:
> +	reset_tracing_files(ftrace);
>  	return done ? 0 : -1;
>  }
>  
