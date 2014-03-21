Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaCUNje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:39:34 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36661 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaCUNja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:39:30 -0400
MIME-Version: 1.0
In-Reply-To: <1395179766-31575-4-git-send-email-pantelis.antoniou@konsulko.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1395179766-31575-4-git-send-email-pantelis.antoniou@konsulko.com>
Date: Fri, 21 Mar 2014 08:39:29 -0500
Message-ID: <CAL_JsqKJqakXGWDEKPAoJ9P5myYXnodcYCdvowV6MPuZXgwVmw@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] OF: DT-Overlay configfs interface
From: Rob Herring <robherring2@gmail.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 4:56 PM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Add a runtime interface to using configfs for generic device tree overlay
> usage.
>
> A device-tree configfs entry is created in /config/device-tree/overlays
>
> To create an overlay you mkdir the directory and then echo the overlay
> firmware file to the path property file.
>
>         # mkdir /config/device-tree/overlays/foo
>         # echo foo.dtbo >/config/device-tree/overlays/foo/path

The purpose of 'path' and what determines its name is not really
clear. The documentation should be clear enough that a user knowing no
details of overlays can be handed a dtbo file and pointer to the
documentation and they can apply it without further information.

> The overlay file will be loaded using the standard firmware loader
> and will be applied.
>
> To remove it simply rmdir the directory.
>
>         # rmdir /config/device-tree/overlays/foo

This description should be put into a file in Documentation/. Probably
Documentation/devicetree/ since it is a kernel interface and not a
bindings.

>
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  drivers/of/Kconfig    |   5 +
>  drivers/of/Makefile   |   1 +
>  drivers/of/configfs.c | 272 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 278 insertions(+)
>  create mode 100644 drivers/of/configfs.c
>
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 7517be2..fc0e3ec 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -77,6 +77,10 @@ config OF_RESERVED_MEM
>         help
>           Helpers to allow for reservation of memory regions
>
> +config OF_CONFIGFS
> +       select CONFIGFS_FS
> +       def_bool n

Is it feasible to make this a module (perhaps all of the overlay support)?

> +
>  config OF_RESOLVE
>         bool "OF Dynamic resolution support"
>         depends on OF
> @@ -92,6 +96,7 @@ config OF_OVERLAY
>         select OF_DYNAMIC
>         select OF_DEVICE
>         select OF_RESOLVE
> +       select OF_CONFIGFS
>         help
>           OpenFirmware overlay support. Allows you to modify on runtime the
>           live tree using overlays.
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index d2a6e0d..4efa17b 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_OF_MTD)  += of_mtd.o
>  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
>  obj-$(CONFIG_OF_RESOLVE)  += resolver.o
>  obj-$(CONFIG_OF_OVERLAY) += overlay.o
> +obj-$(CONFIG_OF_CONFIGFS) += configfs.o
> diff --git a/drivers/of/configfs.c b/drivers/of/configfs.c
> new file mode 100644
> index 0000000..a494643
> --- /dev/null
> +++ b/drivers/of/configfs.c
> @@ -0,0 +1,272 @@
> +/*
> + * Configfs entries for device-tree
> + *
> + * Copyright (C) 2013 - Pantelis Antoniou <panto@antoniou-consulting.com>

It's 2014 now. I assume you have made some changes in 2014.

> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +#include <linux/ctype.h>
> +#include <linux/cpu.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <linux/proc_fs.h>
> +#include <linux/configfs.h>
> +#include <linux/types.h>
> +#include <linux/stat.h>
> +#include <linux/limits.h>
> +#include <linux/file.h>
> +#include <linux/vmalloc.h>
> +#include <linux/firmware.h>
> +
> +#include "of_private.h"
> +
> +#ifdef CONFIG_OF_OVERLAY

This file is only compiled with this defined, so it isn't needed.

> +
> +struct cfs_overlay_item {
> +       struct config_item      item;
> +
> +       char                    path[PATH_MAX];
> +

Remove the blank lines.

> +       const struct firmware   *fw;
> +       struct device_node      *overlay;
> +       int                     ovinfo_cnt;
> +       struct of_overlay_info  *ovinfo;
> +       unsigned int            applied : 1;

Do you plan to expand this? If not, just use bool.

> +};
> +
> +static inline struct cfs_overlay_item *to_cfs_overlay_item(struct config_item *item)
> +{
> +       return item ? container_of(item, struct cfs_overlay_item, item) : NULL;
> +}
> +
> +CONFIGFS_ATTR_STRUCT(cfs_overlay_item);
> +#define CFS_OVERLAY_ITEM_ATTR(_name, _mode, _show, _store)     \
> +struct cfs_overlay_item_attribute cfs_overlay_item_attr_##_name = \
> +       __CONFIGFS_ATTR(_name, _mode, _show, _store)
> +#define CFS_OVERLAY_ITEM_ATTR_RO(_name, _show) \
> +struct cfs_overlay_item_attribute cfs_overlay_item_attr_##_name = \
> +       __CONFIGFS_ATTR_RO(_name, _show)
> +
> +static ssize_t cfs_overlay_item_path_show(struct cfs_overlay_item *overlay,
> +               char *page)
> +{
> +       return sprintf(page, "%s\n", overlay->path);
> +}
> +
> +static ssize_t cfs_overlay_item_path_store(struct cfs_overlay_item *overlay,
> +               const char *page, size_t count)
> +{
> +       const char *p = page;
> +       char *s;
> +       int err;
> +
> +       /* if it's set do not allow changes */
> +       if (overlay->path[0] != '\0')
> +               return -EPERM;
> +
> +       /* copy to path buffer (and make sure it's always zero terminated */
> +       count = snprintf(overlay->path, sizeof(overlay->path) - 1, "%s", p);
> +       overlay->path[sizeof(overlay->path) - 1] = '\0';
> +
> +       /* strip trailing newlines */
> +       s = overlay->path + strlen(overlay->path);
> +       while (s > overlay->path && *--s == '\n')
> +               *s = '\0';

