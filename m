Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaHUOjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:39:54 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:42573 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHUOjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:39:52 -0400
Message-ID: <53F604B2.6020004@linaro.org>
Date: Thu, 21 Aug 2014 16:39:46 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: rjw@rjwysocki.net, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH] ACPI: Add GPIO-signaled event emulator.
References: <1408546700-19309-1-git-send-email-tomasz.nowicki@linaro.org> <20140821104533.GM1660@lahna.fi.intel.com>
In-Reply-To: <20140821104533.GM1660@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On 21.08.2014 12:45, Mika Westerberg wrote:
> On Wed, Aug 20, 2014 at 04:58:20PM +0200, Tomasz Nowicki wrote:
>> GPIO-signaled events is quite new thing in Linux kernel.
>> There are not many board which can take advantage of it.
>> However, GPIO events are very useful feature during work on ACPI
>> subsystems.
>>
>> This commit emulates GPIO h/w behaviour and consists on write
>> operation to debugfs file. GPIO device instance is still required in DSDT
>> table along with _AEI resources and event methods.
>>
>> Please, see Kconfig help and driver head section for more details
>> regarding tool usage.
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   drivers/acpi/Kconfig             |  10 ++
>>   drivers/acpi/Makefile            |   1 +
>>   drivers/acpi/gpio-acpi-evt-emu.c | 195 +++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 206 insertions(+)
>>   create mode 100644 drivers/acpi/gpio-acpi-evt-emu.c
>>
>> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>> index fd54a74..8b9b74d 100644
>> --- a/drivers/acpi/Kconfig
>> +++ b/drivers/acpi/Kconfig
>> @@ -122,6 +122,16 @@ config ACPI_BUTTON
>>   	  To compile this driver as a module, choose M here:
>>   	  the module will be called button.
>>
>> +config ACPI_GPIO_EVT_EMULATE
>> +        bool "ACPI GPIO-signaled Events Emulation Support"
>
> Is there anything preventing building this as a module?
It should be tristate instead of bool statement here. Thanks for remind me.

>
>> +        depends on DEBUG_FS
>
> Spaces -> Tab
>
>> +	default n
>
> n is the default already, no need to specify it here.
>
>> +	help
>> +	  This will enable your system to emulate GPIO-signaled event through
>> +	  proc file system. User needs to trigger event method by
>> +	  echo 1 >  /sys/kernel/debug/acpi/events/<GPIO DEVICE>/<PIN>
>> +	  (where, GPIO DEVICE is a GPIO device name and PIN is a pin number).
>
> We should probably mention that this is dangerous and should be used for
> debugging purposes only.

Good point!

