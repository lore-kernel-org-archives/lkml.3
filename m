Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381Ab3EBXmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:42:25 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:46945 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3EBXmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:42:24 -0400
Message-ID: <1367537373.16154.185.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/3 RFC] Driver core: Add offline/online device
 operations
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Date: Thu, 02 May 2013 17:29:33 -0600
In-Reply-To: <1431630.dgj2h0U6M6@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
	 <1989524.p5J87p9Tnl@vostro.rjw.lan>
	 <1367365118.16154.137.camel@misato.fc.hp.com>
	 <1431630.dgj2h0U6M6@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 02:58 +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 30, 2013 05:38:38 PM Toshi Kani wrote:
> > On Mon, 2013-04-29 at 14:26 +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 :
> > > + */
> > > +int device_offline(struct device *dev)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (dev->offline_disabled)
> > > +		return -EPERM;
> > > +
> > > +	ret = device_for_each_child(dev, NULL, device_check_offline);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	device_lock(dev);
> > > +	if (device_supports_offline(dev)) {
> > > +		if (dev->offline) {
> > > +			ret = 1;
> > > +		} else {
> > > +			ret = dev->bus->offline(dev);
> > > +			if (!ret) {
> > > +				kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> > > +				dev->offline = true;
> > 
> > Shouldn't this offline flag be set before sending KOBJ_OFFLINE?
> > 
> > > +			}
> > > +		}
> > > +	}
> > > +	device_unlock(dev);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +/**
> > > + * device_online - Put the device back online after successful device_offline().
> > > + * @dev: Device to be put back online.
> > > + *
> > > + * If device_offline() has been successfully executed for @dev, but the device
> > > + * has not been removed subsequently, execute its bus type's .online() callback
> > > + * to indicate that the device can be used again.
> > 
> > There is another use-case for online().  When a device like CPU is
> > hot-added, it is added in offline.  I am not sure why, but it has been
> > this way.  So, we need to call online() to make a new device available
> > for use after a hot-add.
> 
> Actually, in the CPU case that is left to user space as far as I can say.
> That is, the device appears initially offline and user space is supposed to
> bring it online via sysfs.
> 
> > > + *
> > > + * Call under device_offline_lock.
> > > + */
> > > +int device_online(struct device *dev)
> > > +{
> > > +	int ret = 0;
> > > +
> > > +	device_lock(dev);
> > > +	if (device_supports_offline(dev)) {
> > > +		if (dev->offline) {
> > > +			ret = dev->bus->online(dev);
> > > +			if (!ret) {
> > > +				kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> > > +				dev->offline = false;
> > 
> > Same comment as KOBJ_OFFLINE.
> 
> I wonder why the ordering may be important?

I do not think it causes any race condition (so this isn't a big deal),
but it seems to make more sense to emit an ONLINE/OFFLINE event after
its object is marked online/offline.

Thanks,
-Toshi




