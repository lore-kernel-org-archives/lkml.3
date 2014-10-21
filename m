Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaJUCj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:39:26 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57032 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaJUCjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:39:25 -0400
Message-ID: <5445C759.5010300@martingkelly.com>
Date: Mon, 20 Oct 2014 19:39:21 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, rientjes@google.com,
        david.vrabel@citrix.com, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] x86, e820: panic on sanitizing invalid memory map
References: <1413607279-3676-1-git-send-email-martin@martingkelly.com>
In-Reply-To: <1413607279-3676-1-git-send-email-martin@martingkelly.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 09:41 PM, Martin Kelly wrote:
> sanitize_e820_map returns two possible values:
> -1: Returned when either the provided memory map has length 1 (ok) or
>     when the provided memory map is invalid (not ok).
> 0:  Returned when the memory map was correctly sanitized.
> 
> In addition, most code ignores the returned value, and none actually
> handles it (except possibly by panicking).
> 
> This patch changes the behavior so that sanitize_e820_map is a void
> function. When the provided memory map has length 1 or it is sanitized
> (both ok cases), it returns nothing. If the provided memory map is
> invalid, then it panics.
> 
> Signed-off-by: Martin Kelly <martkell@amazon.com>
> ---
>  arch/x86/include/asm/e820.h |  2 +-
>  arch/x86/kernel/e820.c      | 95 ++++++++++++++++++++++-----------------------
>  2 files changed, 47 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> index 779c2ef..739f8db 100644
> --- a/arch/x86/include/asm/e820.h
> +++ b/arch/x86/include/asm/e820.h
> @@ -18,7 +18,7 @@ extern int e820_any_mapped(u64 start, u64 end, unsigned type);
>  extern int e820_all_mapped(u64 start, u64 end, unsigned type);
>  extern void e820_add_region(u64 start, u64 size, int type);
>  extern void e820_print_map(char *who);
> -extern int
> +extern void
>  sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
>  extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
>  			       unsigned new_type);
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 49f8864..96ad559 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -188,47 +188,48 @@ void __init e820_print_map(char *who)
>   * be updated on return, with the new number of valid entries
>   * (something no more than max_nr_map.)
>   *
> - * The return value from sanitize_e820_map() is zero if it
> - * successfully 'sanitized' the map entries passed in, and is -1
> - * if it did nothing, which can happen if either of (1) it was
> - * only passed one map entry, or (2) any of the input map entries
> - * were invalid (start + size < start, meaning that the size was
> - * so big the described memory range wrapped around through zero.)
> + * There are three possible actions that sanitize_e820_map() can take:
> + *	(1) If the map entry count is 1, do nothing and return.
> + *	(2) If any of the input map entries were invalid
> + *          (start + size < start), then the size was so big that the described
> + *          memory range wrapped around through zero. In this case, panic.
> + *	(3) If the map entry count is greater than 1 and the map is valid,
> + *          sanitize the map and return.
>   *
> - *	Visually we're performing the following
> - *	(1,2,3,4 = memory types)...
> + * Visually we're performing the following
> + * (1,2,3,4 = memory types)...
>   *
> - *	Sample memory map (w/overlaps):
> - *	   ____22__________________
> - *	   ______________________4_
> - *	   ____1111________________
> - *	   _44_____________________
> - *	   11111111________________
> - *	   ____________________33__
> - *	   ___________44___________
> - *	   __________33333_________
> - *	   ______________22________
> - *	   ___________________2222_
> - *	   _________111111111______
> - *	   _____________________11_
> - *	   _________________4______
> + * Sample memory map (w/overlaps):
> + *    ____22__________________
> + *    ______________________4_
> + *    ____1111________________
> + *    _44_____________________
> + *    11111111________________
> + *    ____________________33__
> + *    ___________44___________
> + *    __________33333_________
> + *    ______________22________
> + *    ___________________2222_
> + *    _________111111111______
> + *    _____________________11_
> + *    _________________4______
>   *
> - *	Sanitized equivalent (no overlap):
> - *	   1_______________________
> - *	   _44_____________________
> - *	   ___1____________________
> - *	   ____22__________________
> - *	   ______11________________
> - *	   _________1______________
> - *	   __________3_____________
> - *	   ___________44___________
> - *	   _____________33_________
> - *	   _______________2________
> - *	   ________________1_______
> - *	   _________________4______
> - *	   ___________________2____
> - *	   ____________________33__
> - *	   ______________________4_
> + * Sanitized equivalent (no overlap):
> + *    1_______________________
> + *    _44_____________________
> + *    ___1____________________
> + *    ____22__________________
> + *    ______11________________
> + *    _________1______________
> + *    __________3_____________
> + *    ___________44___________
> + *    _____________33_________
> + *    _______________2________
> + *    ________________1_______
> + *    _________________4______
> + *    ___________________2____
> + *    ____________________33__
> + *    ______________________4_
>   */
>  struct change_member {
>  	struct e820entry *pbios; /* pointer to original bios entry */
> @@ -252,7 +253,7 @@ static int __init cpcompare(const void *a, const void *b)
>  	return (ap->addr != ap->pbios->addr) - (bp->addr != bp->pbios->addr);
>  }
>  
> -int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
> +void __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
>  			     u32 *pnr_map)
>  {
>  	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
> @@ -269,15 +270,14 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
>  
>  	/* if there's only one memory region, don't bother */
>  	if (*pnr_map < 2)
> -		return -1;
> +		return;
>  
>  	old_nr = *pnr_map;
>  	BUG_ON(old_nr > max_nr_map);
>  
> -	/* bail out if we find any unreasonable addresses in bios map */
> +	/* panic if we find any unreasonable addresses in bios map */
>  	for (i = 0; i < old_nr; i++)
> -		if (biosmap[i].addr + biosmap[i].size < biosmap[i].addr)
> -			return -1;
> +		BUG_ON(biosmap[i].addr + biosmap[i].size < biosmap[i].addr);
>  
>  	/* create pointers for initial change-point information (for sorting) */
>  	for (i = 0; i < 2 * old_nr; i++)
> @@ -564,8 +564,7 @@ void __init update_e820(void)
>  	u32 nr_map;
>  
>  	nr_map = e820.nr_map;
> -	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
> -		return;
> +	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map);
>  	e820.nr_map = nr_map;
>  	printk(KERN_INFO "e820: modified physical RAM map:\n");
>  	e820_print_map("modified");
> @@ -575,8 +574,7 @@ static void __init update_e820_saved(void)
>  	u32 nr_map;
>  
>  	nr_map = e820_saved.nr_map;
> -	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
> -		return;
> +	sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map);
>  	e820_saved.nr_map = nr_map;
>  }
>  #define MAX_GAP_END 0x100000000ull
> @@ -900,8 +898,7 @@ void __init finish_e820_parsing(void)
>  	if (userdef) {
>  		u32 nr = e820.nr_map;
>  
> -		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
> -			early_panic("Invalid user supplied memory map");
> +		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr);
>  		e820.nr_map = nr;
>  
>  		printk(KERN_INFO "e820: user-defined physical RAM map:\n");
> 

I noticed some compiler warnings from this patch; I fixed them and sent
a revision.
