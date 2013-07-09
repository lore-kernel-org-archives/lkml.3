Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3GISeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 14:34:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49677 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3GISeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 14:34:17 -0400
Date: Tue, 9 Jul 2013 14:32:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] xen-block: introduce a new request type to unmap
 grants
Message-ID: <20130709183207.GA9924@phenom.dumpdata.com>
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
 <1373288607-1876-5-git-send-email-roger.pau@citrix.com>
 <20130708194152.GJ4927@phenom.dumpdata.com>
 <51DC3C66.2030606@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <51DC3C66.2030606@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 06:37:58PM +0200, Roger Pau Monné wrote:
> On 08/07/13 21:41, Konrad Rzeszutek Wilk wrote:
> > On Mon, Jul 08, 2013 at 03:03:27PM +0200, Roger Pau Monne wrote:
> >> Right now blkfront has no way to unmap grant refs, if using persistent
> >> grants once a grant is used blkfront cannot assure if blkback will
> >> have this grant mapped or not. To solve this problem, a new request
> >> type (BLKIF_OP_UNMAP) that allows requesting blkback to unmap certain
> >> grants is introduced.
> > 
> > I don't think this is the right way of doing it. It is a new operation
> > (BLKIF_OP_UNMAP) that has nothing to do with READ/WRITE. All it is
> > is just some way for the frontend to say: unmap this grant if you can.
> > 
> > As such I would think a better mechanism would be to have a new
> > grant mechanism that can say: 'I am done with this grant you can
> > remove it' - that is called to the hypervisor. The hypervisor
> > can then figure out whether it is free or not and lazily delete it.
> > (And the guest would be notified when it is freed).
> 
> I would prefer not to involve the hypervisor in persistent grants, this
> is something between the frontends and the backends. The hypervisor
> already provides the basic operations (map/unmap), IMHO there's no need
> to add more logic to the hypervisor itself.
> 
> I agree that it would be better to have a generic way to request a
> backend to unmap certain grants, but so far this seems like the best
> solution.

Lets concentrate on a generic way that any frontend/backend can use.

Please keep in mind that the indirect descriptors could be implemented by
using mapped grants if a backend or frontend wanted to do it.

This all is tied in the 'feature-persistent-grant' and as that could be
implemented in a similar fashion on netfront (perhaps by only doing it
for one of the rings - the TX ring, or is it RX?).

> 
> > 
> > I would presume that this problem would also exist with netback/netfront
> > if it started using persisten grants, right?
> 
> I'm not sure of that, it depends on the number of persistent grants
> netfront/netback use, in the block case we need this operation because
> of indirect descriptors, but netfront/netback might not suffer from this
> problem if the maximum number of grants they use is relatively small.

256 is the default amount of grants one ring can have. Since there is 
a RX and TX ring that means we can have around 512 for one VIF.

I presume that with the multi-queue (not yet implemented) this can expand
to be 512 * vCPU.


> 
