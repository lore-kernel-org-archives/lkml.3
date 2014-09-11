Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaIKPdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:33:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48727 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbaIKPdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:33:13 -0400
Message-ID: <5411C0B2.3060505@ti.com>
Date: Thu, 11 Sep 2014 21:03:06 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/6] phy: improved lookup method
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com> <1408620803-10464-3-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1408620803-10464-3-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 21 August 2014 05:03 PM, Heikki Krogerus wrote:
> Removes the need for the phys to be aware of their users
> even when not using DT. The method is copied from clkdev.c.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>
.
.
<skip>
.
.

>  
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index ff5eec5..67a8c726 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -26,6 +26,7 @@
>  static struct class *phy_class;
>  static DEFINE_MUTEX(phy_provider_mutex);
>  static LIST_HEAD(phy_provider_list);
> +static LIST_HEAD(phys);
>  static DEFINE_IDA(phy_ida);
>  
>  static void devm_phy_release(struct device *dev, void *res)
> @@ -84,6 +85,138 @@ static struct phy *phy_lookup(struct device *device, const char *port)
>  	return ERR_PTR(-ENODEV);
>  }
>  
> +/**
> + * phy_register_lookup() - register PHY/device association
> + * @pl: association to register
> + */
> +void phy_register_lookup(struct phy_lookup *pl)
> +{
> +	mutex_lock(&phy_provider_mutex);
> +	list_add_tail(&pl->node, &phys);
> +	mutex_unlock(&phy_provider_mutex);
> +}
> +
> +/**
> + * phy_unregister_lookup() - remove PHY/device association
> + * @pl: association to be removed
> + */
> +void phy_unregister_lookup(struct phy_lookup *pl)
> +{
> +	mutex_lock(&phy_provider_mutex);
> +	list_del(&pl->node);
> +	mutex_unlock(&phy_provider_mutex);
> +}
> +
> +/**
> + * phy_create_lookup() - allocate and register PHY/device association
> + * @phy: the phy of the association
> + * @con_id: connection ID string on device
> + * @dev_id: the device of the association
> + *
> + * Creates and registers phy_lookup entry.
> + */
> +int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id)
> +{
> +	struct phy_lookup *pl;
> +
> +	if (!phy || (!dev_id && !con_id))
> +		return -EINVAL;
> +
> +	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
> +	if (!pl)
> +		return -ENOMEM;
> +
> +	pl->phy_name = dev_name(&phy->dev);
> +	pl->dev_id = dev_id;
> +	pl->con_id = con_id;
> +
> +	phy_register_lookup(pl);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(phy_create_lookup);
> +
> +/**
> + * phy_remove_lookup() - find and remove PHY/device association
> + * @phy: the phy of the association
> + * @con_id: connection ID string on device
> + * @dev_id: the device of the association
> + *
> + * Finds and unregisters phy_lookup entry that was created with
> + * phy_create_lookup().
> + */
> +void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id)
> +{
> +	struct phy_lookup *pl;
> +
> +	if (!phy || (!dev_id && !con_id))
> +		return;
> +
> +	list_for_each_entry(pl, &phys, node)
> +		if (!strcmp(pl->phy_name, dev_name(&phy->dev)) &&
> +		    !strcmp(pl->dev_id, dev_id) &&
> +		    !strcmp(pl->con_id, con_id)) {
> +			phy_unregister_lookup(pl);
> +			kfree(pl);
> +			return;
> +		}
> +}
> +EXPORT_SYMBOL_GPL(phy_remove_lookup);
> +
> +static struct phy *phy_find(struct device *dev, const char *con_id)
> +{
> +	const char *dev_id = dev ? dev_name(dev) : NULL;
> +	int match, best_found = 0, best_possible = 0;
> +	struct phy *phy = ERR_PTR(-ENODEV);
> +	struct phy_lookup *p, *pl = NULL;
> +
> +	if (dev_id)
> +		best_possible += 2;
> +	if (con_id)
> +		best_possible += 1;
> +
> +	list_for_each_entry(p, &phys, node) {
> +		match = 0;
> +		if (p->dev_id) {
> +			if (!dev_id || strcmp(p->dev_id, dev_id))
> +				continue;
> +			match += 2;
> +		}
> +		if (p->con_id) {
> +			if (!con_id || strcmp(p->con_id, con_id))
> +				continue;
> +			match += 1;
> +		}
> +
> +		if (match > best_found) {
> +			pl = p;
> +			if (match != best_possible)
> +				best_found = match;
> +			else
> +				break;
> +		}
> +	}
> +
> +	if (pl) {
> +		struct class_dev_iter iter;
> +		struct device *phy_dev;
> +
> +		class_dev_iter_init(&iter, phy_class, NULL, NULL);
> +		while ((phy_dev = class_dev_iter_next(&iter))) {
> +			if (!strcmp(dev_name(phy_dev), pl->phy_name)) {

I'm not sure how it'll work with systems which has multiple PHYs since the "id"
component of the device is determined purely in runtime.

I'd assume we'll be constantly patching the lookup data for non-dt boot :-/

Thanks
Kishon
