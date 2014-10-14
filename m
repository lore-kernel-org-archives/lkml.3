Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaJNJaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:30:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41226 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaJNJaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:30:21 -0400
X-IronPort-AV: E=Sophos;i="5.04,716,1406592000"; 
   d="scan'208";a="182237098"
Message-ID: <543CED29.4050905@citrix.com>
Date: Tue, 14 Oct 2014 10:30:17 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen: avoid writing to freed memory after
 race in p2m handling
References: <1413277218-11437-1-git-send-email-jgross@suse.com>
In-Reply-To: <1413277218-11437-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/14 10:00, Juergen Gross wrote:
> In case a race was detected during allocation of a new p2m tree
> element in alloc_p2m() the new allocated mid_mfn page is freed without
> updating the pointer to the found value in the tree. This will result
> in overwriting the just freed page with the mfn of the p2m leaf.

Can this race actually happen?  i.e., does this need tagging for stable?

David

> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -566,6 +566,7 @@ static bool alloc_p2m(unsigned long pfn)
>  		/* Separately check the mid mfn level */
>  		unsigned long missing_mfn;
>  		unsigned long mid_mfn_mfn;
> +		unsigned long old_mfn;
>  
>  		mid_mfn = alloc_p2m_page();
>  		if (!mid_mfn)
> @@ -575,10 +576,13 @@ static bool alloc_p2m(unsigned long pfn)
>  
>  		missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
>  		mid_mfn_mfn = virt_to_mfn(mid_mfn);
> -		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
> +		old_mfn = cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn);
> +		if (old_mfn != missing_mfn) {
>  			free_p2m_page(mid_mfn);
> -		else
> +			mid_mfn = mfn_to_virt(old_mfn);
> +		} else {
>  			p2m_top_mfn_p[topidx] = mid_mfn;
> +		}
>  	}
>  
>  	if (p2m_top[topidx][mididx] == p2m_identity ||
> 

