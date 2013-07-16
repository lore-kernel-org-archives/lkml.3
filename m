Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3GPLyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:54:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab3GPLyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:54:02 -0400
Date: Tue, 16 Jul 2013 13:53:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V6 05/12] perf tools: tidy up sample parsing overflow
 checking
Message-ID: <20130716115323.GA9964@krava.brq.redhat.com>
References: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com>
 <1373956698-27540-6-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373956698-27540-6-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:38:11AM +0300, Adrian Hunter wrote:
> The size of data retrieved from a sample event must be
> validated to ensure it does not go past the end of the
> event.  That was being done sporadically and without
> considering integer overflows.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/evsel.c | 102 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 64 insertions(+), 38 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 724b75a..20e2ed9 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -1114,24 +1114,38 @@ static int perf_evsel__parse_id_sample(const struct perf_evsel *evsel,
>  	return 0;
>  }
>  
> -static bool sample_overlap(const union perf_event *event,
> -			   const void *offset, u64 size)
> +static inline bool overflow_one(const void *endp, const void *offset)
>  {
> -	const void *base = event;
> -
> -	if (offset + size > base + event->header.size)
> -		return true;
> +	return offset + sizeof(u64) > endp;
> +}
>  
> -	return false;
> +static inline bool overflow(const void *endp, u16 max_size, const void *offset,
> +			    u64 size)
> +{
> +	return size > max_size || offset + size > endp;

hum, does '(size > max_size)' catch anything that would
not be catched by '(offset + size > endp)' ?

>  }
>  
> +#define OVERFLOW_CHECK_ONE(offset)				\
> +	do {							\
> +		if (overflow_one(endp, (offset)))		\
> +			return -EFAULT;				\
> +	} while (0)
> +
> +#define OVERFLOW_CHECK(offset, size)				\
> +	do {							\
> +		if (overflow(endp, max_size, (offset), (size)))	\
> +			return -EFAULT;				\
> +	} while (0)

I think, it'd be better to have just one overflow check function, like:

static inline bool overflow(const void *endp, const void *offset, u64 size)
{
        return offset + size > endp;
}

#define OVERFLOW_CHECK(offset, size)                            \
        do {                                                    \
                if (overflow(endp, (offset), (size)))           \
                        return -EFAULT;                         \
        } while (0)

#define OVERFLOW_CHECK_u64(offset) OVERFLOW_CHECK(offset, sizeof(u64))

> +
>  int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  			     struct perf_sample *data)
>  {

Hum, I was thinking of making this check more general and
cover also perf_event__synthesize_sample function.. but
looks like it's not needed there..?


>  	u64 type = evsel->attr.sample_type;
> -	u64 regs_user = evsel->attr.sample_regs_user;
>  	bool swapped = evsel->needs_swap;
>  	const u64 *array;
> +	u16 max_size = event->header.size;
> +	const void *endp = (void *)event + max_size;
> +	u64 sz;
>  
>  	/*
>  	 * used for cross-endian analysis. See git commit 65014ab3
> @@ -1153,6 +1167,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  
>  	array = event->sample.array;
>  
> +	/*
> +	 * sample_size is based on PERF_SAMPLE_MASK which includes up to

please prepend ^^^: The evsel's

> +	 * PERF_SAMPLE_PERIOD.  After that overflow_one() or overflow() must be
> +	 * used to check the format does not go past the end of the event.
> +	 */
>  	if (evsel->sample_size + sizeof(event->header) > event->header.size)
>  		return -EFAULT;
>  

thanks,
jirka
