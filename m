Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3KAOIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:08:41 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43907 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3KAOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:08:40 -0400
Date: Fri, 1 Nov 2013 09:08:37 -0500
From: scameron@beardog.cce.hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tomas Henzl <thenzl@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success, not 1
Message-ID: <20131101140837.GO31390@beardog.cce.hp.com>
References: <20131029184135.5505.77412.stgit@beardog.cce.hp.com> <52700541.70405@kernel.dk> <20131031144241.25090ab7a6c0b668c5c1c2b2@linux-foundation.org> <20131031215444.GN31390@beardog.cce.hp.com> <20131031150618.fa9430269e0de7a5ebad1387@linux-foundation.org> <5273A765.6080705@redhat.com> <20131101063110.6a390f48.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101063110.6a390f48.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 06:31:10AM -0700, Andrew Morton wrote:
> On Fri, 01 Nov 2013 14:06:45 +0100 Tomas Henzl <thenzl@redhat.com> wrote:
> 
> > The problem in kernel is that the error handling in local_pci_probe
> > and  in __pci_device_probe is different for ret values > 0,
> > so we should fix it somewhere so it is in sync.
> > The documentation states that the probe function should return zero on success
> > so what about this -
> > 
> > This would bring the handling to sync
> > diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> > index 98f7b9b..200a071 100644
> > --- a/drivers/pci/pci-driver.c
> > +++ b/drivers/pci/pci-driver.c
> > @@ -317,8 +317,6 @@ __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
> >  		id = pci_match_device(drv, pci_dev);
> >  		if (id)
> >  			error = pci_call_probe(drv, pci_dev, id);
> > -		if (error >= 0)
> > -			error = 0;
> >  	}
> >  	return error;
> >  }
> 
> ah, there it is.
> 
> This change would turn semi-kaput drivers into kaput-kaput drivers.  It
> would be better to add a runtime warning here so those drivers get
> fixed.  Such a warning would need to reliably identify the offending
> probe function so a simple WARN_ON() wouldn't be sufficient.
> 

FWIW, I just booted up with the following change:

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 98f7b9b..ef71bb5 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -264,9 +264,16 @@ static long local_pci_probe(void *_ddi)
 	pm_runtime_get_sync(dev);
 	pci_dev->driver = pci_drv;
 	rc = pci_drv->probe(pci_dev, ddi->id);
-	if (rc) {
+	if (rc < 0) {
 		pci_dev->driver = NULL;
 		pm_runtime_put_sync(dev);
+	} else {
+		if (rc > 0) {
+			dev_warn(dev,
+				"Driver probe function returned %d, greater than 0\n", rc);
+			rc = 0;
+			
+		}
 	}
 	return rc;
 }


And,

[scameron@localhost linux-3.12-rc6]$ dmesg | grep 'Driver probe'
[scameron@localhost linux-3.12-rc6]$

Not that it means all that much since I don't have hardware for
the majority of drivers, obviously.

I think the above should make drivers with probe functions
returning > 0 "work" again, but with a warning.

The question would be, are there drivers which return > 0 and
by this value intend to convey that the probe function has failed?

-- steve

