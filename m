Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaIFTjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaIFTjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:39:15 -0400
Date: Sat, 6 Sep 2014 21:39:09 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH v4 3/3] perf tools: Add support to new style format of
 kernel PMU event
Message-ID: <20140906193909.GE6059@krava.brq.redhat.com>
References: <1409671770-17260-1-git-send-email-kan.liang@intel.com>
 <1409671770-17260-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409671770-17260-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:29:30AM -0400, kan.liang@intel.com wrote:

SNIP

> +++ b/tools/perf/util/parse-events.y
> @@ -47,6 +47,7 @@ static inc_group_count(struct list_head *list,
>  %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
>  %token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
>  %token PE_ERROR
> +%token PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
>  %type <num> PE_VALUE
>  %type <num> PE_VALUE_SYM_HW
>  %type <num> PE_VALUE_SYM_SW
> @@ -58,6 +59,7 @@ static inc_group_count(struct list_head *list,
>  %type <str> PE_MODIFIER_EVENT
>  %type <str> PE_MODIFIER_BP
>  %type <str> PE_EVENT_NAME
> +%type <str> PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
>  %type <num> value_sym
>  %type <head> event_config
>  %type <term> event_term
> @@ -210,6 +212,46 @@ PE_NAME '/' event_config '/'
>  	parse_events__free_terms($3);
>  	$$ = list;
>  }
> +|
> +PE_KERNEL_PMU_EVENT
> +{
> +	struct parse_events_evlist *data = _data;
> +	struct list_head *head = malloc(sizeof(*head));

could you please use ALLOC_LIST(head) ?

> +	struct parse_events_term *term;
> +	struct list_head *list;
> +
> +	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> +					$1, 1));
> +	ABORT_ON(!head);
> +	INIT_LIST_HEAD(head);
> +	list_add_tail(&term->list, head);
> +
> +	ALLOC_LIST(list);
> +	ABORT_ON(parse_events_add_pmu(list, &data->idx, "cpu", head));
> +	parse_events__free_terms(head);
> +	$$ = list;
> +}
> +|
> +PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF
> +{
> +	struct parse_events_evlist *data = _data;
> +	struct list_head *head = malloc(sizeof(*head));

same here

thanks,
jirka
