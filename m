Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3LROLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:11:10 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50031 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab3LROLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:11:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="83493635"
Date: Wed, 18 Dec 2013 14:10:32 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 01/12] xen/p2m: Check for auto-xlat when
 doing mfn_to_local_pfn.
In-Reply-To: <1387313503-31362-2-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312181410010.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> Most of the functions in page.h are prefaced with
> 	if (xen_feature(XENFEAT_auto_translated_physmap))
> 		return mfn;
> 
> Except the mfn_to_local_pfn. At a first sight, the function
> should work without this patch - as the 'mfn_to_mfn' has
> a similar check. But there are no such check in the
> 'get_phys_to_machine' function - so we would crash in there.
> 
> This fixes it by following the convention of having the
> check for auto-xlat in these static functions.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/include/asm/xen/page.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index b913915..4a092cc 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -167,7 +167,12 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
>   */
>  static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
>  {
> -	unsigned long pfn = mfn_to_pfn(mfn);
> +	unsigned long pfn;
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return mfn;
> +
> +	pfn = mfn_to_pfn(mfn);
>  	if (get_phys_to_machine(pfn) != mfn)
>  		return -1; /* force !pfn_valid() */
>  	return pfn;
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
