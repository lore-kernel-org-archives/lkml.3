Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3F1Fnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:43:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:37181 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab3F1Fnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:43:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,956,1363158000"; 
   d="scan'208";a="360892428"
Message-ID: <1372398218.9243.29.camel@envy.home>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr" <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders <danders@circuitco.com>,
        "vishal.l.verma" <vishal.l.verma@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Date: Thu, 27 Jun 2013 22:43:38 -0700
In-Reply-To: <CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	 <CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 11:14 +0200, Linus Walleij wrote:
> On Wed, Jun 26, 2013 at 3:53 AM, Darren Hart <dvhart@linux.intel.com> wrote:
> 
> > Provide a minimal public interface:
> >         minnow_detect()
> >         minnow_lvds_detect()
> >         minnow_hwid()
> >         minnow_phy_reset()
> 
> So instead of these calling drivers issueing gpio_request() themselves
> to obtain a resource, they make a function call to this proxy that issue
> gpio_request() for them.
> 
> This is generally not how we do things. A driver should request its
> GPIO just as it requests its regulator or clock or IRQ line or anything
> else.

I'll fix this for minnow_phy_reset() by moving the reset routine into
the pch_gbe driver and have it request the GPIO, using the pci_id
structure to determine the GPIO line.

I'll drop minnow_lvds_detect() and work toward the firmware managing
this aspect instead.

minnow_detect() doesn't access GPIO.

minnow_hwid() just returns an int that the minnowboard platform driver
read from the GPIO. This seems like a proper abstraction to me. Do you
object to this one as well?

>  Centralizing resource handling is not a good idea IMO, it's better
> that each driver request it's GPIO pin(s) and do the stuff it needs
> with them.

Understood. Since minnow_hwid() is not currently used anywhere anyway,
I'll take Olof's advice and just drop it. We can always add it back if
it becomes necessary.

> This of course creates the problem of associating the GPIOs to a
> driver and how it should look that up, which I guess ACPI can do,
> isn't that what acpi_find_gpio() is for?

The only one that remains is pch_gbe and we have a PCI Subsystem ID
there that we can use. Once we determine it is a MinnowBoard, we can
look the GPIO up by chip and offset. If this changes in future board
revs, we'll need minnow_hwid(), or we'll have to figure something out
either in the PCI config space or via ACPI as you suggested.

Thanks Linus, appreciate all the feedback.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

