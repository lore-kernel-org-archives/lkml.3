Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3AQR6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:58:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab3AQR6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:58:31 -0500
Date: Thu, 17 Jan 2013 18:58:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: acme@ghostprotocols.net, Anton Blanchard <anton@au1.ibm.com>,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] perf: Fix PMU format parsing test failure
Message-ID: <20130117175819.GA6685@krava.brq.redhat.com>
References: <20130117172814.GA18882@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130117172814.GA18882@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 09:28:14AM -0800, Sukadev Bhattiprolu wrote:
> 
> From 776e6d7942754f139c27753213c9cf4617536618 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Thu, 17 Jan 2013 09:11:30 -0800
> Subject: [PATCH] perf; Fix PMU format parsing test failure
> 
> On POWER, the 'perf format parsing' test always fails.
> 
> Looks like it is because memset() is being passed number of longs
> rather than number of bytes. It is interesting that the test always
> passes on my x86 box.

indeed.. not sure how the bison 'union' stuff is (z)allocated,
x86 is probably lucky one ;-)

> 
> With this patch, the test passes on POWER and continues to pass on x86.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  tools/perf/util/include/linux/bitops.h |    1 +
>  tools/perf/util/pmu.c                  |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
> index a55d8cf..45cf10a 100644
> --- a/tools/perf/util/include/linux/bitops.h
> +++ b/tools/perf/util/include/linux/bitops.h
> @@ -14,6 +14,7 @@
>  #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
>  #define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
>  #define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
> +#define BITS_TO_BYTES(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE)
>  
>  #define for_each_set_bit(bit, addr, size) \
>  	for ((bit) = find_first_bit((addr), (size));		\
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 9bdc60c..b93ff14 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -548,7 +548,7 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
>  	if (!to)
>  		to = from;
>  
> -	memset(bits, 0, BITS_TO_LONGS(PERF_PMU_FORMAT_BITS));
> +	memset(bits, 0, BITS_TO_BYTES(PERF_PMU_FORMAT_BITS));
>  	for (b = from; b <= to; b++)
>  		set_bit(b, bits);

oops, nice catch!

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
