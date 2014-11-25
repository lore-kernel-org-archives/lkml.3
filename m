Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaKYOui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:50:38 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:37150 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbaKYOuc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:50:32 -0500
Subject: Re: [PATCH v8 3/8] OF: DT-Overlay configfs interface (v2)
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20141125102844.79BAEC44089@trevor.secretlab.ca>
Date: Tue, 25 Nov 2014 16:50:15 +0200
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <773D4828-4530-46E7-8786-1DBA490C36EB@antoniou-consulting.com>
References: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com> <1414528565-10907-4-git-send-email-pantelis.antoniou@konsulko.com> <20141125102844.79BAEC44089@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

> On Nov 25, 2014, at 12:28 , Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> Hi Pantelis,
> 
> Comments below...
> 
> On Tue, 28 Oct 2014 22:36:00 +0200
> , Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> wrote:
>> Add a runtime interface to using configfs for generic device tree overlay
>> usage.
>> 
>> A device-tree configfs entry is created in /config/device-tree/overlays
>> 
>> * To create an overlay you mkdir the directory:
>> 
>> 	# mkdir /config/device-tree/overlays/foo
>> 
>> * Either you echo the overlay firmware file to the path property file.
>> 
>> 	# echo foo.dtbo >/config/device-tree/overlays/foo/path
>> 
>> * Or you cat the contents of the overlay to the dtbo file
>> 
>> 	# cat foo.dtbo >/config/device-tree/overlays/foo/dtbo
>> 
>> The overlay file will be applied.
>> 
>> To remove it simply rmdir the directory.
>> 
>> 	# rmdir /config/device-tree/overlays/foo
> 
> The above is documentation on how to use it, but it isn't a good commit
> message. The above should be moved into a documentation file (if it
> isn't already and I've missed it) and the commit message should give
> detail about what was needed, what was changed to make it happen, and
> what the result of the new code is.
> 

Hmm, okie dokie.

>> 
>> Changes since v1:
>> * of_resolve() -> of_resolve_phandles().
>> 
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> ---
>> drivers/of/Kconfig    |   7 ++
>> drivers/of/Makefile   |   1 +
>> drivers/of/configfs.c | 340 ++++++++++++++++++++++++++++++++++++++++++++++++++
>> 3 files changed, 348 insertions(+)
>> create mode 100644 drivers/of/configfs.c
>> 
>> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
>> index aa315c4..d59ba40 100644
>> --- a/drivers/of/Kconfig
>> +++ b/drivers/of/Kconfig
>> @@ -90,4 +90,11 @@ config OF_OVERLAY
>> 	select OF_DEVICE
>> 	select OF_RESOLVE
>> 
>> +config OF_CONFIGFS
>> +	bool "OpenFirmware Overlay ConfigFS interface"
> 
> Despite all the APIs being prefixed with OpenFirmware, this isn't an
> OpenFirmware interface, it is a device tree interface.
> 

OK, so device tree config fs interface?

>> +	select CONFIGFS_FS
>> +	select OF_OVERLAY
>> +	help
>> +	  Enable a simple user-space driver DT overlay interface.
>> +
>> endmenu # OF
>> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
>> index 1bfe462..6d12949 100644
>> --- a/drivers/of/Makefile
>> +++ b/drivers/of/Makefile
>> @@ -15,6 +15,7 @@ obj-$(CONFIG_OF_MTD)	+= of_mtd.o
>> obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
>> obj-$(CONFIG_OF_RESOLVE)  += resolver.o
>> obj-$(CONFIG_OF_OVERLAY) += overlay.o
>> +obj-$(CONFIG_OF_CONFIGFS) += configfs.o
> 
> Tip: Insert lines in the middle of the block, roughly alphabetically
> sorted. It cuts down on merge conflicts that way.
> 

k