>
>> +
>>   config ACPI_VIDEO
>>   	tristate "Video"
>>   	depends on X86 && BACKLIGHT_CLASS_DEVICE
>> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
>> index 9fa20ff..24f9d8f 100644
>> --- a/drivers/acpi/Makefile
>> +++ b/drivers/acpi/Makefile
>> @@ -55,6 +55,7 @@ acpi-$(CONFIG_ACPI_PROCFS_POWER) += cm_sbs.o
>>   ifdef CONFIG_ACPI_VIDEO
>>   acpi-y				+= video_detect.o
>>   endif
>> +acpi-$(CONFIG_ACPI_GPIO_EVT_EMULATE)	+= gpio-acpi-evt-emu.o
>>
>>   # These are (potentially) separate modules
>>
>> diff --git a/drivers/acpi/gpio-acpi-evt-emu.c b/drivers/acpi/gpio-acpi-evt-emu.c
>> new file mode 100644
>> index 0000000..c39f501
>> --- /dev/null
>> +++ b/drivers/acpi/gpio-acpi-evt-emu.c
>> @@ -0,0 +1,195 @@
>> +/*
>> + * Code to emulate GPIO-signaled events.
>> + *
>> + * The sole purpose of this module is to help with GPIO event triggering.
>> + * Usage:
>> + * 1. See the list of available GPIO devices and associated pins under:
>> + *    /sys/kernel/debug/acpi/events/<GPIO DEVICE>/<PIN>. Only pins which are to
>> + *    be used as GPIO-signaled events will be listed (_AEI resources).
>> + *
>> + * 2. Trigger method corresponding to device pin number:
>> + *    $ echo 1 > /sys/kernel/debug/acpi/events/<GPIO DEVICE>/<PIN>
>> + */
>> +
>> +/*
>> + * Copyright (C) 2014, Linaro Ltd.
>> + * Author: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>
> You don't need to specify the FSF address here.
>
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/debugfs.h>
>> +#include <linux/acpi.h>
>> +
>> +#include "acpica/accommon.h"
I need accommon.h to operate on the acpi_namespace_node structure and 
get the name of node.

>> +#include "acpica/acnamesp.h"
acnamesp.h is not necessary once I get rid of acpi_ns_validate_handle().

>
> Are these actually needed?
>
>> +
>> +#include "internal.h"
>> +
>> +#define _COMPONENT		ACPI_SYSTEM_COMPONENT
>> +ACPI_MODULE_NAME("gpio_acpi_evt_emu");
>> +
>> +struct gpio_pin_parent_data {
>> +	acpi_handle handle;
>> +	struct dentry *debugfs_dir;
>> +	char *name;
>> +	unsigned int evt_count;
>> +};
>> +
>> +struct gpio_pin_data {
>> +	struct list_head list;
>> +	acpi_handle handle;
>> +	unsigned int pin;
>> +};
>> +
>> +static struct dentry *acpi_evt_debugfs_dir;
>> +static LIST_HEAD(pin_data_list);
>> +
>> +static int gpio_evt_trigger(void *data, u64 val)
>> +{
>> +	struct gpio_pin_data *pin_data = (struct gpio_pin_data *)data;
>> +	int pin = pin_data->pin;
>> +
>> +	if (ACPI_FAILURE(acpi_execute_simple_method(pin_data->handle, NULL,
>> +						    pin <= 255 ? 0 : pin)))
>> +		pr_err(PREFIX "evaluating event method failed\n");
>
> acpi_execute_simple_method() passes one argument to the method. You
> can't use it with _Lxx or _Exx which don't expect any arguments.
> Otherwise you get this:
>
> [  122.258191] ACPI: \_SB_.GPO2._E12: Excess arguments - Caller passed 1, method requires 0 (20140724/nsarguments-263)
Right, I will fix it.

>
> Also where does "PREFIX" come from?
It comes from internal.h header.

>
>> +
>> +	return 0;
>> +}
>> +
>> +DEFINE_SIMPLE_ATTRIBUTE(gpio_evt_emu_fops, NULL, gpio_evt_trigger, "%llu\n");
>> +
>> +static acpi_status gpio_list_resource(struct acpi_resource *ares, void *context)
>> +{
>> +	struct acpi_resource_gpio *agpio = &ares->data.gpio;
>> +	struct gpio_pin_parent_data *parent_data = context;
>> +	struct dentry *pin_debugfs_dir;
>> +	struct gpio_pin_data *pin_data;
>> +	acpi_handle evt_handle;
>> +	acpi_status status;
>> +	char str_pin[5];
>> +	char ev_name[5];
>> +	int pin;
>> +
>> +	if (ares->type != ACPI_RESOURCE_TYPE_GPIO)
>> +		return AE_OK;
>> +
>> +	if (agpio->connection_type != ACPI_RESOURCE_GPIO_TYPE_INT)
>> +		return AE_OK;
>> +
>> +	pin_data = kmalloc(sizeof(*pin_data), GFP_KERNEL);
>> +	if (!pin_data)
>> +		return AE_NO_MEMORY;
>> +
>> +	pin = agpio->pin_table[0];
>> +	snprintf(str_pin, 5, "%d", pin);
>> +	pin_debugfs_dir = debugfs_create_file(str_pin, S_IWUSR,
>> +					      parent_data->debugfs_dir,
>> +					      pin_data,
>> +					      &gpio_evt_emu_fops);
>> +	if (!pin_debugfs_dir) {
>> +		status = AE_NULL_ENTRY;
>> +		goto fail;
>> +	}
>> +
>> +	if (pin <= 255)
>> +		sprintf(ev_name, "_%c%02X",
>> +			agpio->triggering == ACPI_EDGE_SENSITIVE ? 'E' : 'L',
>> +			pin);
>> +	else
>> +		sprintf(ev_name, "_EVT");
>> +
>> +	status = acpi_get_handle(parent_data->handle, ev_name, &evt_handle);
>> +	if (ACPI_FAILURE(status)) {
>> +		pr_err(PREFIX "getting handle to <%s> of <%s> failed, there is no method related to 0x%02X pin\n",
>> +		       ev_name, parent_data->name, pin);
>> +		goto fail;
>> +	}
>> +
>> +	pin_data->handle = evt_handle;
>> +	pin_data->pin = pin;
>> +        list_add_tail(&pin_data->list, &pin_data_list);
>
> Spaces -> tab
>
>> +
>> +	parent_data->evt_count++;
>> +
>> +	return AE_OK;
>> +fail:
>> +	kfree(pin_data);
>> +	return status;
>> +}
>> +
>> +static acpi_status gpio_find_resource(acpi_handle handle, u32 lvl,
>> +					  void *context, void **rv)
>> +{
>> +	struct acpi_namespace_node *node;
>> +	struct dentry *gpio_debugfs_dir;
>> +	struct gpio_pin_parent_data parent_data;
>> +	char gpio_name[5];
>> +
>> +	node = acpi_ns_validate_handle(handle);
>
> Hmm, why is this needed? Is uppose acpi_get_devices() or already makes
> sure you have a valid handle, no?
Correct, acpi_get_devices() validates it for us. I will cast it to 
"struct acpi_namespace_node" directly and then get the node name.

>
>> +	if (!node) {
>> +		pr_err(PREFIX "Mapping GPIO handle to node failed\n");
>> +		return AE_BAD_PARAMETER;
>> +	}
>> +
>> +	snprintf(gpio_name, 5, "%s", node->name.ascii);
>> +	gpio_debugfs_dir = debugfs_create_dir(gpio_name, acpi_evt_debugfs_dir);
>> +	if (gpio_debugfs_dir == NULL)
>> +		return AE_OK;
>> +
>> +	parent_data.debugfs_dir = gpio_debugfs_dir;
>> +	parent_data.handle = handle;
>> +	parent_data.name = gpio_name;
>> +	parent_data.evt_count = 0;
>> +
>> +	acpi_walk_resources(handle, METHOD_NAME__AEI, gpio_list_resource,
>> +			    &parent_data);
>> +
>> +	if (!parent_data.evt_count)
>> +		debugfs_remove(gpio_debugfs_dir);
>> +
>> +	return AE_OK;
>> +}
>> +
>> +static int __init gpio_evt_emu_init(void)
>> +{
>> +	if (acpi_debugfs_dir == NULL)
>> +		return -ENOENT;
>> +
>> +	acpi_evt_debugfs_dir = debugfs_create_dir("events", acpi_debugfs_dir);
>> +	if (acpi_evt_debugfs_dir == NULL)
>> +		return -ENOENT;
>> +
>> +	acpi_get_devices(NULL, gpio_find_resource, NULL, NULL);
>> +
>> +	return 0;
>> +}
>> +
>> +static void __exit gpio_evt_emu_deinit(void)
>
> call it gpio_evt_emu_exit() instead.
>
>> +{
>> +	struct gpio_pin_data *pin_data, *temp;
>> +
>> +	list_for_each_entry_safe(pin_data, temp, &pin_data_list, list)
>> +		kfree(pin_data);
>
> I suppose you want to first remove the directory entries and then the
> pin data. Otherwise if you get pre-empted at this point and someone
> tries to use your debugfs files, bad things might happen.
Good catch!

>
>> +
>> +	debugfs_remove_recursive(acpi_evt_debugfs_dir);
>
> Since this already removes everything below this dentry, why do you need
> to store the pointer in gpio_pin_parent_data?
Not sure I got the question.

GPIO device instance (debugfs dir) is parent for all its pins (debugfs 
nodes). I am using gpio_pin_parent_data as container to pass info for 
all children so I can create debugfs node inside of parent related 
debugfs dir.

pin_data_list, however, is used to keep pointers to allocated memory 
(one for each pins). debugfs_remove_recursive won't free it.

>
>> +}
>> +
>> +module_init(gpio_evt_emu_init);
>> +module_exit(gpio_evt_emu_deinit);
>
> These should follow their respective functions. E.g
>
> static int __init gpio_evt_emu_init(void)
> {
> 	...
> }
> module_init(gpio_evt_emu_init);
>
>> +
>> +MODULE_DESCRIPTION("GPIO-signaled events emulator");
>> +MODULE_LICENSE("GPL");
>
> GPL v2
>

Thanks for comments I will incorporate them all.

Regards,
Tomasz Nowicki
