Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3KFSxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:53:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47575 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3KFSxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:53:47 -0500
Date: Wed, 6 Nov 2013 13:52:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matt Wilson <msw@linux.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Matt Wilson <msw@amazon.com>
Subject: Re: [Xen-devel] [PATCH] grant-table: don't set m2p override if
 kmap_ops is not set
Message-ID: <20131106185233.GI17101@phenom.dumpdata.com>
References: <5278E64C.40200@citrix.com>
 <527904EC.9090402@citrix.com>
 <20131105145607.GB25836@phenom.dumpdata.com>
 <5279085E.7070703@citrix.com>
 <1383664090.13961.88.camel@kazak.uk.xensource.com>
 <527916EE.6060104@citrix.com>
 <20131105200616.GA23362@u109add4315675089e695.ant.amazon.com>
 <878ux2vade.fsf@codemonkey.ws>
 <527A2943.7050400@citrix.com>
 <20131106175934.GA18002@u109add4315675089e695.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106175934.GA18002@u109add4315675089e695.ant.amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 09:59:34AM -0800, Matt Wilson wrote:
> On Wed, Nov 06, 2013 at 11:34:27AM +0000, David Vrabel wrote:
> [...]
> > 
> > Matt, Anthony, I presume you have profiling results or performance data
> > that support this proposed change?  Can you provide them?
> 
> I've measured 10-20% performance improvement in configurations where:
> 
> 1) dom0 has a moderate number of vCPUs doing blkback work
> 2) domU has 32 vCPUs
> 3) 24 configured VBDs without persistent grant support
> 4) some lock contention in grant table hypercalls has been alleviated
> 
> More specific results are still in the works.
> 
> > > It's perfectly fine to store a foreign pfn in the m2p table.  The m2p
> > > override table is used by the grant device to allow a reverse lookup of
> > > the real mfn to a pfn even if it's foreign.
> > > 
> > > blkback doesn't actually need this though.  This was introduced in:
> > > 
> > > commit 5dc03639cc903f887931831d69895facb5260f4b
> > > Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Date:   Tue Mar 1 16:46:45 2011 -0500
> > > 
> > >     xen/blkback: Utilize the M2P override mechanism for GNTMAP_host_map
> > > 
> > > Purely as an optimization.  In practice though due to lock contention it
> > > slows things down.
> > 
> > The full changeset description for this change doesn't make sense to me.
> > 
> >     xen/blkback: Utilize the M2P override mechanism for GNTMAP_host_map
> > 
> >     Instead of doing copy grants lets do mapping grants using
> >     the M2P(and P2M) override mechanism.
> > 
> > As all it is doing is replacing set_phys_to_machine() calls with
> > m2p_add_override().
> 
> Indeed, since this had nothing to do with copying. We were confused
> also. Konrad?

<confused as well>

2011? Hm, I really don't remember. It does not look to be needed.

I think that back in 2011 the m2p override mechanism was much simpler
and was just a wrapper around set_phys_to_machine with a non-lock
write in the m2p override.

The only concern I had, which David had looked at and I did here
too was the DMA unmap operation, but as you can see from the
writeup - it is not warranted.

I think that the set_phys_to_machine is the way to go then
and ditching the m2p_override. Two questions remain:

 - How does this work when block back is running in an HVM domain?

 - Stefano, do we need to worry about the crazy scenario of
   dom0 using xen-blkfront and xen-blkback inside itself to fetch
   bits of data from QEMU?

?
Here is how it interacts with SWIOTLB:


1) Backend gets the foreign MFN from the grant call. Calls m2p_add_override
   which calls set_phys_to_machine and also adds the MFN on the m2p_overrides.
   Takes a lock.
2). Backend submit_bio, it ends up in AHCI driver. Said driver does dma_map_sg
3). We call xen_swiotlb_map_sg_attrs, which does:
	a) pfn_to_mfn, gets from the P2M the MFN | FOREIGN_FRAME_BIT. Strips
	   the FOREIGN_FRAME_BIT. Returns MFN.
	b). Setups up the sg->dma_address
	
    But it also might setup an bounce buffer in case the AHCI can't reach
    the MFN >> PAGE_SHIFT. At which point we just save the virtual
    address of the page handed to us in the IOTLB.

4). .. ahci driver does it cmd, once it is done it calls 'dma_unmap_sg'
   which ends up in xen_swiotlb_unmap_sg_attrs and we call xen_unmap_single
   which calls:

393         phys_addr_t paddr = xen_bus_to_phys(dev_addr);                          
   which ends up doing (in mfn_to_pfn):

112         pfn = mfn_to_pfn_no_overrides(mfn);                                    

   lookup in the M2P array. We find an MFN and then we check the P2M:

113         if (get_phys_to_machine(pfn) != mfn) {                                  

   Since the MFN hasn't changed (it is still the 'local' one instead
   of the forign one - since we can't modify the M2P) we end up
   with p2m(pfn) != mfn. As the p2m(pfn) ends up giving us the 'foreign'
   MFN value and the m2p(pfn) ends up giving us the 'local' MFN.

   So then we consult the override:
114                 /*                                                              
115                  * If this appears to be a foreign mfn (because the pfn         
116                  * doesn't map back to the mfn), then check the local override  
117                  * table to see if there's a better pfn to use.                 
118                  *                                                              
119                  * m2p_find_override_pfn returns ~0 if it doesn't find anything.
120                  */                                                             
121                 pfn = m2p_find_override_pfn(mfn, ~0);              

   And we find it the MFN of the foreign domain, return it back to the SWIOTLB
   as physical address (so mfn << PAGE_SHIFT) so it can a) either ignore it,
   or b) if the bounce buffer ended up being used - ignore it too. As the
   bounce buffer mechanism ends up using the original stashed virtual address
   and bounces between the bounce buffer and foreign owned virtual address.

   The dma_mark_clean is a nop.
