Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaIWFqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:46:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbaIWFqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:46:31 -0400
Message-ID: <54210932.5010605@suse.com>
Date: Tue, 23 Sep 2014 07:46:26 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, akpm@linux-foundation.org, arnd@arndb.de
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v3 1/5] x86, mm, pat: Set WT to PA7 slot of PAT MSR
References: <1410983321-15162-1-git-send-email-toshi.kani@hp.com> <1410983321-15162-2-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1410983321-15162-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 09:48 PM, Toshi Kani wrote:
> This patch sets WT to the PA7 slot in the PAT MSR when the processor
> is not affected by the PAT errata.  The PA7 slot is chosen to further
> minimize the risk of using the PAT bit as the PA3 slot is UC and is
> not currently used.
>
> The following Intel processors are affected by the PAT errata.
>
>     errata               cpuid
>     ----------------------------------------------------
>     Pentium 2, A52       family 0x6, model 0x5
>     Pentium 3, E27       family 0x6, model 0x7, 0x8
>     Pentium 3 Xenon, G26 family 0x6, model 0x7, 0x8, 0xa
>     Pentium M, Y26       family 0x6, model 0x9
>     Pentium M 90nm, X9   family 0x6, model 0xd
>     Pentium 4, N46       family 0xf, model 0x0
>
> Instead of making sharp boundary checks, this patch makes conservative
> checks to exclude all Pentium 2, 3, M and 4 family processors.  For
> such processors, _PAGE_CACHE_MODE_WT is redirected to UC- per the
> default setup in __cachemode2pte_tbl[].
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Reviewed-by: Juergen Gross <jgross@suse.com>

> ---
>   arch/x86/mm/pat.c |   64 +++++++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 49 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index ff31851..db687c3 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -133,6 +133,7 @@ void pat_init(void)
>   {
>   	u64 pat;
>   	bool boot_cpu = !boot_pat_state;
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
>
>   	if (!pat_enabled)
>   		return;
> @@ -153,21 +154,54 @@ void pat_init(void)
>   		}
>   	}
>
> -	/* Set PWT to Write-Combining. All other bits stay the same */
> -	/*
> -	 * PTE encoding used in Linux:
> -	 *      PAT
> -	 *      |PCD
> -	 *      ||PWT
> -	 *      |||
> -	 *      000 WB		_PAGE_CACHE_WB
> -	 *      001 WC		_PAGE_CACHE_WC
> -	 *      010 UC-		_PAGE_CACHE_UC_MINUS
> -	 *      011 UC		_PAGE_CACHE_UC
> -	 * PAT bit unused
> -	 */
> -	pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
> -	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
> +	if ((c->x86_vendor == X86_VENDOR_INTEL) &&
> +	    (((c->x86 == 0x6) && (c->x86_model <= 0xd)) ||
> +	     ((c->x86 == 0xf) && (c->x86_model <= 0x6)))) {
> +		/*
> +		 * PAT support with the lower four entries. Intel Pentium 2,
> +		 * 3, M, and 4 are affected by PAT errata, which makes the
> +		 * upper four entries unusable.  We do not use the upper four
> +		 * entries for all the affected processor families for safe.
> +		 *
> +		 *  PTE encoding used in Linux:
> +		 *      PAT
> +		 *      |PCD
> +		 *      ||PWT  PAT
> +		 *      |||    slot
> +		 *      000    0    WB : _PAGE_CACHE_MODE_WB
> +		 *      001    1    WC : _PAGE_CACHE_MODE_WC
> +		 *      010    2    UC-: _PAGE_CACHE_MODE_UC_MINUS
> +		 *      011    3    UC : _PAGE_CACHE_MODE_UC
> +		 * PAT bit unused
> +		 *
> +		 * NOTE: When WT or WP is used, it is redirected to UC- per
> +		 * the default setup in __cachemode2pte_tbl[].
> +		 */
> +		pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
> +		      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
> +	} else {
> +		/*
> +		 * PAT full support. WT is set to slot 7, which minimizes
> +		 * the risk of using the PAT bit as slot 3 is UC and is
> +		 * currently unused. Slot 4 should remain as reserved.
> +		 *
> +		 *  PTE encoding used in Linux:
> +		 *      PAT
> +		 *      |PCD
> +		 *      ||PWT  PAT
> +		 *      |||    slot
> +		 *      000    0    WB : _PAGE_CACHE_MODE_WB
> +		 *      001    1    WC : _PAGE_CACHE_MODE_WC
> +		 *      010    2    UC-: _PAGE_CACHE_MODE_UC_MINUS
> +		 *      011    3    UC : _PAGE_CACHE_MODE_UC
> +		 *      100    4    <reserved>
> +		 *      101    5    <reserved>
> +		 *      110    6    <reserved>
> +		 *      111    7    WT : _PAGE_CACHE_MODE_WT
> +		 */
> +		pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
> +		      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, WT);
> +	}
>
>   	/* Boot CPU check */
>   	if (!boot_pat_state)
>

