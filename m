Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaJWNaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:30:19 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:57153 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJWNaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:30:16 -0400
Date: Thu, 23 Oct 2014 15:30:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v3 09/16] virtio: set FEATURES_OK
Message-ID: <20141023153006.0cb1e7c3.cornelia.huck@de.ibm.com>
In-Reply-To: <20141023125139.GA10033@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
	<1414003404-505-10-git-send-email-mst@redhat.com>
	<20141023142808.377551d8.cornelia.huck@de.ibm.com>
	<20141023125139.GA10033@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102313-0013-0000-0000-00000194B30F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 15:51:39 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Thu, Oct 23, 2014 at 02:28:08PM +0200, Cornelia Huck wrote:
> > On Wed, 22 Oct 2014 21:44:44 +0300
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > set FEATURES_OK as per virtio 1.0 spec
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  include/uapi/linux/virtio_config.h |  2 ++
> > >  drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
> > >  2 files changed, 24 insertions(+), 7 deletions(-)
> > > 
> > 
> > >  	dev->config->finalize_features(dev);
> > > 
> > > +	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> > > +		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> > > +		status = dev->config->get_status(dev);
> > > +		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> > > +			printk(KERN_ERR "virtio: device refuses features: %x\n",
> > > +			       status);
> > > +			err = -ENODEV;
> > > +			goto err;
> > > +		}
> > > +	}
> > > +
> > 
> > Ugh, I just realize that virtio-ccw has a problem with that mechanism :(
> > 
> > Up to now, the driver only propagated status to the device: For
> > virtio-ccw, this was easily implemented via a ccw that transmitted
> > "status" to the device. However, the "read back status" part now
> > actually requires that the driver can get "status" from the device, or
> > has a comparable way to find out that the device won't accept the
> > status it tried to write.
> 
> Ugh, it actually caches the status in the transport :(

Well, it worked as long as this was unidirectional...

> 
> 
> > I can think of two solutions:
> > 
> > (1) Introduce a new ccw that actually reads the device status.
> > (2) Make the WRITE_STATUS ccw fail (with a unit check) if the driver
> >     sets FEATURES_OK after it tried to set features the device won't
> >     accept.
> > 
> > (1) is probably more generic, while (2) is more straightforward to
> > implement.
> > 
> > Good thing we actually try to finally implement this,
> 
> > I did not notice
> > this problem during the review :(
> 
> Well, it's a nuisance, but the spec is out.
> It seems to me a new command would be a substantive change so we can't
> do this in errata.
> 
> Option (2) would require two statements for drivers and devices,
> but since it's clearly the case for correct drivers/devices
> that command does not fail, it follows that this
> is not a substantive change so it can be fixed
> in an errata.

It only adds a new failure case, so it's not really magic, agreed.

> 
> So the new command would have to be optional, 

I think a new command should be tied to a new virtio-ccw revision.

> please open
> two issues in the TC: one documenting that driver must check
> WRITE_STATUS and device can fail WRITE_STATUS, and another
> for adding READ_STATUS (which will have to wait until
> the next CS).

I think I need to contemplate that a bit more. The problem with a new
READ_STATUS is that it is, by nature, an asynchronous command (as all
ccw commands are - the Linux guest driver uses a simple wrapper that
makes it appear synchronous). This means, for example, that every
status update now involves two channel programs instead of one, and
that reading e.g. the status sysfs attribute in Linux now triggers
channel I/O, which means several exits (at least ssch, interrupt
injection, tsch; probably more depending on what the guest does)...

