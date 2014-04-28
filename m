Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaD1Bul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:50:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:17811 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbaD1Bui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,940,1389772800"; 
   d="scan'208";a="529581030"
Message-ID: <1398649833.2443.6.camel@rzhang1-mobl4>
Subject: Re: [PATCH V5 05/12] ACPI: check and enumerate CMOS RTC devices
 explicitly
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Mon, 28 Apr 2014 09:50:33 +0800
In-Reply-To: <1564965.tVxnMB4jPP@vostro.rjw.lan>
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com>
	 <1396886819-2637-6-git-send-email-rui.zhang@intel.com>
	 <2272159.YQH4PJyHMe@vostro.rjw.lan> <1564965.tVxnMB4jPP@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 00:19 +0200, Rafael J. Wysocki wrote:
> On Monday, April 28, 2014 12:17:49 AM Rafael J. Wysocki wrote:
> > On Tuesday, April 08, 2014 12:06:52 AM Zhang Rui wrote:
> > > For CMOS RTC devices, the acpi pnp scan handler does not work because
> > > there is already a cmos rtc scan handler installed, thus we need to
> > > check those devices and enumerate them to PNP bus explicitly.
> > > Plus, the cmos rtc scan handler needs to return 1 so that it will not
> > > be enumerated to platform bus.
> > > 
> > > Note: the CMOS RTC device id is not removed from ACPI pnp scan handler
> > >       id list, thus, if cmos rtc scan handler is compiled out, the ACPI
> > >       pnp scan handler will be attached to the CMOS RTC devices instead,
> > >       to prevent these devices from being created to platform bus.
> > > 
> > > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > > ---
> > >  drivers/acpi/acpi_cmos_rtc.c |    2 +-
> > >  drivers/acpi/acpi_pnp.c      |   22 +++++++++++++++++++++-
> > >  2 files changed, 22 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/acpi_cmos_rtc.c b/drivers/acpi/acpi_cmos_rtc.c
> > > index 961b45d..2da8660 100644
> > > --- a/drivers/acpi/acpi_cmos_rtc.c
> > > +++ b/drivers/acpi/acpi_cmos_rtc.c
> > > @@ -68,7 +68,7 @@ static int acpi_install_cmos_rtc_space_handler(struct acpi_device *adev,
> > >  		return -ENODEV;
> > >  	}
> > >  
> > > -	return 0;
> > > +	return 1;
> > >  }
> > >  
> > >  static void acpi_remove_cmos_rtc_space_handler(struct acpi_device *adev)
> > > diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> > > index 8cf7d9d..387b150 100644
> > > --- a/drivers/acpi/acpi_pnp.c
> > > +++ b/drivers/acpi/acpi_pnp.c
> > > @@ -349,9 +349,29 @@ static struct acpi_scan_handler acpi_pnp_handler = {
> > >  	.attach = acpi_pnp_scan_handler_attach,
> > >  };
> > >  
> > > +/*
> > > + * For CMOS RTC devices, the acpi pnp spcan handler does not work because
> > > + * there is already a cmos rtc scan handler installed, thus we need to
> > > + * check those devices and enumerate them to PNP bus explicitly.
> > > + */
> > > +static int is_cmos_rtc_device(struct acpi_device *adev)
> > > +{
> > > +	struct acpi_device_id ids[] = {
> > > +		{ "PNP0B00" },
> > > +		{ "PNP0B01" },
> > > +		{ "PNP0B02" },
> > > +		{""},
> > > +	};
> > > +	return !acpi_match_device_ids(adev, ids);
> > > +}
> > > +
> > >  bool acpi_is_pnp_device(struct acpi_device *device)
> > >  {
> > > -	return device->handler == &acpi_pnp_handler;
> > > +	if (device->handler == &acpi_pnp_handler)
> > > +		return true;
> > > +	if (is_cmos_rtc_device(device))
> > > +		return true;
> > > +	return false;
> > 
> > What about doing
> > 
> > 	return device->handler == &acpi_pnp_handler || is_cmos_rtc_device(device);
> > 
> > instead?
> > 
okay.

> > >  }
> > >  EXPORT_SYMBOL_GPL(acpi_is_pnp_device);
> 
> Moreover, it looks like this patch should be folded into [2/12] to avoid
> breaking bisection.
> 
well, I wanted to make the patch clean and cleasr so I preferred to do
one thing in one patch and fix the side effect in a later patch as long
as it builds okay.
But you're right, will merge them in next version.

thanks,
rui

