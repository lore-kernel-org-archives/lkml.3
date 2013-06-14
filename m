Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3FNOGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:06:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37355 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab3FNOGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:06:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [BUGFIX 3/9] ACPI, DOCK: clean up unused module related code
Date: Fri, 14 Jun 2013 16:16:04 +0200
Message-ID: <3188924.9xuW7um1Oj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51BB22D1.9070204@gmail.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <1841512.D0ScSNfNgy@vostro.rjw.lan> <51BB22D1.9070204@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 10:04:01 PM Jiang Liu wrote:
> On 06/14/2013 02:26 AM, Rafael J. Wysocki wrote:
> > On Friday, June 14, 2013 12:32:26 AM Jiang Liu wrote:
> >> ACPI dock driver can't be built as a module any more, so clean up
> >> module related code.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >> Cc: Shaohua Li <shaohua.li@intel.com>
> >> Cc: Len Brown <lenb@kernel.org>
> >> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> >> Cc: linux-acpi@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> > 
> > How exactly does this depend on [2/9]?  If it doesn't at all, it should go
> > after [1/9].
> > 
> >> ---
> >>  drivers/acpi/dock.c | 41 -----------------------------------------
> >>  1 file changed, 41 deletions(-)
> >>
> >> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> >> index 79c8d9e..50e38b7 100644
> >> --- a/drivers/acpi/dock.c
> >> +++ b/drivers/acpi/dock.c
> >> @@ -53,12 +53,6 @@ MODULE_PARM_DESC(immediate_undock, "1 (default) will cause the driver to "
> >>  
> >>  static struct atomic_notifier_head dock_notifier_list;
> >>  
> >> -static const struct acpi_device_id dock_device_ids[] = {
> >> -	{"LNXDOCK", 0},
> >> -	{"", 0},
> >> -};
> >> -MODULE_DEVICE_TABLE(acpi, dock_device_ids);
> >> -
> > 
> > Don't we actually need the device IDs?
> Now dock driver could only be built as built-in, and it doesn't really
> bind to ACPI dock devices, so I think the device ids are not used any
> more. Not sure whether any userspace tool has dependency on the device
> IDs.

I see.  OK

Thanks,
Rafael


> > 
> >>  struct dock_station {
> >>  	acpi_handle handle;
> >>  	unsigned long last_dock_time;
> >> @@ -1013,30 +1007,6 @@ err_unregister:
> >>  }
> >>  
> >>  /**
> >> - * dock_remove - free up resources related to the dock station
> >> - */
> >> -static int dock_remove(struct dock_station *ds)
> >> -{
> >> -	struct dock_dependent_device *dd, *tmp;
> >> -	struct platform_device *dock_device = ds->dock_device;
> >> -
> >> -	if (!dock_station_count)
> >> -		return 0;
> >> -
> >> -	/* remove dependent devices */
> >> -	list_for_each_entry_safe(dd, tmp, &ds->dependent_devices, list)
> >> -		kfree(dd);
> >> -
> >> -	list_del(&ds->sibling);
> >> -
> >> -	/* cleanup sysfs */
> >> -	sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);
> >> -	platform_device_unregister(dock_device);
> >> -
> >> -	return 0;
> >> -}
> >> -
> >> -/**
> >>   * find_dock_and_bay - look for dock stations and bays
> >>   * @handle: acpi handle of a device
> >>   * @lvl: unused
> >> @@ -1073,14 +1043,3 @@ int __init acpi_dock_init(void)
> >>  		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
> >>  	return 0;
> >>  }
> >> -
> >> -static void __exit dock_exit(void)
> >> -{
> >> -	struct dock_station *tmp, *dock_station;
> >> -
> >> -	unregister_acpi_bus_notifier(&dock_acpi_notifier);
> >> -	list_for_each_entry_safe(dock_station, tmp, &dock_stations, sibling)
> >> -		dock_remove(dock_station);
> >> -}
> >> -
> >> -module_exit(dock_exit);
> > 
> > The other changes look OK to me.
> Thanks for review.
> 
> > 
> > Thanks,
> > Rafael
> > 
> > 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
