Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaIFTjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:39:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaIFTjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:39:05 -0400
Date: Sat, 6 Sep 2014 21:39:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH v4 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140906193900.GD6059@krava.brq.redhat.com>
References: <1409671770-17260-1-git-send-email-kan.liang@intel.com>
 <1409671770-17260-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409671770-17260-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:29:29AM -0400, kan.liang@intel.com wrote:

SNIP

>  {
>  	YY_BUFFER_STATE buffer;
> @@ -906,7 +1006,10 @@ int parse_events(struct perf_evlist *evlist, const char *str)
>  	};
>  	int ret;
>  
> +	/* scan kernel pmu events from sysfs */
> +	scan_kernel_pmu_events_list();
>  	ret = parse_events__scanner(str, &data, PE_START_EVENTS);
> +	release_kernel_pmu_events_list();
>  	if (!ret) {
>  		int entries = data.idx - evlist->nr_entries;
>  		perf_evlist__splice_list_tail(evlist, &data.list, entries);
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index df094b4..d06fec4 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -35,6 +35,19 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
>  
>  #define EVENTS_HELP_MAX (128*1024)
>  
> +#define KERNEL_PMU_EVENT_MAX	1024

hum.. so roughly for 15 (+-) strings of size around 20 bytes we will
use 15K of memory.. seems like overkill

seems better to allocate each symbol string separatelly, and
update the release function

> +enum kernel_pmu_event_type {
> +	NONE_KERNEL_PMU_EVENT,		/* not a PMU EVENT */
> +	KERNEL_PMU_EVENT,		/* normal style PMU event */
> +	KERNEL_PMU_EVENT_PREFIX,	/* prefix of pre-suf style event */
> +	KERNEL_PMU_EVENT_SUFFIX,	/* suffix of pre-suf style event */
> +};
> +
> +struct kernel_pmu_event_symbol {
> +	char	symbol[KERNEL_PMU_EVENT_MAX];
> +	enum kernel_pmu_event_type	type;
> +};
> +

also, I think this is more pmu object related stuff.. how about:

enum perf_pmu_event_symbol_type
struct perf_pmu_event_symbol

  perf_pmu__parse_init
  perf_pmu__parse_cleanup
  perf_pmu__parse_check

with perf_pmu__parse_init being called from perf_pmu__parse_check
in case it's needed..

and perf_pmu__parse_cleanup being called from parse_events same as
release_kernel_pmu_events_list

jirka
