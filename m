Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3KLR2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:28:34 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:61926 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3KLR23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:28:29 -0500
X-IronPort-AV: E=Sophos;i="4.93,686,1378857600"; 
   d="scan'208";a="71129161"
Date: Tue, 12 Nov 2013 17:27:05 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <konrad@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 2/2] swiotlb-xen: xen_swiotlb_map_page: do
 not error out if dma_capable fails
In-Reply-To: <20131112144832.GC9435@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1311121704590.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com> <1384265520-6833-2-git-send-email-stefano.stabellini@eu.citrix.com> <20131112144832.GC9435@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell gave a great explanation of the issue so I am just going to
limit myself to answering to:

On Tue, 12 Nov 2013, Konrad Rzeszutek Wilk wrote:
> > Considering that we know that the swiotlb buffer has a low address,
> > skip the check.
> 
> I am not following that sentence. Could you please explain to me
> how the SWIOTLB buffer low address guarantees that we don't need
> the check?

xen_swiotlb_fixup makes sure that the swiotlb buffer is lower than 4GB,
probably lower than 3GB, by passing dma_bits to
xen_create_contiguous_region.
This meets the requirements of most devices out there.
In fact we are not even running this check under the same conditions in
swiotlb_map_sg_attrs.
I admit that it is possible to come up with a scenario where the check
would be useful, but it is far easier to come up with scenarios where
not only is unneeded but it is even harmful.

Alternatively (without Rob's "of: set dma_mask to point to
coherent_dma_mask") Linux 3.13 is going to fail to get the network
running on Midway. It is going to avoid fs mounting failures just
because we don't do the same check in swiotlb_map_sg_attrs.

FYI given that Rob's patch is probably going upstream soon anyway, I
don't feel so strongly about this.
