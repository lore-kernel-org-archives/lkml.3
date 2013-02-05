Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3BEIii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:38:38 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39628 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3BEIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:38:34 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-c4-5110c50872e9
Message-id: <5110C506.2060209@samsung.com>
Date: Tue, 05 Feb 2013 09:38:30 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
MIME-version: 1.0
To: Minchan Kim <minchan@kernel.org>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high memory
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
 <20130204150657.6d05f76a.akpm@linux-foundation.org>
 <CAH9JG2Usd4HJKrBXwX3aEc3i6068zU=F=RjcoQ8E8uxYGrwXgg@mail.gmail.com>
 <20130204234358.GB2610@blaptop>
 <CAH9JG2VDOVv4-QrDs1FeyQNPzEDq+bf+qiSZ0snEqLGSed3PqA@mail.gmail.com>
 <20130205004032.GD2610@blaptop>
In-reply-to: <20130205004032.GD2610@blaptop>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4NV2OowKBBjseMltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6ME093shb0clfMe7+QsYFxLkcXIyeHhICJxM7NLewQtpjEhXvr
	2boYuTiEBJYySky4PJsNJCEksIRJom2OPojNK6AlcWbqHWYQm0VAVeL9gqdgNpuAoUTX2y6w
	elGBUIm1+9YwQ9QLSvyYfI8FxBYRUJH48/QfI8gCZoFZjBIPd35lAkkIC/hLHHnYzgSx+TyT
	xNs3bWAncQroSEzcsxisiFnATOJRyzpmCFteYvOat8wTGIHGICyZhaRsFpKyBYzMqxhFU0uT
	C4qT0nMN9YoTc4tL89L1kvNzNzFCgvDLDsbFx6wOMQpwMCrx8AZe4w8UYk0sK67MPcQowcGs
	JML78QZQiDclsbIqtSg/vqg0J7X4ECMTB6dUA6Pc9jXLyrg87837GfH+Et/0h1l1cQ6SB2Tr
	f+aGLpZj7zjKscE97Ups1am2+8xv2st6dLY+tTKK3ZKm6e7+l3Pv9N2fTO2/R7ecy1De09ts
	935j6+3SifzWa28dd9+z+lBdyXtFtavc09wPergzX+77kz0/Zc/XkIppXaaf78+vbHSY/O/A
	xY1KLMUZiYZazEXFiQBd64GnIAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2/5/2013 1:40 AM, Minchan Kim wrote:

...

> > Previous time, it's not fully tested and now we checked it with
> > highmem support patches.
>
> I get it. Sigh. then [1] inline attached below wan't good.
> We have to code like this?
>
> [1] 6a6dccba, mm: cma: don't replace lowmem pages with highmem
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b97cf12..0707e0a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5671,11 +5671,10 @@ static struct page *
>   __alloc_contig_migrate_alloc(struct page *page, unsigned long private,
>                               int **resultp)
>   {
> -       gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
> -
> -       if (PageHighMem(page))
> -               gfp_mask |= __GFP_HIGHMEM;
> -
> +       gfp_t gfp_mask = GFP_HIGHUSER_MOVABLE;
> +       struct address_space *mapping = page_mapping(page);
> +       if (mapping)
> +               gfp_mask = mapping_gfp_mask(mapping);
>          return alloc_page(gfp_mask);
>   }

Am I right that this code will allocate more pages from himem? Old approach
never migrate lowmem page to himem, what is now possible as gfp mask is 
always
taken from mapping_gfp flags. I only wonder if forcing GFP_HIGHUSER_MOVABLE
for pages without the mapping is a correct. Shouldn't we use avoid himem in
such case?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


