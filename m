Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaKKGmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:42:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53945 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaKKGmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:42:36 -0500
Message-ID: <5461AFD3.5020302@ti.com>
Date: Tue, 11 Nov 2014 12:12:27 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        <andrew.kim@intel.com>
Subject: Re: [PATCHv4 2/6] phy: improved lookup method
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>	<1413556756-5050-3-git-send-email-heikki.krogerus@linux.intel.com> <CAFp+6iH2oPT-HyJhFCXVCL4eUOQ0AFfxuyGsnXzPv9JTo55+VQ@mail.gmail.com>
In-Reply-To: <CAFp+6iH2oPT-HyJhFCXVCL4eUOQ0AFfxuyGsnXzPv9JTo55+VQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 31 October 2014 06:03 PM, Vivek Gautam wrote:
> Hi Heikki,
> 
> 
> On Fri, Oct 17, 2014 at 8:09 PM, Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
>> Removes the need for the phys to be aware of their users
>> even when not using DT. The method is copied from clkdev.c.
>>
>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  Documentation/phy.txt   |  66 ++++++++---------------
>>  drivers/phy/phy-core.c  | 135 +++++++++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/phy/phy.h |  27 ++++++++++
>>  3 files changed, 183 insertions(+), 45 deletions(-)
>>
>> diff --git a/Documentation/phy.txt b/Documentation/phy.txt
>> index c6594af..8add515 100644
>> --- a/Documentation/phy.txt
>> +++ b/Documentation/phy.txt
>> @@ -54,18 +54,14 @@ The PHY driver should create the PHY in order for other peripheral controllers
>>  to make use of it. The PHY framework provides 2 APIs to create the PHY.
>>
>>  struct phy *phy_create(struct device *dev, struct device_node *node,
>> -                      const struct phy_ops *ops,
>> -                      struct phy_init_data *init_data);
>> +                      const struct phy_ops *ops);
>>  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
>> -                           const struct phy_ops *ops,
>> -                           struct phy_init_data *init_data);
>> +                           const struct phy_ops *ops);
>>
>>  The PHY drivers can use one of the above 2 APIs to create the PHY by passing
>> -the device pointer, phy ops and init_data.
>> +the device pointer and phy ops.
>>  phy_ops is a set of function pointers for performing PHY operations such as
>> -init, exit, power_on and power_off. *init_data* is mandatory to get a reference
>> -to the PHY in the case of non-dt boot. See section *Board File Initialization*
>> -on how init_data should be used.
>> +init, exit, power_on and power_off.
>>
>>  Inorder to dereference the private data (in phy_ops), the phy provider driver
>>  can use phy_set_drvdata() after creating the PHY and use phy_get_drvdata() in
>> @@ -137,42 +133,24 @@ There are exported APIs like phy_pm_runtime_get, phy_pm_runtime_get_sync,
>>  phy_pm_runtime_put, phy_pm_runtime_put_sync, phy_pm_runtime_allow and
>>  phy_pm_runtime_forbid for performing PM operations.
>>
>> -8. Board File Initialization
>> -
>> -Certain board file initialization is necessary in order to get a reference
>> -to the PHY in the case of non-dt boot.
>> -Say we have a single device that implements 3 PHYs that of USB, SATA and PCIe,
>> -then in the board file the following initialization should be done.
>> -
>> -struct phy_consumer consumers[] = {
>> -       PHY_CONSUMER("dwc3.0", "usb"),
>> -       PHY_CONSUMER("pcie.0", "pcie"),
>> -       PHY_CONSUMER("sata.0", "sata"),
>> -};
>> -PHY_CONSUMER takes 2 parameters, first is the device name of the controller
>> -(PHY consumer) and second is the port name.
>> -
>> -struct phy_init_data init_data = {
>> -       .consumers = consumers,
>> -       .num_consumers = ARRAY_SIZE(consumers),
>> -};
>> -
>> -static const struct platform_device pipe3_phy_dev = {
>> -       .name = "pipe3-phy",
>> -       .id = -1,
>> -       .dev = {
>> -               .platform_data = {
>> -                       .init_data = &init_data,
>> -               },
>> -       },
>> -};
>> -
>> -then, while doing phy_create, the PHY driver should pass this init_data
>> -       phy_create(dev, ops, pdata->init_data);
>> -
>> -and the controller driver (phy consumer) should pass the port name along with
>> -the device to get a reference to the PHY
>> -       phy_get(dev, "pcie");
>> +8. PHY Mappings
>> +
>> +In order to get reference to a PHY without help from DeviceTree, the framework
>> +offers lookups which can be compared to clkdev that allow clk structures to be
>> +bound to devices. A lookup can be made statically by directly registering
>> +phy_lookup structure which contains the name of the PHY device, the name of the
>> +device which the PHY will be bind to and Connection ID string. Alternatively a
>> +lookup can be made during runtime when a handle to the struct phy already
>> +exists.
>> +
>> +The framework offers the following APIs for registering and unregistering the
>> +lookups.
>> +
>> +void phy_register_lookup(struct phy_lookup *pl);
>> +int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id);
>> +
>> +void phy_unregister_lookup(struct phy_lookup *pl);
>> +void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id);
>>
>>  9. DeviceTree Binding
>>
>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>> index ff5eec5..c8d0f66 100644
>> --- a/drivers/phy/phy-core.c
>> +++ b/drivers/phy/phy-core.c
>> @@ -26,6 +26,7 @@
>>  static struct class *phy_class;
>>  static DEFINE_MUTEX(phy_provider_mutex);
>>  static LIST_HEAD(phy_provider_list);
>> +static LIST_HEAD(phys);
>>  static DEFINE_IDA(phy_ida);
>>
>>  static void devm_phy_release(struct device *dev, void *res)
>> @@ -84,6 +85,138 @@ static struct phy *phy_lookup(struct device *device, const char *port)
>>         return ERR_PTR(-ENODEV);
>>  }
>>
>> +/**
>> + * phy_register_lookup() - register PHY/device association
>> + * @pl: association to register
>> + */
>> +void phy_register_lookup(struct phy_lookup *pl)
>> +{
>> +       mutex_lock(&phy_provider_mutex);
>> +       list_add_tail(&pl->node, &phys);
>> +       mutex_unlock(&phy_provider_mutex);
>> +}
>> +
>> +/**
>> + * phy_unregister_lookup() - remove PHY/device association
>> + * @pl: association to be removed
>> + */
>> +void phy_unregister_lookup(struct phy_lookup *pl)
>> +{
>> +       mutex_lock(&phy_provider_mutex);
>> +       list_del(&pl->node);
>> +       mutex_unlock(&phy_provider_mutex);
>> +}
>> +
>> +/**
>> + * phy_create_lookup() - allocate and register PHY/device association
>> + * @phy: the phy of the association
>> + * @con_id: connection ID string on device
>> + * @dev_id: the device of the association
>> + *
>> + * Creates and registers phy_lookup entry.
>> + */
>> +int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id)
>> +{
>> +       struct phy_lookup *pl;
>> +
>> +       if (!phy || (!dev_id && !con_id))
>> +               return -EINVAL;
>> +
>> +       pl = kzalloc(sizeof(*pl), GFP_KERNEL);
>> +       if (!pl)
>> +               return -ENOMEM;
>> +
>> +       pl->phy_name = dev_name(phy->dev.parent);
>> +       pl->dev_id = dev_id;
>> +       pl->con_id = con_id;
>> +
>> +       phy_register_lookup(pl);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(phy_create_lookup);
>> +
>> +/**
>> + * phy_remove_lookup() - find and remove PHY/device association
>> + * @phy: the phy of the association
>> + * @con_id: connection ID string on device
>> + * @dev_id: the device of the association
>> + *
>> + * Finds and unregisters phy_lookup entry that was created with
>> + * phy_create_lookup().
>> + */
>> +void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id)
>> +{
>> +       struct phy_lookup *pl;
>> +
>> +       if (!phy || (!dev_id && !con_id))
>> +               return;
>> +
>> +       list_for_each_entry(pl, &phys, node)
>> +               if (!strcmp(pl->phy_name, dev_name(phy->dev.parent)) &&
>> +                   !strcmp(pl->dev_id, dev_id) &&
>> +                   !strcmp(pl->con_id, con_id)) {
>> +                       phy_unregister_lookup(pl);
>> +                       kfree(pl);
>> +                       return;
>> +               }
>> +}
>> +EXPORT_SYMBOL_GPL(phy_remove_lookup);
>> +
>> +static struct phy *phy_find(struct device *dev, const char *con_id)
>> +{
>> +       const char *dev_id = dev ? dev_name(dev) : NULL;
>> +       int match, best_found = 0, best_possible = 0;
>> +       struct phy *phy = ERR_PTR(-ENODEV);
>> +       struct phy_lookup *p, *pl = NULL;
>> +
>> +       if (dev_id)
>> +               best_possible += 2;
>> +       if (con_id)
>> +               best_possible += 1;
>> +
>> +       list_for_each_entry(p, &phys, node) {
>> +               match = 0;
>> +               if (p->dev_id) {
>> +                       if (!dev_id || strcmp(p->dev_id, dev_id))
>> +                               continue;
>> +                       match += 2;
>> +               }
>> +               if (p->con_id) {
>> +                       if (!con_id || strcmp(p->con_id, con_id))
>> +                               continue;
>> +                       match += 1;
>> +               }
>> +
>> +               if (match > best_found) {
>> +                       pl = p;
>> +                       if (match != best_possible)
>> +                               best_found = match;
>> +                       else
>> +                               break;
>> +               }
>> +       }
>> +
>> +       if (pl) {
>> +               struct class_dev_iter iter;
>> +               struct device *phy_dev;
>> +
>> +               class_dev_iter_init(&iter, phy_class, NULL, NULL);
>> +               while ((phy_dev = class_dev_iter_next(&iter))) {
> 
> We have the case with phy-exynos5-usbdrd driver, which registers two
> phys usb2-phy and usb3-phy
> both being used by xhci (after dwc3 creates a lookup table).
> 
> The phy_dev is coming same for both the PHYs, and that's the reason
> when i try to get
> "usb2-phy" and "usb3-phy" i end up getting only usb2-phy.
> This is happening with V4 of this patch; V3 seems fine. The only
> differnece i see is
> we are creating the phy_lookup_table using phy_dev->parent.
> 
> Is there something that i am missing ?

looks like a genuine problem.
> 
>> +                       if (!strcmp(dev_name(phy_dev->parent), pl->phy_name)) {

here there are two phys which has the same parent and the first one that
matches will be returned. Hence you always get "usb2-phy".

IIUC just with device names of parent, we won't be able to get the PHY. We need
another 'variable' to differentiate it's children. Or have *phy* pointer
directly in the lookup table like how clk driver does?

Thanks
Kishon
>> +                               phy = to_phy(phy_dev);
>> +                               break;
>> +                       }
>> +               }
>> +               class_dev_iter_exit(&iter);
>> +       }
>> +
>> +       /* fall-back to the old lookup method for now */
>> +       if (IS_ERR(phy))
>> +               phy = phy_lookup(dev, con_id);
>> +       return phy;
>> +}
>> +
>>  static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
>>  {
>>         struct phy_provider *phy_provider;
>> @@ -463,7 +596,7 @@ struct phy *phy_get(struct device *dev, const char *string)
>>                         string);
>>                 phy = _of_phy_get(dev->of_node, index);
>>         } else {
>> -               phy = phy_lookup(dev, string);
>> +               phy = phy_find(dev, string);
>>         }
>>         if (IS_ERR(phy))
>>                 return phy;
>> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
>> index 9fda683..2696b95 100644
>> --- a/include/linux/phy/phy.h
>> +++ b/include/linux/phy/phy.h
>> @@ -110,6 +110,20 @@ struct phy_init_data {
>>         .port           = _port,                                \
>>  }
>>
>> +struct phy_lookup {
>> +       struct list_head node;
>> +       const char *phy_name;
>> +       const char *dev_id;
>> +       const char *con_id;
>> +};
>> +
>> +#define PHY_LOOKUP(a, b, c)    \
>> +       {                               \
>> +               .phy_name = a,          \
>> +               .dev_id = b,            \
>> +               .con_id = c,            \
>> +       }
>> +
>>  #define        to_phy(a)       (container_of((a), struct phy, dev))
>>
>>  #define        of_phy_provider_register(dev, xlate)    \
>> @@ -174,6 +188,10 @@ struct phy_provider *__devm_of_phy_provider_register(struct device *dev,
>>  void of_phy_provider_unregister(struct phy_provider *phy_provider);
>>  void devm_of_phy_provider_unregister(struct device *dev,
>>         struct phy_provider *phy_provider);
>> +void phy_register_lookup(struct phy_lookup *pl);
>> +void phy_unregister_lookup(struct phy_lookup *pl);
>> +int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id);
>> +void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id);
>>  #else
>>  static inline int phy_pm_runtime_get(struct phy *phy)
>>  {
>> @@ -345,6 +363,15 @@ static inline void devm_of_phy_provider_unregister(struct device *dev,
>>         struct phy_provider *phy_provider)
>>  {
>>  }
>> +static inline void phy_register_lookup(struct phy_lookup *pl) { }
>> +static inline void phy_unregister_lookup(struct phy_lookup *pl) { }
>> +static inline int
>> +phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id)
>> +{
>> +       return 0;
>> +}
>> +static inline void phy_remove_lookup(struct phy *phy, const char *con_id,
>> +                                    const char *dev_id) { }
>>  #endif
>>
>>  #endif /* __DRIVERS_PHY_H */
>> --
>> 2.1.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
