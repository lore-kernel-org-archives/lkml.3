Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3JaWGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:06:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3JaWGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:06:19 -0400
Date: Thu, 31 Oct 2013 15:06:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: scameron@beardog.cce.hp.com
Cc: Jens Axboe <axboe@kernel.dk>, stephenmcameron@gmail.com,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success,
 not 1
Message-Id: <20131031150618.fa9430269e0de7a5ebad1387@linux-foundation.org>
In-Reply-To: <20131031215444.GN31390@beardog.cce.hp.com>
References: <20131029184135.5505.77412.stgit@beardog.cce.hp.com>
	<52700541.70405@kernel.dk>
	<20131031144241.25090ab7a6c0b668c5c1c2b2@linux-foundation.org>
	<20131031215444.GN31390@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 16:54:44 -0500 scameron@beardog.cce.hp.com wrote:

> > > How did this ever work?
> > 
> > Beats me.  local_pci_probe() does
> > 
> > 	rc = pci_drv->probe(pci_dev, ddi->id);
> > 	if (rc) {
> > 		pci_dev->driver = NULL;
> > 		pm_runtime_put_sync(dev);
> > 	}
> > 	return rc;
> > 
> > shrug, maybe this ->probe somehow has a different caller which checks
> > for <0.
> 
> Older kernels (eg: http://lxr.linux.no/#linux+v2.6.32.61/drivers/pci/pci-driver.c )
> had different code:
> 
>  330__pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
>  331{
>  332        const struct pci_device_id *id;
>  333        int error = 0;
>  334
>  335        if (!pci_dev->driver && drv->probe) {
>  336                error = -ENODEV;
>  337
>  338                id = pci_match_device(drv, pci_dev);
>  339                if (id)
>  340                        error = pci_call_probe(drv, pci_dev, id);
>  341                if (error >= 0) {
>  342                        pci_dev->driver = drv;
>  343                        error = 0;
>  344                }
>  345        }
>  346        return error;
>  347}

So cciss is presently kompletely kaput?  If so, the kapputting code is
present in 3.9 and probably earlier, so this patch is needed in 3.12 and
-stable.  Or if not, what?

(Playing question and answer like this is a bad way of writing a
changelog btw - all this stuff should have been right there in the v1
changelog).

