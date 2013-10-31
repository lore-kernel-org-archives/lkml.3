Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3JaVyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 17:54:49 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:28203 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3JaVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 17:54:48 -0400
Date: Thu, 31 Oct 2013 16:54:44 -0500
From: scameron@beardog.cce.hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, stephenmcameron@gmail.com,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com, scameron@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success, not 1
Message-ID: <20131031215444.GN31390@beardog.cce.hp.com>
References: <20131029184135.5505.77412.stgit@beardog.cce.hp.com> <52700541.70405@kernel.dk> <20131031144241.25090ab7a6c0b668c5c1c2b2@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031144241.25090ab7a6c0b668c5c1c2b2@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 02:42:41PM -0700, Andrew Morton wrote:
> On Tue, 29 Oct 2013 12:58:09 -0600 Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On 10/29/2013 12:41 PM, Stephen M. Cameron wrote:
> > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > 
> > > A return value of 1 is interpreted as an error
> > > 
> > > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > ---
> > >  drivers/block/cciss.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > > index edfa251..0c004ac 100644
> > > --- a/drivers/block/cciss.c
> > > +++ b/drivers/block/cciss.c
> > > @@ -5183,7 +5183,7 @@ reinit_after_soft_reset:
> > >  	rebuild_lun_table(h, 1, 0);
> > >  	cciss_engage_scsi(h);
> > >  	h->busy_initializing = 0;
> > > -	return 1;
> > > +	return 0;
> > >  
> > >  clean4:
> > >  	cciss_free_cmd_pool(h);
> > > 
> > 
> > How did this ever work?
> 
> Beats me.  local_pci_probe() does
> 
> 	rc = pci_drv->probe(pci_dev, ddi->id);
> 	if (rc) {
> 		pci_dev->driver = NULL;
> 		pm_runtime_put_sync(dev);
> 	}
> 	return rc;
> 
> shrug, maybe this ->probe somehow has a different caller which checks
> for <0.

Older kernels (eg: http://lxr.linux.no/#linux+v2.6.32.61/drivers/pci/pci-driver.c )
had different code:

 330__pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 331{
 332        const struct pci_device_id *id;
 333        int error = 0;
 334
 335        if (!pci_dev->driver && drv->probe) {
 336                error = -ENODEV;
 337
 338                id = pci_match_device(drv, pci_dev);
 339                if (id)
 340                        error = pci_call_probe(drv, pci_dev, id);
 341                if (error >= 0) {
 342                        pci_dev->driver = drv;
 343                        error = 0;
 344                }
 345        }
 346        return error;
 347}

> 
> 
> While we're there...
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/block/cciss.c:cciss_init_one(): use proper errnos
> 
> pci_driver.probe should return a meaningful errno, not -1.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/block/cciss.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/block/cciss.c~drivers-block-ccissc-cciss_init_one-use-proper-errnos drivers/block/cciss.c
> --- a/drivers/block/cciss.c~drivers-block-ccissc-cciss_init_one-use-proper-errnos
> +++ a/drivers/block/cciss.c
> @@ -5004,7 +5004,7 @@ reinit_after_soft_reset:
>  
>  	i = alloc_cciss_hba(pdev);
>  	if (i < 0)
> -		return -1;
> +		return -ENOMEM;
>  
>  	h = hba[i];
>  	h->pdev = pdev;
> @@ -5205,7 +5205,7 @@ clean_no_release_regions:
>  	 */
>  	pci_set_drvdata(pdev, NULL);
>  	free_hba(h);
> -	return -1;
> +	return -ENODEV;
>  }
>  
>  static void cciss_shutdown(struct pci_dev *pdev)
> _

Thanks.

-- steve

