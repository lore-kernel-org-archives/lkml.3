Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbbATVIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:08:53 -0500
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:48000
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752289AbbATVIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:08:51 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Jake Oshins <jakeo@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: Jake Oshins <jakeo@microsoft.com>
Subject: RE: [PATCH 1/1] drivers:hv:vmbus Allow for more than one MMIO range
 for children.
Thread-Topic: [PATCH 1/1] drivers:hv:vmbus Allow for more than one MMIO range
 for children.
Thread-Index: AQHQNPJGpSAYl2A1tEq4jEWvsC2sjJzJfiXw
Date: Tue, 20 Jan 2015 21:08:46 +0000
Message-ID: <BY2PR0301MB071168CE194C74BFE98366A7A04B0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <y> <1421791180-18810-1-git-send-email-jakeo@microsoft.com>
In-Reply-To: <1421791180-18810-1-git-send-email-jakeo@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.176]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN3PR0301MB1219;UriScan:;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1219;
x-forefront-prvs: 0462918D61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(13464003)(377454003)(189002)(97736003)(2950100001)(2900100001)(76176999)(50986999)(68736005)(54356999)(102836002)(46102003)(54206007)(1511001)(74316001)(2656002)(87936001)(2501002)(66066001)(2561002)(122556002)(54606007)(2201001)(76576001)(106356001)(33656002)(2421001)(105586002)(106116001)(64706001)(19580405001)(19580395003)(92566002)(40100003)(99286002)(86362001)(62966003)(77156002)(101416001)(86612001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1219;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2015 21:08:46.7098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1219
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB0852;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jake Oshins [mailto:jakeo@microsoft.com]
> Sent: Tuesday, January 20, 2015 2:00 PM
> To: gregkh@linuxfoundation.org; KY Srinivasan; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; vkuznets@redhat.com
> Cc: Jake Oshins
> Subject: [PATCH 1/1] drivers:hv:vmbus Allow for more than one MMIO range
> for children.

Include a descriptive commit log for this patch.
> 
> Signed-off-by: Jake Oshins <jakeo@microsoft.com>
> ---
>  drivers/hv/vmbus_drv.c          | 85
> +++++++++++++++++++++++++++++++++--------
>  drivers/video/fbdev/hyperv_fb.c |  2 +-
>  include/linux/hyperv.h          |  2 +-
>  3 files changed, 72 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c index
> 4d6b269..ba5b7a1 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -43,10 +43,7 @@ static struct tasklet_struct msg_dpc;  static struct
> completion probe_event;  static int irq;
> 
> -struct resource hyperv_mmio = {
> -	.name  = "hyperv mmio",
> -	.flags = IORESOURCE_MEM,
> -};
> +struct resource *hyperv_mmio;
>  EXPORT_SYMBOL_GPL(hyperv_mmio);
> 
>  static int vmbus_exists(void)
> @@ -849,23 +846,74 @@ void vmbus_device_unregister(struct hv_device
> *device_obj)
> 
> 
>  /*
> - * VMBUS is an acpi enumerated device. Get the the information we
> - * need from DSDT.
> + * VMBUS is an acpi enumerated device. Get the
> + * information we need from DSDT.
>   */
> 
>  static acpi_status vmbus_walk_resources(struct acpi_resource *res, void
> *ctx)  {
> +	resource_size_t start = 0;
> +	resource_size_t end = 0;
> +	struct resource *new_res;
> +	struct resource **old_res = &hyperv_mmio;
> +
>  	switch (res->type) {
>  	case ACPI_RESOURCE_TYPE_IRQ:
>  		irq = res->data.irq.interrupts[0];
> +		return AE_OK;
> +
> +	/*
> +	 * "Address" descriptors are for bus windows. Ignore
> +	 * "memory" descriptors, which are for registers on
> +	 * devices.
> +	 */
> +	case ACPI_RESOURCE_TYPE_ADDRESS32:
> +		start = res->data.address32.minimum;
> +		end = res->data.address32.maximum;
>  		break;
> 
>  	case ACPI_RESOURCE_TYPE_ADDRESS64:
> -		hyperv_mmio.start = res->data.address64.minimum;
> -		hyperv_mmio.end = res->data.address64.maximum;
> +		start = res->data.address64.minimum;
> +		end = res->data.address64.maximum;
>  		break;
> +
> +	default:
> +		/* Unused resource type */
> +		return AE_OK;
>  	}
> 
> +	/*
> +	 * Ignore ranges that are below 1MB, as they're not
> +	 * necessary or useful here.
> +	 */
> +	if (end < 0x100000)
> +		return AE_OK;
> +
> +	new_res = kzalloc(sizeof(*new_res), GFP_ATOMIC);
> +	if (!new_res)
> +		return AE_NO_MEMORY;
> +
> +	new_res->name = "hyperv mmio";
> +	new_res->flags = IORESOURCE_MEM;
> +	new_res->start = start;
> +	new_res->end = end;
> +
> +	do {
> +		if (!*old_res) {
> +			*old_res = new_res;
> +			break;
> +		}
> +
> +		if ((*old_res)->start > new_res->end) {
> +			new_res->sibling = *old_res;
> +			*old_res = new_res;
> +			break;
> +		}
> +
> +		old_res = &(*old_res)->sibling;
> +
> +	} while (1);
> +
>  	return AE_OK;
>  }
> 
> @@ -873,6 +921,7 @@ static int vmbus_acpi_add(struct acpi_device *device)
> {
>  	acpi_status result;
>  	int ret_val = -ENODEV;
> +	struct acpi_device *ancestor;
> 
>  	hv_acpi_dev = device;
> 
> @@ -882,18 +931,22 @@ static int vmbus_acpi_add(struct acpi_device
> *device)
>  	if (ACPI_FAILURE(result))
>  		goto acpi_walk_err;
>  	/*
> -	 * The parent of the vmbus acpi device (Gen2 firmware) is the VMOD
> that
> -	 * has the mmio ranges. Get that.
> +	 * Some ancestor of the vmbus acpi device (Gen1 or Gen2
> +	 * firmware) is the VMOD that has the mmio ranges. Get that.
>  	 */
> -	if (device->parent) {
> -		result = acpi_walk_resources(device->parent->handle,
> +	for (ancestor = device->parent;
> +		ancestor;
> +		ancestor = ancestor->parent) {
> +		result = acpi_walk_resources(ancestor->handle,
>  					METHOD_NAME__CRS,
>  					vmbus_walk_resources, NULL);
> 
>  		if (ACPI_FAILURE(result))
> -			goto acpi_walk_err;
> -		if (hyperv_mmio.start && hyperv_mmio.end)
> -			request_resource(&iomem_resource,
> &hyperv_mmio);
> +			continue;
> +		if (hyperv_mmio) {
> +			request_resource(&iomem_resource,
> hyperv_mmio);
> +			break;
> +		}
>  	}
>  	ret_val = 0;
> 
If we have a failure in walking the ACPI resources, you are not rolling back the
State with regards to the memory you allocated for the resource structure and the
resource you have requested.
 
> @@ -962,6 +1015,8 @@ static void __exit vmbus_exit(void)
>  	hv_remove_vmbus_irq();
>  	vmbus_free_channels();
>  	bus_unregister(&hv_bus);
> +	if (hyperv_mmio)
> +		release_resource(hyperv_mmio);

You are leaking memory here; you have not freed up the resource structures
that you allocated earlier.

 
>  	hv_cleanup();
>  	acpi_bus_unregister_driver(&vmbus_acpi_driver);
>  }
> diff --git a/drivers/video/fbdev/hyperv_fb.c
> b/drivers/video/fbdev/hyperv_fb.c index 4254336..003c8f0 100644
> --- a/drivers/video/fbdev/hyperv_fb.c
> +++ b/drivers/video/fbdev/hyperv_fb.c
> @@ -686,7 +686,7 @@ static int hvfb_getmem(struct fb_info *info)
>  	par->mem.name = KBUILD_MODNAME;
>  	par->mem.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
>  	if (gen2vm) {
> -		ret = allocate_resource(&hyperv_mmio, &par->mem,
> +		ret = allocate_resource(hyperv_mmio, &par->mem,
>  					screen_fb_size,
>  					0, -1,
>  					screen_fb_size,
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h index
> 476c685..8903689 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1178,7 +1178,7 @@ int hv_vss_init(struct hv_util_service *);  void
> hv_vss_deinit(void);  void hv_vss_onchannelcallback(void *);
> 
> -extern struct resource hyperv_mmio;
> +extern struct resource *hyperv_mmio;
> 
>  /*
>   * Negotiated version with the Host.
> --
> 1.9.1

