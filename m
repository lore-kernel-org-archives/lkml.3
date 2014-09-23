Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaIWPwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:52:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:59776 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaIWPwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:52:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,580,1406617200"; 
   d="scan'208";a="595654770"
Date: Tue, 23 Sep 2014 18:52:02 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device
 properties interface
Message-ID: <20140923155202.GT1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1410868367-11056-8-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdaZJt_6cd1vtDw-Ys+YqUhNb0aXazUxGCX8mk4=6EmdHw@mail.gmail.com>
 <12538216.vu4CbU01qP@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12538216.vu4CbU01qP@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 05:45:57PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 17:25:50 Linus Walleij wrote:
> > On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > 
> > > Some drivers need to deal with only firmware representation of its
> > > GPIOs. An example would be a GPIO button array driver where each button
> > > is described as a separate firmware node in device tree. Typically these
> > > child nodes do not have physical representation in the Linux device
> > > model.
> > >
> > > In order to help device drivers to handle such firmware child nodes we
> > > add dev[m]_node_get_named_gpiod() that takes a firmware node pointer as
> > > parameter, finds the GPIO using whatever is the underlying firmware
> > > method, and requests the GPIO properly.
> > >
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > I have a hard time figuring out if this is what we want for common
> > accessors between DT and ACPI.
> > 
> > Can I get some input from Grant, Arnd, Mark, Darren...?
> 
> I just took a brief look at this. My first impression is that the
> fw_dev_node structure is weird when all callers just do (in patch 2)
> 
> +	struct fw_dev_node fdn = {
> +		.of_node = dev->of_node,
> +		.acpi_node = ACPI_COMPANION(dev),
> +	};
> 
> I'd much rather see an interface that passes the 'struct device'
> pointer down to dev_get_named_gpiod() and all other exported
> functions, and then internally does the conversion at the point
> where the access is done.

Problem is that if you don't have the dev pointer in the first place.
Please look how leds-gpio.c or gpio_keys_polled.c are using this.

Of course you have the first level device but when you need to iterate
"leds" or "buttons" below where there is no Linux device available we
need something like this.
