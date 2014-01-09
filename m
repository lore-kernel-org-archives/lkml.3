Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaAISKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:10:12 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:39933 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaAISKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:10:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,632,1384300800"; 
   d="scan'208";a="89243078"
Date: Thu, 9 Jan 2014 18:09:11 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Wei Liu <wei.liu2@citrix.com>, <jonathan.davies@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zoltan Kiss <zoltan.kiss@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH net-next v3 1/9] xen-netback: Introduce TX
 grant map definitions
In-Reply-To: <52CEE084.5000409@citrix.com>
Message-ID: <alpine.DEB.2.02.1401091759100.21510@kaball.uk.xensource.com>
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com> <1389139818-24458-2-git-send-email-zoltan.kiss@citrix.com> <20140109153010.GE12164@zion.uk.xensource.com> <52CEC370.10503@citrix.com> <alpine.DEB.2.02.1401091722150.21510@kaball.uk.xensource.com>
 <52CEE084.5000409@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014, David Vrabel wrote:
> On 09/01/14 17:28, Stefano Stabellini wrote:
> > On Thu, 9 Jan 2014, David Vrabel wrote:
> >> On 09/01/14 15:30, Wei Liu wrote:
> >>> On Wed, Jan 08, 2014 at 12:10:10AM +0000, Zoltan Kiss wrote:
> >>>> This patch contains the new definitions necessary for grant mapping.
> >>>>
> >>>> v2:
> >>>> - move unmapping to separate thread. The NAPI instance has to be scheduled
> >>>>   even from thread context, which can cause huge delays
> >>>> - that causes unfortunately bigger struct xenvif
> >>>> - store grant handle after checking validity
> >>>>
> >>>> v3:
> >>>> - fix comment in xenvif_tx_dealloc_action()
> >>>> - call unmap hypercall directly instead of gnttab_unmap_refs(), which does
> >>>>   unnecessary m2p_override. Also remove pages_to_[un]map members
> >>>
> >>> Is it worthy to have another function call
> >>> gnttab_unmap_refs_no_m2p_override in Xen core driver, or just add a
> >>> parameter to control wether we need to touch m2p_override? I *think* it
> >>> will benefit block driver as well?
> >>
> >> add_m2p_override and remove_m2p_override calls should be moved into the
> >> gntdev device as that should be the only user.
> > 
> > First of all the gntdev device is common code, while the m2p_override is
> > an x86 concept.
> 
> m2p_add_override() and m2p_remove_override() are already called from
> common code and ARM already provides inline stubs.

This is the right time to fix it, then :)
Maybe we should add the m2p_add_override call to the x86 implementation
of set_phys_to_machine, or maybe we need a new generic
set_machine_to_phys call.


> The m2p override mechanism is also broken by design (local PFN to
> foreign MFN may be many-to-one, but the m2p override only works if local
> PFN to foreign MFN is one-to-one). So I want the m2p override to be only
> used where it is /currently/ necessary.  I think there should be no new
> users of it nor should it be considered a fix for any other use case.

I agree, but I think that we have different views on the use case.
To me the m2p_override use case is "everywhere an mfn_to_pfn translation
is required", that unfortunately is potentially everywhere at this time.

I would love to restrict it further but at the very least we would need
something written down under Documentation. Otherwise when the next
Linux hacker comes along with a performance optimization for her new
network driver that breaks Xen because Xen is incapable of doing mfn to
pfn translations, the maintainers might (rightfully) decide that it is
simply our problem.
