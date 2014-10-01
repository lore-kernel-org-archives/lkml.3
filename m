Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaJABXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 21:23:42 -0400
Received: from ozlabs.org ([103.22.144.67]:58326 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaJABXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 21:23:40 -0400
In-Reply-To: <1411586681-21262-2-git-send-email-sukadev@linux.vnet.ibm.com>
To: sukadev@linux.vnet.ibm.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org,
        eranian@google.com, Paul Mackerras <paulus@samba.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, dev@codyps.com,
        linuxppc-dev@lists.ozlabs.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [v2, 1/4] powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack allocations
Message-Id: <20141001012339.AD06A14021A@ozlabs.org>
Date: Wed,  1 Oct 2014 11:23:39 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-24-09 at 19:24:38 UTC, sukadev@linux.vnet.ibm.com wrote:
> From: Cody P Schafer <cody@linux.vnet.ibm.com>
> 
> Ian pointed out the use of __aligned(4096) caused rather large stack
> consumption in single_24x7_request(), so use the kmem_cache
> hv_page_cache (which we've already got set up for other allocations)
> insead of allocating locally.
> 
> diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
> index 70d4f74..2f2215c 100644
> --- a/arch/powerpc/perf/hv-24x7.c
> +++ b/arch/powerpc/perf/hv-24x7.c
> @@ -294,7 +294,7 @@ static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
>  					 u16 lpar, u64 *res,
>  					 bool success_expected)
>  {
> -	unsigned long ret;
> +	unsigned long ret = -ENOMEM;
>  
>  	/*
>  	 * request_buffer and result_buffer are not required to be 4k aligned,
> @@ -304,7 +304,27 @@ static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
>  	struct reqb {
>  		struct hv_24x7_request_buffer buf;
>  		struct hv_24x7_request req;
> -	} __packed __aligned(4096) request_buffer = {
> +	} __packed * request_buffer;

No space after the * please.

> +	struct resb {

You never use the struct name so this can be anonymous, eg:

	struct {
		struct hv_24x7_data_result_buffer buf;
		...

> +		struct hv_24x7_data_result_buffer buf;
> +		struct hv_24x7_result res;
> +		struct hv_24x7_result_element elem;
> +		__be64 result;
> +	} __packed * result_buffer;

No space again.

> +	BUILD_BUG_ON(sizeof(*request_buffer) > 4096);
> +	BUILD_BUG_ON(sizeof(*result_buffer) > 4096);
> +
> +	request_buffer = kmem_cache_alloc(hv_page_cache, GFP_USER);

Why aren't we using kzalloc here?

It looks like we're initialising everything below except the reserved fields,
but are they allowed to be non-zero? It's probably safer to just kzalloc it.

> +	if (!request_buffer)
> +		goto out_reqb;

If prefer labels to be named for what they do, so this would be just "out".

> +
> +	result_buffer = kmem_cache_zalloc(hv_page_cache, GFP_USER);
> +	if (!result_buffer)
> +		goto out_resb;

And this would be "out_free_request_buffer".

> +
> +	*request_buffer = (struct reqb) {
>  		.buf = {
>  			.interface_version = HV_24X7_IF_VERSION_CURRENT,
>  			.num_requests = 1,
> @@ -320,28 +340,30 @@ static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
>  		}
>  	};
>  
> -	struct resb {
> -		struct hv_24x7_data_result_buffer buf;
> -		struct hv_24x7_result res;
> -		struct hv_24x7_result_element elem;
> -		__be64 result;
> -	} __packed __aligned(4096) result_buffer = {};
> -
>  	ret = plpar_hcall_norets(H_GET_24X7_DATA,
> -			virt_to_phys(&request_buffer), sizeof(request_buffer),
> -			virt_to_phys(&result_buffer),  sizeof(result_buffer));
> +			virt_to_phys(request_buffer), sizeof(*request_buffer),
> +			virt_to_phys(result_buffer),  sizeof(*result_buffer));
>  
>  	if (ret) {
>  		if (success_expected)
>  			pr_err_ratelimited("hcall failed: %d %#x %#x %d => 0x%lx (%ld) detail=0x%x failing ix=%x\n",
>  					domain, offset, ix, lpar,
>  					ret, ret,
> -					result_buffer.buf.detailed_rc,
> -					result_buffer.buf.failing_request_ix);
> -		return ret;
> +					result_buffer->buf.detailed_rc,
> +					result_buffer->buf.failing_request_ix);
> +		goto out_hcall;
>  	}
>  
> -	*res = be64_to_cpu(result_buffer.result);
> +	*res = be64_to_cpu(result_buffer->result);
> +	kfree(result_buffer);
> +	kfree(request_buffer);
> +	return ret;
> +
> +out_hcall:
> +	kfree(result_buffer);
> +out_resb:
> +	kfree(request_buffer);
> +out_reqb:
>  	return ret;
>  }

Wouldn't this be better as:

	*res = be64_to_cpu(result_buffer->result);

out_free_result_buffer:
	kfree(result_buffer);
out_free_request_buffer:
	kfree(request_buffer);
out:
	return ret;
}


cheers