>> 
>> CFLAGS_fdt.o = -I$(src)/../../scripts/dtc/libfdt
>> CFLAGS_fdt_address.o = -I$(src)/../../scripts/dtc/libfdt
>> diff --git a/drivers/of/configfs.c b/drivers/of/configfs.c
>> new file mode 100644
>> index 0000000..932f572
>> --- /dev/null
>> +++ b/drivers/of/configfs.c
>> @@ -0,0 +1,340 @@
>> +/*
>> + * Configfs entries for device-tree
>> + *
>> + * Copyright (C) 2013 - Pantelis Antoniou <panto@antoniou-consulting.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version
>> + * 2 of the License, or (at your option) any later version.
>> + */
>> +#include <linux/ctype.h>
>> +#include <linux/cpu.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_fdt.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/slab.h>
>> +#include <linux/proc_fs.h>
>> +#include <linux/configfs.h>
>> +#include <linux/types.h>
>> +#include <linux/stat.h>
>> +#include <linux/limits.h>
>> +#include <linux/file.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/firmware.h>
>> +
>> +#include "of_private.h"
>> +
>> +#ifdef CONFIG_OF_OVERLAY
> 
> ???
> 
> This file shouldn't even be compiled if CONFIG_OF_OVERLAY isn't
> selected. Why is this here?
> 

Err, good question.

