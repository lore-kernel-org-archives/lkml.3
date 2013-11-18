Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3KREo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 23:44:58 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57711 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3KREow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 23:44:52 -0500
Message-ID: <52899B3E.9050901@gmail.com>
Date: Sun, 17 Nov 2013 21:44:46 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCH 2/3] perf script: Print comm, fork and exit events
 also
References: <1384743642-15120-1-git-send-email-namhyung@kernel.org> <1384743642-15120-2-git-send-email-namhyung@kernel.org>
In-Reply-To: <1384743642-15120-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/13, 8:00 PM, Namhyung Kim wrote:
> @@ -578,6 +579,106 @@ static int process_attr(struct perf_tool *tool, union perf_event *event,
>   	return perf_evsel__check_attr(evsel, scr->session);
>   }
>
> +static int process_comm_event(struct perf_tool *tool,
> +			      union perf_event *event,
> +			      struct perf_sample *sample,
> +			      struct machine *machine)
> +{
> +	struct thread *thread;
> +	struct perf_script *script = container_of(tool, struct perf_script, tool);
> +	struct perf_session *session = script->session;
> +	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
> +	char *oldname;
> +
> +	thread = machine__findnew_thread(machine, event->comm.pid, event->comm.tid);
> +	if (thread == NULL) {
> +		pr_debug("problem processing COMM event, skipping it.\n");
> +		return -1;
> +	}
> +
> +	oldname = strdup(thread__comm_str(thread));
> +	if (oldname == NULL) {
> +		pr_debug("problem processing COMM event, skipping it.\n");
> +		return -1;
> +	}
> +
> +	if (perf_event__process_comm(tool, event, sample, machine) < 0)
> +		return -1;
> +
> +	if (!evsel->attr.sample_id_all) {
> +		sample->cpu = 0;
> +		sample->time = 0;
> +		sample->tid = event->comm.tid;
> +		sample->pid = event->comm.pid;
> +	}
> +	print_sample_start(sample, thread, evsel);
> +	printf("comm: %s --> %s\n", oldname, event->comm.comm);

free(oldname)

David
