Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab3HGQ6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:58:05 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:64976 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756951Ab3HGQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:58:04 -0400
Message-ID: <1375894677.7303.55.camel@x61.thuisdomein>
Subject: Re: Can we drop __must_check from driver_for_each_device()?
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Wed, 07 Aug 2013 18:57:57 +0200
In-Reply-To: <20130807055154.GA5304@kroah.com>
References: <1375306513.8170.33.camel@x61.thuisdomein>
	 <20130802003157.GA11584@kroah.com>
	 <1375821085.7303.33.camel@x61.thuisdomein>
	 <20130807055154.GA5304@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2013 16:57:58.0504 (UTC) FILETIME=[44D99680:01CE938F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 14:51 +0900, Greg Kroah-Hartman wrote:
> On Tue, Aug 06, 2013 at 10:31:25PM +0200, Paul Bolle wrote:
> > On Fri, 2013-08-02 at 08:31 +0800, Greg Kroah-Hartman wrote:
> > > On Wed, Jul 31, 2013 at 11:35:13PM +0200, Paul Bolle wrote:
> > > > 2) Please note that if the callback always returns zero,
> > > > driver_for_each_device() can still return -EINVAL, but only if it was
> > > > provided a NULL "drv" (a struct device_driver). It sure seems odd to do
> > > > so. Can that actually happen?
> > > 
> > > Possibly.
> > 
> > So driver_for_each_device() really should be NULL "drv" safe.
> 
> Probably not, now that I think about it some more.  I don't see how that
> could ever really happen, do you?

No, I don't.

See there are two groups of user of driver_for_each_device():
1) those that call it on the device_driver member of their
platform_driver, pci_driver, or usb_driver. If that device_driver member
turns out to be NULL we've got bigger problems, I guess;
2) those that call driver_find() to get a pointer to a device_driver.
These users can trivially check for NULL before calling
driver_for_each_device().

[Side note: the comment above driver_find() reads in part:
    This routine provides no locking to prevent the driver it returns
    from being unregistered or unloaded while the caller is using it.
    The caller is responsible for preventing this.

None of these callers of driver_find() seem to be troubled by this.
Their use of the pointer to a device_driver could be racey.]

Anyhow, I think the NULL "dev" check can be dropped.

> > But wouldn't it therefor be better to make sure the callback functions
> > do not return -EINVAL themselves, so -EINVAL will always only indicate
> > the NULL "drv" case?
> 
> I doubt it's a real need at all.

This is, of course, why I raised this issue. Because if we drop the NULL
"drv" check, we have a function that will in most cases always return
zero, because the callbacks it uses mostly return zero. So I think that
if the NULL "drv" check could be dropped, we might as well drop
__must_check here. The few cases were the callback might return non-zero
are already handled correctly.

> > So, since this warning is still there, I'm looking for another way to
> > get rid of it.
> 
> Fix it properly would be good to do, don't you think?

It's hard to disagree with that!

Thanks,


Paul Bolle

