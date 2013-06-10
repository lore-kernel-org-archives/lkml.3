Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3FJQoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:44:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46765 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FJQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:44:11 -0400
Date: Mon, 10 Jun 2013 12:43:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, roger.pau@citrix.com,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: Check for insane amounts of request on the
 ring.
Message-ID: <20130610164319.GB24467@phenom.dumpdata.com>
References: <1370375826-7311-1-git-send-email-konrad.wilk@oracle.com>
 <20130607201140.GA22115@phenom.dumpdata.com>
 <51B6126302000078000DCC1C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B6126302000078000DCC1C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 04:52:35PM +0100, Jan Beulich wrote:
> >>> On 07.06.13 at 22:11, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Tue, Jun 04, 2013 at 03:57:06PM -0400, Konrad Rzeszutek Wilk wrote:
> >> +	/* N.B. 'rp', not 'rc'. */
> >> +	if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rp)) {
> >> +		pr_warn(DRV_PFX "Frontend provided bogus ring requests (%d - %d = %d). 
> > Halting ring processing on dev=%04x\n",
> >> +			rp, rc, rp - rc, blkif->vbd.pdevice);
> > 
> > Hm, I seem to be able to get:
> > 
> > [  189.398095] xen-blkback:Frontend provided bogus ring requests (125 - 115 = 
> > 10). Halting ring processing on dev=800011
> > or:
> > [  478.558699] xen-blkback:Frontend provided bogus ring requests (95 - 94 = 
> > 1). Halting ring processing on dev=800011
> > 
> > Which is clearly wrong. Piggybacking on the rsp_prod_pvt does not seem to 
> > cut it.
> 
> We see that too, but not very frequently. One thing is that
> rsp_prod_pvt doesn't get printed along with rc and rp, thus
> making it not immediately obvious how this can be off in any way.
> 
> Among the instance there are cases where the printed
> difference is 32, which makes me wonder whether part of the
> problem is the >= in the macro (we may want > here).
> 
> And then we might have been living with some sort of issue in the
> past, because the existing use of the macro just causes the loop
> to be exited, with it getting re-entered subsequently (i.e. at worst
> causing performance issues).

My observation was that the rsp_prod_pvt was lagging behind b/c the 
READ requests weren't completed. In other words, the processing
of the ring was stalled b/c 'make_response' hadn't been called yet.
Which meant that rsp_prod was not updated to rsp_prod_pvt (backend
does not care about that value, only frontend does).

Going back to the rc an rp check solves the immediate 'insane ring
check'. 
