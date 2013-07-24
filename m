Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3GXMvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3GXMvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:51:17 -0400
Date: Wed, 24 Jul 2013 14:50:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V8 13/15] perf tools: expand
 perf_event__synthesize_sample()
Message-ID: <20130724125025.GA4203@krava.brq.redhat.com>
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
 <1374144177-24762-14-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374144177-24762-14-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 01:42:55PM +0300, Adrian Hunter wrote:

SNIP

> @@ -1349,11 +1349,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  }
>  
>  int perf_event__synthesize_sample(union perf_event *event, u64 type,
> +				  u64 sample_regs_user,
>  				  const struct perf_sample *sample,
>  				  bool swapped)
>  {
>  	u64 *array;
> -
> +	size_t sz;
>  	/*
>  	 * used for cross-endian analysis. See git commit 65014ab3
>  	 * for why this goofiness is needed.
> @@ -1426,6 +1427,73 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
>  		array++;
>  	}
>  
> +	if (type & PERF_SAMPLE_READ) {
> +		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
> +		return -1;
> +	}
> +
> +	if (type & PERF_SAMPLE_CALLCHAIN) {
> +		sz = (sample->callchain->nr + 1) * sizeof(u64);
> +		memcpy(array, sample->callchain, sz);
> +		array = (void *)array + sz;
> +	}
> +
> +	if (type & PERF_SAMPLE_RAW) {
> +		u.val32[0] = sample->raw_size;
> +		if (WARN_ONCE(swapped,
> +			      "Endianness of raw data not corrected!\n")) {
> +			/*
> +			 * Inverse of what is done in perf_evsel__parse_sample
> +			 */
> +			u.val32[0] = bswap_32(u.val32[0]);
> +			u.val32[1] = bswap_32(u.val32[1]);
> +			u.val64 = bswap_64(u.val64);
> +		}
> +		*array = u.val64;
> +		array = (void *)array + sizeof(u32);
> +
> +		memcpy(array, sample->raw_data, sample->raw_size);
> +		array = (void *)array + sample->raw_size;
> +	}
> +
> +	if (type & PERF_SAMPLE_BRANCH_STACK) {
> +		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
> +		sz += sizeof(u64);
> +		memcpy(array, sample->branch_stack, sz);
> +		array = (void *)array + sz;
> +	}
> +
> +	if (type & PERF_SAMPLE_REGS_USER) {
> +		if (sample->user_regs.regs && sample_regs_user) {
> +			*array++ = sample_regs_user;

it's 'enum perf_sample_regs_abi' value that goes here ^^^

I guess for now it could be hardcoded like:

#if defined(__x86_64__)
abi = PERF_SAMPLE_REGS_ABI_64
#else
#if defined(__i386__)
abi = PERF_SAMPLE_REGS_ABI_64
#endif
WARN()
#endif


jirka
