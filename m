Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaIKIvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbaIKIvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:51:48 -0400
Date: Thu, 11 Sep 2014 10:51:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH V5 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140911085143.GB7326@krava.brq.redhat.com>
References: <1410371732-1185-1-git-send-email-kan.liang@intel.com>
 <1410371732-1185-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410371732-1185-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:55:31PM -0400, kan.liang@intel.com wrote:

SNIP

> +	struct perf_pmu_event_symbol *pmu2 =
> +			(struct perf_pmu_event_symbol *) p2;
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
> +	while ((pmu = perf_pmu__scan(pmu)) != NULL)
> +		list_for_each_entry(alias, &pmu->aliases, list) {
> +			if (!strcmp(pmu->name, "cpu")) {
> +				if (strchr(alias->name, '-'))
> +					len++;
> +				len++;
> +			}
> +	}
> +	if (len == 0)
> +		return;

s oif 'len' is 0 we will scan all the time? maybe we want some
separate 'init' variable..


> +	perf_pmu_events_list =
> +		malloc(sizeof(struct perf_pmu_event_symbol) * len);
> +	perf_pmu_events_list_num = len;
> +
> +	pmu = NULL;
> +	len = 0;

SNIP

> +	qsort(perf_pmu_events_list, len,
> +		sizeof(struct perf_pmu_event_symbol), comp_pmu);
> +
> +}
> +
> +static void perf_pmu__parse_cleanup(void)
> +{
> +	if (!perf_pmu_events_list_num) {

should this be 'if (perf_pmu_events_list_num)' ?

could you also please write automated test for this feature?

thanks,
jirka

> +		struct perf_pmu_event_symbol *p;
> +		size_t i;
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

SNIP
