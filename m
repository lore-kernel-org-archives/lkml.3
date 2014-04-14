Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaDNPxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:53:50 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:31427 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaDNPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:53:46 -0400
Date: Mon, 14 Apr 2014 10:52:41 -0500
From: scameron@beardog.cce.hp.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Baoquan He <bhe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: fix uninitialized trans_support in hpsa_put_ctlr_into_performant_mode()
Message-ID: <20140414155241.GC21686@beardog.cce.hp.com>
References: <20140410221704.GA22465@beardog.cce.hp.com> <1397490316.2207.23.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397490316.2207.23.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 08:45:16AM -0700, James Bottomley wrote:
> Your subject line is very tame.  It should be the one line summary of
> why we apply the patch, so it should read something like
> 
>  hpsa: fix NULL deref in performant mode
> 
> On Thu, 2014-04-10 at 17:17 -0500, scameron@beardog.cce.hp.com wrote:
> > Without this, you'll see a null pointer dereference in
> > hpsa_enter_performant_mode().
> 
> The description should be more comprehensible.
> 
> I'm clear that the use before initialisation is a bug ... I'm less clear
> on why it causes an oops.
> 
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > ---
> >  drivers/scsi/hpsa.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 8cf4a0c..ef4dfdd 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
> >  	if (hpsa_simple_mode)
> >  		return;
> >  
> > +	trans_support = readl(&(h->cfgtable->TransportSupport));
> > +	if (!(trans_support & PERFORMANT_MODE))
> > +		return;
> > +
> >  	/* Check for I/O accelerator mode support */
> >  	if (trans_support & CFGTBL_Trans_io_accel1) {
> >  		transMethod |= CFGTBL_Trans_io_accel1 |
> 
> Shouldn't you be moving this check from its previous location, rather
> than adding a new one that makes the original obsolete?

Oh... I didn't notice that.   So that's what happened to that hunk.
Yes, that is what should be done.

I will resend the patch after fixing up this and the commit message.

-- steve


> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 8cf4a0c..9a6e4a2 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
>  	if (hpsa_simple_mode)
>  		return;
>  
> +	trans_support = readl(&(h->cfgtable->TransportSupport));
> +	if (!(trans_support & PERFORMANT_MODE))
> +		return;
> +
>  	/* Check for I/O accelerator mode support */
>  	if (trans_support & CFGTBL_Trans_io_accel1) {
>  		transMethod |= CFGTBL_Trans_io_accel1 |
> @@ -7479,10 +7483,6 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
>  	}
>  
>  	/* TODO, check that this next line h->nreply_queues is correct */
> -	trans_support = readl(&(h->cfgtable->TransportSupport));
> -	if (!(trans_support & PERFORMANT_MODE))
> -		return;
> -
>  	h->nreply_queues = h->msix_vector > 0 ? h->msix_vector : 1;
>  	hpsa_get_max_perf_mode_cmds(h);
>  	/* Performant mode ring buffer and supporting data structures */
> 
