Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3A2La3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:30:29 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58435 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab3A2LaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:30:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ACPI / platform: Use struct acpi_scan_handler for creating devices
Date: Tue, 29 Jan 2013 12:36:35 +0100
Message-ID: <1626323.c4yXjdNWq0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <510731FC.9040402@jp.fujitsu.com>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <1540645.4oLGJ3spZ3@vostro.rjw.lan> <510731FC.9040402@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 11:20:44 AM Yasuaki Ishimatsu wrote:
> Hi Rafael,
> 
> 2013/01/28 22:01, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Currently, the ACPI namespace scanning code creates platform device
> > objects for ACPI device nodes whose IDs match the contents of the
> > acpi_platform_device_ids[] table.  However, this adds a superfluous
> > special case into acpi_bus_device_attach() and makes it more
> > difficult to follow than it has to be.  It also will make it more
> > difficult to implement removal code for those platform device objects
> > in the future.
> >
> > For the above reasons, introduce a struct acpi_scan_handler object
> > for creating platform devices and move the code related to that from
> > acpi_bus_device_attach() to the .attach() callback of that object.
> > Also move the acpi_platform_device_ids[] table to acpi_platform.c.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >   drivers/acpi/acpi_platform.c |   55 +++++++++++++++++++++++++++++++++++--------
> >   drivers/acpi/internal.h      |    7 -----
> >   drivers/acpi/scan.c          |   30 -----------------------
> >   3 files changed, 47 insertions(+), 45 deletions(-)
> >
> > Index: test/drivers/acpi/acpi_platform.c
> > ===================================================================
> > --- test.orig/drivers/acpi/acpi_platform.c
> > +++ test/drivers/acpi/acpi_platform.c
> > @@ -22,6 +22,30 @@
> >
> >   ACPI_MODULE_NAME("platform");
> >
> > +/* Flags for acpi_create_platform_device */
> > +#define ACPI_PLATFORM_CLK	BIT(0)
> > +
> > +/*
> > + * The following ACPI IDs are known to be suitable for representing as
> > + * platform devices.
> > + */
> > +static const struct acpi_device_id acpi_platform_device_ids[] = {
> > +
> > +	{ "PNP0D40" },
> > +
> > +	/* Haswell LPSS devices */
> > +	{ "INT33C0", ACPI_PLATFORM_CLK },
> > +	{ "INT33C1", ACPI_PLATFORM_CLK },
> > +	{ "INT33C2", ACPI_PLATFORM_CLK },
> > +	{ "INT33C3", ACPI_PLATFORM_CLK },
> > +	{ "INT33C4", ACPI_PLATFORM_CLK },
> > +	{ "INT33C5", ACPI_PLATFORM_CLK },
> > +	{ "INT33C6", ACPI_PLATFORM_CLK },
> > +	{ "INT33C7", ACPI_PLATFORM_CLK },
> > +
> > +	{ }
> > +};
> > +
> >   static int acpi_create_platform_clks(struct acpi_device *adev)
> >   {
> >   	static struct platform_device *pdev;
> > @@ -39,8 +63,7 @@ static int acpi_create_platform_clks(str
> >   /**
> >    * acpi_create_platform_device - Create platform device for ACPI device node
> >    * @adev: ACPI device node to create a platform device for.
> > - * @flags: ACPI_PLATFORM_* flags that affect the creation of the platform
> > - *	   devices.
> > + * @id: ACPI device ID used to match @adev.
> >    *
> >    * Check if the given @adev can be represented as a platform device and, if
> >    * that's the case, create and register a platform device, populate its common
> > @@ -48,9 +71,10 @@ static int acpi_create_platform_clks(str
> >    *
> >    * Name of the platform device will be the same as @adev's.
> >    */
> > -struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
> > -						    unsigned long flags)
> > +static int acpi_create_platform_device(struct acpi_device *adev,
> > +				       const struct acpi_device_id *id)
> >   {
> > +	unsigned long flags = id->driver_data;
> >   	struct platform_device *pdev = NULL;
> >   	struct acpi_device *acpi_parent;
> >   	struct platform_device_info pdevinfo;
> > @@ -59,25 +83,26 @@ struct platform_device *acpi_create_plat
> >   	struct resource *resources;
> >   	int count;
> >
> 
> > -	if ((flags & ACPI_PLATFORM_CLK) && acpi_create_platform_clks(adev)) {
> > +	if (flags & ACPI_PLATFORM_CLK) {
> > +		int ret = acpi_create_platform_clks(adev);
> >   		dev_err(&adev->dev, "failed to create clocks\n");
> > -		return NULL;
> > +		return ret;
> >   	}
> 
> If (flag & ACPI_PLATFORM_CLK) is true, the acpi_create_platform_device()
> always retruns with dev_err() messages. Why?

Ah.  By mistake. :-)

Thanks for poiting this out!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
