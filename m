Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKYWKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:10:35 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56321 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751166AbaKYWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:10:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, wsa@the-dreams.de, robert.moore@intel.com,
        lv.zheng@intel.com, shigorin@gmail.com, adamw@happyassassin.net,
        jan.brummer@tabos.org, mika.westerberg@linux.intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, devel@acpica.org
Subject: Re: [PATCH V3] ACPI: Add _DEP(Operation Region Dependencies) support to fix battery issue on the Asus T100TA
Date: Tue, 25 Nov 2014 23:31:47 +0100
Message-ID: <2784837.a10Sa2bqgX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416748974-24124-1-git-send-email-tianyu.lan@intel.com>
References: <1416748974-24124-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 23, 2014 09:22:54 PM Lan Tianyu wrote:
> ACPI 5.0 introduces _DEP to designate device objects that OSPM should
> assign a higher priority in start ordering due to future operation region
> accesses.
> 
> On Asus T100TA, ACPI battery info are read from a I2C slave device via
> I2C operation region. Before I2C operation region handler is installed,
> battery _STA always returns 0. There is a _DEP method of designating
> start order under battery device node.
> 
> This patch is to implement _DEP feature to fix battery issue on the Asus T100TA.
> Introducing acpi_dep_list and adding dep_unmet count in the struct
> acpi_device. During ACPI namespace scan, create struct acpi_dep_data for a
> valid pair of master (device pointed to by _DEP)/slave(device with _DEP), record
> master's and slave's ACPI handle in it and put it into acpi_dep_list. The dep_unmet
> count will increase by one if there is a device under its _DEP. Driver's probe() should
> return EPROBE_DEFER when find dep_unmet is larger than 0. When I2C operation
> region handler is installed, remove all struct acpi_dep_data on the acpi_dep_list
> whose master is pointed to I2C host controller and decrease slave's dep_unmet.
> When dep_unmet decreases to 0, all _DEP conditions are met and then do acpi_bus_attach()
> for the device in order to resolve battery _STA issue on the Asus T100TA.
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=69011
> Tested-by: Jan-Michael Brummer <jan.brummer@tabos.org>
> Tested-by: Adam Williamson <adamw@happyassassin.net>
> Tested-by: Michael Shigorin <shigorin@gmail.com>
> Acked-by: Wolfram Sang <wsa@the-dreams.de>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Queued up for 3.19-rc1, thanks!

