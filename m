Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaFYHnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaFYHnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:43:10 -0400
Date: Wed, 25 Jun 2014 09:42:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Maynard Johnson <mpjohn@us.ibm.com>, ulrich.weigand@de.ibm.com,
        Michael Ellerman <michaele@au1.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] powerpc/perf: Adjust callchain based on DWARF
 debug info
Message-ID: <20140625074248.GC1153@krava.brq.redhat.com>
References: <20140625000052.GA4484@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140625000052.GA4484@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 05:00:52PM -0700, Sukadev Bhattiprolu wrote:
> [PATCH v5 1/1] powerpc/perf: Adjust callchain based on DWARF debug info

superflous ^^^

> 
> When saving the callchain on Power, the kernel conservatively saves excess
> entries in the callchain. A few of these entries are needed in some cases
> but not others. We should use the DWARF debug information to determine
> when the entries are  needed.

SNIP

> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 0e5fea9..6221d01 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1291,7 +1291,9 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  	u8 cpumode = PERF_RECORD_MISC_USER;
>  	int chain_nr = min(max_stack, (int)chain->nr);
>  	int i;
> +	int j;
>  	int err;
> +	int skip_idx;
>  
>  	callchain_cursor_reset(&callchain_cursor);
>  
> @@ -1300,14 +1302,26 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  		return 0;
>  	}
>  
> +	/*
> +	 * Based on DWARF debug information, some architectures skip
> +	 * a callchain entry saved by the kernel.
> +	 */
> +	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
> +
>  	for (i = 0; i < chain_nr; i++) {
>  		u64 ip;
>  		struct addr_location al;
>  
>  		if (callchain_param.order == ORDER_CALLEE)
> -			ip = chain->ips[i];
> +			j = i;
>  		else
> -			ip = chain->ips[chain->nr - i - 1];
> +			j = chain->nr - i - 1;
> +
> +#ifdef HAVE_SKIP_CALLCHAIN_IDX
> +		if (j == skip_idx)
> +			continue;
> +#endif
> +		ip = chain->ips[j];
>  
>  		if (ip >= PERF_CONTEXT_MAX) {
>  			switch (ip) {
> -- 
> 1.7.9.5
> 

got following compile error:

  CC       util/map.o
util/machine.c: In function ‘machine__resolve_callchain_sample’:
util/machine.c:1286:6: error: variable ‘skip_idx’ set but not used [-Werror=unused-but-set-variable]
  int skip_idx;
      ^
cc1: all warnings being treated as errors
make[2]: *** [util/machine.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [all] Error 2
  test: test -x ./perf
make: *** [make_pure] Error 1


you could use __maybe_unused for the 'skip_idx'

jirka
