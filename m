Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbaIRT7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:59:52 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:53486 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbaIRT7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:59:51 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Dinh Nguyen <dinguyen@opensource.altera.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv4 01/12] usb: dwc2: Update Kconfig to support dual-role
Thread-Topic: [PATCHv4 01/12] usb: dwc2: Update Kconfig to support dual-role
Thread-Index: AQHPwUoTG0V0UOa4iEiY4yP+9i85Ppv+NSoAgAlvPQD//8e9sA==
Date: Thu, 18 Sep 2014 19:59:47 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844D968C@US01WEMBX2.internal.synopsys.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-2-git-send-email-dinguyen@opensource.altera.com>
 <2539965.N1OFkvgc6j@amdc1032> <541B0030.3000904@opensource.altera.com>
In-Reply-To: <541B0030.3000904@opensource.altera.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dinh Nguyen [mailto:dinguyen@opensource.altera.com]
> Sent: Thursday, September 18, 2014 8:54 AM
> 
> On 09/12/2014 10:49 AM, Bartlomiej Zolnierkiewicz wrote:
> >
> > [ added linux-kernel ML to cc: ]
> >
> > Hi,
> >
> > On Tuesday, August 26, 2014 11:19:52 AM dinguyen@opensource.altera.com wrote:
> >> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> >>
> >> Update DWC2 kconfig and makefile to support dual-role mode. The platform
> >> file will always get compiled for the case where the controller is directly
> >> connected to the CPU. So for loadable modules, only dwc2.ko is needed.
> >
> > Kconfig and Makefile changes should be done after (or at the same time as)
> > driver code itself is modified to support dual-role mode.  Each individual
> > patch of the patchset should be correct itself (not cause any breakages)
> > in order to keep the whole patchset bisectable.
> >
> 
> Paulz mentioned this in v1 of this patch series and ever since then, I
> have been careful to test each patch on it's own, and each version since
> then has passed 0-Day kbuild testing. But I may have missed something in
> v4. Will try to move the edits to Kconfig/Makefile to end for v5.

As I said in another email, try building with ARM multi_v7_defconfig,
you should see the problems then (it defines CONFIG_PCI for example).
Also be sure to test building with all variations of the DWC2 config.

I would suggest deleting all of the object files in the dwc2/ directory
between builds, that will make it more obvious if something is missing
(for example, platform.o doesn't get built if CONFIG_PCI is defined).

> >> diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
> >> index f93807b..4396a1f 100644
> >> --- a/drivers/usb/dwc2/Kconfig
> >> +++ b/drivers/usb/dwc2/Kconfig
> >> @@ -1,40 +1,29 @@
> >>  config USB_DWC2
> >> -	bool "DesignWare USB2 DRD Core Support"
> >> +	tristate "DesignWare USB2 DRD Core Support"
> >>  	depends on USB
> >>  	help
> >>  	  Say Y here if your system has a Dual Role Hi-Speed USB
> >>  	  controller based on the DesignWare HSOTG IP Core.
> >>
> >> -	  For host mode, if you choose to build the driver as dynamically
> >> -	  linked modules, the core module will be called dwc2.ko, the PCI
> >> -	  bus interface module (if you have a PCI bus system) will be
> >> -	  called dwc2_pci.ko, and the platform interface module (for
> >> -	  controllers directly connected to the CPU) will be called
> >> -	  dwc2_platform.ko. For gadget mode, there will be a single
> >> -	  module called dwc2_gadget.ko.
> >> -
> >> -	  NOTE: The s3c-hsotg driver is now renamed to dwc2_gadget. The
> >> -	  host and gadget drivers are still currently separate drivers.
> >> -	  There are plans to merge the dwc2_gadget driver with the dwc2
> >> -	  host driver in the near future to create a dual-role driver.
> >> +	  If you choose to build the driver as dynamically
> >> +	  linked modules, a single dwc2.ko(regardless of mode of operation)
> >
> > minort nitpick: " " is missing after dwc2.ko
> >
> >> +	  will get built for both platform IPs and PCI.
> >
> > Why do you want ot merge both platform and PCI drivers into one?
> >
> > To do it properly you need to modify module_init/exit() of the final
> > module to properly handle both PCI and platform devices.  It should
> > be easier to leave separate dwc2_pci/platform drivers and just put
> > the common code into dwc2.ko.
> 
> I need to rework to the comment. I think it should say, "will get built
> for either platform IPs or PCI." I am not merging both platform and PCI
> drivers into one.

It looks to me like you are building the platform code into the main
dwc2.ko module, with a separate dwc2_pci.ko module. That might work
(I'm not sure), but as Bartlomiej said, I think it would be better to
have just the common code in dwc2.ko, with separate modules for pci
and platform. This is the pattern that DWC3 follows.

> > You've also left the "depends on USB_DWC2_HOST && PCI" unmodified
> > which causes DWC2 PCI support to show up only if "Host only mode"
> > is selected (it is not available if "Dual Role mode" is selected).
> >
> 
> Does PCI support gadget? I left it unmodified because I didn't think the
> PCI driver supported Gadget.

PCI can support gadget, but currently it is not implemented. I plan to
add that after this series goes in, since I think I have the only PCI
platform for DWC2. So I think it's fine to leave this as-is for now,
and I will change it later.
 
-- 
Paul

