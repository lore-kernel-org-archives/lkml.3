Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3AKUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:25:59 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38068 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab3AKUZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:25:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 1/16] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Fri, 11 Jan 2013 21:31:43 +0100
Message-ID: <2859994.arbXorpfaz@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130111200046.GB13897@intel.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <23002897.6xbQGtPaGy@vostro.rjw.lan> <20130111200046.GB13897@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 10:00:46 PM Mika Westerberg wrote:
> (Sorry to jump in late but I noticed one problem with this series while
> testing).
> 
> On Thu, Dec 20, 2012 at 02:47:47AM +0100, Rafael J. Wysocki wrote:
> > +static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
> > +					void *context, void **not_used)
> > +{
> > +	struct acpi_bus_ops *ops = context;
> > +	acpi_status status = AE_OK;
> > +	struct acpi_device *device;
> > +	unsigned long long sta_not_used;
> > +	int type_not_used;
> > +
> > +	/*
> > +	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
> > +	 * namespace walks prematurely.
> > +	 */
> > +	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
> > +		return AE_OK;
> > +
> > +	if (acpi_bus_get_device(handle, &device))
> > +		return AE_CTRL_DEPTH;
> > +
> > +	if (ops->acpi_op_add) {
> > +		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
> > +			/* This is a known good platform device. */
> > +			acpi_create_platform_device(device);
> > +		} else if (device_attach(&device->dev)) {
> 
> device_attach() returns 1 if it succeeds to attach device to a driver. In
> that case we should continue and not return AE_CTRL_DEPTH, right?

That's correct.  The check is reversed, so we need the appended patch on top
of linux-pm.git/acpi-scan.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / scan: Fix check of device_attach() return value.

Since device_attach() returns 1 on success and 0 on failure,
the check against its return value in acpi_bus_device_attach()
should be reveresed.  Make it so.

Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1598,7 +1598,7 @@ static acpi_status acpi_bus_device_attac
 	if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
 		/* This is a known good platform device. */
 		acpi_create_platform_device(device);
-	} else if (device_attach(&device->dev)) {
+	} else if (!device_attach(&device->dev)) {
 		status = AE_CTRL_DEPTH;
 	}
 	return status;

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
