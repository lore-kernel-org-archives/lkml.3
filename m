Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763834Ab3DDRhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:37:08 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59360 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763588Ab3DDRhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:37:06 -0400
Date: Thu, 4 Apr 2013 10:36:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jacob Shin <jacob.shin@amd.com>,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 03/20] x86, ACPI, mm: Kill max_low_pfn_mapped
Message-ID: <20130404173626.GQ9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
 <1362897887-30808-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362897887-30808-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Mar 09, 2013 at 10:44:30PM -0800, Yinghai Lu wrote:
> Now we have arch_pfn_mapped array, and max_low_pfn_mapped should not
> be used anymore.
> 
> User should use arch_pfn_mapped or just 1UL<<(32-PAGE_SHIFT) instead.
> 
> Only user is ACPI_INITRD_TABLE_OVERRIDE, and it should not use that,
> as later accessing is using early_ioremap(). Change to try to 4G below
> and then 4G above.
...
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 586e7e9..c08cdb6 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -624,9 +624,13 @@ void __init acpi_initrd_override(void *data, size_t size)
>  	if (table_nr == 0)
>  		return;
>  
> -	acpi_tables_addr =
> -		memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
> -				       all_tables_size, PAGE_SIZE);
> +	/* under 4G at first, then above 4G */
> +	acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
> +					all_tables_size, PAGE_SIZE);
> +	if (!acpi_tables_addr)
> +		acpi_tables_addr = memblock_find_in_range(0,
> +					~(phys_addr_t)0,
> +					all_tables_size, PAGE_SIZE);

So, it's changing the allocation from <=4G to <=4G first and then >4G.
The only explanation given is "as later accessing is using
early_ioremap()", but I can't see why that can be a reason for that.
early_ioremap() doesn't care whether the given physaddr is under 4G or
not, it unconditionally maps it into fixmap, so whether the allocated
address is below or above 4G doesn't make any difference.

Changing the allowed range of the allocation should be a separate
patch.  It has some chance of its own breakage and the change itself
isn't really related to this one.

Please try to elaborate the reasoning behind "why", so that readers of
the description don't have to deduce (oh well, guess) your intentions
behind the changes.  As much as it would help the readers, it'd also
help you even more as you would have had to explicitly write something
like "the table is accessed with early_ioremap() so the address
doesn't need to be restricted under 4G; however, to avoid unnecessary
remappings, first try <= 4G and then > 4G."  Then, you would be
compelled to check whether the statement you explicitly wrote is true,
which isn't in this case and you would also realize that the change
isn't trivial and doesn't really belong with this patch.  By not doing
the due diligence, you're offloading what you should have done to
others, which isn't very nice.

I think the descriptions are better in this posting than the last time
but it's still lacking, so, please putfff more effort into describing
the changes and reasoning behind them.

Thanks.

-- 
tejun
