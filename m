Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaIYT4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:56:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54312 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750866AbaIYT4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:56:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        robert.moore@intel.com, lv.zheng@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [RFC PATCH] ACPI: Add _DEP(Operation Region Dependencies) support to fix battery issue on the Asus T100TA
Date: Thu, 25 Sep 2014 22:15:59 +0200
Message-ID: <2099115.E7zZOe2MuE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2232717.X50lT6IYgQ@vostro.rjw.lan>
References: <1411456003-29541-1-git-send-email-tianyu.lan@intel.com> <5423E40B.8010302@intel.com> <2232717.X50lT6IYgQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2014 09:27:25 PM Rafael J. Wysocki wrote:
> On Thursday, September 25, 2014 05:44:43 PM Lan Tianyu wrote:
> > On 2014年09月25日 06:27, Rafael J. Wysocki wrote:
> > > On Tuesday, September 23, 2014 03:06:43 PM Lan Tianyu wrote:
> > >> ACPI 5.0 introduces _DEP to designate device objects that OSPM should
> > >> assign a higher priority in start ordering due to future operation region
> > >> accesses.
> > >>
> > >> On Asus T100TA, ACPI battery info are read from a I2C slave device via
> > >> I2C operation region. Before I2C operation region handler is installed,
> > >> battery _STA always returns 0. There is a _DEP method of designating
> > >> start order under battery device node.
> > >>
> > >> This patch is to implement _DEP feature to fix battery issue on the Asus T100TA.
> > >> Introducing acpi_bus_dep_device_list and adding dep_present flags in the struct
> > >> acpi_device. During ACPI namespace scan, all devices with _DEP support will be put
> > >> into the new list and those devices' dep_present flag will be set. Driver's probe()
> > >> should return EPROBE_DEFER when find dep_present is set. When I2C operation
> > >> region handler is installed, check all devices on the new list. Remove the one from
> > >> list if _DEP condition is met and clear its dep_present flag and do acpi_bus_attch()
> > >> for the device in order to resolve battery _STA issue on the Asus T100TA.
> > >>
> > >> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> > > 
> > > This is going in the right direction in my view, but isn't there just yet.
> > > 
> > > Details below.
> > 
> > Thanks for review.
> > 
> > > 
> > >> ---
> > >>  drivers/acpi/battery.c  |  4 +++
> > >>  drivers/acpi/scan.c     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >>  drivers/i2c/i2c-acpi.c  |  1 +
> > >>  include/acpi/acpi_bus.h |  2 ++
> > >>  include/linux/acpi.h    |  3 ++
> > >>  5 files changed, 94 insertions(+)
> > >>
> > >> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> > >> index 1c162e7..c0a68ce 100644
> > >> --- a/drivers/acpi/battery.c
> > >> +++ b/drivers/acpi/battery.c
> > >> @@ -1194,6 +1194,10 @@ static int acpi_battery_add(struct acpi_device *device)
> > >>  
> > >>  	if (!device)
> > >>  		return -EINVAL;
> > >> +
> > >> +	if (device->dep_present)
> > > 
> > > device->flags.dep_present would be better.  Or even call the flag dep_unmet.
> > 
> > Ok. Will update.
> > 
> > > 
> > >> +		return -EPROBE_DEFER;
> > >> +
> > >>  	battery = kzalloc(sizeof(struct acpi_battery), GFP_KERNEL);
> > >>  	if (!battery)
> > >>  		return -ENOMEM;
> > >> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > >> index 3bf7764..a26dbb3 100644
> > >> --- a/drivers/acpi/scan.c
> > >> +++ b/drivers/acpi/scan.c
> > >> @@ -36,6 +36,7 @@ bool acpi_force_hot_remove;
> > >>  
> > >>  static const char *dummy_hid = "device";
> > >>  
> > >> +static LIST_HEAD(acpi_bus_dep_device_list);
> > >>  static LIST_HEAD(acpi_bus_id_list);
> > >>  static DEFINE_MUTEX(acpi_scan_lock);
> > >>  static LIST_HEAD(acpi_scan_handlers_list);
> > >> @@ -43,6 +44,11 @@ DEFINE_MUTEX(acpi_device_lock);
> > >>  LIST_HEAD(acpi_wakeup_device_list);
> > >>  static DEFINE_MUTEX(acpi_hp_context_lock);
> > >>  
> > >> +struct acpi_dep_data {
> > >> +	struct list_head node;
> > >> +	struct acpi_device *adev;
> > >> +};
> > >> +
> > >>  struct acpi_device_bus_id{
> > >>  	char bus_id[15];
> > >>  	unsigned int instance_no;
> > >> @@ -2048,6 +2054,32 @@ static void acpi_scan_init_hotplug(struct acpi_device *adev)
> > >>  	}
> > >>  }
> > >>  
> > >> +static void acpi_device_dep_initialize(struct acpi_device * adev)
> > >> +{
> > >> +	struct acpi_dep_data *dep;
> > >> +	acpi_status status;
> > >> +
> > >> +	if (!acpi_has_method(adev->handle, "_DEP"))
> > >> +		return;
> > >> +
> > >> +	status = acpi_evaluate_reference(adev->handle, "_DEP", NULL,
> > >> +					&adev->dep_devices);
> > >> +	if (ACPI_FAILURE(status)) {
> > >> +		dev_err(&adev->dev, "Fail to evaluate _DEP.\n");
> > > 
> > > "Failed"
> > > 
> > >> +		return;
> > >> +	}
> > >> +
> > >> +	dep = kzalloc(sizeof(struct acpi_dep_data), GFP_KERNEL);
> > >> +	if (!dep) {
> > >> +		dev_err(&adev->dev, "Memory allocation error.\n");
> > > 
> > > "Not enough memory for _DEP list entry\n"
> > > 
> > >> +		return;
> > >> +	}
> > >> +
> > >> +	dep->adev = adev;
> > >> +	adev->dep_present = true;
> > >> +	list_add_tail(&dep->node , &acpi_bus_dep_device_list);
> > >> +}
> > >> +
> > >>  static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
> > >>  				      void *not_used, void **return_value)
> > >>  {
> > >> @@ -2074,6 +2106,7 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
> > >>  		return AE_CTRL_DEPTH;
> > >>  
> > >>  	acpi_scan_init_hotplug(device);
> > >> +	acpi_device_dep_initialize(device);
> > >>  
> > >>   out:
> > >>  	if (!*return_value)
> > >> @@ -2191,6 +2224,57 @@ static void acpi_bus_attach(struct acpi_device *device)
> > >>  		acpi_bus_attach(child);
> > >>  }
> > >>  
> > >> +static int acpi_device_dep_check(struct acpi_device *adev)
> > >> +{
> > >> +	struct acpi_device *dep_adev;
> > >> +	struct acpi_device_physical_node *pn;
> > >> +	int i;
> > >> +
> > >> +	for (i = 0; i < adev->dep_devices.count; i++) {
> > >> +		dep_adev = acpi_bus_get_acpi_device(
> > >> +				adev->dep_devices.handles[i]);
> > >> +
> > >> +		if (!dep_adev)
> > >> +			return -ENODEV;
> > >> +
> > >> +		/* Check acpi device driver probing */
> > >> +		if (dep_adev->dev.driver)
> > >> +			continue;
> > > 
> > > This check isn't sufficient, because _DEP is supposed to be about operation
> > > regions being present, not about drivers being present.  Same for the driver
> > > check below.
> > > 
> > > I wouldn't bother to check drivers in this stub implementation. ->
> > 
> > Sounds like we need to check whether the dependent device node has been
> > attached with operation region handler and this needs ACPICA to expose
> > such function, right?
> 
> Yes.  That's why I suggested to do the check in the function that installs
> the operation region handler.  This way we are sure that the handler is
> already present.
> 
> > > 
> > >> +
> > >> +		if (!dep_adev->physical_node_count)
> > >> +			return -ENODEV;
> > >> +
> > >> +		/* Check physcial device node driver probing */
> > >> +		mutex_lock(&dep_adev->physical_node_lock);
> > >> +		list_for_each_entry(pn, &dep_adev->physical_node_list, node) {
> > >> +			if (pn->dev->driver) {
> > >> +				mutex_unlock(&dep_adev->physical_node_lock);
> > >> +				continue;
> > >> +			}
> > >> +		}
> > >> +		mutex_unlock(&dep_adev->physical_node_lock);
> > >> +		return -EFAULT;
> > >> +	}
> > >> +
> > >> +	return 0;
> > >> +}
> > >> +
> > >> +int acpi_walk_dep_device_list(void)
> > > 
> > > -> I'd pass the operation region device to that (and I'd call the function
> > > differently, but that's a detail).  Then, I'd just clear flags.dep_unmet
> > > for all devices having that operation region device in their dep_devices
> > > (and drop their entries from the list).  It wouldn't cover the case when
> > > one device depends on two operation regions at the same time (in a meaningful
> > > way), but should be sufficient to address the battery problem at hand. 
> > > 
> > 
> > This requires the dependent devices have a list to record devices which
> > depends on them, right? Create such lists during ACPI namespace scan.
> 
> I'm not sure what you mean.  "Dependent" means "depending on something", so the
> question reads "This requires the devices with _DEP to have a list of devices
> that depend on them" which is probably not what you meant.
> 
> For each device with _DEP we have dep_devices, so if you pass a pointer
> (opregion_adev) to the device that has just installed an operation region
> handler to acpi_walk_dep_device_list() as an argument, then you can do
> 
> 	for (i = 0; i < adev->dep_devices.count; i++)
> 		if (opregion_adev->handle == adev->dep_devices.handles[i]) {
> 			adev->dep_unmet = false;
> 			acpi_bus_attach(adev);
> 			list_del(&dep->node);
> 			kfree(dep);
> 		}
> 
> and of course appropriate locking needs to be there in case this races with
> enumeration during hotplug after loading a new ACPI table on demand).
> 
> I think you can even define
>   
> struct acpi_dep_data {
> 	struct list_head node;
> 	struct acpi_device *master;
> 	struct acpi_device *slave;
> };
> 
> and create that for every valid pair of master (device pointed to by _DEP)/slave
> (device with _DEP) and create a list of these.  Then, you won't need dep_devices
> in struct acpi_device any more and your acpi_walk_dep_device_list() will only
> need to walk the list until it finds the matching master/slave pair.
> 
> That will handle the case when one device depends on multiple other devices too
> I think.

Of course, in that case dep_unmet needs to be a counter that will be dropped by 1
every time an item is dropped from the list for the given slave device.  In which
case it is better to keep it directly under struct acpi_device rather than in the
flags.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
