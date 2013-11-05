Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3KEVRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:17:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48665 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3KEVRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:17:22 -0500
Date: Tue, 5 Nov 2013 16:16:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Matt Wilson <msw@linux.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>, Matt Wilson <msw@amazon.com>,
        xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH] grant-table: don't set m2p override if
 kmap_ops is not set
Message-ID: <20131105211635.GA1695@phenom.dumpdata.com>
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
 <5278E64C.40200@citrix.com>
 <527904EC.9090402@citrix.com>
 <20131105145607.GB25836@phenom.dumpdata.com>
 <5279085E.7070703@citrix.com>
 <1383664090.13961.88.camel@kazak.uk.xensource.com>
 <527916EE.6060104@citrix.com>
 <20131105200616.GA23362@u109add4315675089e695.ant.amazon.com>
 <878ux2vade.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <878ux2vade.fsf@codemonkey.ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 12:53:17PM -0800, Anthony Liguori wrote:
> Matt Wilson <msw@linux.com> writes:
> 
> > On Tue, Nov 05, 2013 at 05:03:58PM +0100, Roger Pau Monné wrote:
> >> On 05/11/13 16:08, Ian Campbell wrote:
> >> > On Tue, 2013-11-05 at 16:01 +0100, Roger Pau Monné wrote:
> >> >> On 05/11/13 15:56, Konrad Rzeszutek Wilk wrote:
> >> >>> On Tue, Nov 05, 2013 at 03:47:08PM +0100, Roger Pau Monné wrote:
> >> >>>> On 05/11/13 13:36, David Vrabel wrote:
> >> >>>>> On 05/11/13 11:24, Roger Pau Monne wrote:
> >> >>>>>> IMHO there's no reason to set a m2p override if the mapping is done in
> >> >>>>>> kernel space, so only set the m2p override when kmap_ops is set.
> >> >>>>>
> >> >>>>> Can you provide a more detailed reasoning about why this is safe?
> >> >>>>
> >> >>>> To tell the truth, I don't understand why we need to use the m2p
> >> >>>> override for kernel space only mappings, my understanding is that this
> >> >>>> m2p override is needed for user space mappings only (where we actually
> >> >>>> end up doing two mappings, one in kernel space and one in user space).
> >> >>>> For kernel space I don't see why we need to do anything else than
> >> >>>> setting the right p2m translation.
> >> >>>
> >> >>> We needed the m2p when doing DMA operations. As the driver would
> >> >>> want the bus address (so p2m) and then when unmapping the DMA we
> >> >>> only get the bus address  - so we needed to do a m2p lookup.
> >> >>
> >> >> OK, we need a m2p (that we already have in machine_to_phys_mapping),
> >> >> what I don't understand is why we need the m2p override.
> >> > 
> >> > The m2p is a host global table.
> >> > 
> >> > For a foreign page grant mapped into the current domain the m2p will
> >> > give you the foreign (owner) domain's p from the m, not the local one.
> >> 
> >> Yes, you are completely right, then I have to figure out why blkback
> >> works fine with this patch applied (or at least it seems to work fine).
> >
> > blkback also works for me when testing a similar patch. I'm still
> > confused. One thing with your proposed patch: I'm not sure that you're
> > putting back the correct mfn.
> 
> It's perfectly fine to store a foreign pfn in the m2p table.  The m2p
> override table is used by the grant device to allow a reverse lookup of
> the real mfn to a pfn even if it's foreign.
> 
> blkback doesn't actually need this though.  This was introduced in:
> 
> commit 5dc03639cc903f887931831d69895facb5260f4b
> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date:   Tue Mar 1 16:46:45 2011 -0500
> 
>     xen/blkback: Utilize the M2P override mechanism for GNTMAP_host_map
> 
> Purely as an optimization.  In practice though due to lock contention it
> slows things down.
> 
> I think an alternative would be to use a read/write lock instead of just
> a spinlock since it's the read path that is the most hot.

The m2p hash table can also be expanded to lower the contention.

> 
> I haven't tested that yet though.

Looking forward to your patches :-)
> 
> Regards,
> 
> Anthony Liguori
> 
> >
> > Adding Anthony to the thread.
> >
> > --msw
