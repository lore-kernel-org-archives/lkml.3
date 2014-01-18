Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaARVBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 16:01:48 -0500
Received: from smtp.citrix.com ([66.165.176.89]:31636 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaARVBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 16:01:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,681,1384300800"; 
   d="scan'208";a="94189308"
Message-ID: <52DAEBB1.2050405@citrix.com>
Date: Sat, 18 Jan 2014 21:01:37 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: Re: [PATCH v2 1/2] xen/grant-table: Avoid m2p_override during mapping
References: <1389640119-7936-1-git-send-email-zoltan.kiss@citrix.com> <1389640119-7936-2-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1389640119-7936-2-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.14.32]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/14 19:08, Zoltan Kiss wrote:
> @@ -284,8 +287,37 @@ static int map_grant_pages(struct grant_map *map)
>   	}
>   
>   	pr_debug("map %d+%d\n", map->index, map->count);
> -	err = gnttab_map_refs(map->map_ops, use_ptemod ? map->kmap_ops : NULL,
> -			map->pages, map->count);
> +	err = gnttab_map_refs(map->map_ops, NULL, map->pages, map->count);
> +	if (err)
> +		return err;
> +
> +	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> +		arch_enter_lazy_mmu_mode();
> +		lazy = true;
> +	}
> +
> +	for (i = 0; i < map->count; i++) {
> +		/* Do not add to override if the map failed. */
> +		if (map->map_ops[i].status)
> +			continue;
> +
> +		if (map->map_ops[i].flags & GNTMAP_contains_pte) {
> +			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map->map_ops[i].host_addr)) +
> +				(map->map_ops[i].host_addr & ~PAGE_MASK));
> +			mfn = pte_mfn(*pte);
> +		} else {
> +			mfn = PFN_DOWN(map->map_ops[i].dev_bus_addr);
> +		}
> +		err = m2p_add_override(mfn,
> +				       map->pages[i],
> +				       use_ptemod ? &map->kmap_ops[i] : NULL);
> +		if (err)
> +			break;
> +	}
> +
> +	if (lazy)
> +		arch_leave_lazy_mmu_mode();
> +
>   	if (err)
>   		return err;
>   
>
This patch has a fundamental problem here: we change the pfn in 
gnttab_map_refs, then fetch it in m2p_override again, but then we have a 
different one than we need. This causes Dom0 crash. I will send a new 
version to fix that.

Zoli
