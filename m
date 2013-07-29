Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3G2WLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:11:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46574 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab3G2WLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:11:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/3] ACPI / PM: Only set power states of devices that are power manageable
Date: Tue, 30 Jul 2013 00:21:28 +0200
Message-ID: <3386345.rYEkrXssx8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51F677B1.9090502@intel.com>
References: <10433383.dueoNg39qi@vostro.rjw.lan> <1657971.1utElu0Hzo@vostro.rjw.lan> <51F677B1.9090502@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 10:09:53 PM Aaron Lu wrote:
> On 07/27/2013 09:10 PM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Make acpi_device_set_power() check if the given device is power
> > manageable before checking if the given power state is valid for that
> > device.  Otherwise it will print that "Device does not support" that
> > power state into the kernel log, which may not make sense for some
> > power states (D0 and D3cold are supported by all devices by
> > definition).
> 
> It will not print "Device does not support" that power state if that
> power state is D0 or D3cold since we have unconditionally set those two
> power state's valid flag.

So you didn't actually looked at acpi_bus_get_power_flags() that set the
power.states[].flags.valid flag, because If you had looked at it, you would
have seen that that's not the case.

No, we don't set the valid flag for devices that aren't power manageable
(i.e. have flags.power_manageable unset), which is the *whole* *point* of
this change.

> OTOH, what value should we return for a device node that is not power
> manageable in acpi_device_set_power when the target state is D0 or D3
> cold? The old behavior is to return 0, meanning success without taking
> any actual action.
> 
> In acpi_bus_set_power, if the device is not power manageable, we will
> return -ENODEV; in acpi_dev_pm_full/low_power, we will return 0 as in
> the original acpi_device_set_power. So return -EINVAL here is correct?

No, the original acpi_device_set_power() will return -ENODEV then, but
in my opinion returning -EINVAL is more accurate, because "power
manageable" means "you can change power state of it".

Thanks,
Rafael


> > Tested-by: Yinghai Lu <yinghai@kernel.org>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/device_pm.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-pm/drivers/acpi/device_pm.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/device_pm.c
> > +++ linux-pm/drivers/acpi/device_pm.c
> > @@ -159,7 +159,8 @@ int acpi_device_set_power(struct acpi_de
> >  	int result = 0;
> >  	bool cut_power = false;
> >  
> > -	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
> > +	if (!device || !device->flags.power_manageable
> > +	    || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
> >  		return -EINVAL;
> >  
> >  	/* Make sure this is a valid target state */
> > 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
