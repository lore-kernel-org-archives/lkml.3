Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaGSX2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 19:28:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49772 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756612AbaGSX2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 19:28:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 2/7] ACPICA: Linux: Add stub implementation of ACPICA 64-bit mathematics.
Date: Sun, 20 Jul 2014 01:46:25 +0200
Message-ID: <3777197.HSR7Q9huIS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <01bab2394df93a3064f09d961f4011b62895eef2.1405500886.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1405500886.git.lv.zheng@intel.com> <01bab2394df93a3064f09d961f4011b62895eef2.1405500886.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2014 04:58:00 PM Lv Zheng wrote:
> This patch adds default 64-bit mathematics in aclinux.h using do_div(). As
> do_div() can be used for all Linux architectures, this can also be used as
> stub macros for ACPICA 64-bit mathematics.
> 
> But this is not a performance friendly way, as ACPICA's architecture
> specific division OSL only requires a dividing 64-bit number with a 32-bit
> number implementation, while Linux __div64_32() is not available for all
> build environments. So currently, if an architecture really wants to
> support ACPICA, it must implement its own division OSL.

What does this mean for i386, in particular?

> This is required by the ACPICA header stub support. ACPICA header stubs are
> useful to protect CONFIG_ACPI=n Linux kernel builds where ACPICA headers
> are included. Lv Zheng.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  include/acpi/platform/aclinuxex.h |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/include/acpi/platform/aclinuxex.h b/include/acpi/platform/aclinuxex.h
> index 191e741..568d4b8 100644
> --- a/include/acpi/platform/aclinuxex.h
> +++ b/include/acpi/platform/aclinuxex.h
> @@ -46,6 +46,28 @@
>  
>  #ifdef __KERNEL__
>  
> +#ifndef ACPI_USE_NATIVE_DIVIDE
> +
> +#ifndef ACPI_DIV_64_BY_32
> +#define ACPI_DIV_64_BY_32(n_hi, n_lo, d32, q32, r32) \
> +	do { \
> +		u64 (__n) = ((u64) n_hi) << 32 | (n_lo); \
> +		(r32) = do_div ((__n), (d32)); \
> +		(q32) = (u32) (__n); \
> +	} while (0)
> +#endif
> +
> +#ifndef ACPI_SHIFT_RIGHT_64
> +#define ACPI_SHIFT_RIGHT_64(n_hi, n_lo) \
> +	do { \
> +		(n_lo) >>= 1; \
> +		(n_lo) |= (((n_hi) & 1) << 31); \
> +		(n_hi) >>= 1; \
> +	} while (0)
> +#endif
> +
> +#endif
> +
>  /*
>   * Overrides for in-kernel ACPICA
>   */
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
