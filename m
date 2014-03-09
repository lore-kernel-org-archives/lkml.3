Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbaCIFaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 00:30:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:51948 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaCIFaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 00:30:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,616,1389772800"; 
   d="scan'208";a="469060175"
Message-ID: <1394342970.9294.2.camel@rzhang1-mobl4>
Subject: Re: [RFC PATCH 2/8] PNPACPI: use whilte list for pnpacpi device
 enumeration
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Sun, 09 Mar 2014 13:29:30 +0800
In-Reply-To: <5270164.5tzAny1Rxt@vostro.rjw.lan>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
	 <1393405874-3266-3-git-send-email-rui.zhang@intel.com>
	 <5270164.5tzAny1Rxt@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 02:44 +0100, Rafael J. Wysocki wrote:
> On Wednesday, February 26, 2014 05:11:08 PM Zhang Rui wrote:
> > +
> > +static int __init acpi_pnp_scan_handler_attach(struct acpi_device *adev,
> 
> This can't be __init.
> 
> > +                                   const struct acpi_device_id *id)
> > +{
> > +	return 1;
> > +}
> > +
> > +static int __init acpi_pnp_scan_handler_match(char *devid, char *handlerid)
> 
> And this too.
> 
> > +{
> > +	int i;
> > +
> > +	if (!ispnpidacpi(devid))
> > +		return 0;
> > +
> > +	if (memcmp(devid, handlerid, 3))
> > +		return 0;
> > +
> > +        for (i = 3; i < 7; i++) {
> > +                if (handlerid[i] != 'X' &&
> > +		    toupper(devid[i]) != toupper(handlerid[i]))
> > +                        return 0;
> > +        }
> > +	return 1;
> > +}
> > +
> > +static struct acpi_scan_handler pnpacpi_handler __initdata = {
> 
> And this cannot be __initdata, because the list of ACPI scan handlers is
> walked during hotplug.
> 
right. will update it in next version.

> > +	.ids = acpi_pnp_device_ids,
> > +	.match = acpi_pnp_scan_handler_match,
> > +	.attach = acpi_pnp_scan_handler_attach,
> > +};
> > +
> > +void __init acpi_pnp_init(void)
> > +{
> > +	acpi_scan_add_handler(&pnpacpi_handler);
> > +}
> > +
> > +static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
> > +						     u32 lvl, void *context,
> > +						     void **rv)
> > +{
> > +	struct acpi_device *device;
> > +
> > +	if (acpi_bus_get_device(handle, &device))
> > +		return AE_CTRL_DEPTH;
> > +	if (device->handler == &pnpacpi_handler)
> > +		pnpacpi_add_device(device);
> 
> Why don't you do that in acpi_pnp_scan_handler_attach() ?
> 
because the PNP bus is not ready at that time.

thanks,
rui

