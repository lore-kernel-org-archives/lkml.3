Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaLWUmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:42:10 -0500
Received: from mga14.intel.com ([192.55.52.115]:58826 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaLWUmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:42:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,633,1413270000"; 
   d="scan'208";a="652352213"
Date: Tue, 23 Dec 2014 12:43:22 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        baolu.lu@linux.intel.com
Subject: Re: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port
 controlled by GPIO(s)
Message-ID: <20141223204322.GB19996@psi-dev26.jf.intel.com>
References: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
 <549969D4.5020303@cogentembedded.com>
 <20141223195709.GA19996@psi-dev26.jf.intel.com>
 <5499CC08.8000606@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5499CC08.8000606@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 11:09:44PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 12/23/2014 10:57 PM, David Cohen wrote:
> 
> >>>Some platforms have an USB OTG port fully (or partially) controlled by
> >>>GPIOs:
> 
> >>>(1) USB ID is connected directly to GPIO
> 
> >>>Optionally:
> >>>(2) VBUS is enabled by a GPIO (when ID is grounded)
> 
> >>    Can't the host driver still control Vbus?
> 
> >I can't a clean way for host driver to control VBUS considering it
> >depends on USB ID.
> 
>    You're using the cable state notifiers, why not control Vbus from there?
> You need some way of passing the GPIO to host driver though... I assume
> you're not using the device tree, and your host controllers live on PCI, so
> the platform data is out of question. You may be right then...

Yes to all questions :)

> 
> >>>(3) Platform has 2 USB controllers connected to same port: one for
> >>>     device and one for host role. D+/- are switched between phys
> >>>     by GPIO.
> 
> >>>As per initial version, this driver has the duty to control whether
> >>>USB-Host cable is plugged in or not:
> >>>  - If yes, OTG port is configured for host role
> >>>  - If no, by standard, the OTG port is configured for device role
> 
> >>>Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> >>>---
> 
> >>>Hi,
> 
> >>>Some Intel Bay Trail boards have an unusual way to handle the USB OTG port:
> >>>  - The USB ID pin is connected directly to GPIO on SoC
> >>>  - When in host role, VBUS is provided by enabling a GPIO
> >>>  - Device and host roles are supported by 2 independent controllers with D+/-
> >>>    pins from port switched between different phys according a GPIO level.
> 
> >>>The ACPI table describes this USB port as a (virtual) device with all the
> >>>necessary GPIOs. This driver implements support to this virtual device as an
> >>>extcon class driver. All drivers that depend on the USB OTG port state (USB phy,
> >>>PMIC, charge detection) will listen to extcon events.
> 
> >>    It's very close to my setup on R-Car R8A7791 based boards. :-)
> >>I have already submitted Maxim MAX3355 OTG chip GPIO-based driver.
> 
> >Hm. I'll look for it. Thanks for pointing.
> 
>    http://marc.info/?l=linux-usb&m=141825413802370
>    In my case, Vbus is not controlled via GPIO though. I would have probably
> used the generic GPIO extcon driver if I didn't have to drive MAX3355's
> SHDN# pin high...

Besides the USB ID, I need to control VBUS and the D+/- switch. We have
a new use case coming soon that may need to add a second switch control.

>    There were also some other patches for this issue, the one probably
> interesting to you is there:
> 
>    http://marc.info/?l=linux-usb&m=141877180912359

This one is interesting, but I'm restricted to ACPI and to the DSDTs already
released.
E.g. http://www.androidauthority.com/trekstor-xintron-lollipop-564364/

Br, David

> 
> >>>Comments are welcome.
> 
> >>>Br, David
> 
> [...]
> 
> >>>+static int __init vuport_init(void)
> >>>+{
> >>>+	return platform_driver_register(&vuport_driver);
> >>>+}
> >>>+subsys_initcall(vuport_init);
> 
> >>    Hm, why?
> 
> >We have drivers that depend on this one during their probe.
> 
>    What about deferred probing? With EPROBE_DEFER we don't need to play the
> initcall games any more AFAIU.
> 
> >Br, David
> 
> WBR, Sergei
> 
