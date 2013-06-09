Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab3FIWHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:07:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60929 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3FIWHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:07:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / scan: Simplify ACPI driver probing
Date: Mon, 10 Jun 2013 00:16:40 +0200
Message-ID: <5445053.CFZ3ZkxVKT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51B3E069.8090301@intel.com>
References: <2159292.upDGjkPUz6@vostro.rjw.lan> <51B3D825.3060505@intel.com> <51B3E069.8090301@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 09, 2013 09:54:49 AM Aaron Lu wrote:
> On 06/09/2013 09:19 AM, Aaron Lu wrote:
> > On 06/09/2013 06:28 AM, Rafael J. Wysocki wrote:
> >> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> There is no particular reason why acpi_bus_driver_init() needs to be
> >> a separate function and its location with respect to its only caller,
> >> acpi_device_probe(), makes the code a bit difficult to follow.
> >>
> >> Besides, it doesn't really make sense to check if 'device' is not
> >> NULL in acpi_bus_driver_init(), because we've already dereferenced
> >> dev->driver in acpi_device_probe() at that point, so that check has
> >> to be moved to acpi_device_probe() anyway.
> >>
> >> For these reasons, drop acpi_bus_driver_init() altogether and move
> >> the code from it directly into acpi_device_probe().
> >>
> >> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> ---
> >>
> >> Should apply on top of the bleeding-edge branch of the linux-pm.git tree.
> >>
> >> Thanks,
> >> Rafael
> >>
> >> ---
> >>  drivers/acpi/scan.c |   88 +++++++++++++++++++---------------------------------
> >>  1 file changed, 33 insertions(+), 55 deletions(-)
> >>
> >> Index: linux-pm/drivers/acpi/scan.c
> >> ===================================================================
> >> --- linux-pm.orig/drivers/acpi/scan.c
> >> +++ linux-pm/drivers/acpi/scan.c
> >> @@ -933,32 +933,45 @@ static void acpi_device_remove_notify_ha
> >>  					   acpi_device_notify);
> >>  }
> >>  
> >> -static int acpi_bus_driver_init(struct acpi_device *, struct acpi_driver *);
> >>  static int acpi_device_probe(struct device * dev)
> >>  {
> >> -	struct acpi_device *acpi_dev = to_acpi_device(dev);
> >> -	struct acpi_driver *acpi_drv = to_acpi_driver(dev->driver);
> >> +	struct acpi_device *acpi_dev;
> >> +	struct acpi_driver *acpi_drv;
> >>  	int ret;
> >>  
> >> -	ret = acpi_bus_driver_init(acpi_dev, acpi_drv);
> >> -	if (!ret) {
> >> -		if (acpi_drv->ops.notify) {
> >> -			ret = acpi_device_install_notify_handler(acpi_dev);
> >> -			if (ret) {
> >> -				if (acpi_drv->ops.remove)
> >> -					acpi_drv->ops.remove(acpi_dev);
> >> -				acpi_dev->driver = NULL;
> >> -				acpi_dev->driver_data = NULL;
> >> -				return ret;
> >> -			}
> >> -		}
> >> +	if (!dev || !dev->driver)
> >> +		return -EINVAL;
> > 
> > Just out of curiosity, will dev ever be NULL in this function?
> > This function is called in really_probe by dev->bus->probe after
> > assigning dev->driver, so does the above check make any sense?

Well, it makes sense as such, but it's not useful. :-)

> BTW, I also tested the patch on a desktop and two laptops, no problems
> found. Feel free to add my tested-by tag.

I've modified the patch to remove that check and will post it again shortly.
Can you please give the new version a run?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
