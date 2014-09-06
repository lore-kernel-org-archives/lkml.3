Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaIFTiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:38:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaIFTiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:38:54 -0400
Date: Sat, 6 Sep 2014 21:38:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH v4 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140906193848.GC6059@krava.brq.redhat.com>
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
> From: Kan Liang <kan.liang@intel.com>

SNIP

> + * Read the pmu events list from sysfs
> + * Save it into kernel_pmu_events_list
> + */
> +static void scan_kernel_pmu_events_list(void)
> +{
> +
> +	struct perf_pmu *pmu = NULL;
> +	struct perf_pmu_alias *alias;
> +	int len = 0;
> +
> +	while ((pmu = perf_pmu__scan(pmu)) != NULL)
> +		list_for_each_entry(alias, &pmu->aliases, list) {

Why do we need to call scan here? Looks like:
  pmu = pmu_lookup("cpu")

should be enough.. and could be used below as well

> +			if (!strcmp(pmu->name, "cpu")) {
> +				if (strchr(alias->name, '-'))
> +					len++;
> +				len++;
> +			}
> +	}
> +	if (len == 0)
> +		return;
> +	kernel_pmu_events_list =
> +		malloc(sizeof(struct kernel_pmu_event_symbol) * len);
> +	kernel_pmu_events_list_num = len;
> +
> +	pmu = NULL;
> +	len = 0;
> +	while ((pmu = perf_pmu__scan(pmu)) != NULL)
> +		list_for_each_entry(alias, &pmu->aliases, list) {
> +			if (!strcmp(pmu->name, "cpu")) {
> +				struct kernel_pmu_event_symbol *p =
> +					kernel_pmu_events_list + len;
> +				char *tmp = strchr(alias->name, '-');
> +
> +				if (tmp != NULL) {
> +					strlcpy(p->symbol, alias->name,
> +						tmp - alias->name + 1);
> +					p->type = KERNEL_PMU_EVENT_PREFIX;
> +					tmp++;
> +					p++;
> +					strcpy(p->symbol, tmp);
> +					p->type = KERNEL_PMU_EVENT_SUFFIX;
> +					len += 2;
> +				} else {
> +					strcpy(p->symbol, alias->name);
> +					p->type = KERNEL_PMU_EVENT;
> +					len++;
> +				}
> +			}
> +		}
> +	qsort(kernel_pmu_events_list, len,
> +		sizeof(struct kernel_pmu_event_symbol), comp_pmu);
> +
> +}

SNIP

thanks,
jirka
