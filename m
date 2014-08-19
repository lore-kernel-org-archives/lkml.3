Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaHSUw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:52:26 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:14569
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916AbaHSUwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:52:24 -0400
Message-ID: <53F3B8EA.6070609@freescale.com>
Date: Tue, 19 Aug 2014 15:51:54 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>, <linuxppc-release@linux.freescale.net>
Subject: Re: [RFC PATCH 2/4] drivers/bus: Freescale Management Complex (fsl-mc)
 bus driver
References: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com> <1408140794-25064-3-git-send-email-German.Rivera@freescale.com> <3344352.Av1d0tahxM@wuerfel>
In-Reply-To: <3344352.Av1d0tahxM@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: DM2PR04CA038.namprd04.prod.outlook.com (10.141.154.156) To
 DM2PR03MB334.namprd03.prod.outlook.com (10.141.54.19)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019006)(6049001)(6009001)(189002)(51704005)(199003)(377454003)(479174003)(164054003)(24454002)(99396002)(81342001)(81542001)(31966008)(65816999)(85852003)(107046002)(54356999)(87266999)(106356001)(95666004)(74502001)(4396001)(105586002)(110136001)(77096002)(83322001)(74662001)(42186005)(64706001)(101416001)(64126003)(76482001)(23746002)(79102001)(87976001)(47776003)(20776003)(21056001)(59896002)(46102001)(33656002)(80022001)(83506001)(36756003)(65806001)(102836001)(83072002)(50466002)(50986999)(80316001)(76176999)(77982001)(92726001)(92566001)(85306004)(65956001)(66066001)(86362001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB334;H:[10.214.85.151];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for your comments. My replies inline below.
Please let me know if there is anything else, before post a respin
of the patch series that addresses your comments.

Thanks,

German

On 08/16/2014 09:12 AM, Arnd Bergmann wrote:
> On Friday 15 August 2014 17:13:12 J. German Rivera wrote:
>> +struct fsl_mc_bus *fsl_mc_bus;
>> +EXPORT_SYMBOL(fsl_mc_bus);
>
> This does not look like something that should be exported.
> Or even better, kill this structure entirely and just pass around
> pointers to the fsl_mc_device so you can deal with multiple root
> instances.
>
Ok. I'll remove this global structure.

>> +static struct kmem_cache *mc_dev_cache;
>> +
>> +/**
>> + * fsl_mc_bus_match - device to driver matching callback
>> + * @dev: the MC object device structure to match against
>> + * @drv: the device driver to search for matching MC object device id
>> + * structures
>> + *
>> + * Returns 1 on success, 0 otherwise.
>> + */
>> +static int fsl_mc_bus_match(struct device *dev, struct device_driver *drv)
>> +{
>> +	const struct fsl_mc_device_match_id *id;
>> +	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
>> +	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(drv);
>> +	bool found = false;
>> +
>> +	if (WARN_ON(mc_dev->magic != FSL_MC_DEVICE_MAGIC))
>> +		goto out;
>> +	if (WARN_ON(mc_drv->magic != FSL_MC_DRIVER_MAGIC))
>> +		goto out;
>
> We normally don't do this magic number matching, just remove these
> and rely on the compile-time checks.
Ok. I'll remove all the magic fields and their checking.

>> +struct bus_type fsl_mc_bus_type = {
>> +	.name = "fsl-mc",
>> +	.match = fsl_mc_bus_match,
>> +	.uevent = fsl_mc_bus_uevent,
>> +	.drv_groups = NULL,
>> +	.dev_groups = NULL,
>> +	.bus_groups = NULL,
>> +	.pm = NULL,
>> +};
>> +EXPORT_SYMBOL(fsl_mc_bus_type);
>
> No need to assign NULL members.
>
Ok. I'll removed them.

> Does it need to be exported to drivers? How about making it
> EXPORT_SYMBOL_GPL if it does?
>
Yes it needs to be accessed by another driver that will come in
a later patch series. I'll change it to EXPORT_SYMBOL_GPL()

>> +static int dprc_parse_dt_node(struct platform_device *pdev,
>> +			      phys_addr_t *mc_portal_phys_addr,
>> +			      uint32_t *mc_portal_size)
>> +{
>> +	struct resource res;
>> +	struct device_node *pdev_of_node = pdev->dev.of_node;
>> +	int error = -EINVAL;
>> +
>> +	error = of_address_to_resource(pdev_of_node, 0, &res);
>> +	if (error < 0) {
>> +		FSL_MC_ERROR(&pdev->dev,
>> +			     "of_address_to_resource() failed for %s\n",
>> +			     pdev_of_node->full_name);
>> +		goto out;
>> +	}
>> +
>> +	*mc_portal_phys_addr = res.start;
>> +	*mc_portal_size = resource_size(&res);
>> +	error = 0;
>> +out:
>> +	return error;
>> +}
>
> Why not just call of_address_to_resource in the caller?
>
Done.

>> +/**
>> + * __fsl_mc_driver_register - registers a child device driver with the
>> + * MC bus
>> + *
>> + * This function is implicitly invoked from the registration function of
>> + * fsl_mc device drivers, which is generated by the
>> + * module_fsl_mc_driver() macro.
>> + */
>> +int __fsl_mc_driver_register(struct fsl_mc_driver *mc_driver,
>> +			     struct module *owner)
>> +{
>> +	struct fsl_mc_device *root_mc_dev;
>
> Here the root_mc_dev variable isn't really used for much.
>
Removed.

>> +static int fsl_mc_device_get_mmio_regions(struct fsl_mc_device *mc_dev,
>> +					  struct fsl_mc_device *container_dev)
>> +{
>> +	int i;
>> +	int error;
>> +	struct fsl_mc_device_region *regions;
>> +	struct dprc_obj_desc *obj_desc = &mc_dev->obj_desc;
>> +	struct device *parent_dev = mc_dev->dev.parent;
>> +
>> +	regions = kmalloc_array(obj_desc->region_count,
>> +				sizeof(regions[0]), GFP_KERNEL);
>
> Better use 'struct resource' for the resources than make your own type.
>
Ok, I will remove struct fsl_mc_device_region and use struct resource 
instead.

>> +		mc_dev->icid = container_dev->icid;
>> +		mc_dev->dma_mask = 0xffffffff;	/* 32bit */
>> +		mc_dev->dev.dma_mask = &mc_dev->dma_mask;
>
> Is 32-bit DMA a fundamental limit of the bus?
>
No, there is not 32-bit DMA limitation for this bus.
Also,this dma_mask field is not currently being used. So, I'll remove it.

>> +
>> +static const struct of_device_id fsl_mc_bus_match_table[] = {
>> +	{.compatible = "fsl,qoriq-mc",},
>> +	{},
>> +};
>
> Please add a binding documentation for this device in Documentation/device-tree/
>
Yes, this is being added in the 'ARM64: Add support for FSL's LS2085A 
SoC' patch series, already posted for review.

>> +#define FSL_MC_MAGIC(_a, _b, _c, _d) \
>> +	(((uint32_t)(_a) << 24) | \
>> +	((uint32_t)(_b) << 16) | \
>> +	((uint32_t)(_c) << 8)  | \
>> +	(uint32_t)(_d))
>
> Can be dropped once you remove all the magic number matching
>
Done.

>> +/**
>> + * struct fsl_mc_device_region - MC object device MMIO region
>> + * @addr: base physical address
>> + * @size: size of the region in bytes
>> + */
>> +struct fsl_mc_device_region {
>> +	phys_addr_t paddr;
>> +	uint32_t size;
>> +};
>
> Can be removed when you move to 'struct resource'
>
Done.

>> +/**
>> + * struct fsl_mc_device - MC object device object
>> + * @magic: marker to verify identity of this structure
>
> remove
>
Removed all 'magic' fields

>> + * @flags: MC object device flags
>> + * @icid: Isolation context ID for the device
>> + * @mc_handle: MC handle for the corresponding MC object opened
>> + * @mc_io: Pointer to MC IO object assigned to this device or
>> + * NULL if none.
>> + * @driver: Pointer to the MC object device driver for this device
>
> Use container_of(&this->dev.driver, ...) instead
>
Removed redundant driver field.

>> + * @container: Pointer to the DPRC device that contains this MC object device
>
> Why are there two devices for this? Should this just use dev->parent instead?
>
You are right. Removed the container field. We can get the parent DPRC 
of a given dev, from its dev.parent field.

>> + * @dev_node: Node in the container's child list
>
> Same here: just use the device model's list management instead if you can,
> or explain why this is needed.
>
We still need to keep a per-bus list of child devices (devices contained 
in a given DPRC object). Unless I'm missing something,
I think the device model's list management links together all the 
devices of the same bus type. We are trying to follow a similar approach 
to the pci_dev/pci_bus structs.

>> + * @obj_desc: MC description of the DPAA device
>> + * @num_regions: Number of MMIO regions for this MC object device
>
> Doesn't actually exist?
>
No. Removed.

>> +#define FSL_MC_ERROR(_dev, _fmt, ...) \
>> +	do {								\
>> +		if ((_dev) != NULL)					\
>> +			dev_err(_dev, "%s:" __stringify(__LINE__) " "   \
>> +				_fmt, __func__, ##__VA_ARGS__);		\
>> +		else							\
>> +			pr_err("%s:" __stringify(__LINE__) " " _fmt,	\
>> +			       __func__, ##__VA_ARGS__);		\
>> +	} while (0)
>
> just use dev_err() directly, it handles the !_dev case already
>
Done.

>> +/**
>> + * struct fsl_mc_bus - Management Complex (MC) bus object
>> + * @magic: marker to verify identity of this structure
>> + * @pdev: platform device for this MC bus object
>> + * @root_mc_dev: pointer to root MC object device for this MC bus.
>> + */
>> +struct fsl_mc_bus {
>> +#	define FSL_MC_BUS_MAGIC   FSL_MC_MAGIC('L', 'B', 'U', 'S')
>> +	uint32_t magic;
>> +	struct platform_device *pdev;
>> +	struct fsl_mc_device *root_mc_dev;
>> +};
>
> pdev should be root_mc_dev->dev->parent, and magic seems pointless, so
> no need for this structure at all.
>
Agreed. This is redundant. Removed.

>> +/**
>> + * struct fsl_mc_dprc - Data Path Resource Container (DPRC) object
>> + * @magic: marker to verify identity of this structure
>> + * @mc_dev: pointer to MC object device object for this DPRC
>> + * @mutex: mutex to serialize access to the container.
>> + * @child_device_count: have the count of devices in this DPRC
>> + * @child_list:	anchor node of list of child devices on this DPRC
>> + */
>> +struct fsl_mc_dprc {
>> +#	define FSL_MC_DPRC_MAGIC   FSL_MC_MAGIC('D', 'P', 'R', 'C')
>> +	uint32_t magic;
>> +	struct fsl_mc_device *mc_dev;
>> +	struct mutex mutex;	/* serializes access to fields below */
>> +	uint16_t child_device_count;	/* Count of devices in this DPRC */
>> +	struct list_head child_list;
>> +};
>
> It's not clear what this represents to me. mc_dev presumably already
> has a list of children, so why not just use a pointer to mc_dev
> and remove this structure entirely?
>
This structure represents the per-bus (per DPRC object) information.
It is kind of the equivalent to 'struct pci_bus' in the PCI world.
I have renamed this struct to 'struct fsl_mc_bus'.

> 	Arnd
>
