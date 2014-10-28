Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaJ1MXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:23:33 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49671 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaJ1MXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:23:31 -0400
Date: Tue, 28 Oct 2014 12:23:24 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
Message-ID: <20141028122324.GB12136@arm.com>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
 <20141022164454.GI15370@e104818-lin.cambridge.arm.com>
 <CANLsYkx08dw=YYBoRJ47QC+iL578HxPoMFcRDw6aKsvyqaqtkw@mail.gmail.com>
 <20141024092832.GD20534@e104818-lin.cambridge.arm.com>
 <CANLsYkz+UZv+vd9hbQOTNvsdyR7MyMrb0DxCOpMcgCr+1NQR5Q@mail.gmail.com>
 <20141024161634.GG20534@e104818-lin.cambridge.arm.com>
 <20141027155444.GW8768@arm.com>
 <CANLsYkyNNXc5XHOfrzRZ2Bz_32Dn_qhEsWEzymXxf_9-VRqcOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkyNNXc5XHOfrzRZ2Bz_32Dn_qhEsWEzymXxf_9-VRqcOA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:14:41PM +0000, Mathieu Poirier wrote:
> On 27 October 2014 09:54, Will Deacon <will.deacon@arm.com> wrote:
> > On Fri, Oct 24, 2014 at 05:16:34PM +0100, Catalin Marinas wrote:
> >> As I said, it's confusing. Anyway, you can go ahead and add the
> >> readq/writeq for ARMv6 and later, though it won't be guaranteed to have
> >> a 64-bit access, it depends on the bus.
> >
> > I'm really not comfortable with this... we don't make any guarantees for
> > 32-bit CPUs that a double-word access will be single-copy atomic for MMIO.
> > That means it could be subjected to things like reordering and merging,
> > which I think means that it depends on both the bus *and* the endpoint as to
> > whether or not this will work. Worse still, the endpoint could decide to
> > return a SLVERR, which would appear as an external abort.
> 
> I agree on all of the point you bring up.  The person using these
> should know their architecture and the target endpoint support this
> kind of access.  If they don't then a problem will show up pretty
> quickly.

That goes against the I/O abstractions provided by the kernel to allow for
portable device drivers. readq/writeq *must* have some portable semantics
and I don't think that we should implement them on a best-effort basis
in io.h.

> >
> > Is it not possible to use 32-bit MMIO accesses for this driver?
> 
> Sure it is but we wouldn't be using the HW to it's full capability.
> Another solution is to move the accessors to the driver itself where
> nobody else in the 32 bit world will have access to them.  Russell,
> what you're opinion on that?

FWIW, I'd much prefer that, but I'd be interested to know how much of a
a couple of {read,write}l_relaxed operations really cost you by
comparison.

Will
