Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3DAUaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:30:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab3DAU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:29:57 -0400
Date: Mon, 1 Apr 2013 22:29:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 5/9] perf sort: Separate out memory-specific sort keys
Message-ID: <20130401202937.GA1022@krava.redhat.com>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
 <1364816125-12212-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364816125-12212-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 08:35:21PM +0900, Namhyung Kim wrote:

SNIP

> +
>  int sort_dimension__add(const char *tok)
>  {
>  	unsigned int i;
> @@ -964,6 +971,33 @@ int sort_dimension__add(const char *tok)
>  		return 0;
>  	}
>  
> +	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++) {
> +		struct sort_dimension *sd = &memory_sort_dimensions[i];
> +
> +		if (strncasecmp(tok, sd->name, strlen(tok)))
> +			continue;
> +
> +		if (sort__mode != SORT_MODE__MEMORY)
> +			return -EINVAL;
> +
> +		if (sd->entry == &sort_mem_daddr_sym)
> +			sort__has_sym = 1;
> +
> +		if (sd->taken)
> +			return 0;
> +
> +		if (sd->entry->se_collapse)
> +			sort__need_collapse = 1;
> +
> +		if (list_empty(&hist_entry__sort_list))
> +			sort__first_dimension = i + __SORT_MEMORY_MODE;
> +
> +		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
> +		sd->taken = 1;
> +
> +		return 0;

nice idea, I wonder some of the above code be put into function
and used also in previous loop, no big deal though

jirka
