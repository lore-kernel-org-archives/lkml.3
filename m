Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3CVBLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:11:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43256 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3CVBLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:11:32 -0400
Date: Thu, 21 Mar 2013 21:10:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "james.harper@bendigoit.com.au" <james.harper@bendigoit.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 12/12] xen-block: implement indirect descriptors
Message-ID: <20130322011045.GD28902@phenom.dumpdata.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
 <20130304204154.GL15386@phenom.dumpdata.com>
 <5136266D.8050707@citrix.com>
 <20130305214641.GD8235@phenom.dumpdata.com>
 <513A1ABC.1040906@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <513A1ABC.1040906@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 06:07:08PM +0100, Roger Pau Monné wrote:
> On 05/03/13 22:46, Konrad Rzeszutek Wilk wrote:
> > On Tue, Mar 05, 2013 at 06:07:57PM +0100, Roger Pau Monné wrote:
> >> On 04/03/13 21:41, Konrad Rzeszutek Wilk wrote:
> >>> On Thu, Feb 28, 2013 at 11:28:55AM +0100, Roger Pau Monne wrote:
> >>>> Indirect descriptors introduce a new block operation
> >>>> (BLKIF_OP_INDIRECT) that passes grant references instead of segments
> >>>> in the request. This grant references are filled with arrays of
> >>>> blkif_request_segment_aligned, this way we can send more segments in a
> >>>> request.
> >>>>
> >>>> The proposed implementation sets the maximum number of indirect grefs
> >>>> (frames filled with blkif_request_segment_aligned) to 256 in the
> >>>> backend and 64 in the frontend. The value in the frontend has been
> >>>> chosen experimentally, and the backend value has been set to a sane
> >>>> value that allows expanding the maximum number of indirect descriptors
> >>>> in the frontend if needed.
> >>>
> >>> So we are still using a similar format of the form:
> >>>
> >>> <gref, first_sec, last_sect, pad>, etc.
> >>>
> >>> Why not utilize a layout that fits with the bio sg? That way
> >>> we might not even have to do the bio_alloc call and instead can
> >>> setup an bio (and bio-list) with the appropiate offsets/list?
> 
> I think we can already do this without changing the structure of the
> segments, we could just allocate a bio big enough to hold all the
> segments and queue them up (provided that the underlying storage device
> supports bios of this size).
> 
> bio = bio_alloc(GFP_KERNEL, nseg);
> if (unlikely(bio == NULL))
> 	goto fail_put_bio;
> biolist[nbio++] = bio;
> bio->bi_bdev    = preq.bdev;
> bio->bi_private = pending_req;
> bio->bi_end_io  = end_block_io_op;
> bio->bi_sector  = preq.sector_number;
> 
> for (i = 0; i < nseg; i++) {
> 	rc = bio_add_page(bio, pages[i], seg[i].nsec << 9,
> 		seg[i].buf & ~PAGE_MASK);
> 	if (rc == 0)
> 		goto fail_put_bio;
> }
> 
> This seems to work with Linux blkfront/blkback, and I guess biolist in
> blkback only has one bio all the time.

> 
> >>> Meaning that the format of the indirect descriptors is:
> >>>
> >>> <gref, offset, next_index, pad>
> 
> Don't we need a length parameter? Also, next_index will be current+1,
> because we already send the segments sorted (using for_each_sg) in blkfront.
> 
> >>>
> >>> We already know what the first_sec and last_sect are - they
> >>> are basically: sector_number +  nr_segments * (whatever the sector size is) + offset
> >>
> >> This will of course be suitable for Linux, but what about other OSes, I
> >> know they support the traditional first_sec, last_sect (because it's
> >> already implemented), but I don't know how much work will it be for them
> >> to adopt this. If we have to do such a change I will have to check first
> >> that other frontend/backend can handle this easily also, I wouldn't like
> >> to simplify this for Linux by making it more difficult to implement in
> >> other OSes...
> > 
> > I would think that most OSes use the same framework. The ones that
> > are of notable interest are the Windows and BSD. Lets CC James here
> 
> Maybe I'm missing something here, but I don't see a really big benefit
> of using this new structure for segments instead of the current one.

The DIF/DIX requires that the bio layout going in blkfront and then
emerging on the other side in the SAS/SCSI/SATA drivers must be the same.

That means when you have a bio-vec, for example, where there are
five pages linked - the first four have 512 bytes of data (say in the middle
of the page - so 2048 -> 2560 are occupied, the rest is not). The total
is 2048 bytes, and the last page contains 32 bytes (four CRC checksums, each
8 bytes).

If we coalesce any of the five pages in one, then we need to (when we
take the request out of the ring) in the backend, to reconstruct these
five pages. 

My thought was that with the fsect, lsect as they exist now, we will be 
tempted to just colesce four sectors in a page and just make lsect = fsect + 4.

That however is _not_ what we are doing now - I think. We look to recreate
the layout exactly as the READ/WRITE requests are set to xen-blkfront.
