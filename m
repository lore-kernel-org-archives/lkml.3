Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaDHG7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:59:20 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:51808 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaDHG7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:59:18 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 03/15 V3] perf c2c: Shared data analyser
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-4-git-send-email-dzickus@redhat.com>
Date: Tue, 08 Apr 2014 15:59:15 +0900
In-Reply-To: <1395689826-215033-4-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:36:54 -0400")
Message-ID: <87a9bwxq64.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Mon, 24 Mar 2014 15:36:54 -0400, Don Zickus wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> This is the start of a new perf tool that will collect information about
> memory accesses and analyse it to find things like hot cachelines, etc.

So why not integrating this into existing 'perf mem' command if it's all
about analyzing memory accesses?

>
> This is basically trying to get a prototype written by Richard Fowles
> written using the tools/perf coding style and libraries.
>
> Start it from 'perf sched', this patch starts the process by adding the
> 'record' subcommand to collect the needed mem loads and stores samples.
>
> It also have the basic 'report' skeleton, resolving the sample address
> and hooking the events found in a perf.data file with methods to handle
> them, right now just printing the resolved perf_sample data structure
> after each event name.
>
> [dcz: refreshed to latest upstream changes]

[SNIP]
> +perf-c2c(1)
> +===========
> +
> +NAME
> +----
> +perf-c2c - Shared Data C2C/HITM Analyzer.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'perf c2c' record
> +
> +DESCRIPTION
> +-----------
> +These are the variants of perf c2c:
> +
> +  'perf c2c record <command>' to record the memory accesses of an arbitrary
> +  workload.
> +
> +SEE ALSO
> +--------
> +linkperf:perf-record[1], linkperf:perf-mem[1]

This document is very terse and only memtions the 'record' subcommand -
also it's not updated throughout the series.  So I'd like to suggest
adding a separate documentation patch with full/verbose descriptions at
the end of this series.


[SNIP]
> +static int perf_c2c__read_events(struct perf_c2c *c2c)
> +{
> +	int err = -1;
> +	struct perf_session *session;
> +	struct perf_data_file file = {
> +			.path = input_name,
> +			.mode = PERF_DATA_MODE_READ,
> +	};
> +	struct perf_evsel *evsel;
> +
> +	session = perf_session__new(&file, 0, &c2c->tool);
> +	if (session == NULL) {
> +		pr_debug("No memory for session\n");
> +		goto out;
> +	}
> +
> +	/* setup the evsel handlers for each event type */
> +	evlist__for_each(session->evlist, evsel) {
> +		const char *name = perf_evsel__name(evsel);
> +		unsigned int i;
> +
> +		for (i = 0; i < ARRAY_SIZE(handlers); i++) {
> +			if (!strcmp(name, handlers[i].name))
> +				evsel->handler = handlers[i].handler;
> +		}
> +	}
> +
> +	err = perf_session__process_events(session, &c2c->tool);
> +	if (err)
> +		pr_err("Failed to process events, error %d", err);

You may want to add perf_session__delete() here.

> +
> +out:
> +	return err;
> +}


[SNIP]
> +int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
> +{
> +	struct perf_c2c c2c = {
> +		.tool = {
> +			.sample		 = perf_c2c__process_sample,
> +			.comm		 = perf_event__process_comm,
> +			.exit		 = perf_event__process_exit,
> +			.fork		 = perf_event__process_fork,
> +			.lost		 = perf_event__process_lost,

It seems that it also needs to handle mmap[2] events otherwise it cannot
find symbols from an address.

Thanks,
Namhyung


> +			.ordered_samples = true,
> +		},
> +	};
