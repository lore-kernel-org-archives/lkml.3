Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaLBMEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:04:34 -0500
Received: from 8bytes.org ([81.169.241.247]:57071 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaLBMEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:04:33 -0500
Date: Tue, 2 Dec 2014 13:04:30 +0100
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: Fix an off-by-one bug in __domain_mapping()
Message-ID: <20141202120430.GA32294@8bytes.org>
References: <1416966130-866-1-git-send-email-jiang.liu@linux.intel.com>
 <20141201162740.GK3762@8bytes.org>
 <1417516475.5525.57.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417516475.5525.57.camel@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:34:35AM +0000, David Woodhouse wrote:
> __domain_mapping() is an amalgamation of the old domain_pfn_mapping()
> and domain_sg_mapping() functions. When I did that, in commit 9051aa026,
> the 'sg_res' variable was used *only* for tracking how many pages were
> left in the current scatterlist element, before we had to get the next
> one from the sglist.
> 
> For reasons which are lost now, in the case of a simple pfn range I was
> setting 'sg_res = nr_pages + 1' to ensure that we *never* got down to
> sg_res=0 and tried to look for more from the (non-existent, in this
> case) sglist.
> 
> Later in commit 6dd9a7c73 we added large page support, using sg_res in a
> way which actually required it to be accurate. And now we have an
> off-by-one because we'll actually *try* to use a 2GiB large page for a
> mapping of size 0x1ff000, because of that '+1'.
> 
> The BUG_ON is entirely correct here, and correctly highlighted the
> problem.
> 
> However, the +1 is no longer necessary, because the check that needed it
> was also modified to read 'if (sg_res && nr_pages)', which is perfectly
> sufficient and arguably how it should have been done in the first place.
> 
> I had an almost identical patch last week for internal testing, because
> I stupidly hadn't noticed that Jiang had beaten me to it.
> 
> Acked-By: David Woodhouse <David.Woodhouse@intel.com>
> 
> > > 	This issue was introduced in v2.6.31, but intel-iommu.c has
> > > been moved into drivers/iommu in v3.1. So what's the preferred way
> > > to deal with stable kernels between v2.6.31 and v3.1?
> > 
> > Just remove the kernel version marker from the stable tag. The stable
> > kernel maintainers for kernels >3.1 will ask you to backport the patch
> > or just backport it by themselfes.
> 
> I think this is only an issue since commit 6dd9a7c737 added super page
> support in 3.0, isn't it? Before that, the +1 was *needed*.

Okay guys, thanks for the explanations. I applied the patch to the
x86/vt-d branch and changed the stable tag to >= 3.0.


	Joerg

