Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3FPE1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:27:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:34725 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3FPE1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:27:22 -0400
Message-ID: <1371356818.21896.114.camel@pasglop>
Subject: Re: [PATCH 2/4] powerpc: Prepare to support kernel handling of
 IOMMU map/unmap
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Sun, 16 Jun 2013 14:26:58 +1000
In-Reply-To: <1370412673-1345-3-git-send-email-aik@ozlabs.ru>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-3-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#if defined(CONFIG_SPARSEMEM_VMEMMAP) || defined(CONFIG_FLATMEM)
> +int realmode_get_page(struct page *page)
> +{
> +	if (PageCompound(page))
> +		return -EAGAIN;
> +
> +	get_page(page);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(realmode_get_page);
> +
> +int realmode_put_page(struct page *page)
> +{
> +	if (PageCompound(page))
> +		return -EAGAIN;
> +
> +	if (!atomic_add_unless(&page->_count, -1, 1))
> +		return -EAGAIN;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(realmode_put_page);
> +#endif

Several worries here, mostly that if the generic code ever changes
(something gets added to get_page() that makes it no-longer safe for use
in real mode for example, or some other condition gets added to
put_page()), we go out of sync and potentially end up with very hard and
very subtle bugs.

It might be worth making sure that:

 - This is reviewed by some generic VM people (and make sure they
understand why we need to do that)

 - A comment is added to get_page() and put_page() to make sure that if
they are changed in any way, dbl check the impact on our
realmode_get_page() (or "ping" us to make sure things are still ok).

Cheers,
Ben.


