Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaD1Esc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:48:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:46676 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbaD1Esa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:48:30 -0400
Message-ID: <1398660478.30694.10.camel@pasglop>
Subject: Re: [PATCH v2 6/6] powerpc/perf/hv-24x7: catalog version number is
 be64, not be32
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com
Date: Mon, 28 Apr 2014 14:47:58 +1000
In-Reply-To: <1397581855-4585-7-git-send-email-cody@linux.vnet.ibm.com>
References: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
	 <1397581855-4585-7-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 10:10 -0700, Cody P Schafer wrote:
> The catalog version number was changed from a be32 (with proceeding
> 32bits of padding) to a be64, update the code to treat it as a be64
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> --

Have you tested this ?

It doesn't build for me:

arch/powerpc/perf/hv-24x7.c: In function 'catalog_read':
arch/powerpc/perf/hv-24x7.c:223:3: error: format '%d' expects argument of type 'int', but argument 2 has type 'uint64_t' [-Werror=format]
cc1: all warnings being treated as errors

I'll fix that up in my tree.

Cheers,
Ben.

>  arch/powerpc/perf/hv-24x7.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
> index 95a67f8..9d4badc 100644
> --- a/arch/powerpc/perf/hv-24x7.c
> +++ b/arch/powerpc/perf/hv-24x7.c
> @@ -171,7 +171,7 @@ static unsigned long h_get_24x7_catalog_page_(unsigned long phys_4096,
>  }
>  
>  static unsigned long h_get_24x7_catalog_page(char page[],
> -					     u32 version, u32 index)
> +					     u64 version, u32 index)
>  {
>  	return h_get_24x7_catalog_page_(virt_to_phys(page),
>  					version, index);
> @@ -185,7 +185,7 @@ static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
>  	ssize_t ret = 0;
>  	size_t catalog_len = 0, catalog_page_len = 0, page_count = 0;
>  	loff_t page_offset = 0;
> -	uint32_t catalog_version_num = 0;
> +	uint64_t catalog_version_num = 0;
>  	void *page = kmem_cache_alloc(hv_page_cache, GFP_USER);
>  	struct hv_24x7_catalog_page_0 *page_0 = page;
>  	if (!page)
> @@ -197,7 +197,7 @@ static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
>  		goto e_free;
>  	}
>  
> -	catalog_version_num = be32_to_cpu(page_0->version);
> +	catalog_version_num = be64_to_cpu(page_0->version);
>  	catalog_page_len = be32_to_cpu(page_0->length);
>  	catalog_len = catalog_page_len * 4096;
>  
> @@ -255,7 +255,7 @@ e_free:								\
>  static DEVICE_ATTR_RO(_name)
>  
>  PAGE_0_ATTR(catalog_version, "%lld\n",
> -		(unsigned long long)be32_to_cpu(page_0->version));
> +		(unsigned long long)be64_to_cpu(page_0->version));
>  PAGE_0_ATTR(catalog_len, "%lld\n",
>  		(unsigned long long)be32_to_cpu(page_0->length) * 4096);
>  static BIN_ATTR_RO(catalog, 0/* real length varies */);


