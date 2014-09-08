Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaIHH5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:57:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25784 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaIHH5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:57:04 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-dc-540d614cd62e
Content-transfer-encoding: 8BIT
Message-id: <1410163019.4300.1.camel@AMDC1943>
Subject: Re: [PATCH 1/3] dmaengine: pl330: Do not dereference pl330_thread
 pointer before non-NULL check
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 08 Sep 2014 09:56:59 +0200
In-reply-to: <5409D6D8.2020802@metafoo.de>
References: <1409929466-29506-1-git-send-email-k.kozlowski@samsung.com>
 <5409D6D8.2020802@metafoo.de>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7o+ibwhBlueqlpsnLGe1eL1v+ks
	FtOnXmC0WD31L6vF2aY37BZLJs9ntbi8aw6bxdojd9kt3r2MsHjZt5/Fgctj8Z6XTB5L3hxi
	9fj49BaLR9+WVYwenzfJeez9/JslgC2KyyYlNSezLLVI3y6BK2Npy2WWgnfcFZ2zFzM2MC7n
	7GLk5JAQMJH40DCHHcIWk7hwbz1bFyMXh5DAUkaJh0cuMYIkeAUEJX5MvsfSxcjBwSwgL3Hk
	UjZImFlAXWLSvEXMEPWfGSW6Hsxjh6jXk9g/7RcriC0skCWx4NpsJhCbTcBYYvPyJWwgtoiA
	hsT/N5PYQZqZBT4ySdye+g6siEVAVWLt5mVgRZwCWhLT/94AGyQkkC5xtKGVDeQICQFlicZ+
	twmMArOQnDcL4bxZSM5bwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkEr7uYFx6zOoQ
	owAHoxIPb8JVnhAh1sSy4srcQ4wSHMxKIrwMYbwhQrwpiZVVqUX58UWlOanFhxiZODilGhiP
	3Cl4a/avUrd5/92EOZHmlRXBZ/lz2a69Zftw9oaVR82mTRv9rFNSJ3ratWit99j1MCpSR3L6
	Vybv3veHs9uX/CqZMvfp9J2dChbGZx/Pj1d/P0/JYH1t+Pbwhb0vDx1NX3/meMf+0Fd1fg7b
	L1munvB1zdIdtn4eR6zeTNP5y/nh155G85gtSizFGYmGWsxFxYkAfDKHk2ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-09-05 at 17:29 +0200, Lars-Peter Clausen wrote:
> On 09/05/2014 05:04 PM, Krzysztof Kozlowski wrote:
> > Do not dereference the 'struct pl330_thread *thrd' before the check for
> > non-NULL value.
> >
> > This fixes following warning:
> > drivers/dma/pl330.c:1376 pl330_submit_req() warn: variable dereferenced before check 'thrd' (see line 1367)
> 
> I think we can just drop that whole line of checks, none of them will ever 
> be true.

Sure, I'll send another version of the patch.

Thanks for review,
Krzysztof


> 
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >   drivers/dma/pl330.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > index d5149aacd2fe..47d82070848d 100644
> > --- a/drivers/dma/pl330.c
> > +++ b/drivers/dma/pl330.c
> > @@ -1364,7 +1364,7 @@ static inline u32 _prepare_ccr(const struct pl330_reqcfg *rqc)
> >   static int pl330_submit_req(struct pl330_thread *thrd,
> >   	struct dma_pl330_desc *desc)
> >   {
> > -	struct pl330_dmac *pl330 = thrd->dmac;
> > +	struct pl330_dmac *pl330;
> >   	struct _xfer_spec xs;
> >   	unsigned long flags;
> >   	void __iomem *regs;
> > @@ -1376,6 +1376,7 @@ static int pl330_submit_req(struct pl330_thread *thrd,
> >   	if (!desc || !thrd || thrd->free)
> >   		return -EINVAL;
> >
> > +	pl330 = thrd->dmac;
> >   	regs = thrd->dmac->base;
> >
> >   	if (pl330->state == DYING
> >