>> +
>> +struct cfs_overlay_item {
>> +	struct config_item	item;
>> +
>> +	char			path[PATH_MAX];
>> +
>> +	const struct firmware	*fw;
>> +	struct device_node	*overlay;
>> +	int			ov_id;
>> +
>> +	void			*dtbo;
>> +	int			dtbo_size;
>> +};
>> +
>> +static int create_overlay(struct cfs_overlay_item *overlay, void *blob)
>> +{
>> +	int err;
>> +
>> +	/* unflatten the tree */
>> +	of_fdt_unflatten_tree((void *)blob, &overlay->overlay);
> 
> blob is already void*
> 

ok

>> +	if (overlay->overlay == NULL) {
>> +		pr_err("%s: failed to unflatten tree\n", __func__);
>> +		err = -EINVAL;
>> +		goto out_err;
>> +	}
>> +	pr_debug("%s: unflattened OK\n", __func__);
>> +
>> +	/* mark it as detached */
>> +	of_node_set_flag(overlay->overlay, OF_DETACHED);
>> +
>> +	/* perform resolution */
>> +	err = of_resolve_phandles(overlay->overlay);
>> +	if (err != 0) {
>> +		pr_err("%s: Failed to resolve tree\n", __func__);
>> +		goto out_err;
>> +	}
>> +	pr_debug("%s: resolved OK\n", __func__);
>> +
>> +	err = of_overlay_create(overlay->overlay);
>> +	if (err < 0) {
>> +		pr_err("%s: Failed to create overlay (err=%d)\n",
>> +				__func__, err);
>> +		goto out_err;
>> +	}
>> +	overlay->ov_id = err;
>> +
>> +out_err:
>> +	return err;
>> +}
>> +
>> +static inline struct cfs_overlay_item *to_cfs_overlay_item(
>> +		struct config_item *item)
>> +{
>> +	return item ? container_of(item, struct cfs_overlay_item, item) : NULL;
>> +}
>> +
>> +CONFIGFS_ATTR_STRUCT(cfs_overlay_item);
>> +#define CFS_OVERLAY_ITEM_ATTR(_name, _mode, _show, _store)	\
>> +struct cfs_overlay_item_attribute cfs_overlay_item_attr_##_name = \
>> +	__CONFIGFS_ATTR(_name, _mode, _show, _store)
>> +#define CFS_OVERLAY_ITEM_ATTR_RO(_name, _show)	\
>> +struct cfs_overlay_item_attribute cfs_overlay_item_attr_##_name = \
>> +	__CONFIGFS_ATTR_RO(_name, _show)
>> +
>> +CONFIGFS_BIN_ATTR_STRUCT(cfs_overlay_item);
>> +#define CFS_OVERLAY_ITEM_BIN_ATTR(_name, _mode, _read, _write, _priv, _max) \
>> +struct cfs_overlay_item_bin_attribute cfs_overlay_item_bin_attr_##_name = \
>> +	__CONFIGFS_BIN_ATTR(_name, _mode, _read, _write, _priv, _max)
>> +#define CFS_OVERLAY_ITEM_BIN_ATTR_RO(_name, _read, _priv, _max)	\
>> +struct cfs_overlay_item_bin_attribute cfs_overlay_item_bin_attr_##_name = \
>> +	__CONFIGFS_BIN_ATTR_RO(_name, _read, _priv, _max)
>> +
>> +static ssize_t cfs_overlay_item_path_show(struct cfs_overlay_item *overlay,
>> +		char *page)
>> +{
>> +	return sprintf(page, "%s\n", overlay->path);
>> +}
>> +
>> +static ssize_t cfs_overlay_item_path_store(struct cfs_overlay_item *overlay,
>> +		const char *page, size_t count)
>> +{
>> +	const char *p = page;
>> +	char *s;
>> +	int err;
>> +
>> +	/* if it's set do not allow changes */
>> +	if (overlay->path[0] != '\0' || overlay->dtbo_size > 0)
>> +		return -EPERM;
>> +
>> +	/* copy to path buffer (and make sure it's always zero terminated */
>> +	count = snprintf(overlay->path, sizeof(overlay->path) - 1, "%s", p);
>> +	overlay->path[sizeof(overlay->path) - 1] = '\0';
>> +
>> +	/* strip trailing newlines */
>> +	s = overlay->path + strlen(overlay->path);
>> +	while (s > overlay->path && *--s == '\n')
>> +		*s = '\0';
>> +
>> +	pr_debug("%s: path is '%s'\n", __func__, overlay->path);
>> +
>> +	err = request_firmware(&overlay->fw, overlay->path, NULL);
>> +	if (err != 0)
>> +		goto out_err;
>> +
>> +	err = create_overlay(overlay, (void *)overlay->fw->data);
>> +	if (err != 0)
>> +		goto out_err;
>> +
>> +	return count;
>> +
>> +out_err:
>> +
>> +	release_firmware(overlay->fw);
>> +	overlay->fw = NULL;
>> +
>> +	overlay->path[0] = '\0';
>> +	return err;
>> +}
>> +
>> +static ssize_t cfs_overlay_item_status_show(struct cfs_overlay_item *overlay,
>> +		char *page)
>> +{
>> +	return sprintf(page, "%s\n",
>> +			overlay->ov_id >= 0 ? "applied" : "unapplied");
>> +}
>> +
>> +CFS_OVERLAY_ITEM_ATTR(path, S_IRUGO | S_IWUSR,
>> +		cfs_overlay_item_path_show, cfs_overlay_item_path_store);
> 
> World writable? Am I reading this correctly?
> 

Err, user writeable, world readable. “-rw-r--r—"

> DT modifications are privileged. A user can potentially get arbitrary
> access to i2c, spi, gpio or other things that shouldn't be allowed. This
> feature give access right into the Linux driver model.
> 

Yes, it does.

> Before this can be merged, it needs to be locked down, and there needs
> to be documentation about how it is locked down. Owned by root is only
> the first step, there also needs to be some rules about which nodes can
> be modified by the configfs interface. By default think no modifications
> should be allowed on a tree unless there are properties somewhere in the
> tree that explicitly allow modifications to be performed.
> 

TBH this is more of a debug level interface. The way I see it a different
overlay manager, that’s tuned to the platform, should handle the overlay
request and application, in a manner that’s not directly open to user
control. For example in a beaglebone you’d have a ‘cape’ manager reading
the i2c eeproms and request the overlays they match without any user-space
implication.

However, this is an interface that developers will use daily, so I agree
that we need to look into the security model now before it’s too late.

