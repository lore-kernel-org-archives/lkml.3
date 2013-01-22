Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3AVH3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:29:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:5169 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab3AVH3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:29:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,512,1355126400"; 
   d="scan'208";a="193821066"
Message-ID: <1358839767.12502.44.camel@smile>
Subject: Re: [PATCH] lib: vsprintf: Add %pa format specifier for phys_addr_t
 types
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>, mingo@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Tue, 22 Jan 2013 09:29:27 +0200
In-Reply-To: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>
References: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 21:47 -0800, Stepan Moskovchenko wrote: 
> Add the %pa format specifier for printing a phys_addr_t
> type, since the physical address size on some platforms
> can vary based on build options, regardless of the native
> integer type.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
>  Documentation/printk-formats.txt |   13 ++++++++++---
>  lib/vsprintf.c                   |    7 +++++++
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 8ffb274..dbc977b 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -53,6 +53,13 @@ Struct Resources:
>  	For printing struct resources. The 'R' and 'r' specifiers result in a
>  	printed resource with ('R') or without ('r') a decoded flags member.
> 
> +Physical addresses:
> +
> +	%pa	0x01234567 or 0x0123456789abcdef
> +
> +	For printing a phys_addr_t type, which can vary based on build options,
> +	regardless of the width of the CPU data path. Passed by reference.
> +
>  Raw buffer as a hex string:
>  	%*ph	00 01 02  ...  3f
>  	%*phC	00:01:02: ... :3f
> @@ -150,9 +157,9 @@ s64 SHOULD be printed with %lld/%llx, (long long):
>  	printk("%lld", (long long)s64_var);
> 
>  If <type> is dependent on a config option for its size (e.g., sector_t,
> -blkcnt_t, phys_addr_t, resource_size_t) or is architecture-dependent
> -for its size (e.g., tcflag_t), use a format specifier of its largest
> -possible type and explicitly cast to it.  Example:
> +blkcnt_t, resource_size_t) or is architecture-dependent for its size (e.g.,

resource_size_t is a typedef of phys_addr_t.

Probably you should mention that your change related to the phys_addr_t
*and* derivatives.

> +tcflag_t), use a format specifier of its largest possible type and explicitly
> +cast to it.  Example:
> 
>  	printk("test: sector number/total blocks: %llu/%llu\n",
>  		(unsigned long long)sector, (unsigned long long)blockcount);
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 39c99fe..9b02a71 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1022,6 +1022,7 @@ int kptr_restrict __read_mostly;
>   *              N no separator
>   *            The maximum supported length is 64 bytes of the input. Consider
>   *            to use print_hex_dump() for the larger input.
> + * - 'a' For a phys_addr_t type (passed by reference)
>   *
>   * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>   * function pointers are really function descriptors, which contain a
> @@ -1112,6 +1113,12 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  			return netdev_feature_string(buf, end, ptr, spec);
>  		}
>  		break;
> +	case 'a':
> +		spec.flags |= SPECIAL | SMALL | ZEROPAD;
> +		spec.field_width = sizeof(phys_addr_t) * 2;
> +		spec.base = 16;
> +		return number(buf, end,
> +			      (unsigned long long) *((phys_addr_t *)ptr), spec);
>  	}
>  	spec.flags |= SMALL;
>  	if (spec.field_width == -1) {
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
