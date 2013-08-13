Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab3HMLRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:17:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28224 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287Ab3HMLRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:17:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,868,1367971200"; 
   d="scan'208";a="43724009"
Date: Tue, 13 Aug 2013 12:17:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <dcrisan@flexiant.com>, <alex@alex.org.uk>, <ian.campbell@citrix.com>
Subject: Re: [PATCH v4 2/2] xen/m2p: use GNTTABOP_unmap_and_replace to
 reinstate the original mapping
In-Reply-To: <20130809152601.GB5637@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1308131212040.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308041531220.4893@kaball.uk.xensource.com> <1375627181-14948-2-git-send-email-stefano.stabellini@eu.citrix.com> <20130809152601.GB5637@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, Konrad Rzeszutek Wilk wrote:
> On Sun, Aug 04, 2013 at 03:39:41PM +0100, Stefano Stabellini wrote:
> > GNTTABOP_unmap_grant_ref unmaps a grant and replaces it with a 0
> > mapping instead of reinstating the original mapping.
> > Doing so separately would be racy.
> > 
> > To unmap a grant and reinstate the original mapping atomically we use
> > GNTTABOP_unmap_and_replace.
> > GNTTABOP_unmap_and_replace doesn't work with GNTMAP_contains_pte, so
> > don't use it for kmaps.  GNTTABOP_unmap_and_replace zeroes the mapping
> > passed in new_addr so we have to reinstate it, however that is a
> > per-cpu mapping only used for balloon scratch pages, so we can be sure that
> > it's not going to be accessed while the mapping is not valid.
> 
> This looks to be depend on a new structure, which is not in Linux kernel?
> Are you missing a dependency patch?

Nope, GNTTABOP_unmap_and_replace and struct gnttab_unmap_and_replace are
already present in include/xen/interface/grant_table.h.


> Shouldn't we use some logic to figure out which hypercall to use if the
> hypervisor does not support it?

GNTTABOP_unmap_and_replace is not a new hypercall, it has been supported
by Xen for a very long time.

In a previous iteration of this patch series, I did introduce a new
hypercall, but then I dropped it because I figured out that I could
achieve the same thing with the existing hypercall.
