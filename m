Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaHLKm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:42:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaHLKm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:42:26 -0400
Date: Tue, 12 Aug 2014 11:50:14 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
Subject: Re: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
Message-ID: <20140812105014.GB1674@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <bc13ddf17d035921de994d2f8a52902e0a5d1a60.1405533479.git.agordeev@redhat.com>
 <20140811073902.GB16504@dhcp-27-160.brq.redhat.com>
 <20B1A3CBD98F3845B3F5F56D8597EF59FA0CF6@avmb2.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20B1A3CBD98F3845B3F5F56D8597EF59FA0CF6@avmb2.qlogic.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 11:02:56AM +0000, Anil Gurumurthy wrote:
> Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Many thanks, Anil!

If your Ack apply to this patch only or to all three
'bfa' patches in this series?

Thanks!

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com] 
> Sent: 11 August 2014 13:09
> To: linux-kernel
> Cc: Anil Gurumurthy; Vijaya Mohan Guvva; linux-scsi; linux-pci; Anil Gurumurthy; Sudarsana Kalluru
> Subject: Re: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact() instead of pci_enable_msix()
> 
> On Wed, Jul 16, 2014 at 08:05:08PM +0200, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers using these 
> > two interfaces need to be updated to use the new 
> > pci_enable_msi_range()  or pci_enable_msi_exact() and 
> > pci_enable_msix_range() or pci_enable_msix_exact() interfaces.
> 
> Anil, Sudarsana,
> 
> Could you please review bfa patches in this series?
> 
> Thanks!
> 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: Anil Gurumurthy <agurumur@brocade.com>
> > Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
> > Cc: linux-scsi@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> > ---
> >  drivers/scsi/bfa/bfad.c |   20 ++++++--------------
> >  1 files changed, 6 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index 
> > c18279f..e90a374 100644
> > --- a/drivers/scsi/bfa/bfad.c
> > +++ b/drivers/scsi/bfa/bfad.c
> > @@ -1234,29 +1234,21 @@ bfad_setup_intr(struct bfad_s *bfad)
> >  	if ((bfa_asic_id_ctc(pdev->device) && !msix_disable_ct) ||
> >  	   (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {
> >  
> > -		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
> > +		error = pci_enable_msix_exact(bfad->pcidev,
> > +					      msix_entries, bfad->nvec);
> >  		/* In CT1 & CT2, try to allocate just one vector */
> > -		if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
> > +		if (error == -ENOSPC && bfa_asic_id_ctc(pdev->device)) {
> >  			printk(KERN_WARNING "bfa %s: trying one msix "
> >  			       "vector failed to allocate %d[%d]\n",
> >  			       bfad->pci_name, bfad->nvec, error);
> >  			bfad->nvec = 1;
> > -			error = pci_enable_msix(bfad->pcidev,
> > -						msix_entries, bfad->nvec);
> > +			error = pci_enable_msix_exact(bfad->pcidev,
> > +						      msix_entries, 1);
> >  		}
> >  
> > -		/*
> > -		 * Only error number of vector is available.
> > -		 * We don't have a mechanism to map multiple
> > -		 * interrupts into one vector, so even if we
> > -		 * can try to request less vectors, we don't
> > -		 * know how to associate interrupt events to
> > -		 *  vectors. Linux doesn't duplicate vectors
> > -		 * in the MSIX table for this case.
> > -		 */
> >  		if (error) {
> >  			printk(KERN_WARNING "bfad%d: "
> > -			       "pci_enable_msix failed (%d), "
> > +			       "pci_enable_msix_exact failed (%d), "
> >  			       "use line based.\n",
> >  				bfad->inst_no, error);
> >  			goto line_based;
> > --
> > 1.7.7.6
> > 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
