Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab3B1RCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 12:02:12 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47188 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3B1RCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 12:02:08 -0500
Message-ID: <512F8D8B.3070307@suse.cz>
Date: Thu, 28 Feb 2013 18:02:03 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: kswapd craziness round 2
References: <5121C7AF.2090803@numascale-asia.com> <CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com> <51254AD2.7000906@suse.cz> <CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com>
In-Reply-To: <CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 01:07 PM, Hillf Danton wrote:
> On Thu, Feb 21, 2013 at 6:14 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>>
>>> Does Ingo's revert help? https://lkml.org/lkml/2013/2/15/168
>>
>> Not at all...
>>
> Then mind taking a try?

Ok, no difference, kswap is still crazy. I'm attaching the output of
"grep -vw '0' /proc/vmstat" if you see something there.

> --- a/mm/vmscan.c	Thu Feb 21 20:01:02 2013
> +++ b/mm/vmscan.c	Thu Feb 21 20:05:58 2013
> @@ -1715,7 +1715,7 @@ static void get_scan_count(struct lruvec
>  	 * to swap.  Better start now and leave the - probably heavily
>  	 * thrashing - remaining file pages alone.
>  	 */
> -	if (global_reclaim(sc)) {
> +	if (global_reclaim(sc) && sc->priority >= DEF_PRIORITY - 2) {
>  		free = zone_page_state(zone, NR_FREE_PAGES);
>  		if (unlikely(file + free <= high_wmark_pages(zone))) {
>  			scan_balance = SCAN_ANON;
> @@ -2840,9 +2840,10 @@ out:
>  		 * reclaim if they wish.
>  		 */
>  		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
> -			order = sc.order = 0;
> -
> -		goto loop_again;
> +			if (order != 0) {
> +				sc.order = order = 0;
> +				goto loop_again;
> +			}
>  	}
> 
>  	/*


nr_free_pages 36767
nr_inactive_anon 209253
nr_active_anon 1000355
nr_inactive_file 130500
nr_active_file 82677
nr_anon_pages 781334
nr_mapped 94443
nr_file_pages 554906
nr_dirty 29
nr_slab_reclaimable 13104
nr_slab_unreclaimable 9202
nr_page_table_pages 11694
nr_kernel_stack 477
nr_vmscan_write 114
nr_vmscan_immediate_reclaim 831
nr_shmem 341734
nr_dirtied 13492560
nr_written 13388832
nr_anon_transparent_hugepages 169
nr_dirty_threshold 20063
nr_dirty_background_threshold 10031
pgpgin 29026221
pgpgout 55166319
pgalloc_dma 256
pgalloc_dma32 75887179
pgalloc_normal 127591749
pgfree 212204191
pgactivate 5665900
pgdeactivate 1370274
pgfault 130946292
pgmajfault 91443
pgrefill_dma32 582854
pgrefill_normal 1140727
pgsteal_kswapd_dma32 6244454
pgsteal_kswapd_normal 6341734
pgsteal_direct_dma32 1209055
pgsteal_direct_normal 2280164
pgscan_kswapd_dma32 6271350
pgscan_kswapd_normal 6403760
pgscan_direct_dma32 1213349
pgscan_direct_normal 2300634
pginodesteal 190690
slabs_scanned 5139200
kswapd_inodesteal 456779
kswapd_low_wmark_hit_quickly 5042
kswapd_high_wmark_hit_quickly 156125
pageoutrun 170524
allocstall 32073
pgrotated 1321
pgmigrate_success 890843
pgmigrate_fail 282
compact_migrate_scanned 7776871
compact_free_scanned 565089036
compact_isolated 10590951
compact_stall 3114
compact_fail 2675
compact_success 439
unevictable_pgs_culled 658
unevictable_pgs_rescued 5309
unevictable_pgs_mlocked 5309
unevictable_pgs_munlocked 5309
thp_fault_alloc 6071
thp_fault_fallback 34735
thp_collapse_alloc 1817
thp_collapse_alloc_failed 2822
thp_split 292
thp_zero_page_alloc 2
thp_zero_page_alloc_failed 243

thanks,
-- 
js
suse labs
