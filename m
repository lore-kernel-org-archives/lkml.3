Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3JaDt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 23:49:29 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:45086 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JaDt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 23:49:28 -0400
Message-ID: <5271D340.2090706@gmail.com>
Date: Thu, 31 Oct 2013 14:49:20 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Frank Haverkamp <haver@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
CC: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de, Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com> <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
In-Reply-To: <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/13 20:32, Frank Haverkamp wrote:
> From: Frank Haverkamp <haver@vnet.ibm.com>

> Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
> Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
>             Michael Jung <MIJUNG@de.ibm.com>,
>             Michael Ruettger <michael@ibmra.de>
> ---
>  Documentation/ABI/testing/debugfs-driver-genwqe |   57 +
>  Documentation/ABI/testing/sysfs-driver-genwqe   |   46 +
>  drivers/misc/Kconfig                            |    1 +
>  drivers/misc/Makefile                           |    1 +
>  drivers/misc/genwqe/Kconfig                     |   23 +
>  drivers/misc/genwqe/Makefile                    |    8 +
>  drivers/misc/genwqe/card_base.c                 | 1238 +++++++++++++++++++
>  drivers/misc/genwqe/card_base.h                 |  569 +++++++++
>  drivers/misc/genwqe/card_ddcb.c                 | 1380 +++++++++++++++++++++
>  drivers/misc/genwqe/card_ddcb.h                 |  188 +++
>  drivers/misc/genwqe/card_debugfs.c              |  566 +++++++++
>  drivers/misc/genwqe/card_dev.c                  | 1499 +++++++++++++++++++++++
>  drivers/misc/genwqe/card_sysfs.c                |  306 +++++
>  drivers/misc/genwqe/card_utils.c                |  983 +++++++++++++++
>  drivers/misc/genwqe/genwqe_driver.h             |   75 ++
>  include/linux/genwqe/genwqe_card.h              |  559 +++++++++
>  16 files changed, 7499 insertions(+), 0 deletions(-)


Please consider breaking this into multiple patches. One behemoth patch
is harder to review and less likely for people to read all of it. Since
this adds a new driver, you can add it in parts, e.g: core, sysfs,
documentation, etc, and add the Makefile/Kconfig bits in the final
patch. That way it won't break the build at any point.

Couple of comments on the sysfs bits below.

~Ryan

