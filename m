Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaIGJhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 05:37:16 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:55638 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaIGJhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 05:37:11 -0400
Message-ID: <1410082623.2650.9.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC v2] device coredump: add new device coredump class
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org
Date: Sun, 07 Sep 2014 11:37:03 +0200
In-Reply-To: <20140905221314.GA1533@kroah.com>
References: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
	 <20140905221314.GA1533@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 15:13 -0700, Greg Kroah-Hartman wrote:

> > +MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
> > +MODULE_DESCRIPTION("Device Coredump support");
> > +MODULE_LICENSE("GPL");
> 
> As you only allow Y or N as build options, it's not really a "module" :)

Umm, yeah. I went back and forth on whether this should be allowed to be
modular, but then decided it wasn't big enough to be worth it.

> > +	/*
> > +	 * this seems racy, but I don't see a notifier or such on
> > +	 * a struct device to know when it goes away?
> > +	 */
> > +	if (devcd->failing_dev->kobj.sd)
> > +		sysfs_delete_link(&devcd->failing_dev->kobj, &dev->kobj,
> > +				  "dev_coredump");
> 
> What is this link?  It should "just go away" if this:
> 
> > +	put_device(devcd->failing_dev);
> 
> was the last put_device() call on the failing_dev, right?  So you
> shouldn't need to make this call to sysfs_delete_link().

Oh, thanks, I'll try that. I did something slightly different first and
ended up with dead symlinks, but in that case I think I was actually
removing the bus/class of the device while the device was still alive or
something - that was a big mess.

> > +void dev_coredumpm(struct device *dev, struct module *owner,
> > +		   const void *data, size_t datalen, gfp_t gfp,
> > +		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
> > +				   const void *data, size_t datalen),
> > +		   void (*free)(const void *data))
> > +{
> > +	static atomic_t devcd_count = ATOMIC_INIT(0);
> > +	struct devcd_entry *devcd;
> > +	struct device *existing;
> > +
> > +	existing = class_find_device(&devcd_class, NULL, dev,
> > +				     devcd_match_failing);
> > +	if (existing) {
> > +		put_device(existing);
> > +		return;
> > +	}
> 
> I thought multiple dumps per "device" would throw away the older ones?
> It's fine if you don't, but you might want to document this behavior in
> the kerneldoc for the function.

I ... umm ... Yeah. I need to free the new one here. I actually wanted
to keep the first one because it seems likely that the driver would
attempt some sort of recovery and then if it happens to crash the device
again it's probably not very helpful to see the last crash.

But I definitely need to free the new one and document the behaviour.
Maybe if somebody needs something else we can make it configurable, but
for now I think all potential users have indicated that they'd prefer
keeping the first dump.

> Other than those very minor things, looks good to me, want to resend it
> cleaned up and without the "RFC" in the Subject?

Tomorrow :)

johannes

