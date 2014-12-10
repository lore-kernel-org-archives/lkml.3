Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaLJJJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:09:13 -0500
Received: from ozlabs.org ([103.22.144.67]:37543 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaLJJJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:09:11 -0500
Message-ID: <1418202549.9279.0.camel@ellerman.id.au>
Subject: Re: [PATCH 1/2] perf/powerpc/hv-24x7: Use per-cpu page buffer
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, dev@codyps.com, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Date: Wed, 10 Dec 2014 20:09:09 +1100
In-Reply-To: <20141210070637.GA27377@us.ibm.com>
References: <20141210070637.GA27377@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 23:06 -0800, Sukadev Bhattiprolu wrote:
> From 470c16c8955672103a9529c78dffbb239e9e27b8 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Tue, 9 Dec 2014 22:17:46 -0500
> Subject: [PATCH 1/2] perf/poweprc/hv-24x7: Use per-cpu page buffer
> 
> diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
> index dba3408..18e1f49 100644
> --- a/arch/powerpc/perf/hv-24x7.c
> +++ b/arch/powerpc/perf/hv-24x7.c
> @@ -217,11 +217,14 @@ static bool is_physical_domain(int domain)
>  		domain == HV_24X7_PERF_DOMAIN_PHYSICAL_CORE;
>  }
>  
> +DEFINE_PER_CPU(char, hv_24x7_reqb[4096]);
> +DEFINE_PER_CPU(char, hv_24x7_resb[4096]);

Do we need it to be 4K aligned also? I would guess so.

Rather than declaring these as char arrays and then casting below, can you pull
the struct definitions up and then declare the per cpu variables with the
proper type.


>  static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
>  					 u16 lpar, u64 *res,
>  					 bool success_expected)
>  {
> -	unsigned long ret = -ENOMEM;
> +	unsigned long ret;
>  
>  	/*
>  	 * request_buffer and result_buffer are not required to be 4k aligned,
> @@ -243,13 +246,11 @@ static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
>  	BUILD_BUG_ON(sizeof(*request_buffer) > 4096);
>  	BUILD_BUG_ON(sizeof(*result_buffer) > 4096);
>  
> -	request_buffer = kmem_cache_zalloc(hv_page_cache, GFP_USER);
> -	if (!request_buffer)
> -		goto out;
> +	request_buffer = (void *)get_cpu_var(hv_24x7_reqb);
> +	result_buffer = (void *)get_cpu_var(hv_24x7_resb);
>  
> -	result_buffer = kmem_cache_zalloc(hv_page_cache, GFP_USER);
> -	if (!result_buffer)
> -		goto out_free_request_buffer;
> +	memset(request_buffer, 0, 4096);
> +	memset(result_buffer, 0, 4096);

Do we have to memset them? That's not going to speed things up.


cheers


