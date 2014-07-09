Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbaGIWUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:20:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbaGIWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:20:12 -0400
Date: Thu, 10 Jul 2014 00:19:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/9] perf, tools: Add support for text descriptions of
 events and alias add
Message-ID: <20140709221944.GG20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:15:57PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Change pmu.c to allow descriptions of events and add interfaces
> to add aliases at runtime from another file. To be used by jevents in the
> next patch.
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

SNIP

> +	return __perf_pmu__new_alias(list, name, dir, NULL, buf);
> +}
> +
>  /*
>   * Process all the sysfs attributes located under the directory
>   * specified in 'dir' parameter.
> @@ -720,11 +737,51 @@ static char *format_alias_or(char *buf, int len, struct perf_pmu *pmu,
>  	return buf;
>  }

changes below, the list command update should be separated patch

jirka

>  
> -static int cmp_string(const void *a, const void *b)
> +struct pair {
> +	char *name;
> +	char *desc;
> +};
> +
> +static int cmp_pair(const void *a, const void *b)
> +{
> +	const struct pair *as = a;
> +	const struct pair *bs = b;
> +
> +	/* Put downloaded event list last */
> +	if (!!as->desc != !!bs->desc)
> +		return !!as->desc - !!bs->desc;
> +	return strcmp(as->name, bs->name);
> +}
> +
> +static void wordwrap(char *s, int start, int max, int corr)
>  {
> -	const char * const *as = a;
> -	const char * const *bs = b;
> -	return strcmp(*as, *bs);
> +	int column = start;
> +	int n;
> +
> +	while (*s) {
> +		int wlen = strcspn(s, " \t");
> +
> +		if (column + wlen >= max && column > start) {
> +			printf("\n%*s", start, "");
> +			column = start + corr;
> +		}
> +		n = printf("%s%.*s", column > start ? " " : "", wlen, s);
> +		if (n <= 0)
> +			break;
> +		s += wlen;
> +		column += n;
> +		while (isspace(*s))
> +			s++;
> +	}
> +}
> +
> +static int get_columns(void)
> +{
> +	/*
> +	 * Should ask the terminal with TIOCGWINSZ here, but we
> +	 * need the original fd before the pager.
> +	 */
> +	return 79;
>  }
>  
>  void print_pmu_events(const char *event_glob, bool name_only)
> @@ -734,21 +791,24 @@ void print_pmu_events(const char *event_glob, bool name_only)
>  	char buf[1024];
>  	int printed = 0;
>  	int len, j;
> -	char **aliases;
> +	struct pair *aliases;
> +	int numdesc = 0;
> +	int columns = get_columns();
>  
>  	pmu = NULL;
>  	len = 0;
>  	while ((pmu = perf_pmu__scan(pmu)) != NULL)
>  		list_for_each_entry(alias, &pmu->aliases, list)
>  			len++;
> -	aliases = malloc(sizeof(char *) * len);
> +	aliases = malloc(sizeof(struct pair) * len);
>  	if (!aliases)
>  		return;
>  	pmu = NULL;
>  	j = 0;
>  	while ((pmu = perf_pmu__scan(pmu)) != NULL)
>  		list_for_each_entry(alias, &pmu->aliases, list) {
> -			char *name = format_alias(buf, sizeof(buf), pmu, alias);
> +			char *name = alias->desc ? alias->name :
> +				format_alias(buf, sizeof(buf), pmu, alias);
>  			bool is_cpu = !strcmp(pmu->name, "cpu");
>  
>  			if (event_glob != NULL &&
> @@ -756,22 +816,31 @@ void print_pmu_events(const char *event_glob, bool name_only)
>  			      (!is_cpu && strglobmatch(alias->name,
>  						       event_glob))))
>  				continue;
> -			aliases[j] = name;
> -			if (is_cpu && !name_only)
> -				aliases[j] = format_alias_or(buf, sizeof(buf),
> -							      pmu, alias);
> -			aliases[j] = strdup(aliases[j]);
> +			aliases[j].name = name;
> +			if (is_cpu && !name_only && !alias->desc)
> +				aliases[j].name = format_alias_or(buf,
> +								  sizeof(buf),
> +								  pmu, alias);
> +			aliases[j].name = strdup(aliases[j].name);
> +			aliases[j].desc = alias->desc;
>  			j++;
>  		}
>  	len = j;
> -	qsort(aliases, len, sizeof(char *), cmp_string);
> +	qsort(aliases, len, sizeof(struct pair), cmp_pair);
>  	for (j = 0; j < len; j++) {
>  		if (name_only) {
> -			printf("%s ", aliases[j]);
> +			printf("%s ", aliases[j].name);
>  			continue;
>  		}
> -		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
> -		zfree(&aliases[j]);
> +		if (aliases[j].desc) {
> +			if (numdesc++ == 0 && printed)
> +				printf("\n");
> +			printf("  %-50s [", aliases[j].name);
> +			wordwrap(aliases[j].desc, 53, columns, 1);
> +			printf("]\n");
> +		} else
> +			printf("  %-50s [Kernel PMU event]\n", aliases[j].name);
> +		zfree(&aliases[j].name);
>  		printed++;
>  	}
>  	if (printed)
> -- 
> 1.9.3
> 
