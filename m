Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaCJCYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:24:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:29556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbaCJCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:24:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,621,1389772800"; 
   d="scan'208";a="469338832"
Message-ID: <1394418250.10554.7.camel@rzhang1-mobl4>
Subject: Re: [RFC PATCH 2/8] PNPACPI: use whilte list for pnpacpi device
 enumeration
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Mon, 10 Mar 2014 10:24:10 +0800
In-Reply-To: <1493365.6dEb5KKfS7@vostro.rjw.lan>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
	 <5270164.5tzAny1Rxt@vostro.rjw.lan> <1394342970.9294.2.camel@rzhang1-mobl4>
	 <1493365.6dEb5KKfS7@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-09 at 18:49 +0100, Rafael J. Wysocki wrote:
> On Sunday, March 09, 2014 01:29:30 PM Zhang Rui wrote:
> > On Fri, 2014-03-07 at 02:44 +0100, Rafael J. Wysocki wrote:
> > > On Wednesday, February 26, 2014 05:11:08 PM Zhang Rui wrote:
> > > > +
> > > > +static int __init acpi_pnp_scan_handler_attach(struct acpi_device *adev,
> > > 
> > > This can't be __init.
> > > 
> > > > +                                   const struct acpi_device_id *id)
> > > > +{
> > > > +	return 1;
> > > > +}
> > > > +
> > > > +static int __init acpi_pnp_scan_handler_match(char *devid, char *handlerid)
> > > 
> > > And this too.
> > > 
> > > > +{
> > > > +	int i;
> > > > +
> > > > +	if (!ispnpidacpi(devid))
> > > > +		return 0;
> > > > +
> > > > +	if (memcmp(devid, handlerid, 3))
> > > > +		return 0;
> > > > +
> > > > +        for (i = 3; i < 7; i++) {
> > > > +                if (handlerid[i] != 'X' &&
> > > > +		    toupper(devid[i]) != toupper(handlerid[i]))
> > > > +                        return 0;
> > > > +        }
> > > > +	return 1;
> > > > +}
> > > > +
> > > > +static struct acpi_scan_handler pnpacpi_handler __initdata = {
> > > 
> > > And this cannot be __initdata, because the list of ACPI scan handlers is
> > > walked during hotplug.
> > > 
> > right. will update it in next version.
> > 
> > > > +	.ids = acpi_pnp_device_ids,
> > > > +	.match = acpi_pnp_scan_handler_match,
> > > > +	.attach = acpi_pnp_scan_handler_attach,
> > > > +};
> > > > +
> > > > +void __init acpi_pnp_init(void)
> > > > +{
> > > > +	acpi_scan_add_handler(&pnpacpi_handler);
> > > > +}
> > > > +
> > > > +static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
> > > > +						     u32 lvl, void *context,
> > > > +						     void **rv)
> > > > +{
> > > > +	struct acpi_device *device;
> > > > +
> > > > +	if (acpi_bus_get_device(handle, &device))
> > > > +		return AE_CTRL_DEPTH;
> > > > +	if (device->handler == &pnpacpi_handler)
> > > > +		pnpacpi_add_device(device);
> > > 
> > > Why don't you do that in acpi_pnp_scan_handler_attach() ?
> > > 
> > because the PNP bus is not ready at that time.
> 
> Do you mean it hasn't been initialized yet?
> 
right.
both acpi_init() and pnp_init() are subsys_initcall, but pnp_init() is
invoked later because of the link order.

> But we can initialize it before the scan handler initialization, can't we?
> 
well, I'm not sure, here is what I get from drivers/Makefile
obj-$(CONFIG_ACPI)              += acpi/
obj-$(CONFIG_SFI)               += sfi/
# PnP must come after ACPI since it will eventually need to check ifacpi
# was used and do nothing if so
obj-$(CONFIG_PNP)               += pnp/

this comment was added long time ago and I do not know the background of
it, maybe Len knows the reason of this?

thanks,
rui

