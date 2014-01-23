Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaAWNVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:21:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaAWNVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:21:30 -0500
Date: Thu, 23 Jan 2014 14:21:00 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/5] perf tools: Count filtered entries to total period
 also
Message-ID: <20140123132100.GA1180@krava.brq.redhat.com>
References: <1390433333-15350-1-git-send-email-namhyung@kernel.org>
 <1390433333-15350-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390433333-15350-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:28:49AM +0900, Namhyung Kim wrote:
> Currently if a sample was filtered by command line option, it just
> dropped.  But this affects final output in that the percentage can be
> different since the filtered entries were not included to the total.
> 
> But user might want to see the original percentages when filter
> applied so change the behavior depends on a new symbol_conf.filter_
> relative value in order to be controlled by user later.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

SNIP

> +++ b/tools/perf/util/hist.h
> @@ -14,6 +14,13 @@ struct hist_entry;
>  struct addr_location;
>  struct symbol;
>  
> +enum hist_filter {
> +	HIST_FILTER__DSO,
> +	HIST_FILTER__THREAD,
> +	HIST_FILTER__PARENT,
> +	HIST_FILTER__SYMBOL,
> +};

in thread__find_addr_map we still have:
		...
                if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
                        cpumode == PERF_RECORD_MISC_GUEST_KERNEL) &&
                        !perf_guest)
                        al->filtered = true;
                if ((cpumode == PERF_RECORD_MISC_USER ||
                        cpumode == PERF_RECORD_MISC_KERNEL) &&
                        !perf_host)
                        al->filtered = true;
		...

seems like we need HIST_FILTER__GUEST|HOST

also in machine__resolve_callchain_sample there's old (and superfluos) init:
		...
                al.filtered = false;
                thread__find_addr_location(thread, machine, cpumode,
                                           MAP__FUNCTION, ip, &al);
		...


jirka
