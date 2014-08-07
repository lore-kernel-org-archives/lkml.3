Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaHGEGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:06:02 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:35860 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaHGEGA (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 7 Aug 2014 00:06:00 -0400
Date: Thu, 7 Aug 2014 12:05:43 +0800
From: joeyli <jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Hibernate: check unsafe page should not in e820
 reserved region
Message-ID: <20140807040543.GE26210@linux-rxt1.site>
References: <1407165801-24648-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407165801-24648-1-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts, 

On Mon, Aug 04, 2014 at 11:23:21PM +0800, Lee, Chun-Yi wrote:
> When the machine doesn't well handle the e820 persistent when hibernate
> resuming, then it may causes page fault when writing image to snapshot
> buffer:
> 
> [   17.929495] BUG: unable to handle kernel paging request at ffff880069d4f000
> [   17.933469] IP: [<ffffffff810a1cf0>] load_image_lzo+0x810/0xe40
> [   17.933469] PGD 2194067 PUD 77ffff067 PMD 2197067 PTE 0
> [   17.933469] Oops: 0002 [#1] SMP
> ...
> 
> The ffff880069d4f000 page is in e820 reserved region of resume boot
> kernel:
> 
> [    0.000000] BIOS-e820: [mem 0x0000000069d4f000-0x0000000069e12fff] reserved
> ...
> [    0.000000] PM: Registered nosave memory: [mem 0x69d4f000-0x69e12fff]
> 
> So snapshot.c mark the pfn to forbidden pages map. But, this
> page is also in the memory bitmap in snapshot image because it's an
> original page used by image kernel, so it will also mark as an
> unsafe(free) page in prepare_image().
> 
> That means the page in e820 when resuming mark as "forbidden" and
> "free", it causes get_buffer() treat it as an allocated unsafe page.
> Then snapshot_write_next() return this page to load_image, load_image
> writing content to this address, but this page didn't really allocated
> . So, we got page fault.
> 
> Although the root cause is from BIOS, I think aggressive check and
> significant message in kernel will better then a page fault for
> issue tracking, especially when serial console unavailable.
> 
> This patch adds code in mark_unsafe_pages() for check does free pages in
> nosave region. If so, then it print message and return fault to stop whole
> S4 resume process:
> 
> [    8.166004] PM: Image loading progress:   0%
> [    8.658717] PM: 0x6796c000 in e820 nosave region: [mem 0x6796c000-0x6796cfff]
> [    8.918737] PM: Read 2511940 kbytes in 1.04 seconds (2415.32 MB/s)
> [    8.926633] PM: Error -14 resuming
> [    8.933534] PM: Failed to load hibernation image, recovering.
> 
> v2:
>  + removed empty check of nosave_regions list.
>  + fixed the typo of "region" in code for error message and patch comment.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

I discussed with Vojtech Pavlik for this patch, he raised a situation is:

Maybe e820 changed but image kernel original pages do not fall into new e820 region.
Then the hibernate will recovery success, but later kernel drivers may got problem
when accessing memory. 

My idea is hashing the start/end pfn of each nosave region sequentially, put this
nosave region digest to hibernate header then compare e820 digest in check_header()
when hibernate resuming.

I am developing patch, then we don't need check unsafe page should not in unsave(e820)
regions.


Thanks a lot!
Joey Lee

> ---
>  kernel/power/snapshot.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 4fc5c32..c4b8093 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -954,6 +954,25 @@ static void mark_nosave_pages(struct memory_bitmap *bm)
>  	}
>  }
>  
> +static bool is_nosave_page(unsigned long pfn)
> +{
> +	struct nosave_region *region;
> +
> +	list_for_each_entry(region, &nosave_regions, list) {
> +		if (pfn >= region->start_pfn && pfn < region->end_pfn) {
> +			pr_err("PM: %#010llx in e820 nosave region: "
> +			       "[mem %#010llx-%#010llx]\n",
> +			       (unsigned long long) pfn << PAGE_SHIFT,
> +			       (unsigned long long) region->start_pfn << PAGE_SHIFT,
> +			       ((unsigned long long) region->end_pfn << PAGE_SHIFT)
> +					- 1);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>  /**
>   *	create_basic_memory_bitmaps - create bitmaps needed for marking page
>   *	frames that should not be saved and free page frames.  The pointers
> @@ -2015,7 +2034,7 @@ static int mark_unsafe_pages(struct memory_bitmap *bm)
>  	do {
>  		pfn = memory_bm_next_pfn(bm);
>  		if (likely(pfn != BM_END_OF_MAP)) {
> -			if (likely(pfn_valid(pfn)))
> +			if (likely(pfn_valid(pfn)) && !is_nosave_page(pfn))
>  				swsusp_set_page_free(pfn_to_page(pfn));
>  			else
>  				return -EFAULT;
> -- 
> 1.8.4.5
> 
