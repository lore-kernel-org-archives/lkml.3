Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaCDFTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:19:40 -0500
Received: from ozlabs.org ([203.10.76.45]:60743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbaCDFTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:19:37 -0500
In-Reply-To: <1393535105-7528-3-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        scottwood@freescale.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 02/11] perf: add PMU_FORMAT_RANGE() helper for use by sw-like pmus
Message-Id: <20140304051936.33A712C01AB@ozlabs.org>
Date: Tue,  4 Mar 2014 16:19:36 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-27-02 at 21:04:55 UTC, Cody P Schafer wrote:
> Add PMU_FORMAT_RANGE() and PMU_FORMAT_RANGE_RESERVED() (for reserved
> areas) which generate functions to extract the relevent bits from
> event->attr.config{,1,2} for use by sw-like pmus where the
> 'config{,1,2}' values don't map directly to hardware registers.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  include/linux/perf_event.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index e56b07f..3da5081 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -871,4 +871,21 @@ _name##_show(struct device *dev,					\
>  									\
>  static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
>  
> +#define PMU_FORMAT_RANGE(name, attr_var, bit_start, bit_end)		\
> +PMU_FORMAT_ATTR(name, #attr_var ":" #bit_start "-" #bit_end);		\
> +PMU_FORMAT_RANGE_RESERVED(name, attr_var, bit_start, bit_end)

I really think these should have event in the name.

Someone looking at the code is going to see event_get_foo() and wonder where
that is defined. Grep won't find a definition, tags won't find a definition,
the least you can do is have the macro name give some hint.

> +#define PMU_FORMAT_RANGE_RESERVED(name, attr_var, bit_start, bit_end)	\

It doesn't generate a format attribute.

> +static u64 event_get_##name##_max(void)					\
> +{									\
> +	int bits = (bit_end) - (bit_start) + 1;				\
> +	return ((0x1ULL << (bits - 1ULL)) - 1ULL) |			\
> +		(0xFULL << (bits - 4ULL));				\

What's wrong with:

	(0x1ULL << ((bit_end) - (bit_start) + 1)) - 1ULL;

cheers