How do you feel for something like this in chosen:

overlay-targets = “/ocp”, “/pinctrl”;

That would allow overlays to target the ocp and pinctrl nodes (and all their
children). To allow overlays to attach everywhere just use

overlay-targets = “/“;

> Regardless, there needs to be a proposal made about the security model
> so that it can be discussed and analyzed by folks better versed in
> security that either of us. I would like to get Kees Cook to take a look
> at what we are doing here.
> 

Admittedly we could use some help here.
 
>> +CFS_OVERLAY_ITEM_ATTR_RO(status, cfs_overlay_item_status_show);
>> +
>> +static struct configfs_attribute *cfs_overlay_attrs[] = {
>> +	&cfs_overlay_item_attr_path.attr,
>> +	&cfs_overlay_item_attr_status.attr,
>> +	NULL,
>> +};
>> +
>> +ssize_t cfs_overlay_item_dtbo_read(struct cfs_overlay_item *overlay,
>> +		void *buf, size_t max_count)
>> +{
>> +	pr_debug("%s: buf=%p max_count=%u\n", __func__,
>> +			buf, max_count);
>> +
>> +	if (overlay->dtbo == NULL)
>> +		return 0;
>> +
>> +	/* copy if buffer provided */
>> +	if (buf != NULL) {
>> +		/* the buffer must be large enough */
>> +		if (overlay->dtbo_size > max_count)
>> +			return -ENOSPC;
>> +
>> +		memcpy(buf, overlay->dtbo, overlay->dtbo_size);
>> +	}
>> +
>> +	return overlay->dtbo_size;
>> +}
>> +
>> +ssize_t cfs_overlay_item_dtbo_write(struct cfs_overlay_item *overlay,
>> +		const void *buf, size_t count)
>> +{
>> +	int err;
>> +
>> +	/* if it's set do not allow changes */
>> +	if (overlay->path[0] != '\0' || overlay->dtbo_size > 0)
>> +		return -EPERM;
>> +
>> +	/* copy the contents */
>> +	overlay->dtbo = kmemdup(buf, count, GFP_KERNEL);
>> +	if (overlay->dtbo == NULL)
>> +		return -ENOMEM;
>> +
>> +	overlay->dtbo_size = count;
>> +
>> +	err = create_overlay(overlay, overlay->dtbo);
>> +	if (err != 0)
>> +		goto out_err;
>> +
>> +	return count;
>> +
>> +out_err:
>> +	kfree(overlay->dtbo);
>> +	overlay->dtbo = NULL;
>> +	overlay->dtbo_size = 0;
>> +
>> +	return err;
>> +}
>> +
>> +CFS_OVERLAY_ITEM_BIN_ATTR(dtbo, S_IRUGO | S_IWUSR,
>> +		cfs_overlay_item_dtbo_read, cfs_overlay_item_dtbo_write,
>> +		NULL, SZ_1M);
>> +
>> +static struct configfs_bin_attribute *cfs_overlay_bin_attrs[] = {
>> +	&cfs_overlay_item_bin_attr_dtbo.bin_attr,
>> +	NULL,
>> +};
>> +
>> +static void cfs_overlay_release(struct config_item *item)
>> +{
>> +	struct cfs_overlay_item *overlay = to_cfs_overlay_item(item);
>> +
>> +	if (overlay->ov_id >= 0)
>> +		of_overlay_destroy(overlay->ov_id);
>> +	if (overlay->fw)
>> +		release_firmware(overlay->fw);
>> +	/* kfree with NULL is safe */
>> +	kfree(overlay->dtbo);
>> +	kfree(overlay);
>> +}
>> +
>> +CONFIGFS_ATTR_OPS(cfs_overlay_item);
>> +CONFIGFS_BIN_ATTR_OPS(cfs_overlay_item);
>> +static struct configfs_item_operations cfs_overlay_item_ops = {
>> +	.release		= cfs_overlay_release,
>> +	.show_attribute		= cfs_overlay_item_attr_show,
>> +	.store_attribute	= cfs_overlay_item_attr_store,
>> +	.read_bin_attribute	= cfs_overlay_item_bin_attr_read,
>> +	.write_bin_attribute	= cfs_overlay_item_bin_attr_write,
>> +};
>> +
>> +static struct config_item_type cfs_overlay_type = {
>> +	.ct_item_ops	= &cfs_overlay_item_ops,
>> +	.ct_attrs	= cfs_overlay_attrs,
>> +	.ct_bin_attrs	= cfs_overlay_bin_attrs,
>> +	.ct_owner	= THIS_MODULE,
>> +};
>> +
>> +static struct config_item *cfs_overlay_group_make_item(
>> +		struct config_group *group, const char *name)
>> +{
>> +	struct cfs_overlay_item *overlay;
>> +
>> +	overlay = kzalloc(sizeof(*overlay), GFP_KERNEL);
>> +	if (!overlay)
>> +		return ERR_PTR(-ENOMEM);
>> +	overlay->ov_id = -1;
>> +
>> +	config_item_init_type_name(&overlay->item, name, &cfs_overlay_type);
>> +	return &overlay->item;
>> +}
>> +
>> +static void cfs_overlay_group_drop_item(struct config_group *group,
>> +		struct config_item *item)
>> +{
>> +	struct cfs_overlay_item *overlay = to_cfs_overlay_item(item);
>> +
>> +	config_item_put(&overlay->item);
>> +}
>> +
>> +static struct configfs_group_operations overlays_ops = {
>> +	.make_item	= cfs_overlay_group_make_item,
>> +	.drop_item	= cfs_overlay_group_drop_item,
>> +};
>> +
>> +static struct config_item_type overlays_type = {
>> +	.ct_group_ops   = &overlays_ops,
>> +	.ct_owner       = THIS_MODULE,
>> +};
>> +
>> +#endif /* CONFIG_OF_OVERLAY */
>> +
>> +static struct configfs_group_operations of_cfs_ops = {
>> +	/* empty - we don't allow anything to be created */
>> +};
>> +
>> +static struct config_item_type of_cfs_type = {
>> +	.ct_group_ops   = &of_cfs_ops,
>> +	.ct_owner       = THIS_MODULE,
>> +};
>> +
>> +struct config_group of_cfs_overlay_group;
>> +
>> +struct config_group *of_cfs_def_groups[] = {
>> +#ifdef CONFIG_OF_OVERLAY
>> +	&of_cfs_overlay_group,
>> +#endif
>> +	NULL
>> +};
>> +
>> +static struct configfs_subsystem of_cfs_subsys = {
>> +	.su_group = {
>> +		.cg_item = {
>> +			.ci_namebuf = "device-tree",
>> +			.ci_type = &of_cfs_type,
>> +		},
>> +		.default_groups = of_cfs_def_groups,
>> +	},
>> +	.su_mutex = __MUTEX_INITIALIZER(of_cfs_subsys.su_mutex),
>> +};
>> +
>> +static int __init of_cfs_init(void)
>> +{
>> +	int ret;
>> +
>> +	pr_info("%s\n", __func__);
>> +
>> +	config_group_init(&of_cfs_subsys.su_group);
>> +#ifdef CONFIG_OF_OVERLAY
>> +	config_group_init_type_name(&of_cfs_overlay_group, "overlays",
>> +			&overlays_type);
>> +#endif
>> +
>> +	ret = configfs_register_subsystem(&of_cfs_subsys);
>> +	if (ret != 0) {
>> +		pr_err("%s: failed to register subsys\n", __func__);
>> +		goto out;
>> +	}
>> +	pr_info("%s: OK\n", __func__);
>> +out:
>> +	return ret;
>> +}
>> +late_initcall(of_cfs_init);
>> -- 
>> 1.7.12
>> 

Regards

— Pantelis

