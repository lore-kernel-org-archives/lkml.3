Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaABLV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:21:59 -0500
Received: from smtp.citrix.com ([66.165.176.89]:39418 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaABLV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:21:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,590,1384300800"; 
   d="scan'208";a="89190547"
Message-ID: <52C54BD3.30101@citrix.com>
Date: Thu, 2 Jan 2014 11:21:55 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 05/18] xen/mmu/p2m: Refactor the xen_pagetable_init
 code.
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-6-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-6-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> The revector and copying of the P2M only happens when
> !auto-xlat and on 64-bit builds. It is not obvious from
> the code, so lets have seperate 32 and 64-bit functions.
> 
> We also invert the check for auto-xlat to make the code
> flow simpler.
[...]
> @@ -1255,8 +1251,19 @@ static void __init xen_pagetable_init(void)
>  	 * anything at this stage. */
>  	xen_cleanhighmap(MODULES_VADDR, roundup(MODULES_VADDR, PUD_SIZE) - 1);
>  #endif
> -skip:
> +}
> +#else
> +static void __init xen_pagetable_p2m_copy(void)
> +{
> +	/* Nada! */
> +}
>  #endif
> +
> +static void __init xen_pagetable_init(void)
> +{
> +	paging_init();
> +	xen_setup_shared_info();

I would prefer

#ifdef CONFIG_X86_64

> +	xen_pagetable_p2m_copy();

#endif

rather than the empty stub function.  I think this makes it clearer what
is 64-bit specific.

>  	xen_post_allocator_init();
>  }
>  static void xen_write_cr2(unsigned long cr2)

David
