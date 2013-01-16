Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3APBet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:34:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50803 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab3APBes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:34:48 -0500
Message-ID: <50F603AC.90005@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 17:34:36 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 15/17] mm/page_alloc: add informative debugging message
 in page_outside_zone_boundaries()
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com> <1358295894-24167-16-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1358295894-24167-16-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011601-5406-0000-0000-0000043F17AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 04:24 PM, Cody P Schafer wrote:
> Add a debug message which prints when a page is found outside of the
> boundaries of the zone it should belong to. Format is:
> 	"page $pfn outside zone [ $start_pfn - $end_pfn ]"

I'd make sure to say 'pfn' here, just to make sure that it's explicitly
stated to be a pfn and not a 'struct page'

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f8ed277..f1783cf 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -239,13 +239,20 @@ static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
>  	int ret = 0;
>  	unsigned seq;
>  	unsigned long pfn = page_to_pfn(page);
> +	unsigned long sp, start_pfn;

I think calling this zone_spanned is probably just fine.  Shouldn't take
up too much room.

>  	do {
>  		seq = zone_span_seqbegin(zone);
> +		start_pfn = zone->zone_start_pfn;
> +		sp = zone->spanned_pages;
>  		if (!zone_spans_pfn(zone, pfn))
>  			ret = 1;
>  	} while (zone_span_seqretry(zone, seq));
> 
> +	if (ret)
> +		pr_debug("page %lu outside zone [ %lu - %lu ]\n",
> +			pfn, start_pfn, start_pfn + sp);
> +
>  	return ret;
>  }

Is there a way we could also fit in something to disambiguate the zones?
 I can imagine a scenario where two zones might have identical
start/spanned_pages, so they might be impossible to tell apart in a
message like this.  Maybe we could add the NUMA node or the
DMA/Normal/Highmem text?

