Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3KMNNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:13:13 -0500
Received: from smtp.citrix.com ([66.165.176.89]:30070 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab3KMNNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:13:11 -0500
X-IronPort-AV: E=Sophos;i="4.93,692,1378857600"; 
   d="scan'208";a="73996949"
Date: Wed, 13 Nov 2013 13:13:08 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, <xen-devel@lists.xen.org>,
        Matt Wilson <msw@amazon.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>, <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Anthony Liguori <aliguori@amazon.com>
Subject: Re: [PATCH] xen-gnttab: do not add m2p override entries for blkback
 mappings
In-Reply-To: <52835646.5040907@citrix.com>
Message-ID: <alpine.DEB.2.02.1311131253310.4714@kaball.uk.xensource.com>
References: <1384307336-5328-1-git-send-email-anthony@codemonkey.ws> <52835646.5040907@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013, David Vrabel wrote:
> On 13/11/13 01:48, Anthony Liguori wrote:
> > From: Anthony Liguori <aliguori@amazon.com>
> > 
> > Commit 5dc03639 switched blkback to also add m2p override entries
> > when mapping grant pages but history seems to have forgotten why
> > this is useful if it ever was.
> > 
> > The blkback driver does not need m2p override entries to exist
> > and there is significant overhead due to the locking in the m2p
> > override table.  We see about a 10% improvement in IOP rate with
> > this patch applied running FIO in the guest.
> > 
> > See http://article.gmane.org/gmane.linux.kernel/1590932 for a full
> > analysis of current users.
> 
> I think it would be better if it was made clearer what
> m2p_add/remove_override() is for (i.e., allowing get_user_pages_fast()
> to work) so there isn't this confusion in the future.  Please add some
> comments for this and move the calls into the gntdev driver.

Even though get_user_pages_fast is obviously the most important use case
for the m2p_override, it is not the only one, see below.


> As a prerequiste, the call to dma_mark_clean() in xen_swiotlb_unmap()
> needs to be removed and replaced with a comment explaining why this now
> differs from the generic implementation.  i.e., the necessary
> phys_to_virt() will not work for foreign pages

Actually it is machine_to_phys that is not going to work and only on x86.
machine_to_phys is going to be fine for foreign pages on ARM.

Let's be clear about this: without the m2p_override on x86
xen_swiotlb_unmap is going to fail and that undeniably is a mistake.
However it is a mistake that happens not to cause any problems today.

In fact the following comment is not right:

+/* override is used to add m2p override table entries when mapping the
+ * grant references.  Currently there are only two callers to this function,
+ * blkback and gntdev.  gntdev needs all grant mappings to have corresponding
+ * m2p override table entries but blkback currently doesn't.  This is because
+ * blkback can gracefully handle the case where m2p(p2m(pfn)) fails with
+ * foreign pfns.  If you cannot handle this correctly, you need to set
+ * override 1 when calling the map and unmap functions.
+ */


I would add the following comment to xen_unmap_single instead:

/* On x86 xen_bus_to_phys is going to fail for foreign pages unless they
 * have been added to the m2p_override. Only gntdev currently adds them to
 * the m2p_override, while blkback does not. As a consequence any foreign
 * pages mapped by blkback and used for DMA are not going to be unmapped
 * correctly here. Fortunately this is not a problem because this function
 * is actually a nop for non-swiotlb pages on x86.
 */


> and dma_mark_clean() is a nop on all Xen supported architectures.

That's true, it should be removed. It is just confusing.
