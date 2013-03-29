Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3C2Jex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:34:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab3C2Jev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:34:51 -0400
Message-ID: <51555F8F.1050508@redhat.com>
Date: Fri, 29 Mar 2013 10:31:59 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        qemu-devel <qemu-devel@nongnu.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v16] pvpanic: pvpanic device driver
References: <cover.1364541739.git.hutao@cn.fujitsu.com> <1364546077-10539-1-git-send-email-hutao@cn.fujitsu.com>
In-Reply-To: <1364546077-10539-1-git-send-email-hutao@cn.fujitsu.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/03/2013 09:34, Hu Tao ha scritto:
> pvpanic device is a qemu simulated device through which guest panic
> event is sent to host.
> 
> Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
> ---
> 
> ref: http://lists.nongnu.org/archive/html/qemu-devel/2013-03/msg05297.html
> 
>  drivers/platform/x86/Kconfig   |   7 +++
>  drivers/platform/x86/Makefile  |   2 +
>  drivers/platform/x86/pvpanic.c | 115 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 124 insertions(+)
>  create mode 100644 drivers/platform/x86/pvpanic.c
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 3338437..527ed04 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -781,4 +781,11 @@ config APPLE_GMUX
>  	  graphics as well as the backlight. Currently only backlight
>  	  control is supported by the driver.
>  
> +config PVPANIC
> +	tristate "pvpanic device support"
> +	depends on ACPI
> +	---help---
> +	  This driver provides support for pvpanic device, which is a qemu
> +	  simulated device through which guest panic event is sent to host.
> +
>  endif # X86_PLATFORM_DEVICES
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index ace2b38..ef0ec74 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -51,3 +51,5 @@ obj-$(CONFIG_INTEL_OAKTRAIL)	+= intel_oaktrail.o
>  obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
>  obj-$(CONFIG_APPLE_GMUX)	+= apple-gmux.o
>  obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
> +
> +obj-$(CONFIG_PVPANIC)           += pvpanic.o
> diff --git a/drivers/platform/x86/pvpanic.c b/drivers/platform/x86/pvpanic.c
> new file mode 100644
> index 0000000..e6ea595
> --- /dev/null
> +++ b/drivers/platform/x86/pvpanic.c
> @@ -0,0 +1,115 @@
> +/*
> + *  pvpanic.c - pvpanic Device Support
> + *
> + *  Copyright (C) 2013 Fujitsu.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <acpi/acpi_bus.h>
> +#include <acpi/acpi_drivers.h>
> +
> +MODULE_AUTHOR("Hu Tao <hutao@cn.fujitsu.com>");
> +MODULE_DESCRIPTION("pvpanic device driver");
> +MODULE_LICENSE("GPL");
> +
> +static int pvpanic_add(struct acpi_device *device);
> +static int pvpanic_remove(struct acpi_device *device);
> +
> +static const struct acpi_device_id pvpanic_device_ids[] = {
> +	{ "QEMU0001", 0},
> +	{ "", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, pvpanic_device_ids);
> +
> +#define PVPANIC_PANICKED	(1 << 0)
> +
> +static acpi_handle handle;
> +
> +static struct acpi_driver pvpanic_driver = {
> +	.name =		"pvpanic",
> +	.class =	"QEMU",
> +	.ids =		pvpanic_device_ids,
> +	.ops =		{
> +				.add =		pvpanic_add,
> +				.remove =	pvpanic_remove,
> +			},
> +	.owner =	THIS_MODULE,
> +};
> +
> +static void
> +pvpanic_send_event(unsigned int event)
> +{
> +	union acpi_object arg;
> +	struct acpi_object_list arg_list;
> +
> +	if (!handle)
> +		return;
> +
> +	arg.type = ACPI_TYPE_INTEGER;
> +	arg.integer.value = event;
> +
> +	arg_list.count = 1;
> +	arg_list.pointer = &arg;
> +
> +	acpi_evaluate_object(handle, "WRPT", &arg_list, NULL);
> +}
> +
> +static int
> +pvpanic_panic_notify(struct notifier_block *nb, unsigned long code,
> +		     void *unused)
> +{
> +	pvpanic_send_event(PVPANIC_PANICKED);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block pvpanic_panic_nb = {
> +	.notifier_call = pvpanic_panic_notify,
> +};
> +
> +static int pvpanic_add(struct acpi_device *device)
> +{
> +	acpi_status status;
> +	u64 ret;
> +
> +	status = acpi_evaluate_integer(device->handle, "_STA", NULL,
> +				       &ret);
> +
> +	if (ACPI_FAILURE(status) || !ret)
> +		return -ENODEV;

Please return if (ret & 0x0B) != 0x0B.  This checks:

Bit 0 - Set if the device is present.
Bit 1 - Set if the device is enabled and decoding its resources.
Bit 3 - Set if the device is functioning properly.

Otherwise looks good.

> +
> +	handle = device->handle;
> +	atomic_notifier_chain_register(&panic_notifier_list,
> +				       &pvpanic_panic_nb);
> +
> +	return 0;
> +}
> +
> +static int pvpanic_remove(struct acpi_device *device)
> +{
> +
> +	atomic_notifier_chain_unregister(&panic_notifier_list,
> +					 &pvpanic_panic_nb);
> +	handle = NULL;
> +	return 0;
> +}
> +
> +module_acpi_driver(pvpanic_driver);
> 

