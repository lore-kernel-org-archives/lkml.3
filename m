Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3CEVrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:47:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45629 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3CEVrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:47:23 -0500
Date: Tue, 5 Mar 2013 16:46:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        james.harper@bendigoit.com.au
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 12/12] xen-block: implement indirect descriptors
Message-ID: <20130305214641.GD8235@phenom.dumpdata.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
 <20130304204154.GL15386@phenom.dumpdata.com>
 <5136266D.8050707@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5136266D.8050707@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 06:07:57PM +0100, Roger Pau Monné wrote:
> On 04/03/13 21:41, Konrad Rzeszutek Wilk wrote:
> > On Thu, Feb 28, 2013 at 11:28:55AM +0100, Roger Pau Monne wrote:
> >> Indirect descriptors introduce a new block operation
> >> (BLKIF_OP_INDIRECT) that passes grant references instead of segments
> >> in the request. This grant references are filled with arrays of
> >> blkif_request_segment_aligned, this way we can send more segments in a
> >> request.
> >>
> >> The proposed implementation sets the maximum number of indirect grefs
> >> (frames filled with blkif_request_segment_aligned) to 256 in the
> >> backend and 64 in the frontend. The value in the frontend has been
> >> chosen experimentally, and the backend value has been set to a sane
> >> value that allows expanding the maximum number of indirect descriptors
> >> in the frontend if needed.
> > 
> > So we are still using a similar format of the form:
> > 
> > <gref, first_sec, last_sect, pad>, etc.
> > 
> > Why not utilize a layout that fits with the bio sg? That way
> > we might not even have to do the bio_alloc call and instead can
> > setup an bio (and bio-list) with the appropiate offsets/list?
> > 
> > Meaning that the format of the indirect descriptors is:
> > 
> > <gref, offset, next_index, pad>
> > 
> > We already know what the first_sec and last_sect are - they
> > are basically: sector_number +  nr_segments * (whatever the sector size is) + offset
> 
> This will of course be suitable for Linux, but what about other OSes, I
> know they support the traditional first_sec, last_sect (because it's
> already implemented), but I don't know how much work will it be for them
> to adopt this. If we have to do such a change I will have to check first
> that other frontend/backend can handle this easily also, I wouldn't like
> to simplify this for Linux by making it more difficult to implement in
> other OSes...

I would think that most OSes use the same framework. The ones that
are of notable interest are the Windows and BSD. Lets CC James here

> 
