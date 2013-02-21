Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3BUB2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:28:38 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29461 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3BUB2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:28:36 -0500
Message-ID: <1361409468.12845.7.camel@misato.fc.hp.com>
Subject: Re: [Update][PATCH 2/7] ACPI / scan: Introduce common code for
 ACPI-based device hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Date: Wed, 20 Feb 2013 18:17:48 -0700
In-Reply-To: <1765527.DdJ8fCt5cH@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
	 <2540040.4NPGdn6Df0@vostro.rjw.lan> <1765527.DdJ8fCt5cH@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 23:49 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 :
> +
> +/**
> + * acpi_bus_hot_remove_device: hot-remove a device and its children
> + * @context: struct acpi_eject_event pointer (freed in this func)
> + *
> + * Hot-remove a device and its children. This function frees up the
> + * memory space passed by arg context, so that the caller may call
> + * this function asynchronously through acpi_os_hotplug_execute().
> + */
> +void acpi_bus_hot_remove_device(void *context)
> +{
> +	struct acpi_eject_event *ej_event = context;
> +	struct acpi_device *device = ej_event->device;
> +	acpi_handle handle = device->handle;
> +	u32 ost_code = ACPI_OST_SC_SUCCESS;
> +	int error;
> +
> +	mutex_lock(&acpi_scan_lock);
> +
> +	error = acpi_scan_hot_remove(device);
> +	if (error)
> +		ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> +
> +	acpi_evaluate_hotplug_ost(handle, ej_event->event, ost_code, NULL);

Thanks for the quick update.  It fixed the deadlock issue. :-)  As it
now completes an eject operation, I found a new issue.  When the OS
called _EJ0, it is not supposed to call _OST since FW has already
received the completion status from _EJ0.  That is, the OS calls either
_EJ0 (success case) or _OST (failure case) for hot-delete. 

-Toshi


