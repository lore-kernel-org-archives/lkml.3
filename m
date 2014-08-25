Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573AbaHYWGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:06:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60250 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933512AbaHYWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:06:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device objects
Date: Tue, 26 Aug 2014 00:25:09 +0200
Message-ID: <1493252.guStSdlKdN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408864010.3315.47.camel@rzhang1-toshiba>
References: <5487060.QsgluucUH4@vostro.rjw.lan> <1408864010.3315.47.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 24, 2014 03:06:50 PM Zhang Rui wrote:
> On Thu, 2014-08-21 at 06:04 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[cut]

> >  3 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > Index: linux-pm/drivers/acpi/acpi_pnp.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/acpi_pnp.c
> > +++ linux-pm/drivers/acpi/acpi_pnp.c
> > @@ -396,3 +396,8 @@ void __init acpi_pnp_init(void)
> >  {
> >  	acpi_scan_add_handler(&acpi_pnp_handler);
> >  }
> > +
> > +bool is_acpi_pnp_device(struct acpi_device *adev)
> > +{
> > +	return adev->handler == &acpi_pnp_handler;
> > +}
> 
> can we reuse acpi_is_pnp_device()?
> The only difference is that acpi_is_pnp_device() returns true for
> RTC_CMOS devices, which is not a problem IMO because RTC CMOS devices
> have PNP driver only.

Yes, we can.  Overlooked that.

Updated patch is appended.

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device objects

We generally don't allow ACPI drivers to bind to ACPI device objects
that companion "physical" device objects are created for to avoid
situations in which two different drivers may attempt to handle one
device at the same time.  Recent ACPI device enumeration rework
extended that approach to ACPI PNP devices by starting to use a scan
handler for enumerating them.  However, we previously allowed ACPI
drivers to bind to ACPI device objects with existing PNP device
companions and changing that led to functional regressions on some
systems.

For this reason, add a special check for PNP devices in
acpi_device_probe() so that ACPI drivers can bind to ACPI device
objects having existing PNP device companions as before.

Fixes: eec15edbb0e1 (ACPI / PNP: use device ID list for PNPACPI device enumeration)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=81511
Link: https://bugzilla.kernel.org/show_bug.cgi?id=81971
Reported-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Reported-by: Dirk Griesbach <spamthis@freenet.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -975,7 +975,7 @@ static int acpi_device_probe(struct devi
 	struct acpi_driver *acpi_drv = to_acpi_driver(dev->driver);
 	int ret;
 
-	if (acpi_dev->handler)
+	if (acpi_dev->handler && !acpi_is_pnp_device(acpi_dev))
 		return -EINVAL;
 
 	if (!acpi_drv->ops.add)

