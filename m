Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3GYFHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 01:07:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3GYFH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 01:07:28 -0400
Date: Wed, 24 Jul 2013 22:08:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navinp@cdac.in>
Cc: mfm@muteddisk.com, sergei.shtylyov@cogentembedded.com, joe@perches.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] staging: usbip: replace pr_warning() with dev_warn().
Message-ID: <20130725050840.GA21814@kroah.com>
References: <CAPV97ydVKFdRuKRkW12KNmoh8ZoN-XoX=vW8CjaBz-u386ZOiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPV97ydVKFdRuKRkW12KNmoh8ZoN-XoX=vW8CjaBz-u386ZOiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 10:19:31AM +0530, navin patidar wrote:
> >> -        pr_warning("Unable to start control thread\n");
> >> +        struct device *dev;
> >> +
> >> +        if (ud->side == USBIP_STUB)
> >> +            dev = &container_of(ud, struct stub_device, ud)->udev->dev;
> >> +        else
> >> +            dev = &container_of(ud, struct vhci_device, ud)->udev->dev;
> >
> > Putting '&' in front of container_of seems odd, are you sure it's needed
> > here?  If ud is a pointer, everything else should "just work" properly
> > without that.
> 
> Removing '&'   caused following error.
> drivers/staging/usbip/usbip_event.c: In function ‘usbip_start_eh’:
> drivers/staging/usbip/usbip_event.c:93:8: error: incompatible types
> when assigning to type ‘struct device *’ from type ‘struct device’
> drivers/staging/usbip/usbip_event.c:95:8: error: incompatible types
> when assigning to type ‘struct device *’ from type ‘struct device’
> 
> dev needs to be initialized with address of dev (struct device ) which
> is member of struct usb_device pointed by the udev.
> 
> To make it more clear i can change it to
> 
> dev = &(container_of(ud, struct vhci_device, ud)->udev->dev);
> 
>  or
> 
> struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
> dev = &(vdev->udev->dev);

Or perhaps:
	dev = container_of(ud, struct stub_device, ud).udev->dev;

or ->udev.dev; I don't remember which, but that should work, right?

greg k-h
