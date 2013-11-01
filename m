Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3KAM4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:56:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3KAM4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:56:14 -0400
Date: Fri, 1 Nov 2013 13:55:51 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 07/14] perf tools: Update cpumode for each cumulative
 entry
Message-ID: <20131101125551.GE10041@krava.brq.redhat.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383202576-28141-8-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:56:09PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The cpumode and level in struct addr_localtion was set for a sample
> and but updated as cumulative callchains were added.  This led to have
> non-matching symbol and cpumode in the output.
> 
> Update it accordingly based on the fact whether the map is a part of
> the kernel or not.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 92cbd5cd1ab1..1b152a8b7f51 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -80,6 +80,7 @@ struct add_entry_iter {
>  	struct perf_report *rep;
>  	struct perf_evsel *evsel;
>  	struct perf_sample *sample;
> +	struct machine *machine;
>  	struct hist_entry *he;
>  	struct symbol *parent;
>  	void *priv;
> @@ -388,7 +389,7 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
>  
>  static int
>  iter_prepare_cumulative_entry(struct add_entry_iter *iter,
> -			      struct machine *machine __maybe_unused,
> +			      struct machine *machine,
>  			      struct perf_evsel *evsel,
>  			      struct addr_location *al __maybe_unused,
>  			      struct perf_sample *sample)
> @@ -404,6 +405,7 @@ iter_prepare_cumulative_entry(struct add_entry_iter *iter,
>  
>  	iter->evsel = evsel;
>  	iter->sample = sample;
> +	iter->machine = machine;
>  	return 0;
>  }
>  
> @@ -468,6 +470,27 @@ iter_next_cumulative_entry(struct add_entry_iter *iter __maybe_unused,
>  	if (al->sym == NULL)
>  		return 0;
>  
> +	if (al->map->groups == &iter->machine->kmaps) {
> +		if (machine__is_host(iter->machine)) {
> +			al->cpumode = PERF_RECORD_MISC_KERNEL;
> +			al->level = 'k';
> +		} else {
> +			al->cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
> +			al->level = 'g';
> +		}
> +	} else {
> +		if (machine__is_host(iter->machine)) {
> +			al->cpumode = PERF_RECORD_MISC_USER;
> +			al->level = '.';
> +		} else if (perf_guest) {
> +			al->cpumode = PERF_RECORD_MISC_GUEST_USER;
> +			al->level = 'u';
> +		} else {
> +			al->cpumode = PERF_RECORD_MISC_HYPERVISOR;
> +			al->level = 'H';
> +		}
> +	}
> +

Looks like this is what thread__find_addr_map does as well.
Could above code go into a function used by both places?

jirka
