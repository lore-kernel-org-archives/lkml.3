Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaBTNVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:21:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbaBTNU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:20:59 -0500
Date: Thu, 20 Feb 2014 14:22:58 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] ntb: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140220132258.GB8198@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-1-git-send-email-agordeev@redhat.com>
 <20140219180926.GA1333@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219180926.GA1333@jonmason-lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:09:27AM -0700, Jon Mason wrote:
> On Wed, Feb 19, 2014 at 11:15:21AM +0100, Alexander Gordeev wrote:
> > @@ -1112,26 +1106,21 @@ static int ntb_setup_msix(struct ntb_device *ndev)
> >  	for (i = 0; i < msix_entries; i++)
> >  		ndev->msix_entries[i].entry = i;
> >  
> > -	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
> > -	if (rc < 0)
> > -		goto err1;
> > -	if (rc > 0) {
> > +	if (ndev->hw_type != BWD_HW)
> >  		/* On SNB, the link interrupt is always tied to 4th vector.  If
> >  		 * we can't get all 4, then we can't use MSI-X.
> >  		 */
> > -		if (ndev->hw_type != BWD_HW) {
> > -			rc = -EIO;
> > -			goto err1;
> > -		}
> > -
> > -		dev_warn(&pdev->dev,
> > -			 "Only %d MSI-X vectors.  Limiting the number of queues to that number.\n",
> > -			 rc);
> > +		rc = pci_enable_msix_range(pdev, ndev->msix_entries,
> > +					   msix_entries, msix_entries);
> > +	else
> > +		rc = pci_enable_msix_range(pdev, ndev->msix_entries,
> > +					   1, msix_entries);
> 
> Actually, this must be 2 for the min.  One for the Data and one for
> the Link.  If you look a few lines after this in the original code,
> there is a grabbing of the last vector for the link.  I realize there
> is currently no check for this in the driver and a potential error
> case occurs.  I can make a separate patch to correct this issue if
> this patch is not going through my tree.

I am confused here again. In the original code I see "ntb-callback-msix"
is requested for all MSI-Xs on BWD_HW and "ntb-event-msix" requested for
the last vector on SNB_HW. Therefore, the range [1..msix_entries] should
be fine for BWD_HW, isn't it?

> Thanks,
> Jon

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
