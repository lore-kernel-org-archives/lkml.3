Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaCJPkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:40:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17256 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaCJPkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:40:17 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-1e-531ddcdfaeaf
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCHv2] mm/compaction: Break out of loop on !PageBuddy in
 isolate_freepages_block
Date: Mon, 10 Mar 2014 16:40:02 +0100
Message-id: <6597669.aH5TlWtQEa@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1394130092-25440-1-git-send-email-lauraa@codeaurora.org>
References: <1394130092-25440-1-git-send-email-lauraa@codeaurora.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd37d2SDDU72G1nMWb+GzWJldzOb
	xfbOGewWl3fNYbO4t+Y/q8Xkd88YLWY39jE6sHtc7utl8tj0aRK7R9fbK0weJ2b8ZvE4s+AI
	u8fm09UenzfJBbBHcdmkpOZklqUW6dslcGVceGNQsEig4sG6DrYGxjbeLkZODgkBE4mTy38w
	QthiEhfurWfrYuTiEBJYxCjxatJGdginhUni4rTrrCBVbAJWEhPbV4F1iAhoSMz8OZ8VpIhZ
	4CSjxMaTrWAJYYEkiWkfr7GB2CwCqhKzv88Da+YV0JQ48vEjmC0q4CmxY/tKsBpOATeJ7Wdv
	gPUKCbhKHPsxhwmiXlDix+R7LCA2s4C8xL79U1khbB2J/a3T2CYwCsxCUjYLSdksJGULGJlX
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH/jPpHYyrGiwOMQpwMCrx8Cr2ygYLsSaWFVfm
	HmKU4GBWEuFluwgU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvE
	wSnVwLj+sF+9f8Sephula98+zwk0O7GRea/to9/zWZVnnpu9b+3Z7TWRk+Z+SDq0XVa1ecPu
	Pjd2NnefwLjpB1X3M83a6l8nemzf7u5FTLdXfQkU3mCQNmFevc6mY+fCIi1yalRir00yPrto
	TtWXtmzLX/5zywSUI7/uS2Z9bZB7cqv0gQ9p1o9X7Q9UYinOSDTUYi4qTgQAWMdm8HgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, March 06, 2014 10:21:32 AM Laura Abbott wrote:
> We received several reports of bad page state when freeing CMA pages
> previously allocated with alloc_contig_range:
> 
> <1>[ 1258.084111] BUG: Bad page state in process Binder_A  pfn:63202
> <1>[ 1258.089763] page:d21130b0 count:0 mapcount:1 mapping:  (null) index:0x7dfbf
> <1>[ 1258.096109] page flags: 0x40080068(uptodate|lru|active|swapbacked)
> 
> Based on the page state, it looks like the page was still in use. The page
> flags do not make sense for the use case though. Further debugging showed
> that despite alloc_contig_range returning success, at least one page in the
> range still remained in the buddy allocator.
> 
> There is an issue with isolate_freepages_block. In strict mode (which CMA
> uses), if any pages in the range cannot be isolated,
> isolate_freepages_block should return failure 0. The current check keeps
> track of the total number of isolated pages and compares against the size
> of the range:
> 
>         if (strict && nr_strict_required > total_isolated)
>                 total_isolated = 0;
> 
> After taking the zone lock, if one of the pages in the range is not
> in the buddy allocator, we continue through the loop and do not
> increment total_isolated. If in the last iteration of the loop we isolate
> more than one page (e.g. last page needed is a higher order page), the
> check for total_isolated may pass and we fail to detect that a page was
> skipped. The fix is to bail out if the loop immediately if we are in
> strict mode. There's no benfit to continuing anyway since we need all
> pages to be isolated. Additionally, drop the error checking based on
> nr_strict_required and just check the pfn ranges. This matches with
> what isolate_freepages_range does.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Thanks for catching & fixing this!

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

