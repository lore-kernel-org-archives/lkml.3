Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaINNXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaINNXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:23:19 -0400
Date: Sun, 14 Sep 2014 15:23:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH V6 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140914132312.GA1731@krava.redhat.com>
References: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
 <1410462539-5468-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410462539-5468-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 03:08:58PM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>

typo in subject - s/surfix/suffix/

SNIP

> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index b9174bc..20e01d1 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -30,6 +30,9 @@ extern int parse_events_debug;
>  #endif
>  int parse_events_parse(void *data, void *scanner);
>  
> +static struct perf_pmu_event_symbol *perf_pmu_events_list;
> +static int perf_pmu_events_list_num;

please make some comment for the perf_pmu_events_list_num in here,
saying that 0 means 'ready to init', -1 means 'failed, dont try anymore',
and > 0 means 'initialized'

> +
>  static struct event_symbol event_symbols_hw[PERF_COUNT_HW_MAX] = {
>  	[PERF_COUNT_HW_CPU_CYCLES] = {
>  		.symbol = "cpu-cycles",
> @@ -864,6 +867,114 @@ int parse_events_name(struct list_head *list, char *name)
>  	return 0;
>  }
>  
> +static int
> +comp_pmu(const void *p1, const void *p2)
> +{
> +	struct perf_pmu_event_symbol *pmu1 =
> +			(struct perf_pmu_event_symbol *) p1;
> +	struct perf_pmu_event_symbol *pmu2 =
> +			(struct perf_pmu_event_symbol *) p2;

please keep it on one line, like:
	const struct perf_pmu_event_symbol *pmu1 = p1;
	const struct perf_pmu_event_symbol *pmu2 = p2;

> +
> +	return strcmp(pmu1->symbol, pmu2->symbol);
> +}
> +
> +/*
> + * Read the pmu events list from sysfs
> + * Save it into perf_pmu_events_list
> + */
> +static void perf_pmu__parse_init(void)
> +{
> +
> +	struct perf_pmu *pmu = NULL;
> +	struct perf_pmu_alias *alias;
> +	int len = 0;
> +
> +	pmu = perf_pmu__find("cpu");
> +	if ((pmu == NULL) || list_empty(&pmu->aliases)) {
> +		perf_pmu_events_list_num = -1;
> +		return;
> +	}
> +	list_for_each_entry(alias, &pmu->aliases, list) {
> +		if (strchr(alias->name, '-'))
> +			len++;
> +		len++;
> +	}
> +	perf_pmu_events_list =
> +		malloc(sizeof(struct perf_pmu_event_symbol) * len);

please keep above on one line

> +	perf_pmu_events_list_num = len;
> +
> +	len = 0;
> +	pmu = perf_pmu__find("cpu");

no need to lookup 'cpu' pmu again

> +	list_for_each_entry(alias, &pmu->aliases, list) {
> +		struct perf_pmu_event_symbol *p =
> +			perf_pmu_events_list + len;

please keep above on one line

> +		char *tmp = strchr(alias->name, '-');
> +
> +		if (tmp != NULL) {
> +			p->symbol = malloc(tmp - alias->name + 1);
> +			strlcpy(p->symbol, alias->name,
> +				tmp - alias->name + 1);
> +			p->type = KERNEL_PMU_EVENT_PREFIX;
> +			tmp++;
> +			p++;
> +			p->symbol = malloc(strlen(tmp) + 1);
> +			strcpy(p->symbol, tmp);
> +			p->type = KERNEL_PMU_EVENT_SUFFIX;
> +			len += 2;
> +		} else {
> +			p->symbol = malloc(strlen(alias->name) + 1);
> +			strcpy(p->symbol, alias->name);
> +			p->type = KERNEL_PMU_EVENT;
> +			len++;

I can see pattern above and missing check for failed malloc
how about using strdup and macro like:

...

#define SET_SYMBOL(str, type)	\
do {				\
	p->symbol = str;	\
	if (!p->symbol)		\
		goto err;	\
	p->type = type;		\
} while (0)

if (tmp != NULL) {
	SET_SYMBOL(strndup(alias->name, tmp - alias->name + 1), KERNEL_PMU_EVENT_PREFIX);
	p++;
	SET_SYMBOL(strdup(++tmp), KERNEL_PMU_EVENT_SUFFIX);
	len += 2;
} else {
	SET_SYMBOL(strdup(alias->name), KERNEL_PMU_EVENT);
}

...

err:
	perf_pmu__parse_cleanup

> +		}
> +	}
> +	qsort(perf_pmu_events_list, len,
> +		sizeof(struct perf_pmu_event_symbol), comp_pmu);
> +}
> +
> +static void perf_pmu__parse_cleanup(void)
> +{
> +	if (perf_pmu_events_list_num > 0) {
> +		struct perf_pmu_event_symbol *p;
> +		int i;
> +
> +		for (i = 0; i < perf_pmu_events_list_num; i++) {
> +			p = perf_pmu_events_list + i;
> +			free(p->symbol);
> +		}
> +		free(perf_pmu_events_list);
> +		perf_pmu_events_list = NULL;
> +		perf_pmu_events_list_num = 0;
> +	}
> +}
> +
> +enum perf_pmu_event_symbol_type
> +perf_pmu__parse_check(const char *name)
> +{
> +	struct perf_pmu_event_symbol p, *r;
> +
> +	/* scan kernel pmu events from sysfs if needed */
> +	if (perf_pmu_events_list_num == 0)
> +		perf_pmu__parse_init();
> +	/*
> +	 * name "cpu" could be prefix of cpu-cycles or cpu// events.
> +	 * cpu-cycles has been handled by hardcode.
> +	 * So it must be cpu// events, not kernel pmu event.
> +	 */
> +	if ((perf_pmu_events_list_num <= 0) || !strcmp(name, "cpu"))
> +		return NONE_KERNEL_PMU_EVENT;
> +
> +	p.symbol = malloc(strlen(name) + 1);
> +	strcpy(p.symbol, name);

please use strdup and check for error,
but I think you could use name directly no? like:
	p.symbol = name;

> +	r = bsearch(&p, perf_pmu_events_list,
> +			(size_t) perf_pmu_events_list_num,
> +			sizeof(struct perf_pmu_event_symbol), comp_pmu);
> +	free(p.symbol);
> +	if (r == NULL)
> +		return NONE_KERNEL_PMU_EVENT;
> +	return r->type;

	return r ? r->type : NONE_KERNEL_PMU_EVENT;

> +}
> +
>  static int parse_events__scanner(const char *str, void *data, int start_token)
>  {
>  	YY_BUFFER_STATE buffer;
> @@ -918,6 +1029,7 @@ int parse_events(struct perf_evlist *evlist, const char *str)
>  	int ret;
>  
>  	ret = parse_events__scanner(str, &data, PE_START_EVENTS);
> +	perf_pmu__parse_cleanup();
>  	if (!ret) {
>  		int entries = data.idx - evlist->nr_entries;
>  		perf_evlist__splice_list_tail(evlist, &data.list, entries);
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index df094b4..9f064e4 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -35,6 +35,18 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
>  
>  #define EVENTS_HELP_MAX (128*1024)
>  
> +enum perf_pmu_event_symbol_type {
> +	NONE_KERNEL_PMU_EVENT,		/* not a PMU EVENT */
> +	KERNEL_PMU_EVENT,		/* normal style PMU event */
> +	KERNEL_PMU_EVENT_PREFIX,	/* prefix of pre-suf style event */
> +	KERNEL_PMU_EVENT_SUFFIX,	/* suffix of pre-suf style event */
> +};

maybe following enum names go better with the enum name:
	PMU_EVENT_SYMBOL_ERR
	PMU_EVENT_SYMBOL
	PMU_EVENT_SYMBOL_PREFIX
	PMU_EVENT_SYMBOL_SUFFIX

> +
> +struct perf_pmu_event_symbol {
> +	char	*symbol;
> +	enum perf_pmu_event_symbol_type	type;
> +};
> +
>  enum {
>  	PARSE_EVENTS__TERM_TYPE_NUM,
>  	PARSE_EVENTS__TERM_TYPE_STR,
> @@ -95,6 +107,8 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
>  				void *ptr, char *type);
>  int parse_events_add_pmu(struct list_head *list, int *idx,
>  			 char *pmu , struct list_head *head_config);
> +enum perf_pmu_event_symbol_type
> +perf_pmu__parse_check(const char *name);
>  void parse_events__set_leader(char *name, struct list_head *list);
>  void parse_events_update_lists(struct list_head *list_event,
>  			       struct list_head *list_all);
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 22a4ad5..f358345 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -12,16 +12,6 @@
>  #include "parse-events.h"
>  #include "cpumap.h"
>  
> -#define UNIT_MAX_LEN	31 /* max length for event unit name */
> -
> -struct perf_pmu_alias {
> -	char *name;
> -	struct list_head terms; /* HEAD struct parse_events_term -> list */
> -	struct list_head list;  /* ELEM */
> -	char unit[UNIT_MAX_LEN+1];
> -	double scale;
> -};
> -
>  struct perf_pmu_format {
>  	char *name;
>  	int value;
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index 0f5c0a8..2020519 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -25,6 +25,16 @@ struct perf_pmu {
>  	struct list_head list;    /* ELEM */
>  };
>  
> +#define UNIT_MAX_LEN	31 /* max length for event unit name */
> +
> +struct perf_pmu_alias {
> +	char *name;
> +	struct list_head terms; /* HEAD struct parse_events_term -> list */
> +	struct list_head list;  /* ELEM */
> +	char unit[UNIT_MAX_LEN+1];
> +	double scale;
> +};
> +
>  struct perf_pmu *perf_pmu__find(const char *name);
>  int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
>  		     struct list_head *head_terms);
> -- 
> 1.8.3.2
> 
