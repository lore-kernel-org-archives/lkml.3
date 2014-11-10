Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaKJSlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:41:22 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55757 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaKJSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:41:21 -0500
Date: Mon, 10 Nov 2014 18:41:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 03/13] xen/arm: if(pfn_valid(pfn)) call native dma_ops
Message-ID: <20141110184111.GH25609@e104818-lin.cambridge.arm.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
 <1415636045-24669-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415636045-24669-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 04:13:55PM +0000, Stefano Stabellini wrote:
>  void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
>  		size_t size, enum dma_data_direction dir,
> -		struct dma_attrs *attrs);
> +		struct dma_attrs *attrs)
> +{
> +	unsigned long pfn = PFN_DOWN(handle);
> +	/* Dom0 is mapped 1:1, so calling pfn_valid on a foreign mfn will
> +	 * always return false. If the page is local we can safely call the
> +	 * native dma_ops function, otherwise we call the xen specific
> +	 * function. */
> +	if (pfn_valid(pfn)) {
> +		if (__generic_dma_ops(hwdev)->unmap_page)
> +			__generic_dma_ops(hwdev)->unmap_page(hwdev, handle, size, dir, attrs);

Similarly here, do we need the unmap_page check? dma_map_page() does not
do it.

-- 
Catalin
