Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaJXFP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:15:56 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:48343 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaJXFPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:15:54 -0400
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
Subject: Re: [PATCH 02/16] perf pmu: Let pmu's with no events show up on perf list
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
	<1414061124-26830-3-git-send-email-adrian.hunter@intel.com>
Date: Fri, 24 Oct 2014 14:15:52 +0900
In-Reply-To: <1414061124-26830-3-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Thu, 23 Oct 2014 13:45:10 +0300")
Message-ID: <87y4s6cak7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 13:45:10 +0300, Adrian Hunter wrote:
> perf list only lists PMUs with events.  Add a
> flag to cause a PMU to be also listed separately.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/pmu.c | 13 +++++++++++--
>  tools/perf/util/pmu.h |  1 +
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index e243ad9..91dca60 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -747,15 +747,18 @@ void print_pmu_events(const char *event_glob, bool name_only)
>  
>  	pmu = NULL;
>  	len = 0;
> -	while ((pmu = perf_pmu__scan(pmu)) != NULL)
> +	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
>  		list_for_each_entry(alias, &pmu->aliases, list)
>  			len++;
> +		if (pmu->selectable)
> +			len++;
> +	}
>  	aliases = malloc(sizeof(char *) * len);
>  	if (!aliases)
>  		return;
>  	pmu = NULL;
>  	j = 0;
> -	while ((pmu = perf_pmu__scan(pmu)) != NULL)
> +	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
>  		list_for_each_entry(alias, &pmu->aliases, list) {
>  			char *name = format_alias(buf, sizeof(buf), pmu, alias);
>  			bool is_cpu = !strcmp(pmu->name, "cpu");
> @@ -772,6 +775,12 @@ void print_pmu_events(const char *event_glob, bool name_only)
>  			aliases[j] = strdup(aliases[j]);
>  			j++;
>  		}
> +		if (pmu->selectable) {
> +			scnprintf(buf, sizeof(buf), "%s//", pmu->name);
> +			aliases[j] = strdup(buf);

You need to check the return value here (and above too).


> +			j++;
> +		}
> +	}
>  	len = j;
>  	qsort(aliases, len, sizeof(char *), cmp_string);
>  	for (j = 0; j < len; j++) {
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index fe9dfbe..8092de7 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -18,6 +18,7 @@ struct perf_event_attr;
>  struct perf_pmu {
>  	char *name;
>  	__u32 type;
> +	bool selectable;

I think it's a bit confusing.  IIUC this 'selectable' means that this
PMU doesn't contain any events but wants to be listed.  So the normal
PMUs which contain events are not selectable, right?

Thanks,
Namhyung


>  	struct perf_event_attr *default_config;
>  	struct cpu_map *cpus;
>  	struct list_head format;  /* HEAD struct perf_pmu_format -> list */
