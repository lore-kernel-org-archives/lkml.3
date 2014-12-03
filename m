Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaLCHCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:02:14 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:47455 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaLCHCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:02:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141203152733.20ab945f@canb.auug.org.au>
References: <20141203152733.20ab945f@canb.auug.org.au>
Date: Wed, 3 Dec 2014 08:02:11 +0100
Message-ID: <CABgxDoKJbhXCwvLbruKLSn5L-3vkma7Bct56nLtQR4_tu24QSQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the
 regulator tree
From: Romain Perier <romain.perier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My part looks good and unchanged (first commit), however I would
prefer a confirmation from Grant about the full merge.

Thanks,
Romain

2014-12-03 5:27 GMT+01:00 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi Grant,
>
> Today's linux-next merge of the devicetree tree got a conflict in
> include/linux/of.h between commit 8f73110f6bac ("of: Rename
> "poweroff-source" property to "system-power-controller"") from the pm
> tree and commit 7518b5890d8a ("of/overlay: Introduce DT overlay
> support") from the devicetree tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc include/linux/of.h
> index b47096730dc5,aa01cf5852f8..000000000000
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@@ -23,7 -23,7 +23,8 @@@
>   #include <linux/spinlock.h>
>   #include <linux/topology.h>
>   #include <linux/notifier.h>
>  +#include <linux/property.h>
> + #include <linux/list.h>
>
>   #include <asm/byteorder.h>
>   #include <asm/errno.h>
> @@@ -108,27 -111,18 +114,27 @@@ static inline struct device_node *of_no
>   static inline void of_node_put(struct device_node *node) { }
>   #endif /* !CONFIG_OF_DYNAMIC */
>
>  -#ifdef CONFIG_OF
>  -
>   /* Pointer for first entry in chain of all nodes. */
> - extern struct device_node *of_allnodes;
> + extern struct device_node *of_root;
>   extern struct device_node *of_chosen;
>   extern struct device_node *of_aliases;
>   extern struct device_node *of_stdout;
>   extern raw_spinlock_t devtree_lock;
>
>  +#ifdef CONFIG_OF
>  +static inline bool is_of_node(struct fwnode_handle *fwnode)
>  +{
>  +      return fwnode && fwnode->type == FWNODE_OF;
>  +}
>  +
>  +static inline struct device_node *of_node(struct fwnode_handle *fwnode)
>  +{
>  +      return fwnode ? container_of(fwnode, struct device_node, fwnode) : NULL;
>  +}
>  +
>   static inline bool of_have_populated_dt(void)
>   {
> -       return of_allnodes != NULL;
> +       return of_root != NULL;
>   }
>
>   static inline bool of_node_is_root(const struct device_node *node)
> @@@ -956,14 -959,33 +992,44 @@@ static inline int of_reconfig_get_state
>   extern int of_resolve_phandles(struct device_node *tree);
>
>   /**
>  + * of_device_is_system_power_controller - Tells if system-power-controller is found for device_node
>  + * @np: Pointer to the given device_node
>  + *
>  + * return true if present false otherwise
>  + */
>  +static inline bool of_device_is_system_power_controller(const struct device_node *np)
>  +{
>  +      return of_property_read_bool(np, "system-power-controller");
>  +}
>  +
> ++/**
> +  * Overlay support
> +  */
> +
> + #ifdef CONFIG_OF_OVERLAY
> +
> + /* ID based overlays; the API for external users */
> + int of_overlay_create(struct device_node *tree);
> + int of_overlay_destroy(int id);
> + int of_overlay_destroy_all(void);
> +
> + #else
> +
> + static inline int of_overlay_create(struct device_node *tree)
> + {
> +       return -ENOTSUPP;
> + }
> +
> + static inline int of_overlay_destroy(int id)
> + {
> +       return -ENOTSUPP;
> + }
> +
> + static inline int of_overlay_destroy_all(void)
> + {
> +       return -ENOTSUPP;
> + }
> +
> + #endif
> +
>   #endif /* _LINUX_OF_H */