> ---
> Change since V2:
>         Coding style change
> Change since V1:
>  	Remove redundant blank line and some coding style fixs.
> 
> 
>  drivers/acpi/battery.c  |  4 +++
>  drivers/acpi/scan.c     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/i2c/i2c-core.c  |  1 +
>  include/acpi/acpi_bus.h |  1 +
>  include/linux/acpi.h    |  1 +
>  5 files changed, 92 insertions(+)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 8ec8a89..d98ba43 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -1180,6 +1180,10 @@ static int acpi_battery_add(struct acpi_device *device)
>  
>  	if (!device)
>  		return -EINVAL;
> +
> +	if (device->dep_unmet)
> +		return -EPROBE_DEFER;
> +
>  	battery = kzalloc(sizeof(struct acpi_battery), GFP_KERNEL);
>  	if (!battery)
>  		return -ENOMEM;
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 9cb5cca..1b1cf55 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -36,6 +36,8 @@ bool acpi_force_hot_remove;
>  
>  static const char *dummy_hid = "device";
>  
> +static LIST_HEAD(acpi_dep_list);
> +static DEFINE_MUTEX(acpi_dep_list_lock);
>  static LIST_HEAD(acpi_bus_id_list);
>  static DEFINE_MUTEX(acpi_scan_lock);
>  static LIST_HEAD(acpi_scan_handlers_list);
> @@ -43,6 +45,12 @@ DEFINE_MUTEX(acpi_device_lock);
>  LIST_HEAD(acpi_wakeup_device_list);
>  static DEFINE_MUTEX(acpi_hp_context_lock);
>  
> +struct acpi_dep_data {
> +	struct list_head node;
> +	acpi_handle master;
> +	acpi_handle slave;
> +};
> +
>  struct acpi_device_bus_id{
>  	char bus_id[15];
>  	unsigned int instance_no;
> @@ -2193,6 +2201,59 @@ static void acpi_scan_init_hotplug(struct acpi_device *adev)
>  	}
>  }
>  
> +static void acpi_device_dep_initialize(struct acpi_device *adev)
> +{
> +	struct acpi_dep_data *dep;
> +	struct acpi_handle_list dep_devices;
> +	acpi_status status;
> +	int i;
> +
> +	if (!acpi_has_method(adev->handle, "_DEP"))
> +		return;
> +
> +	status = acpi_evaluate_reference(adev->handle, "_DEP", NULL,
> +					&dep_devices);
> +	if (ACPI_FAILURE(status)) {
> +		dev_err(&adev->dev, "Failed to evaluate _DEP.\n");
> +		return;
> +	}
> +
> +	for (i = 0; i < dep_devices.count; i++) {
> +		struct acpi_device_info *info;
> +		int skip;
> +
> +		status = acpi_get_object_info(dep_devices.handles[i], &info);
> +		if (ACPI_FAILURE(status)) {
> +			dev_err(&adev->dev, "Error reading device info\n");
> +			continue;
> +		}
> +
> +		/*
> +		 * Skip the dependency of Windows System Power
> +		 * Management Controller
> +		 */
> +		skip = info->valid & ACPI_VALID_HID &&
> +			!strcmp(info->hardware_id.string, "INT3396");
> +
> +		kfree(info);
> +
> +		if (skip)
> +			continue;
> +
> +		dep = kzalloc(sizeof(struct acpi_dep_data), GFP_KERNEL);
> +		if (!dep)
> +			return;
> +
> +		dep->master = dep_devices.handles[i];
> +		dep->slave  = adev->handle;
> +		adev->dep_unmet++;
> +
> +		mutex_lock(&acpi_dep_list_lock);
> +		list_add_tail(&dep->node , &acpi_dep_list);
> +		mutex_unlock(&acpi_dep_list_lock);
> +	}
> +}
> +
>  static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
>  				      void *not_used, void **return_value)
>  {
> @@ -2219,6 +2280,7 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
>  		return AE_CTRL_DEPTH;
>  
>  	acpi_scan_init_hotplug(device);
> +	acpi_device_dep_initialize(device);
>  
>   out:
>  	if (!*return_value)
> @@ -2339,6 +2401,29 @@ static void acpi_bus_attach(struct acpi_device *device)
>  		device->handler->hotplug.notify_online(device);
>  }
>  
> +void acpi_walk_dep_device_list(acpi_handle handle)
> +{
> +	struct acpi_dep_data *dep, *tmp;
> +	struct acpi_device *adev;
> +
> +	mutex_lock(&acpi_dep_list_lock);
> +	list_for_each_entry_safe(dep, tmp, &acpi_dep_list, node) {
> +		if (dep->master == handle) {
> +			acpi_bus_get_device(dep->slave, &adev);
> +			if (!adev)
> +				continue;
> +
> +			adev->dep_unmet--;
> +			if (!adev->dep_unmet)
> +				acpi_bus_attach(adev);
> +			list_del(&dep->node);
> +			kfree(dep);
> +		}
> +	}
> +	mutex_unlock(&acpi_dep_list_lock);
> +}
> +EXPORT_SYMBOL_GPL(acpi_walk_dep_device_list);
> +
>  /**
>   * acpi_bus_scan - Add ACPI device node objects in a given namespace scope.
>   * @handle: Root of the namespace scope to scan.
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index f43b4e1..68aeb8e 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -403,6 +403,7 @@ static int acpi_i2c_install_space_handler(struct i2c_adapter *adapter)
>  		return -ENOMEM;
>  	}
>  
> +	acpi_walk_dep_device_list(handle);
>  	return 0;
>  }
>  
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 7d1ce40..d539084 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -372,6 +372,7 @@ struct acpi_device {
>  	void *driver_data;
>  	struct device dev;
>  	unsigned int physical_node_count;
> +	unsigned int dep_unmet;
>  	struct list_head physical_node_list;
>  	struct mutex physical_node_lock;
>  	void (*remove)(struct acpi_device *);
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 10f2ed9..e09f7f4 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -428,6 +428,7 @@ extern bool acpi_driver_match_device(struct device *dev,
>  				     const struct device_driver *drv);
>  int acpi_device_uevent_modalias(struct device *, struct kobj_uevent_env *);
>  int acpi_device_modalias(struct device *, char *, int);
> +void acpi_walk_dep_device_list(acpi_handle handle);
>  
>  struct platform_device *acpi_create_platform_device(struct acpi_device *);
>  #define ACPI_PTR(_ptr)	(_ptr)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
