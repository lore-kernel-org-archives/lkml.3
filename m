Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaINOOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 10:14:18 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57202 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaINOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 10:14:15 -0400
Date: Sun, 14 Sep 2014 15:14:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@acpica.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, robert.moore@intel.com
Subject: Re: [PATCH RFC] x86 early_ioremap: increase FIX_BTMAPS_SLOTS to 8
Message-ID: <20140914141412.GJ18582@console-pimps.org>
References: <20140826090641.GA16550@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826090641.GA16550@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug, at 05:06:41PM, Dave Young wrote:
> 3.16 kernel boot fail with earlyprintk=efi, it keeps scrolling at the
> bottom line of screen.
> 
> Bisected, the first bad commit is below:
> commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> Author: Lv Zheng <lv.zheng@intel.com>
> Date:   Fri Apr 4 12:38:57 2014 +0800
> 
>     ACPICA: Tables: Fix table checksums verification before installation.

[...]

> Quote reply from Lv.zheng about the early ioremap slot usage in this case:
> 
> """
> In early_efi_scroll_up(), 2 mapping entries will be used for the src/dst screen buffer.
> In drivers/acpi/acpica/tbutils.c, we've improved the early table loading code in acpi_tb_parse_root_table().
> We now need 2 mapping entries:
> 1. One mapping entry is used for RSDT table mapping. Each RSDT entry contains an address for another ACPI table.
> 2. For each entry in RSDP, we need another mapping entry to map the table to perform necessary check/override before installing it.
> 
> When acpi_tb_parse_root_table() prints something through EFI earlyprintk console, we'll have 4 mapping entries used.
> The current 4 slots setting of early_ioremap() seems to be too small for such a use case.
> """
> 
> Thus increase the slot to 8 in this patch to fix this issue.
> boot-time mappings become 512 page with this patch.
 
This analysis and solution makes sense to me, but I was really hoping
for one of the x86 maintainers to ACK the below patch. I'm happy to take
it through the EFI tree if it's not picked up into tip meanwhile.

Also, Dave, it sounds like this should be tagged for stable if the bug
has been around since v3.16?

> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
> I'm not sure if this is ok in 32bit, review and comments are appreciated.
>  arch/x86/include/asm/fixmap.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/include/asm/fixmap.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/fixmap.h
> +++ linux/arch/x86/include/asm/fixmap.h
> @@ -106,14 +106,14 @@ enum fixed_addresses {
>  	__end_of_permanent_fixed_addresses,
>  
>  	/*
> -	 * 256 temporary boot-time mappings, used by early_ioremap(),
> +	 * 512 temporary boot-time mappings, used by early_ioremap(),
>  	 * before ioremap() is functional.
>  	 *
> -	 * If necessary we round it up to the next 256 pages boundary so
> +	 * If necessary we round it up to the next 512 pages boundary so
>  	 * that we can have a single pgd entry and a single pte table:
>  	 */
>  #define NR_FIX_BTMAPS		64
> -#define FIX_BTMAPS_SLOTS	4
> +#define FIX_BTMAPS_SLOTS	8
>  #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
>  	FIX_BTMAP_END =
>  	 (__end_of_permanent_fixed_addresses ^


-- 
Matt Fleming, Intel Open Source Technology Center