Seems like this would be common pattern. There are no helpers to do this?

> +
> +       pr_debug("%s: path is '%s'\n", __func__, overlay->path);
> +
> +       err = request_firmware(&overlay->fw, overlay->path, NULL);
> +       if (err != 0)
> +               goto out_err;
> +
> +       /* unflatten the tree */
> +       of_fdt_unflatten_tree((void *)overlay->fw->data, &overlay->overlay);
> +       if (overlay->overlay == NULL) {

"if (!overlay->overlay)" is preferred.

overlay->node would be better naming.

> +               pr_err("%s: failed to unflatten tree\n", __func__);
> +               err = -EINVAL;
> +               goto out_err;
> +       }
> +       pr_debug("%s: unflattened OK\n", __func__);
> +
> +       /* mark it as detached */
> +       of_node_set_flag(overlay->overlay, OF_DETACHED);
> +
> +       /* perform resolution */
> +       err = of_resolve(overlay->overlay);
> +       if (err != 0) {
> +               pr_err("%s: Failed to resolve tree\n", __func__);
> +               goto out_err;
> +       }
> +       pr_debug("%s: resolved OK\n", __func__);
> +
> +       /* now build an overlay info array */
> +       err = of_build_overlay_info(overlay->overlay,
> +                       &overlay->ovinfo_cnt, &overlay->ovinfo);
> +       if (err != 0) {
> +               pr_err("%s: Failed to build overlay info\n", __func__);
> +               goto out_err;
> +       }
> +
> +       pr_debug("%s: built %d overlay segments\n", __func__,
> +                       overlay->ovinfo_cnt);
> +
> +       err = of_overlay(overlay->ovinfo_cnt, overlay->ovinfo);

This really applies to the previous patches, but there's not much
consistency in the function naming. It is not clear what of_overlay
does.

I would prefix all funcitons of_overlay_* and call this one
of_overlay_apply (or finalize?).

> +       if (err != 0) {
> +               pr_err("%s: Failed to apply overlay\n", __func__);
> +               goto out_err;
> +       }
> +
> +       overlay->applied = 1;
> +
> +       pr_debug("%s: Applied #%d overlay segments\n", __func__,
> +                       overlay->ovinfo_cnt);
> +
> +       return count;
> +
> +out_err:
> +       if (overlay->applied)
> +               of_overlay_revert(overlay->ovinfo_cnt, overlay->ovinfo);
> +       overlay->applied = 0;
> +
> +       if (overlay->ovinfo)
> +               of_free_overlay_info(overlay->ovinfo_cnt, overlay->ovinfo);
> +       overlay->ovinfo = NULL;
> +       overlay->ovinfo_cnt = 0;
> +
> +       release_firmware(overlay->fw);

This needs some clean-up with multiple jump labels. You shouldn't need
the if statements and you cal release_firmware on request_firmware
error.

> +       overlay->fw = NULL;
> +
> +       overlay->path[0] = '\0';
> +       return err;
> +}
> +
> +static ssize_t cfs_overlay_item_status_show(struct cfs_overlay_item *overlay,
> +               char *page)
> +{
> +       return sprintf(page, "%s\n",
> +                       overlay->applied ? "applied" : "unapplied");
> +}

This needs to be added to the above mentioned documentation along with
any other files.

