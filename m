Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3BVBXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:23:15 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18063 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3BVBXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:23:10 -0500
Message-ID: <1361495541.12845.18.camel@misato.fc.hp.com>
Subject: Re: [Update 3][PATCH 2/7] ACPI / scan: Introduce common code for
 ACPI-based device hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Date: Thu, 21 Feb 2013 18:12:21 -0700
In-Reply-To: <2894504.SgZF7d1Dbv@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
	 <1765527.DdJ8fCt5cH@vostro.rjw.lan> <2482081.rPvizM7IsG@vostro.rjw.lan>
	 <2894504.SgZF7d1Dbv@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 00:06 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Multiple drivers handling hotplug-capable ACPI device nodes install
> notify handlers covering the same types of events in a very similar
> way.  Moreover, those handlers are installed in separate namespace
> walks, although that really should be done during namespace scans
> carried out by acpi_bus_scan().  This leads to substantial code
> duplication, unnecessary overhead and behavior that is hard to
> follow.
> 
> For this reason, introduce common code in drivers/acpi/scan.c for
> handling hotplug-related notification and carrying out device
> insertion and eject operations in a generic fashion, such that it
> may be used by all of the relevant drivers in the future.  To cover
> the existing differences between those drivers introduce struct
> acpi_hotplug_profile for representing collections of hotplug
> settings associated with different ACPI scan handlers that can be
> used by the drivers to make the common code reflect their current
> behavior.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> This update fixes an issue pointed out by Toshi Kani (that
> ACPI_OST_EC_OSPM_* event source codes should not be used with _OST for events
> that we received a notification for from the platform firmware).
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/acpi/scan.c     |  270 ++++++++++++++++++++++++++++++++++++++----------
>  include/acpi/acpi_bus.h |    7 +
>  2 files changed, 224 insertions(+), 53 deletions(-)
 :
> +static void acpi_bus_device_eject(void *context)
> +{
> +	acpi_handle handle = context;
> +	struct acpi_device *device = NULL;
> +	struct acpi_scan_handler *handler;
> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> +
> +	mutex_lock(&acpi_scan_lock);
> +
> +	acpi_bus_get_device(handle, &device);
> +	if (!device)
> +		goto err_out;
> +
> +	handler = device->handler;
> +	if (!handler || !handler->hotplug.enabled) {
> +		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
> +		goto err_out;
> +	}
> +	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
> +				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> +	if (handler->hotplug.autoeject) {
> +		int error;
> +
> +		get_device(&device->dev);
> +		error = acpi_scan_hot_remove(device);
> +		if (error)
> +			goto err_out;
> +	} else {
> +		device->flags.eject_pending = true;
>  	}
> +	if (handler->hotplug.uevents)
> +		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);

I confirmed that the _OST issue with hot-add is fixed.  Here is a new
one.  When autoeject is enabled, it crashes in kobject_uevent() since
the device is no longer valid. 

Thanks,
-Toshi


