Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbaAIR3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:29:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:12612 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAIR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:29:16 -0500
X-IronPort-AV: E=Sophos;i="4.95,632,1384300800"; 
   d="scan'208";a="89227883"
Date: Thu, 9 Jan 2014 17:28:21 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, <jonathan.davies@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zoltan Kiss <zoltan.kiss@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH net-next v3 1/9] xen-netback: Introduce TX
 grant map definitions
In-Reply-To: <52CEC370.10503@citrix.com>
Message-ID: <alpine.DEB.2.02.1401091722150.21510@kaball.uk.xensource.com>
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com> <1389139818-24458-2-git-send-email-zoltan.kiss@citrix.com> <20140109153010.GE12164@zion.uk.xensource.com> <52CEC370.10503@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014, David Vrabel wrote:
> On 09/01/14 15:30, Wei Liu wrote:
> > On Wed, Jan 08, 2014 at 12:10:10AM +0000, Zoltan Kiss wrote:
> >> This patch contains the new definitions necessary for grant mapping.
> >>
> >> v2:
> >> - move unmapping to separate thread. The NAPI instance has to be scheduled
> >>   even from thread context, which can cause huge delays
> >> - that causes unfortunately bigger struct xenvif
> >> - store grant handle after checking validity
> >>
> >> v3:
> >> - fix comment in xenvif_tx_dealloc_action()
> >> - call unmap hypercall directly instead of gnttab_unmap_refs(), which does
> >>   unnecessary m2p_override. Also remove pages_to_[un]map members
> > 
> > Is it worthy to have another function call
> > gnttab_unmap_refs_no_m2p_override in Xen core driver, or just add a
> > parameter to control wether we need to touch m2p_override? I *think* it
> > will benefit block driver as well?
> 
> add_m2p_override and remove_m2p_override calls should be moved into the
> gntdev device as that should be the only user.

First of all the gntdev device is common code, while the m2p_override is
an x86 concept.

Then I would like to point out that there are no guarantees that a
network driver, or any other kernel subsystems, don't come to rely on
mfn_to_pfn translations for any reasons at any time.
It just happens that today the only known user is gupf, but tomorrow,
who knows?
If we move the m2p_override calls to the gntdev device somehow (avoif
ifdefs please), we should be very well aware of the risks involved.

Of course my practical self realizes that we don't want a performance
regression and this is the quickest way to fix it, so I am not
completely oppose to it.
