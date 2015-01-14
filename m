Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbbANPHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:07:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35134 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753191AbbANPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:07:01 -0500
Date: Wed, 14 Jan 2015 10:07:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Christoph Hellwig <hch@infradead.org>
cc: Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <jbottomley@parallels.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for v3.19, v2] Avoid that sd_shutdown() triggers a kernel
 warning
In-Reply-To: <20150114093302.GA17532@infradead.org>
Message-ID: <Pine.LNX.4.44L0.1501141002500.1464-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Christoph Hellwig wrote:

> On Mon, Jan 12, 2015 at 11:29:15AM -0500, Alan Stern wrote:
> > This seems like a good idea and the obvious (once it has been pointed 
> > out!) approach.
> > 
> > Perhaps not directly related to the issue at hand is this question: In
> > scsi_rescan_device() we will now have:
> > 
> > 	mutex_lock(&shost->scan_mutex);
> > 	if (dev->driver && try_module_get(dev->driver->owner)) {
> > 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> > 
> > 		if (drv->rescan)
> > 			drv->rescan(dev);
> > 		module_put(dev->driver->owner);
> > 	}
> > 	mutex_unlock(&shost->scan_mutex);
> > 
> > What prevents the device from being unbound from its driver while the
> > rescan runs?  Evaluating the argument to the module_put() would then
> > dereference a NULL pointer.
> > 
> > Unbind events that happen through the normal scsi_remove_host() 
> > mechanism are fine, because scsi_remove_host() locks the scan_mutex.  
> > But what about writes to the driver's sysfs "unbind" attribute?
> 
> Looks like we should still get an unconditional reference to
> the device using get_device in scsi_rescan_device at least.

I'm not sure that's necessary.  scsi_rescan_device is exposed by sysfs, 
and the kernfs core insures that the underlying device won't be 
deallocated while a sysfs method runs.

(scsi_rescan_device is also EXPORTed, so in theory it could be called 
under less safe circumstances.  Perhaps then the burden should fall on 
the caller to guarantee that the device won't be deallocated.)

> But this seems like a more generic problem, and at least a quick glance at
> the pci_driver methods seems like others don't have a good
> synchroniation of ->remove against random driver methods.

Can you give one or two examples?

Alan Stern

