Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966751AbaFRNkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966349AbaFRNj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:39:59 -0400
Date: Wed, 18 Jun 2014 15:39:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Maynard Johnson <mpjohn@us.ibm.com>, Ulrich.Weigand@de.ibm.com,
        michael@ellerman.id.au, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2]: Allow architectures to skip a callchain entry
Message-ID: <20140618133937.GC9865@krava.brq.redhat.com>
References: <20140606032109.GA16600@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606032109.GA16600@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 08:21:09PM -0700, Sukadev Bhattiprolu wrote:

SNIP

> index 7409ac8..3f97cf2 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1288,8 +1288,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  {
>  	u8 cpumode = PERF_RECORD_MISC_USER;
>  	int chain_nr = min(max_stack, (int)chain->nr);
> +	enum chain_order order = callchain_param.order;
>  	int i;
>  	int err;
> +	int skip_idx;
>  
>  	callchain_cursor_reset(&callchain_cursor);
>  
> @@ -1298,14 +1300,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  		return 0;
>  	}
>  
> +	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
> +
>  	for (i = 0; i < chain_nr; i++) {
>  		u64 ip;
>  		struct addr_location al;
>  
> -		if (callchain_param.order == ORDER_CALLEE)
> -			ip = chain->ips[i];
> -		else
> -			ip = chain->ips[chain->nr - i - 1];
> +		ip = next_callchain_ip(chain, order, i, skip_idx);

hum, I still dont see a point of adding new user
enum API (PERF_CONTEXT_IGNORE) when we can just do:

		#ifdef HAVE_SKIP_CALLCHAIN_IDX
			if (idx == skip_idx)
				continue;
		#endif

		if (callchain_param.order == ORDER_CALLEE)
			ip = chain->ips[i];
		else
			ip = chain->ips[chain->nr - i - 1];


jirka

>  
>  		if (ip >= PERF_CONTEXT_MAX) {
>  			switch (ip) {
> @@ -1318,6 +1319,8 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  			case PERF_CONTEXT_USER:
>  				cpumode = PERF_RECORD_MISC_USER;
>  				break;
> +			case PERF_CONTEXT_IGNORE:
> +				break;
>  			default:
>  				pr_debug("invalid callchain context: "
>  					 "%"PRId64"\n", (s64) ip);
> -- 
> 1.7.9.5
> 
