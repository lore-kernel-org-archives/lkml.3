Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaILTeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:34:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42591 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaILTeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:34:14 -0400
Date: Fri, 12 Sep 2014 15:33:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com
Subject: Re: [PATCH v2 1/6] x86, mm, pat: Set WT to PA4 slot of PAT MSR
Message-ID: <20140912193345.GH15656@laptop.dumpdata.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
 <1410367910-6026-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410367910-6026-2-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


I think having this nice picture would be beneficial to folks
who want to understand it. And now you can of course expand it with
the slot 7 usage.

> -	 * PAT bit unused
> -	 */
> -	pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
> -	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
> +	if ((c->x86_vendor == X86_VENDOR_INTEL) &&
> +	    (((c->x86 == 0x6) && (c->x86_model <= 0xd)) ||
> +	     ((c->x86 == 0xf) && (c->x86_model <= 0x6)))) {
> +		/*
> +		 * Intel Pentium 2, 3, M, and 4 are affected by PAT errata,
> +		 * which makes the upper four entries unusable.  We do not
> +		 * use the upper four entries for all the affected processor
> +		 * families for safe.
> +		 *
> +		 * PAT 0:WB, 1:WC, 2:UC-, 3:UC, 4-7:unusable
> +		 *
> +		 * NOTE: When WT or WP is used, it is redirected to UC- per
> +		 * the default setup in  __cachemode2pte_tbl[].
> +		 */
> +		pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
> +		      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
> +	} else {
> +		/*
> +		 * WT is set to slot 7, which minimizes the risk of using

You say slot 7 here, but the title of the patch says slot 4?

> +		 * the PAT bit as slot 3 is UC and is currently unused.
> +		 * Slot 4 should remain as reserved.
> +		 *
> +		 * PAT 0:WB, 1:WC, 2:UC-, 3:UC, 4-6:reserved, 7:WT
> +		 */
> +		pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
> +		      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, WT);
> +	}
>  
>  	/* Boot CPU check */
>  	if (!boot_pat_state)
