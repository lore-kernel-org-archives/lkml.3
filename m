Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab3GSMax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:30:53 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56639 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3GSMav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:30:51 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-ea-51e9317a979e
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 18/23] perf tools: Move synthetizing into single function
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
	<1374083403-14591-19-git-send-email-jolsa@redhat.com>
Date: Fri, 19 Jul 2013 21:30:50 +0900
In-Reply-To: <1374083403-14591-19-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Wed, 17 Jul 2013 19:49:58 +0200")
Message-ID: <87y592viit.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 19:49:58 +0200, Jiri Olsa wrote:
> Moving synthetizing into single function, so it

s/synthetizing/synthesizing/

The same goes to the subject line too.


> could be reused.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/builtin-record.c | 155 ++++++++++++++++++++++++++------------------
>  1 file changed, 91 insertions(+), 64 deletions(-)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index b67564c..33a5bce 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -317,6 +317,95 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
>  		       " relocation symbol.\n", machine->pid);
>  }
>  
> +static int synthesize_record_pipe(struct perf_record *rec)
> +{
> +	struct perf_session  *session = rec->session;
> +	struct perf_tool        *tool = &rec->tool;
> +	struct perf_evlist    *evlist = rec->evlist;
> +	int err;
> +
> +	err = perf_event__synthesize_attrs(tool, session,
> +					   process_synthesized_event);
> +	if (err < 0) {
> +		pr_err("Couldn't synthesize attrs.\n");
> +		return err;
> +	}
> +
> +	if (have_tracepoints(&evlist->entries)) {
> +		/*
> +		 * FIXME err <= 0 here actually means that
> +		 * there were no tracepoints so its not really
> +		 * an error, just that we don't need to
> +		 * synthesize anything.  We really have to
> +		 * return this more properly and also
> +		 * propagate errors that now are calling die()
> +		 */

I believe that this comment is doubly wrong.  First we already check
whether evlist has tracepoints before calling the below function.
Secondly I think I got rid of all of the die() calls from the
tracing_data_get/put path.

So I would suggest simply removing this comment block.

Thanks,
Namhyung


> +		err = perf_event__synthesize_tracing_data(tool, rec->output, evlist,
> +							  process_synthesized_event);
> +		if (err <= 0) {
> +			pr_err("Couldn't record tracing data.\n");
> +			return err;
> +		}
> +		advance_output(rec, err);
> +	}
> +
> +	return 0;
> +}
