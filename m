Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaAETec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 14:34:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16478 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAETeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 14:34:21 -0500
Date: Sun, 5 Jan 2014 14:33:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com, hpa@zytor.com
Subject: Re: [PATCH v13 15/19] xen/grant-table: Refactor gnttab_init
Message-ID: <20140105193312.GB12263@phenom.dumpdata.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
 <1388777916-1328-16-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1401051817150.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401051817150.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 06:18:03PM +0000, Stefano Stabellini wrote:
> On Fri, 3 Jan 2014, Konrad Rzeszutek Wilk wrote:
> > We have this odd scenario of where for PV paths we take a shortcut
> > but for the HVM paths we first ioremap xen_hvm_resume_frames, then
> > assign it to gnttab_shared.addr. This is needed because gnttab_map
> > uses gnttab_shared.addr.
> > 
> > Instead of having:
> > 	if (pv)
> > 		return gnttab_map
> > 	if (hvm)
> > 		...
> > 
> > 	gnttab_map
> > 
> > Lets move the HVM part before the gnttab_map and remove the
> > first call to gnttab_map.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> As I wrote in my reply to the previous version of the patch, you can
> have my acked-by, except for the spurious code style fix mixed-up with
> the other changes.

Thanks. I fixed it up (removed the code style fix).

> 
> 
> >  drivers/xen/grant-table.c | 13 ++++---------
> >  1 file changed, 4 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > index 99399cb..cc1b4fa 100644
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> > @@ -1173,22 +1173,17 @@ static int gnttab_setup(void)
> >  	if (max_nr_gframes < nr_grant_frames)
> >  		return -ENOSYS;
> >  
> > -	if (xen_pv_domain())
> > -		return gnttab_map(0, nr_grant_frames - 1);
> > -
> > -	if (gnttab_shared.addr == NULL) {
> > +	if (xen_feature(XENFEAT_auto_translated_physmap) && gnttab_shared.addr == NULL)
> > +	{
> >  		gnttab_shared.addr = xen_remap(xen_hvm_resume_frames,
> > -						PAGE_SIZE * max_nr_gframes);
> > +					       PAGE_SIZE * max_nr_gframes);
> >  		if (gnttab_shared.addr == NULL) {
> >  			pr_warn("Failed to ioremap gnttab share frames (addr=0x%08lx)!\n",
> >  					xen_hvm_resume_frames);
> >  			return -ENOMEM;
> >  		}
> >  	}
> > -
> > -	gnttab_map(0, nr_grant_frames - 1);
> > -
> > -	return 0;
> > +	return gnttab_map(0, nr_grant_frames - 1);
> >  }
> >  
> >  int gnttab_resume(void)
> > -- 
> > 1.8.3.1
> > 
