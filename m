Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaABIJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:09:15 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47193 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaABIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:09:13 -0500
MIME-Version: 1.0
In-Reply-To: <1387439515-8926-5-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	<1387439515-8926-5-git-send-email-jlee@suse.com>
Date: Thu, 2 Jan 2014 16:09:12 +0800
Message-ID: <CAOLK0pynyv2CjA-Jb-0cUMkdnXY8KD2QForsk5ygM1mrRtXOyg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
From: Lan Tianyu <lantianyu1986@gmail.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/19 Lee, Chun-Yi <joeyli.kernel@gmail.com>:
> This patch add the driver of Time and Alarm Device in ACPI 5.0.
> Currently it only implemented get/set time functions and grab
> the capabilities of device when driver initial.
>
> This driver also register rtc-acpitad platform device for RTC ACPITAD
> stub driver using.
>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  drivers/acpi/Makefile   |    3 +
>  drivers/acpi/acpi_tad.c |  176 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/bus.c      |    3 +
>  drivers/acpi/internal.h |    5 ++
>  include/linux/acpi.h    |   31 ++++++++
>  5 files changed, 218 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/acpi/acpi_tad.c
>
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 0331f91..d250b15 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -50,6 +50,9 @@ acpi-$(CONFIG_ACPI_NUMA)      += numa.o
>  ifdef CONFIG_ACPI_VIDEO
>  acpi-y                         += video_detect.o
>  endif
> +ifdef CONFIG_X86
> +acpi-y                         += acpi_tad.o
> +endif
>
>  # These are (potentially) separate modules
>
> diff --git a/drivers/acpi/acpi_tad.c b/drivers/acpi/acpi_tad.c
> new file mode 100644
> index 0000000..c2200f3
> --- /dev/null
> +++ b/drivers/acpi/acpi_tad.c
> @@ -0,0 +1,176 @@
> +/* rtc.c - ACPI 5.0 Time and Alarm Driver
> + *
> + * Copyright (C) 2013 SUSE Linux Products GmbH. All rights reserved.
> + * Written by Lee, Chun-Yi (jlee@suse.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <acpi/acpi_drivers.h>
> +
> +#include <asm/time.h>
> +
> +#define ACPI_TIME_ALARM_NAME           "Time and Alarm"
> +ACPI_MODULE_NAME(ACPI_TIME_ALARM_NAME);
> +#define ACPI_TIME_ALARM_CLASS          "time_alarm"
> +
> +static const struct acpi_device_id time_alarm_ids[] = {
> +       {"ACPI000E", 0},
> +       {"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, time_alarm_ids);
> +
> +static struct platform_device rtc_acpitad_dev = {
> +       .name = "rtc-acpitad",
> +       .id = -1,
> +};
> +
> +static struct acpi_device *acpi_tad_dev;
> +static unsigned long long cap;
> +
> +int acpi_read_time(struct acpi_time *output)
> +{
> +       unsigned long flags;
> +       struct acpi_buffer result = { ACPI_ALLOCATE_BUFFER, NULL };
> +       union acpi_object *obj;
> +       struct acpi_time *acpit;
> +       acpi_status status;
> +
> +       if (!acpi_tad_dev)
> +               return -ENODEV;
> +
> +       if (!(cap & TAD_CAP_GETSETTIME))
> +               return -EINVAL;
> +
> +       if (!output)
> +               return -EINVAL;
> +
> +       spin_lock_irqsave(&rtc_lock, flags);
> +       status = acpi_evaluate_object(acpi_tad_dev->handle, "_GRT", NULL, &result);
> +       spin_unlock_irqrestore(&rtc_lock, flags);
> +       if (ACPI_FAILURE(status)) {
> +               ACPI_EXCEPTION((AE_INFO, status, "Evaluating _GRT"));
> +               return -ENODEV;
> +       }
> +
> +       obj = result.pointer;
> +       if (!obj ||
> +           obj->type != ACPI_TYPE_BUFFER ||
> +           obj->buffer.length > sizeof(struct acpi_time) ||
> +           obj->buffer.length < offsetof(struct acpi_time, pad2)) {
> +               dev_err(&acpi_tad_dev->dev, ACPI_TIME_ALARM_NAME
> +                       " Invalid _GRT data\n");
> +               return -EINVAL;
> +       }
> +
> +       acpit = (struct acpi_time *) obj->buffer.pointer;
> +       if (acpit) {
> +               output->year = acpit->year;
> +               output->month = acpit->month;
> +               output->day = acpit->day;
> +               output->hour = acpit->hour;
> +               output->minute = acpit->minute;
> +               output->second = acpit->second;
> +               output->milliseconds = acpit->milliseconds;
> +               output->timezone = acpit->timezone;
> +               output->daylight = acpit->daylight;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(acpi_read_time);
> +
> +int acpi_set_time(struct acpi_time *acpit)
> +{
> +       unsigned long flags;
> +       struct acpi_object_list input;
> +       union acpi_object params[1];
> +       unsigned long long output;
> +       acpi_status status;
> +
> +       if (!acpi_tad_dev)
> +               return -ENODEV;
> +
> +       if (!(cap & TAD_CAP_GETSETTIME))
> +               return -EINVAL;
> +
> +       if (!acpit)
> +               return -EINVAL;
> +
> +       input.count = 1;
> +       input.pointer = params;
> +       params[0].type = ACPI_TYPE_BUFFER;
> +       params[0].buffer.length = sizeof(struct acpi_time);
> +       params[0].buffer.pointer = (void *) acpit;
> +
> +       spin_lock_irqsave(&rtc_lock, flags);
> +       status = acpi_evaluate_integer(acpi_tad_dev->handle, "_SRT", &input, &output);
> +       spin_unlock_irqrestore(&rtc_lock, flags);
> +       if (ACPI_FAILURE(status)) {
> +               ACPI_EXCEPTION((AE_INFO, status, "Evaluating _SRT"));
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(acpi_set_time);
> +
> +int acpi_tad_get_capability(unsigned long *output)
> +{
> +       if (!acpi_tad_dev)
> +               return -ENODEV;
> +
> +       *output = cap;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(acpi_tad_get_capability);
> +
> +static int acpi_time_alarm_add(struct acpi_device *device)
> +{
> +       acpi_status status;
> +
> +       if (!device)
> +               return -EINVAL;
> +
> +       acpi_tad_dev = device;
> +
> +       /* evaluate _GCP */
> +       status = acpi_evaluate_integer(device->handle, "_GCP", NULL, &cap);
> +       if (ACPI_FAILURE(status)) {
> +               ACPI_EXCEPTION((AE_INFO, status, "Evaluating _GCP"));
> +               return -ENODEV;
> +       }
> +
> +       if (!(cap & TAD_CAP_GETSETTIME))
> +               pr_warn(FW_INFO "Get/Set real time features not available.\n");
> +
> +       if (platform_device_register(&rtc_acpitad_dev) < 0)
> +               pr_err("Unable to register rtc-acpitad device\n");
> +
> +       return 0;
> +}
> +
> +static struct acpi_driver acpi_time_alarm_driver = {
> +       .name = "time_and_alarm",
> +       .class = ACPI_TIME_ALARM_CLASS,
> +       .ids = time_alarm_ids,
> +       .ops = {
> +               .add = acpi_time_alarm_add,
> +               },
> +};
> +
> +int __init acpi_tad_init(void)
> +{
> +       int result = 0;
> +
> +       result = acpi_bus_register_driver(&acpi_time_alarm_driver);
> +       if (result < 0)
> +               return -ENODEV;
> +
> +       return result;
> +}
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index bba9b72..3f7a075 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -689,6 +689,9 @@ static int __init acpi_init(void)
>         pci_mmcfg_late_init();
>         acpi_scan_init();
>         acpi_ec_init();
> +#ifdef CONFIG_X86
> +       acpi_tad_init();
> +#endif

