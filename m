Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaLRAZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:25:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:63415 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaLRAZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:25:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,597,1413270000"; 
   d="scan'208";a="625607391"
Message-ID: <54921EF2.9070004@intel.com>
Date: Wed, 17 Dec 2014 16:25:22 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Glenn Williamson <glenn.p.williamson@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
References: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 01:47 PM, Fenghua Yu wrote:
> +static inline pgd_t *_pgd_alloc(void)
> +{
> +#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
> +	return kmalloc(sizeof(pgdval_t) * PTRS_PER_PGD, PGALLOC_GFP);
> +#else
> +	return (pgd_t *)__get_free_page(PGALLOC_GFP);
> +#endif
> +}

I'm looking at:

	"Figure 4-7. Formats of CR3 and Paging-Structure Entries with
	 PAE Paging"

in the SDM.  It makes it pretty clear that the lower 5 bits of cr3 are
ignored in PAE mode.  That means we have to be 32-byte (or greater)
aligned, right?  Does kmalloc() guarantee that?

IOW, do *ALL* of the sl*b allocators in all of their forms with all of
their debugging options guarantee 32-byte alignment when allocating
256-byte objects?

I know we at least try to align to a cacheline, which would be good
enough, but I'm fuzzy on what we *guarantee*.
