Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaJBQgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:36:52 -0400
Received: from mail-by2on0148.outbound.protection.outlook.com ([207.46.100.148]:57984
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751056AbaJBQgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:36:49 -0400
Message-ID: <542D7F16.4000304@freescale.com>
Date: Thu, 2 Oct 2014 11:36:38 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Timur Tabi <timur@tabi.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>,
        Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 3/3 v2] drivers/bus: Device driver for FSL-MC DPRC devices
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>	<1411166981-3610-4-git-send-email-German.Rivera@freescale.com> <CAOZdJXWqpPypHg1iw7Tg-d=2g=+qnHh-=BK_9_yJKzpooe0+YQ@mail.gmail.com>
In-Reply-To: <CAOZdJXWqpPypHg1iw7Tg-d=2g=+qnHh-=BK_9_yJKzpooe0+YQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.49]
X-ClientProxiedBy: BY2PR04CA029.namprd04.prod.outlook.com (10.141.249.147) To
 DM2PR03MB335.namprd03.prod.outlook.com (10.141.54.20)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB335;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(199003)(479174003)(55674003)(377454003)(51704005)(189002)(164054003)(52314003)(24454002)(19580405001)(21056001)(65816999)(85852003)(66066001)(31966008)(80316001)(19580395003)(105586002)(54356999)(50986999)(87266999)(76176999)(95666004)(106356001)(99396003)(77096002)(10300001)(97736003)(4396001)(23676002)(65956001)(76482002)(42186005)(50466002)(107046002)(47776003)(64706001)(20776003)(102836001)(87976001)(80022003)(101416001)(120916001)(46102003)(33656002)(64126003)(110136001)(65806001)(86362001)(85306004)(92566001)(36756003)(59896002)(83506001)(92726001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB335;H:[10.214.87.140];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/30/2014 09:19 PM, Timur Tabi wrote:
> On Fri, Sep 19, 2014 at 5:49 PM, J. German Rivera
> <German.Rivera@freescale.com> wrote:
>
>> +static int __fsl_mc_device_remove(struct device *dev, void *data)
>> +{
>> +       WARN_ON(dev == NULL);
>> +       WARN_ON(data != NULL);
>
> I see a lot of direct comparisons with NULL and 0.  You don't need to
> be so explicit:
>
> WARN_ON(!dev);
> WARN_ON(!data);
>
> "!= 0" and "!= NULL" is almost always unnecessary, and you can delete them.
>
I know that this is not necessary from the point of view of C boolean 
semantics, but doing explicit comparison improves readability IMHO. 
Anyway, this is subjective and largely a matter of preference.
Besides, "Documentation/CodingStyle" does not seem to advocate one way 
or the other.
Also, I there is evidence that explicit comparisons are allowed in
the kernel source tree:

$  git grep '== NULL' | wc -l
22173
$  git grep '!= NULL' | wc -l
9987
$  git grep '!= 0' | wc -l
22993
$  git grep '== 0' | wc -l
46060

So, unless Greg Kroah-Hartman or Arnd Bergmann feel strongly that I need 
to make this change, I will not make it.

>
>> +       fsl_mc_device_remove(to_fsl_mc_device(dev));
>> +       return 0;
>> +}
>> +
>> +/**
>> + * dprc_remove_devices - Removes devices for objects removed from a DPRC
>> + *
>> + * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
>> + * @obj_desc_array: array of object descriptors for child objects currently
>> + * present in the DPRC in the MC.
>> + * @num_child_objects_in_mc: number of entries in obj_desc_array
>> + *
>> + * Synchronizes the state of the Linux bus driver with the actual state of
>> + * the MC by removing devices that represent MC objects that have
>> + * been dynamically removed in the physical DPRC.
>> + */
>> +static void dprc_remove_devices(struct fsl_mc_device *mc_bus_dev,
>> +                               struct dprc_obj_desc *obj_desc_array,
>> +                               int num_child_objects_in_mc)
>> +{
>> +       if (num_child_objects_in_mc != 0) {
>
> Like here.  Just do "if (num_child_objects_in_mc) {"
>
>> +               /*
>> +                * Remove child objects that are in the DPRC in Linux,
>> +                * but not in the MC:
>> +                */
>> +               struct dprc_child_objs objs;
>> +
>> +               objs.child_count = num_child_objects_in_mc;
>> +               objs.child_array = obj_desc_array;
>> +               device_for_each_child(&mc_bus_dev->dev, &objs,
>> +                                     __fsl_mc_device_remove_if_not_in_mc);
>> +       } else {
>> +               /*
>> +                * There are no child objects for this DPRC in the MC.
>> +                * So, remove all the child devices from Linux:
>> +                */
>> +               device_for_each_child(&mc_bus_dev->dev, NULL,
>> +                                     __fsl_mc_device_remove);
>> +       }
>> +}
>> +
>> +static int __fsl_mc_device_match(struct device *dev, void *data)
>> +{
>> +       struct dprc_obj_desc *obj_desc = data;
>> +       struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
>> +
>> +       return FSL_MC_DEVICE_MATCH(mc_dev, obj_desc);
>> +}
>> +
>> +static struct fsl_mc_device *fsl_mc_device_lookup(struct dprc_obj_desc
>> +                                                               *obj_desc,
>> +                                                 struct fsl_mc_device
>> +                                                               *mc_bus_dev)
>> +{
>> +       struct device *dev;
>> +
>> +       dev = device_find_child(&mc_bus_dev->dev, obj_desc,
>> +                               __fsl_mc_device_match);
>> +
>> +       return (dev != NULL) ? to_fsl_mc_device(dev) : NULL;
>
> return dev ? to_fsl_mc_device(dev) : NULL;
>
>> +}
>> +
>> +/**
>> + * dprc_add_new_devices - Adds devices to the logical bus for a DPRC
>> + *
>> + * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
>> + * @obj_desc_array: array of device descriptors for child devices currently
>> + * present in the physical DPRC.
>> + * @num_child_objects_in_mc: number of entries in obj_desc_array
>> + *
>> + * Synchronizes the state of the Linux bus driver with the actual
>> + * state of the MC by adding objects that have been newly discovered
>> + * in the physical DPRC.
>> + */
>> +static void dprc_add_new_devices(struct fsl_mc_device *mc_bus_dev,
>> +                                struct dprc_obj_desc *obj_desc_array,
>> +                                int num_child_objects_in_mc)
>> +{
>> +       int error;
>> +       int i;
>> +
>> +       for (i = 0; i < num_child_objects_in_mc; i++) {
>> +               struct dprc_region_desc region_desc;
>> +               struct fsl_mc_device *child_dev;
>> +               struct fsl_mc_io *mc_io = NULL;
>> +               struct dprc_obj_desc *obj_desc = &obj_desc_array[i];
>> +
>> +               if (strlen(obj_desc->type) == 0)
>> +                       continue;
>> +               /*
>> +                * Check if device is already known to Linux:
>> +                */
>> +               child_dev = fsl_mc_device_lookup(obj_desc, mc_bus_dev);
>> +               if (child_dev != NULL)
>> +                       continue;
>> +
>> +               if (strcmp(obj_desc->type, "dprc") == 0) {
>
> As for the !=0 thing, I make an exception for strcmp(), however, since
> its meaning is not intuitive.
>
>> +                       /*
>> +                        * Get the MC portal physical address for the device
>> +                        * (specified in the device's first MMIO region):
>> +                        */
>> +                       if (WARN_ON(obj_desc->region_count == 0))
>> +                               continue;
>> +
>> +                       error = dprc_get_obj_region(mc_bus_dev->mc_io,
>> +                                                   mc_bus_dev->mc_handle,
>> +                                                   obj_desc->type,
>> +                                                   obj_desc->id,
>> +                                                   0, &region_desc);
>> +                       if (error < 0) {
>> +                               dev_err(&mc_bus_dev->dev,
>> +                                       "dprc_get_obj_region() failed: %d\n",
>> +                                       error);
>> +                               continue;
>> +                       }
>> +
>> +                       if (region_desc.size !=
>> +                                       mc_bus_dev->mc_io->portal_size) {
>> +                               error = -EINVAL;
>> +                               dev_err(&mc_bus_dev->dev,
>> +                                       "Invalid MC portal size: %u\n",
>> +                                       region_desc.size);
>> +                               continue;
>> +                       }
>> +
>> +                       error = fsl_create_mc_io(&mc_bus_dev->dev,
>> +                                                region_desc.base_paddr,
>> +                                                region_desc.size, 0, &mc_io);
>> +                       if (error < 0)
>> +                               continue;
>> +               }
>> +
>> +               error = fsl_mc_device_add(obj_desc, mc_io, &mc_bus_dev->dev,
>> +                                         &child_dev);
>> +               if (error < 0) {
>> +                       if (mc_io != NULL)
>> +                               fsl_destroy_mc_io(mc_io);
>> +
>> +                       continue;
>> +               }
>> +       }
>> +}
>> +
>> +/**
>> + * dprc_scan_objects - Discover objects in a DPRC
>> + *
>> + * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
>> + *
>> + * Detects objects added and removed from a DPRC and synchronizes the
>> + * state of the Linux bus driver, MC by adding and removing
>> + * devices accordingly.
>> + */
>> +int dprc_scan_objects(struct fsl_mc_device *mc_bus_dev)
>> +{
>> +       int num_child_objects;
>> +       int dprc_get_obj_failures;
>> +       int error = -EINVAL;
>> +       struct dprc_obj_desc *child_obj_desc_array = NULL;
>> +
>> +       error = dprc_get_obj_count(mc_bus_dev->mc_io,
>> +                                  mc_bus_dev->mc_handle,
>> +                                  &num_child_objects);
>> +       if (error < 0) {
>> +               dev_err(&mc_bus_dev->dev, "dprc_get_obj_count() failed: %d\n",
>> +                       error);
>> +               goto out;
>> +       }
>> +
>> +       if (num_child_objects != 0) {
>> +               int i;
>> +
>> +               child_obj_desc_array =
>> +                   devm_kmalloc_array(&mc_bus_dev->dev, num_child_objects,
>> +                                      sizeof(*child_obj_desc_array),
>> +                                      GFP_KERNEL);
>> +               if (child_obj_desc_array == NULL) {
>> +                       error = -ENOMEM;
>> +                       dev_err(&mc_bus_dev->dev,
>> +                               "No memory to allocate obj_desc array\n");
>> +                       goto out;
>> +               }
>> +
>> +               /*
>> +                * Discover objects currently present in the physical DPRC:
>> +                */
>> +               dprc_get_obj_failures = 0;
>> +               for (i = 0; i < num_child_objects; i++) {
>> +                       struct dprc_obj_desc *obj_desc =
>> +                           &child_obj_desc_array[i];
>> +
>> +                       error = dprc_get_obj(mc_bus_dev->mc_io,
>> +                                            mc_bus_dev->mc_handle,
>> +                                            i, obj_desc);
>> +                       if (error < 0) {
>> +                               dev_err(&mc_bus_dev->dev,
>> +                                       "dprc_get_obj(i=%d) failed: %d\n",
>> +                                       i, error);
>> +                               /*
>> +                                * Mark the obj entry as "invalid", by using the
>> +                                * empty string as obj type:
>> +                                */
>> +                               obj_desc->type[0] = '\0';
>> +                               obj_desc->id = error;
>> +                               dprc_get_obj_failures++;
>> +                               continue;
>> +                       }
>> +
>> +                       dev_info(&mc_bus_dev->dev,
>> +                                "Discovered object: type %s, id %d\n",
>> +                                obj_desc->type, obj_desc->id);
>> +               }
>> +
>> +               if (dprc_get_obj_failures != 0) {
>> +                       dev_err(&mc_bus_dev->dev,
>> +                               "%d out of %d devices could not be retrieved\n",
>> +                               dprc_get_obj_failures, num_child_objects);
>> +               }
>> +       }
>> +
>> +       dprc_remove_devices(mc_bus_dev, child_obj_desc_array,
>> +                           num_child_objects);
>> +
>> +       dprc_add_new_devices(mc_bus_dev, child_obj_desc_array,
>> +                            num_child_objects);
>> +
>> +       error = 0;
>> +out:
>> +       if (child_obj_desc_array != NULL)
>> +               devm_kfree(&mc_bus_dev->dev, child_obj_desc_array);
>
> The whole point behind the devm_ functions is that you shoudn't need
> to manually release the resources.
>
Yes, but wouldn't the implicit/automatic freeing only happens when the 
device itself is removed?

The function above may get invoked many times before the device gets 
removed. So, we would just keep accumulating wasted memory in the meantime.

>> +
>> +       return error;
>> +}
>> +EXPORT_SYMBOL_GPL(dprc_scan_objects);
>> +
>> +/**
>> + * dprc_scan_container - Scans a physical DPRC and synchronizes Linux bus state
>> + *
>> + * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
>> + *
>> + * Scans the physical DPRC and synchronizes the state of the Linux
>> + * bus driver with the actual state of the MC by adding and removing
>> + * devices as appropriate.
>> + */
>> +int dprc_scan_container(struct fsl_mc_device *mc_bus_dev)
>> +{
>> +       int error = -EINVAL;
>> +
>> +       error = dprc_scan_objects(mc_bus_dev);
>> +       if (error < 0)
>> +               goto error;
>> +
>> +       return 0;
>> +error:
>> +       return error;
>> +}
>
> This is silly.
>
> int dprc_scan_container(struct fsl_mc_device *mc_bus_dev)
> {
>        return dprc_scan_objects(mc_bus_dev);
> }
>
Agreed. I'll simplify this.
>
>> +EXPORT_SYMBOL_GPL(dprc_scan_container);
>> +
>> +/**
>> + * dprc_probe - callback invoked when a DPRC is being bound to this driver
>> + *
>> + * @mc_dev: Pointer to fsl-mc device representing a DPRC
>> + *
>> + * It opens the physical DPRC in the MC.
>> + * It scans the DPRC to discover the MC objects contained in it.
>> + */
>> +static int dprc_probe(struct fsl_mc_device *mc_dev)
>> +{
>> +       int error = -EINVAL;
>> +       bool dprc_opened = false;
>> +
>> +       if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
>> +               goto error;
>
> Just 'return' here.   And if you're creative, I think you can get rid
> of dprc_opened.  You can have multiple exit labels for gotos.  Try to
> avoid using booleans to tell you at the end of the function whether
> you succeeded.  That's not how kernel code is normally written.
>
OK, I will make this change.
>> +
>> +       error = dprc_open(mc_dev->mc_io, mc_dev->obj_desc.id,
>> +                         &mc_dev->mc_handle);
>> +       if (error < 0) {
>> +               dev_err(&mc_dev->dev, "dprc_open() failed: %d\n", error);
>> +               goto error;
>> +       }
>> +
>> +       dprc_opened = true;
>> +       error = dprc_scan_container(mc_dev);
>> +       if (error < 0)
>> +               goto error;
>> +
>> +       dev_info(&mc_dev->dev, "DPRC device bound to driver");
>> +       return 0;
>> +error:
>> +       if (dprc_opened)
>> +               (void)dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
>> +
>> +       return error;
>> +}
>> +
>> +/**
>> + * dprc_remove - callback invoked when a DPRC is being unbound from this driver
>> + *
>> + * @mc_dev: Pointer to fsl-mc device representing the DPRC
>> + *
>> + * It removes the DPRC's child objects from Linux (not from the MC) and
>> + * closes the DPRC device in the MC.
>> + */
>> +static int dprc_remove(struct fsl_mc_device *mc_dev)
>> +{
>> +       int error = -EINVAL;
>> +
>> +       if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
>> +               goto error;
>> +       if (WARN_ON(mc_dev->mc_io == NULL))
>> +               goto error;
>> +
>> +       device_for_each_child(&mc_dev->dev, NULL, __fsl_mc_device_remove);
>> +       error = dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
>> +       if (error < 0)
>> +               dev_err(&mc_dev->dev, "dprc_close() failed: %d\n", error);
>> +
>> +       dev_info(&mc_dev->dev, "DPRC device unbound from driver");
>> +       return 0;
>> +error:
>> +       return error;
>> +}
>
> Try this:
>
> static int dprc_remove(struct fsl_mc_device *mc_dev)
> {
>         int error;
>
>         if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
>                 return -EINVAL;
>
>         if (WARN_ON(mc_dev->mc_io == NULL))
>                 return -EINVAL;
>
>         device_for_each_child(&mc_dev->dev, NULL, __fsl_mc_device_remove);
>
>         error = dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
>         if (error < 0) {
>                 dev_err(&mc_dev->dev, "dprc_close() failed: %d\n", error);
>                 return error;
>         }
>
>         dev_dbg(&mc_dev->dev, "DPRC device unbound from driver");
>         return 0;
> }
>
OK, I will make this change, as there is no common cleanup to do in this 
case.
>
>> +
>> +static const struct fsl_mc_device_match_id match_id_table[] = {
>> +       {
>> +        .vendor = FSL_MC_VENDOR_FREESCALE,
>> +        .obj_type = "dprc",
>> +        .ver_major = DPRC_VER_MAJOR,
>> +        .ver_minor = DPRC_VER_MINOR},
>> +       {.vendor = 0x0},
>> +};
>> +
>> +static struct fsl_mc_driver dprc_driver = {
>> +       .driver = {
>> +                  .name = FSL_MC_DPRC_DRIVER_NAME,
>> +                  .owner = THIS_MODULE,
>> +                  .pm = NULL,
>> +                  },
>> +       .match_id_table = match_id_table,
>> +       .probe = dprc_probe,
>> +       .remove = dprc_remove,
>> +};
>> +
>> +int __init dprc_driver_init(void)
>> +{
>> +       return fsl_mc_driver_register(&dprc_driver);
>> +}
>> +
>> +void __exit dprc_driver_exit(void)
>> +{
>> +       fsl_mc_driver_unregister(&dprc_driver);
>> +}
>> diff --git a/include/linux/fsl_mc_private.h b/include/linux/fsl_mc_private.h
>> index 3ff3f2b..52721f7 100644
>> --- a/include/linux/fsl_mc_private.h
>> +++ b/include/linux/fsl_mc_private.h
>> @@ -15,6 +15,8 @@
>>   #include <linux/mutex.h>
>>   #include <linux/stringify.h>
>>
>> +#define FSL_MC_DPRC_DRIVER_NAME    "fsl_mc_dprc"
>> +
>>   #define FSL_MC_DEVICE_MATCH(_mc_dev, _obj_desc) \
>>          (strcmp((_mc_dev)->obj_desc.type, (_obj_desc)->type) == 0 && \
>>           (_mc_dev)->obj_desc.id == (_obj_desc)->id)
>> @@ -30,4 +32,12 @@ int __must_check fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
>>
>>   void fsl_mc_device_remove(struct fsl_mc_device *mc_dev);
>>
>> +int __must_check dprc_scan_container(struct fsl_mc_device *mc_bus_dev);
>> +
>> +int __must_check dprc_scan_objects(struct fsl_mc_device *mc_bus_dev);
>
> __must_check?  Really?
Yes, to ensure that callers that are not checking the return code from 
dprc_scan_objects() are caught at compile-time (CHECK time).

Thanks,

German
>
