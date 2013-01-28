Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3A1Pmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:42:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39008 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3A1Pmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:42:43 -0500
Date: Mon, 28 Jan 2013 10:42:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blkback: Check for insane amounts of
 request on the ring.
Message-ID: <20130128154231.GF4838@konrad-lan.dumpdata.com>
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
 <1359135152-30688-4-git-send-email-konrad.wilk@oracle.com>
 <20130125184323.GC1384@phenom.dumpdata.com>
 <51066A1202000078000BA020@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51066A1202000078000BA020@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 11:07:46AM +0000, Jan Beulich wrote:
> >>> On 25.01.13 at 19:43, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > @@ -764,6 +768,9 @@ __do_block_io_op(struct xen_blkif *blkif)
> >  	rp = blk_rings->common.sring->req_prod;
> >  	rmb(); /* Ensure we see queued requests up to 'rp'. */
> >  
> > +	if (RING_REQUEST_PROD_OVERFLOW(&blk_rings->common, rp, rc))
> > +		return -EACCES;
> 
> Actually I wonder whether we need the new macro at all: It seems
> to me that using RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rp)
> here would achieve the same effect.

But it would not. The RING_REQUEST_CONS_OVERFLOW only check that the
non-shared ring entries (rsp_prod and rsp_prod_pvt) are less than
the size of the ring (32). In other words - they check whether we want
to process more requests as we still have a back-log of responses to
deal with.

This new macro would check for the req_prod being bogus and out of
bounds. Bounds being the difference between rsp_prod and req_prod
being bigger than ring (32).

> 
> Jan
> 
> > +
> >  	while (rc != rp) {
> >  
> >  		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
> 
> 
