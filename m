Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaBSXWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:22:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:35653 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaBSXWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:22:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,508,1389772800"; 
   d="scan'208";a="484464256"
Date: Wed, 19 Feb 2014 16:21:53 -0700
From: Jon Mason <jon.mason@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] ntb: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140219232153.GB1333@jonmason-lab>
References: <1392804931-30671-1-git-send-email-agordeev@redhat.com>
 <20140219180926.GA1333@jonmason-lab>
 <20140219192255.GA20609@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219192255.GA20609@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 08:22:55PM +0100, Alexander Gordeev wrote:
> On Wed, Feb 19, 2014 at 11:09:27AM -0700, Jon Mason wrote:
> > > diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> > > index 170e8e6..fda37eb 100644
> > > --- a/drivers/ntb/ntb_hw.c
> > > +++ b/drivers/ntb/ntb_hw.c
> > > @@ -1085,21 +1085,15 @@ static int ntb_setup_msix(struct ntb_device *ndev)
> > >  	struct msix_entry *msix;
> > >  	int msix_entries;
> > >  	int rc, i;
> > > -	u16 val;
> > >  
> > > -	if (!pdev->msix_cap) {
> > > -		rc = -EIO;
> > > -		goto err;
> > > -	}
> > > -
> > > -	rc = pci_read_config_word(pdev, pdev->msix_cap + PCI_MSIX_FLAGS, &val);
> > > -	if (rc)
> > > +	rc = pci_msix_vec_count(pdev);
> > 
> > Nit, you should probably use msix_entries instead of rc in this case.
> 
> This way it resembles the code few lines below, so the style looks more
> consistent. Whichever you wish, though ;)

It'll save the else statement below, and makes the code a little more
obvious...but its not a big deal.

> > > +	if (rc < 0) {
> > >  		goto err;
> > > -
> > > -	msix_entries = msix_table_size(val);
> > > -	if (msix_entries > ndev->limits.msix_cnt) {
> > > +	} else if (rc > ndev->limits.msix_cnt) {
> > >  		rc = -EINVAL;
> > >  		goto err;
> > > +	} else {
> > > +		msix_entries = rc;
> > >  	}
> > 
> > Style Nit.  Braces with only one line.  If you make the change above,
> > then it is moot.
> 
> Not on the top of my head, but do we mix bracing this way?

It was the preferred style once-upon-a-time to not have braces for
single line if/else.  I think it is really up to the driver/driver
maintainer now.  I'd prefer it to be the old way, but its not the end
of the world.

> > >  
> > >  	ndev->msix_entries = kmalloc(sizeof(struct msix_entry) * msix_entries,
> > > @@ -1112,26 +1106,21 @@ static int ntb_setup_msix(struct ntb_device *ndev)
> > >  	for (i = 0; i < msix_entries; i++)
> > >  		ndev->msix_entries[i].entry = i;
> > >  
> > > -	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
> > > -	if (rc < 0)
> > > -		goto err1;
> > > -	if (rc > 0) {
> > > +	if (ndev->hw_type != BWD_HW)
> > >  		/* On SNB, the link interrupt is always tied to 4th vector.  If
> > >  		 * we can't get all 4, then we can't use MSI-X.
> > >  		 */
> > > -		if (ndev->hw_type != BWD_HW) {
> > > -			rc = -EIO;
> > > -			goto err1;
> > > -		}
> > > -
> > > -		dev_warn(&pdev->dev,
> > > -			 "Only %d MSI-X vectors.  Limiting the number of queues to that number.\n",
> > > -			 rc);
> > > +		rc = pci_enable_msix_range(pdev, ndev->msix_entries,
> > > +					   msix_entries, msix_entries);
> > > +	else
> > > +		rc = pci_enable_msix_range(pdev, ndev->msix_entries,
> > > +					   1, msix_entries);
> > 
> > Actually, this must be 2 for the min.  One for the Data and one for
> > the Link.  If you look a few lines after this in the original code,
> > there is a grabbing of the last vector for the link.  I realize there
> > is currently no check for this in the driver and a potential error
> > case occurs.  I can make a separate patch to correct this issue if
> > this patch is not going through my tree.
> 
> Well, I can re-post with a separate fix with this condition updated...
> 
> 	} else if (rc < 2 || rc > ndev->limits.msix_cnt) {

Won't this break for rc == 0 (the most probable case)?

I'm fine with the fix being included in this patch, with a comment to
note the fix.  I don't believe it could ever be hit in real life, so
I'm not worried about it.


> 		rc = -EINVAL;
> 		goto err;
> 	}
> 
> ...and the original patch with call to pci_enable_msix_range( ...,
> 2, ndev->limits.msix_cnt)
>
> Will it work with both BWD_HW and non-BWD_HW hardware?

non-BWD design has a min/max of 4...so it'll always have > 2 or be an
error (hence the comment above).

Thanks,
Jon

> > Thanks,
> > Jon
> > 
> > 
> > > +	if (rc < 0)
> > > +		goto err1;
> > > +	else if (rc < msix_entries) {
> > > +		dev_warn(&pdev->dev, "Only %d MSI-X vectors. "
> > > +			 "Limiting the number of queues to that number.\n", rc);
> > >  		msix_entries = rc;
> > > -
> > > -		rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
> > > -		if (rc)
> > > -			goto err1;
> > >  	}
> > >  
> > >  	for (i = 0; i < msix_entries; i++) {
> > > diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
> > > index bbdb7ed..d307107 100644
> > > --- a/drivers/ntb/ntb_hw.h
> > > +++ b/drivers/ntb/ntb_hw.h
> > > @@ -60,8 +60,6 @@
> > >  #define PCI_DEVICE_ID_INTEL_NTB_SS_HSX		0x2F0F
> > >  #define PCI_DEVICE_ID_INTEL_NTB_B2B_BWD		0x0C4E
> > >  
> > > -#define msix_table_size(control)	((control & PCI_MSIX_FLAGS_QSIZE)+1)
> > > -
> > >  #ifndef readq
> > >  static inline u64 readq(void __iomem *addr)
> > >  {
> > > -- 
> > > 1.7.7.6
> > > 
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