> +
> +CFS_OVERLAY_ITEM_ATTR(path, S_IRUGO | S_IWUSR, \
> +               cfs_overlay_item_path_show, cfs_overlay_item_path_store);
> +CFS_OVERLAY_ITEM_ATTR_RO(status, cfs_overlay_item_status_show);
> +
> +static struct configfs_attribute *cfs_overlay_attrs[] = {
> +       &cfs_overlay_item_attr_path.attr,
> +       &cfs_overlay_item_attr_status.attr,
> +       NULL,
> +};
> +
> +static void cfs_overlay_release(struct config_item *item)
> +{
> +       struct cfs_overlay_item *overlay = to_cfs_overlay_item(item);
> +
> +       if (overlay->applied)
> +               of_overlay_revert(overlay->ovinfo_cnt, overlay->ovinfo);
> +       if (overlay->ovinfo)
> +               of_free_overlay_info(overlay->ovinfo_cnt, overlay->ovinfo);
> +       if (overlay->fw)
> +               release_firmware(overlay->fw);
> +       kfree(overlay);
> +}
> +
> +CONFIGFS_ATTR_OPS(cfs_overlay_item);
> +static struct configfs_item_operations cfs_overlay_item_ops = {
> +       .release                = cfs_overlay_release,
> +       .show_attribute         = cfs_overlay_item_attr_show,
> +       .store_attribute        = cfs_overlay_item_attr_store,
> +};
> +
> +static struct config_item_type cfs_overlay_type = {
> +       .ct_item_ops    = &cfs_overlay_item_ops,
> +       .ct_attrs       = cfs_overlay_attrs,
> +       .ct_owner       = THIS_MODULE,
> +};
> +
> +static struct config_item *cfs_overlay_group_make_item(struct config_group *group, const char *name)
> +{
> +       struct cfs_overlay_item *overlay;
> +
> +       overlay = kzalloc(sizeof(*overlay), GFP_KERNEL);
> +       if (!overlay)
> +               return ERR_PTR(-ENOMEM);
> +
> +       config_item_init_type_name(&overlay->item, name, &cfs_overlay_type);
> +       return &overlay->item;
> +}
> +
> +static void cfs_overlay_group_drop_item(struct config_group *group, struct config_item *item)
> +{
> +       struct cfs_overlay_item *overlay = to_cfs_overlay_item(item);
> +
> +       config_item_put(&overlay->item);
> +}
> +
> +static struct configfs_group_operations overlays_ops = {
> +       .make_item      = cfs_overlay_group_make_item,
> +       .drop_item      = cfs_overlay_group_drop_item,
> +};
> +
> +static struct config_item_type overlays_type = {
> +       .ct_group_ops   = &overlays_ops,
> +       .ct_owner       = THIS_MODULE,
> +};
> +
> +#endif /* CONFIG_OF_OVERLAY */
> +
> +static struct configfs_group_operations of_cfs_ops = {
> +       /* empty - we don't allow anything to be created */
> +};
> +
> +static struct config_item_type of_cfs_type = {
> +       .ct_group_ops   = &of_cfs_ops,
> +       .ct_owner       = THIS_MODULE,
> +};
> +
> +struct config_group of_cfs_overlay_group;
> +
> +struct config_group *of_cfs_def_groups[] = {
> +#ifdef CONFIG_OF_OVERLAY
> +       &of_cfs_overlay_group,
> +#endif
> +       NULL
> +};
> +
> +static struct configfs_subsystem of_cfs_subsys = {
> +       .su_group = {
> +               .cg_item = {
> +                       .ci_namebuf = "device-tree",
> +                       .ci_type = &of_cfs_type,
> +               },
> +               .default_groups = of_cfs_def_groups,
> +       },
> +       .su_mutex = __MUTEX_INITIALIZER(of_cfs_subsys.su_mutex),
> +};
> +
> +static int __init of_cfs_init(void)
> +{
> +       int ret;
> +
> +       pr_info("%s\n", __func__);
> +
> +       config_group_init(&of_cfs_subsys.su_group);
> +#ifdef CONFIG_OF_OVERLAY
> +       config_group_init_type_name(&of_cfs_overlay_group, "overlays", &overlays_type);
> +#endif
> +
> +       ret = configfs_register_subsystem(&of_cfs_subsys);
> +       if (ret != 0) {
> +               pr_err("%s: failed to register subsys\n", __func__);
> +               goto out;
> +       }
> +       pr_info("%s: OK\n", __func__);

These pr_info prints are not necessary you can use initcall_debug.

> +out:
> +       return ret;
> +}
> +late_initcall(of_cfs_init);

Does this really need to be late_initcall?

Rob