Why calling acpi_tad_init() directly here rather than using module_initcall?
Is there dependency?


>         acpi_debugfs_init();
>         acpi_sleep_proc_init();
>         acpi_wakeup_device_init();
> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index a29739c..9cfe589 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -134,6 +134,11 @@ void acpi_ec_block_transactions(void);
>  void acpi_ec_unblock_transactions(void);
>  void acpi_ec_unblock_transactions_early(void);
>
> +/* --------------------------------------------------------------------------
> +                               Time and Alarm Device
> +   -------------------------------------------------------------------------- */
> +int acpi_tad_init(void);
> +
>  /*--------------------------------------------------------------------------
>                                    Suspend/Resume
>    -------------------------------------------------------------------------- */
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index d9099b1..c8dc104 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -173,6 +173,37 @@ extern int ec_transaction(u8 command,
>                            u8 *rdata, unsigned rdata_len);
>  extern acpi_handle ec_get_handle(void);
>
> +/*
> + * Time and Alarm device capability flags
> + */
> +#define TAD_CAP_ACWAKE          (1<<0)
> +#define TAD_CAP_DCWAKE          (1<<1)
> +#define TAD_CAP_GETSETTIME      (1<<2)
> +#define TAD_CAP_ACCURACY        (1<<3)
> +
> +#define ACPI_TIME_AFFECTED_BY_DAYLIGHT  (1<<0)
> +#define ACPI_TIME_ADJUSTED_FOR_DAYLIGHT (1<<1)
> +#define ACPI_ISDST (ACPI_TIME_AFFECTED_BY_DAYLIGHT|ACPI_TIME_ADJUSTED_FOR_DAYLIGHT)
> +#define ACPI_UNSPECIFIED_TIMEZONE       2047
> +
> +struct acpi_time {
> +       u16 year;
> +       u8 month;
> +       u8 day;
> +       u8 hour;
> +       u8 minute;
> +       u8 second;
> +       u8 pad1;
> +       u16 milliseconds;
> +       s16 timezone;
> +       u8 daylight;
> +       u8 pad2[3];
> +};
> +
> +extern int acpi_read_time(struct acpi_time *acpit);
> +extern int acpi_set_time(struct acpi_time *acpit);
> +extern int acpi_tad_get_capability(unsigned long *output);
> +
>  #if defined(CONFIG_ACPI_WMI) || defined(CONFIG_ACPI_WMI_MODULE)
>
>  typedef void (*wmi_notify_handler) (u32 value, void *context);
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
