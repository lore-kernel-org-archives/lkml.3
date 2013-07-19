Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab3GSLdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:33:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61049 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989Ab3GSLdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:33:40 -0400
X-AuditID: 9c930179-b7c49ae000000e68-7e-51e9241265d2
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 10/23] perf tools: Introduce swap_header function
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
	<1374083403-14591-11-git-send-email-jolsa@redhat.com>
Date: Fri, 19 Jul 2013 20:33:37 +0900
In-Reply-To: <1374083403-14591-11-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Wed, 17 Jul 2013 19:49:50 +0200")
Message-ID: <87bo5ywzqm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 19:49:50 +0200, Jiri Olsa wrote:
> Introducing swap_header function to make the swapping
> code more clear and extensible.

[SNIP]
>  
> +static int swap_header(struct perf_file_header *header)
> +{
> +	mem_bswap_64(header, offsetof(struct perf_file_header, adds_features));
> +
> +	if (header->size != sizeof(*header)) {
> +		/* Support the previous format */
> +		if (header->size == offsetof(typeof(*header), adds_features))
> +			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
> +		else
> +			return -1;
> +	} else
> +		swap_features(header->adds_features);
> +
> +	return 0;
> +}
> +
>  int perf_file_header__read(struct perf_file_header *header,
>  			   struct perf_header *ph, int fd)
>  {
> @@ -2562,19 +2578,8 @@ int perf_file_header__read(struct perf_file_header *header,
>  		return -1;
>  	}
>  
> -	if (ph->needs_swap) {
> -		mem_bswap_64(header, offsetof(struct perf_file_header,
> -			     adds_features));
> -	}
> -
> -	if (header->size != sizeof(*header)) {
> -		/* Support the previous format */
> -		if (header->size == offsetof(typeof(*header), adds_features))
> -			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
> -		else
> -			return -1;
> -	} else if (ph->needs_swap)
> -		swap_features(header->adds_features);
> +	if (ph->needs_swap && swap_header(header))
> +		return -1;

Doesn't it change existing behavior?  It looks like supporting previous
format on a same endian machines will be removed by this patch.

Thanks,
Namhyung
