Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3JaVmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 17:42:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3JaVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 17:42:43 -0400
Date: Thu, 31 Oct 2013 14:42:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success,
 not 1
Message-Id: <20131031144241.25090ab7a6c0b668c5c1c2b2@linux-foundation.org>
In-Reply-To: <52700541.70405@kernel.dk>
References: <20131029184135.5505.77412.stgit@beardog.cce.hp.com>
	<52700541.70405@kernel.dk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013 12:58:09 -0600 Jens Axboe <axboe@kernel.dk> wrote:

> On 10/29/2013 12:41 PM, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > A return value of 1 is interpreted as an error
> > 
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > ---
> >  drivers/block/cciss.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > index edfa251..0c004ac 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -5183,7 +5183,7 @@ reinit_after_soft_reset:
> >  	rebuild_lun_table(h, 1, 0);
> >  	cciss_engage_scsi(h);
> >  	h->busy_initializing = 0;
> > -	return 1;
> > +	return 0;
> >  
> >  clean4:
> >  	cciss_free_cmd_pool(h);
> > 
> 
> How did this ever work?

Beats me.  local_pci_probe() does

	rc = pci_drv->probe(pci_dev, ddi->id);
	if (rc) {
		pci_dev->driver = NULL;
		pm_runtime_put_sync(dev);
	}
	return rc;

shrug, maybe this ->probe somehow has a different caller which checks
for <0.


While we're there...

From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/block/cciss.c:cciss_init_one(): use proper errnos

pci_driver.probe should return a meaningful errno, not -1.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~drivers-block-ccissc-cciss_init_one-use-proper-errnos drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-ccissc-cciss_init_one-use-proper-errnos
+++ a/drivers/block/cciss.c
@@ -5004,7 +5004,7 @@ reinit_after_soft_reset:
 
 	i = alloc_cciss_hba(pdev);
 	if (i < 0)
-		return -1;
+		return -ENOMEM;
 
 	h = hba[i];
 	h->pdev = pdev;
@@ -5205,7 +5205,7 @@ clean_no_release_regions:
 	 */
 	pci_set_drvdata(pdev, NULL);
 	free_hba(h);
-	return -1;
+	return -ENODEV;
 }
 
 static void cciss_shutdown(struct pci_dev *pdev)
_

