Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKGNEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:04:15 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:14323 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaKGNEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:04:13 -0500
X-IronPort-AV: E=Sophos;i="5.07,332,1413244800"; 
   d="scan'208";a="190544217"
Message-ID: <545CC349.8020006@citrix.com>
Date: Fri, 7 Nov 2014 13:04:09 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V2 2/5] xen: Delay m2p_override initialization
References: <1415252853-7106-1-git-send-email-jgross@suse.com> <1415252853-7106-3-git-send-email-jgross@suse.com>
In-Reply-To: <1415252853-7106-3-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/14 05:47, Juergen Gross wrote:
> The m2p overrides are used to be able to find the local pfn for a
> foreign mfn mapped into the domain. They are used by driver backends
> having to access frontend data.
> 
> As this functionality isn't used in early boot it makes no sense to
> initialize the m2p override functions very early. It can be done
> later without doing any harm, removing the need for allocating memory
> via extend_brk().
> 
> While at it make some m2p override functions static as they are only
> used internally.
[...]
>  		}
>  		/* This should be the leafs allocated for identity from _brk. */
>  	}
> -	return (unsigned long)mfn_list;
>  
> +	m2p_override_init();
> +	return (unsigned long)mfn_list;
>  }
>  #else
>  unsigned long __init xen_revector_p2m_tree(void)
>  {
>  	use_brk = 0;
> +	m2p_override_init();
>  	return 0;
>  }

This is mentioned in the description...

>  #endif
> @@ -794,15 +794,16 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  #define M2P_OVERRIDE_HASH_SHIFT	10
>  #define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
>  
> -static RESERVE_BRK_ARRAY(struct list_head, m2p_overrides, M2P_OVERRIDE_HASH);
> +static struct list_head *m2p_overrides;
>  static DEFINE_SPINLOCK(m2p_override_lock);
>  
>  static void __init m2p_override_init(void)
>  {
>  	unsigned i;
>  
> -	m2p_overrides = extend_brk(sizeof(*m2p_overrides) * M2P_OVERRIDE_HASH,
> -				   sizeof(unsigned long));
> +	m2p_overrides = alloc_bootmem_align(
> +				sizeof(*m2p_overrides) * M2P_OVERRIDE_HASH,
> +				sizeof(unsigned long));

...as is this.

> -int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
> -			    struct gnttab_map_grant_ref *kmap_ops,
> -			    struct page **pages, unsigned int count)
> -{
> -	int i, ret = 0;
> -	bool lazy = false;
> -	pte_t *pte;
> -
> -	if (xen_feature(XENFEAT_auto_translated_physmap))
> -		return 0;
> -
> -	if (kmap_ops &&
> -	    !in_interrupt() &&
> -	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> -		arch_enter_lazy_mmu_mode();
> -		lazy = true;
> -	}

... but, what's going on here.  What are the rest of these changes?

I suppose this is the "make some functions static" but it's an
unreviewable mess.  If you can't do this with some one line changes
adding "static" and perhaps some forward declarations then please drop
this bit.

David
