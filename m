Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaBGSmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:42:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:5550 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaBGSmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:42:19 -0500
X-IronPort-AV: E=Sophos;i="4.95,802,1384300800"; 
   d="scan'208";a="99060107"
Message-ID: <52F52908.4080205@citrix.com>
Date: Fri, 7 Feb 2014 18:42:16 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH v8] xen/grant-table: Avoid m2p_override during
 mapping
References: <1391691376-21471-1-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1391691376-21471-1-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/14 12:56, Zoltan Kiss wrote:
> The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
> for blkback and future netback patches it just cause a lock contention, as
> those pages never go to userspace. Therefore this series does the following:
> - the original functions were renamed to __gnttab_[un]map_refs, with a new
>   parameter m2p_override
> - based on m2p_override either they follow the original behaviour, or just set
>   the private flag and call set_phys_to_machine
> - gnttab_[un]map_refs are now a wrapper to call __gnttab_[un]map_refs with
>   m2p_override false
> - a new function gnttab_[un]map_refs_userspace provides the old behaviour
> - it cuts out common parts from m2p_*_override functions to
>   *_foreign_p2m_mapping functions
> 
> It also removes a stray space from page.h and change ret to 0 if
> XENFEAT_auto_translated_physmap, as that is the only possible return value
> there.
> 
> v2:

Please put this version information after the '---' marker.  It doesn't
need to end up in the commit message.

> @@ -955,10 +957,12 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  			set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
>  					map_ops[i].dev_bus_addr >> PAGE_SHIFT);
>  		}
> -		return ret;
> +		return 0;
>  	}
>  
> -	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> +	if (m2p_override &&
> +	    !in_interrupt() &&
> +	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
>  		arch_enter_lazy_mmu_mode();
>  		lazy = true;
>  	}

I think this block and the loop should be in an arch-specific function
(e.g., set_foreign_p2m_mappings(), but I would like to hear Stefano's
opinion.

Similarly for clear_foreign_p2m_mappings().

David
