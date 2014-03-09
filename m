Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaCIReb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:34:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58302 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752578AbaCIRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:34:30 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Subject: Re: [RFC PATCH 2/8] PNPACPI: use whilte list for pnpacpi device enumeration
Date: Sun, 09 Mar 2014 18:49:46 +0100
Message-ID: <1493365.6dEb5KKfS7@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394342970.9294.2.camel@rzhang1-mobl4>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com> <5270164.5tzAny1Rxt@vostro.rjw.lan> <1394342970.9294.2.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 09, 2014 01:29:30 PM Zhang Rui wrote:
> On Fri, 2014-03-07 at 02:44 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, February 26, 2014 05:11:08 PM Zhang Rui wrote:
> > > +
> > > +static int __init acpi_pnp_scan_handler_attach(struct acpi_device *adev,
> > 
> > This can't be __init.
> > 
> > > +                                   const struct acpi_device_id *id)
> > > +{
> > > +	return 1;
> > > +}
> > > +
> > > +static int __init acpi_pnp_scan_handler_match(char *devid, char *handlerid)
> > 
> > And this too.
> > 
> > > +{
> > > +	int i;
> > > +
> > > +	if (!ispnpidacpi(devid))
> > > +		return 0;
> > > +
> > > +	if (memcmp(devid, handlerid, 3))
> > > +		return 0;
> > > +
> > > +        for (i = 3; i < 7; i++) {
> > > +                if (handlerid[i] != 'X' &&
> > > +		    toupper(devid[i]) != toupper(handlerid[i]))
> > > +                        return 0;
> > > +        }
> > > +	return 1;
> > > +}
> > > +
> > > +static struct acpi_scan_handler pnpacpi_handler __initdata = {
> > 
> > And this cannot be __initdata, because the list of ACPI scan handlers is
> > walked during hotplug.
> > 
> right. will update it in next version.
> 
> > > +	.ids = acpi_pnp_device_ids,
> > > +	.match = acpi_pnp_scan_handler_match,
> > > +	.attach = acpi_pnp_scan_handler_attach,
> > > +};
> > > +
> > > +void __init acpi_pnp_init(void)
> > > +{
> > > +	acpi_scan_add_handler(&pnpacpi_handler);
> > > +}
> > > +
> > > +static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
> > > +						     u32 lvl, void *context,
> > > +						     void **rv)
> > > +{
> > > +	struct acpi_device *device;
> > > +
> > > +	if (acpi_bus_get_device(handle, &device))
> > > +		return AE_CTRL_DEPTH;
> > > +	if (device->handler == &pnpacpi_handler)
> > > +		pnpacpi_add_device(device);
> > 
> > Why don't you do that in acpi_pnp_scan_handler_attach() ?
> > 
> because the PNP bus is not ready at that time.

Do you mean it hasn't been initialized yet?

But we can initialize it before the scan handler initialization, can't we?

Rafael

