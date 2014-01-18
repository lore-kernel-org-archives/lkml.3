Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaARE03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 23:26:29 -0500
Received: from zougloub.eu ([198.27.83.45]:43667 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaARE01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 23:26:27 -0500
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jan 2014 23:26:27 EST
Date: Fri, 17 Jan 2014 23:18:20 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: "Marius  Silaghi" <msilaghi@fit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Lan Tianyu" <tianyu.lan@intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        "Jiri Kosina" <trivial@kernel.org>, ydesgagne@tamaggo.com
Subject: Re: [PATCH] usbcore: fix BABBLE failed enumeration of legacy USB2
 devices on USB3 bus
Message-ID: <20140117231820.0b6c900e@Vantage>
In-Reply-To: <02270BA454DB7548ABE8E2EBF31D46D96FC7F254@EX10-BE1.fit.edu>
References: <02270BA454DB7548ABE8E2EBF31D46D96FC7B4C5@EX10-BE1.fit.edu>
	<20140108003237.GF13062@kroah.com>
	<02270BA454DB7548ABE8E2EBF31D46D96FC7F254@EX10-BE1.fit.edu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I encountered the same problem with another device.
If possible, it would be nice to pick Marius's patch for stable
kernels (tested here on v3.12.6).

There are chances that MacOSX is affected by a similar issue,
so if anybody has friends there...


Thanks,

-- 
Jérôme


On Wed, 8 Jan 2014 04:00:22 +0000
"Marius  Silaghi" <msilaghi@fit.edu> wrote:

> 
> Great observation,
> Sarah located a patch that is queued for the 3.14 kernel and that has
> a similar effect. So future kernels could work with that one as well.
> 
> The patch I provided (being very small and safe) can still be
> suggested for maintainers of older kernels in various long-term
> maintained distributions (if you know who is doing that).
> 
> Here are some versions of the patch I made for current kernels:
> 
> The next one was tested on Ubuntu, applied to the source for
> 3.5.0-17-generic (Ubuntu)
> 
> --- linux-3.5.0/drivers/usb/core/hub.c.orig	2014-01-07
> 18:16:01.997031650 -0500 +++
> linux-3.5.0/drivers/usb/core/hub.c	2014-01-07
> 18:19:41.617022465 -0500 @@ -4043,7 +4043,11 @@ break;
>    		}
>  
> -		retval = usb_get_device_descriptor(udev, 8);
> +		if (!USE_NEW_SCHEME(retry_counter))
> +		  retval = usb_get_device_descriptor(udev, 8);
> +		else
> +		  retval = usb_get_device_descriptor(udev,
> +			    sizeof(struct usb_device_descriptor));
>  		if (retval < 8) {
>  			dev_err(&udev->dev,
>  					"device descriptor read/8,
> error %d\n",
> 
> 
> ________________________________________
> For kernel 3.9.0-0.4
> 
> --- linux-3.5.0/drivers/usb/core/hub.c.orig	2014-01-07
> 18:16:01.997031650 -0500 +++
> linux-3.5.0/drivers/usb/core/hub.c	2014-01-07
> 18:19:41.617022465 -0500 @@ -4043,7 +4043,11 @@ break;
>    		}
>  
> -		retval = usb_get_device_descriptor(udev, 8);
> +		if (!USE_NEW_SCHEME(retry_counter))
> +		  retval = usb_get_device_descriptor(udev, 8);
> +		else
> +		  retval = usb_get_device_descriptor(udev,
> +			    sizeof(struct usb_device_descriptor));
>  		if (retval < 8) {
>  			dev_err(&udev->dev,
>  					"device descriptor read/8,
> error %d\n",
> 
> ________________________________________
> 
> For kernel 3.10.0-5.15
> 
> --- ubuntu-saucy/drivers/usb/core/hub.c.orig	2014-01-07
> 16:52:41.300835262 -0500 +++
> ubuntu-saucy/drivers/usb/core/hub.c	2014-01-07
> 16:54:53.612829730 -0500 @@ -4126,8 +4126,11 @@ if
> (USE_NEW_SCHEME(retry_counter) && !(hcd->driver->flags & HCD_USB3))
> break; }
> -
> -		retval = usb_get_device_descriptor(udev, 8);
> +		if (!USE_NEW_SCHEME(retry_counter))
> +		  retval = usb_get_device_descriptor(udev, 8);
> +		else
> +		  retval = usb_get_device_descriptor(udev,
> +			    sizeof(struct usb_device_descriptor));
>  		if (retval < 8) {
>  			if (retval != -ENODEV)
>  				dev_err(&udev->dev,
> ________________________________________
> 
> For kernel 3.11
> --- linux-3.11/drivers/usb/core/hub.c.orig	2014-01-07
> 16:57:16.352823760 -0500 +++ linux-3.11/drivers/usb/core/hub.c
> 2014-01-07 16:58:10.168821508 -0500 @@ -4161,7 +4161,11 @@
>  				break;
>    		}
>  
> -		retval = usb_get_device_descriptor(udev, 8);
> +		if (!USE_NEW_SCHEME(retry_counter))
> +		  retval = usb_get_device_descriptor(udev, 8);
> +		else
> +		  retval = usb_get_device_descriptor(udev,
> +			    sizeof(struct usb_device_descriptor));
>  		if (retval < 8) {
>  			if (retval != -ENODEV)
>  				dev_err(&udev->dev,
> 
> 
> ________________________________________
> From: linux-usb-owner@vger.kernel.org
> [linux-usb-owner@vger.kernel.org] on behalf of Greg Kroah-Hartman
> [gregkh@linuxfoundation.org] Sent: Tuesday, January 07, 2014 19:32
> To: Marius  Silaghi Cc: Sarah Sharp; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; Alan Stern; Lan Tianyu; Xenia
> Ragiadakou; Jiri Kosina Subject: Re: [PATCH] usbcore: fix BABBLE
> failed enumeration of legacy USB2 devices on USB3 bus
> 
> On Tue, Dec 24, 2013 at 04:19:18AM +0000, Marius  Silaghi wrote:
> > From: Marius C Silaghi <msilaghi@fit.edu>
> >
> > This patch is generated against the last kernel version in the
> > github kernel repository.
> 
> We work off of the git.kernel.org trees, not github :)
> 
> 
> > Some older families of USB2 cameras (STC-XXXXXUSB) do not support
> > querying only the first 8 bytes of their device descriptor and
> > therefore fail at enumeration on USB3 HCDs, with babble error -75
> > as they send more than the expected 8 bytes. The proposed patch
> > extends the mechanism used for non USB3 HCDs in the first part of
> > the same function, and  successively tries to query both the 8 byte
> > prefix of the device descriptor, as well as the whole device
> > descriptor (in case the old style query of the 8 byte prefix
> > fails). In fact, for the cameras I try to fix, the preferred
> > condition is the negation of the one in the proposed patch, "if
> > (!USE_NEW_SCHEME(retry_counter))", to try first the version
> > successful on this case, but I keep the current order of the "if"
> > branches to ensure clean continuation of support for other
> > supported devices.
> >
> > Signed-off-by: Marius C Silaghi <msilaghi@fit.edu>
> 
> I'll let Sarah take this patch, if it passes her testing.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

