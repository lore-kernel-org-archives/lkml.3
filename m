Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaCNJfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:35:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40249 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbaCNJfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:35:01 -0400
Date: Fri, 14 Mar 2014 02:34:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140314093458.GA19451@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <20140313161347.GA6598@redhat.com>
 <20140314092519.GA10139@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314092519.GA10139@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 02:25:19AM -0700, Christoph Hellwig wrote:
> b) is a bit harder, but we should think hard about it when rewriting the
> multipath code to support blk-mq.  Talking about which I think trying to
> use dm-multipath on any blk-mq device will go horribly crash and boom at
> the moment.

Talking abnout crashing and burning.. Hannes, did you run this patch
past dm-devel and linux-scsi yet?  Don't quite like it but the problem
seems real..


From: Hannes Reinecke <hare@suse.de>
Subject: Kernel bug triggered in multipath
References: bnc#486001
Patch-mainline: not yet

Starting multipath on a cciss device will cause a kernel
warning to be triggered. Problem is that we're using the
->queuedata field of the request_queue to derefence the
scsi device; however, for other (non-SCSI) devices this
points to a totally different structure.
So we should rather be using accessors here which make
sure we're only returning valid SCSI device structures.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/device_handler/scsi_dh.c |   10 +++++-----
 drivers/scsi/scsi_lib.c               |   11 +++++++++++
 include/scsi/scsi_device.h            |    1 +
 3 files changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -397,7 +397,7 @@ int scsi_dh_activate(struct request_queu
 	struct device *dev = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (!sdev) {
		spin_unlock_irqrestore(q->queue_lock, flags);
		err = SCSI_DH_NOSYS;
@@ -484,7 +484,7 @@ int scsi_dh_attach(struct request_queue
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (!sdev || !get_device(&sdev->sdev_gendev))
 		err = -ENODEV;
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -512,7 +512,7 @@ void scsi_dh_detach(struct request_queue
 	struct scsi_device_handler *scsi_dh = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	sdev = q->queuedata;
+	sdev = scsi_device_from_queue(q);
 	if (!sdev || !get_device(&sdev->sdev_gendev))
 		sdev = NULL;
 	spin_unlock_irqrestore(q->queue_lock, flags);
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1594,6 +1594,17 @@ out:
 	spin_lock_irq(q->queue_lock);
 }
 
+struct scsi_device *scsi_device_from_queue(struct request_queue *q)
+{
+	struct scsi_device *sdev = NULL;
+
+	if (q->request_fn == scsi_request_fn)
+		sdev = q->queuedata;
+
+	return sdev;
+}
+EXPORT_SYMBOL_GPL(scsi_device_from_queue);
+
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -300,6 +300,7 @@ extern void starget_for_each_device(stru
 extern void __starget_for_each_device(struct scsi_target *, void *,
 				      void (*fn)(struct scsi_device *,
 						 void *));
+extern struct scsi_device *scsi_device_from_queue(struct request_queue *);
 
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