> +++ b/drivers/misc/genwqe/card_sysfs.c
> @@ -0,0 +1,306 @@
> +/**
> + * IBM Accelerator Family 'GenWQE'
> + *
> + * (C) Copyright IBM Corp. 2013
> + *
> + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> + * Author: Michael Jung <mijung@de.ibm.com>
> + * Author: Michael Ruettger <michael@ibmra.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License (version 2 only)
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +/*
> + * Sysfs interfaces for the GenWQE card. There are attributes to query
> + * the version of the bitstream as well as some for the
> + * driver. Additionally there are some attributes which help to debug
> + * potential problems.
> + */
> +
> +#include <linux/version.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/string.h>
> +#include <linux/fs.h>
> +#include <linux/sysfs.h>
> +#include <linux/ctype.h>
> +
> +#include "card_base.h"
> +#include "card_ddcb.h"
> +
> +static const char * const genwqe_types[] = {
> +	[GENWQE_TYPE_ALTERA_230] = "GenWQE4-230",
> +	[GENWQE_TYPE_ALTERA_530] = "GenWQE4-530",
> +	[GENWQE_TYPE_ALTERA_A4]  = "GenWQE5-A4",
> +	[GENWQE_TYPE_ALTERA_A7]  = "GenWQE5-A7",
> +};
> +
> +static ssize_t show_card_status(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	ssize_t len = 0;
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +	const char *cs[GENWQE_CARD_STATE_MAX] = { "unused", "used", "error" };
> +
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%s\n", cs[cd->card_state]);
> +	return len;

This is a bit confusingly written. Why do:

	scnprintf(&buf[len], ...

When len is always zero at that point? Since you are printing from an
array of statically sized strings that are guaranteed to be smaller than
PAGE_SIZE, you can safely do:

	sprintf(buf, "%s\n", cs[cd->card_state]);

You might want to add some checking for cd->card_state being out of
bounds, and printing "unknown" or something in that case.

Same issue exists in other sysfs handlers.

> +}
> +
> +static ssize_t show_card_appid(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
> +{
> +	ssize_t len = 0;
> +	char app_name[5];
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +
> +	genwqe_read_app_id(cd, app_name, sizeof(app_name));
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%s\n", app_name);
> +	return len;
> +}
> +
> +static ssize_t show_card_version(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	ssize_t len = 0;
> +	u64 slu_id, app_id;
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +
> +	slu_id = __genwqe_readq(cd, IO_SLU_UNITCFG);
> +	app_id = __genwqe_readq(cd, IO_APP_UNITCFG);
> +
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%016llx.%016llx\n", slu_id, app_id);
> +	return len;
> +}
> +
> +/**
> + * FIXME Implement me!
> + */
> +static ssize_t show_cpld_version(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	ssize_t len = 0;
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "unknown (FIXME)\n");
> +	return len;
> +}
> +
> +static ssize_t show_card_type(struct device *dev,
> +			      struct device_attribute *attr,
> +			      char *buf)
> +{
> +	ssize_t len = 0;
> +	u8 card_type;
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +
> +	card_type = genwqe_card_type(cd);
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%s\n", (card_type >= ARRAY_SIZE(genwqe_types)) ?
> +			 "invalid" : genwqe_types[card_type]);
> +	return len;
> +}
> +
> +static ssize_t show_card_driver(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	ssize_t len = 0;
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%s\n", DRV_VERS_STRING);
> +	return len;
> +}
> +
> +static ssize_t show_card_tempsens(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *buf)
> +{
> +	ssize_t len = 0;
> +	u64 tempsens;
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +
> +	tempsens = __genwqe_readq(cd, IO_SLU_TEMPERATURE_SENSOR);
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%016llx\n", tempsens);
> +	return len;
> +}
> +
> +static ssize_t show_card_base_clock(struct device *dev,
> +				    struct device_attribute *attr,
> +				    char *buf)
> +{
> +	ssize_t len = 0;
> +	u64 base_clock;
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +
> +	base_clock = genwqe_base_clock_frequency(cd);
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%lld\n", base_clock);
> +	return len;
> +}
> +
> +/**
> + * show_card_curr_bitstream() - Show the current bitstream id
> + *
> + * There is a bug in some old versions of the CPLD which selects the
> + * bitstream, which causes the IO_SLU_BITSTREAM register to report
> + * unreliable data in very rare cases. This makes this sysfs
> + * unreliable up to the point were a new CPLD version is being used.
> + *
> + * Unfortunately there is no automatic way yet to query the CPLD
> + * version (See show_cpld_version() ;-)), such that you need to
> + * manually ensure via programming tools that you have a recent
> + * version of the CPLD software.
> + *
> + * The proposed circumvention is to use a special recovery bitstream
> + * on the backup partition (0) to identify problems while loading the
> + * image.
> + */
> +static ssize_t show_card_curr_bitstream(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	ssize_t len = 0;
> +	int curr_bitstream;
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +
> +	curr_bitstream = __genwqe_readq(cd, IO_SLU_BITSTREAM) & 0x1;
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%d\n", curr_bitstream);
> +	return len;
> +}
> +
> +/**
> + * show_card_next_bitstream() - Show the next activated bitstream
> + *
> + * IO_SLC_CFGREG_SOFTRESET: This register can only be accessed by the PF.
> + */
> +static ssize_t show_card_next_bitstream(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	ssize_t len = 0;
> +	int next_bitstream;
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +
> +	switch ((cd->softreset & 0xCull) >> 2) {
> +	case 0x2:
> +		next_bitstream =  0;
> +		break;
> +	case 0x3:
> +		next_bitstream =  1;
> +		break;
> +	default:
> +		next_bitstream = -1;
> +		break;		/* error */
> +	}
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "%d\n", next_bitstream);
> +	return len;
> +}
> +
> +static ssize_t store_card_next_bitstream(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t count)
> +{
> +	u64 partition;
> +	struct genwqe_dev *cd = dev_get_drvdata(dev);
> +
> +	if (kstrtoull(buf, 0, &partition) < 0)
> +		return -EINVAL;

Does this give a type error? partition should be unsigned long long,
which is _at least_ 64 bits.

> +
> +	switch (partition) {
> +	case 0x0:
> +		cd->softreset = 0x78ull;
> +		break;
> +	case 0x1:
> +		cd->softreset = 0x7cull;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, cd->softreset);
> +	return count;
> +}
> +
> +/*
> + * Create device_attribute structures / params: name, mode, show, store
> + * additional flag if valid in VF
> + */
> +struct genwqe_dev_attrib {
> +	struct device_attribute att;	/* sysfs entry attributes */
> +	int vf;				/* may exist in VF or not */
> +};
> +
> +static struct genwqe_dev_attrib dev_attr_tab[] = {
> +	{__ATTR(tempsens,       S_IRUGO, show_card_tempsens, NULL), 0},
> +	{__ATTR(next_bitstream, (S_IRUGO | S_IWUSR),
> +		show_card_next_bitstream, store_card_next_bitstream), 0},
> +	{__ATTR(curr_bitstream, S_IRUGO, show_card_curr_bitstream, NULL), 0},
> +	{__ATTR(cpld_version,   S_IRUGO, show_cpld_version, NULL), 0},
> +	{__ATTR(base_clock,	S_IRUGO, show_card_base_clock, NULL), 0},
> +
> +	{__ATTR(driver,		S_IRUGO, show_card_driver, NULL), 1},
> +	{__ATTR(type,		S_IRUGO, show_card_type, NULL), 1},
> +	{__ATTR(version,	S_IRUGO, show_card_version, NULL), 1},
> +	{__ATTR(appid,		S_IRUGO, show_card_appid, NULL), 1},
> +	{__ATTR(status,		S_IRUGO, show_card_status, NULL), 1},
> +};
> +
> +/**
> + * create_card_sysfs() - Setup sysfs entries of the card device
> + *
> + * VFs have restricted mmio capabilities, so not all sysfs entries
> + * are allowed in VFs.
> + */
> +int create_card_sysfs(struct genwqe_dev *cd)

This is extern, and has a very generic name. Prefix it with genwqe or
something. Same for the function below, and for any other extern symbols
you have.


