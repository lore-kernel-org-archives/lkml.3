Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaBXV5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:57:16 -0500
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:58735
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbaBXV5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:57:14 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Abhishek Gupta (LIS)" <abgupta@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH v3 2/4] vmbus: use resource for hyperv mmio region
Thread-Topic: [PATCH v3 2/4] vmbus: use resource for hyperv mmio region
Thread-Index: AQHPMWLJAhNImGLNiECvzWg8o4RRUZrE8nEQ
Date: Mon, 24 Feb 2014 21:57:10 +0000
Message-ID: <70b79a4fbac142cba05b5b67c602b435@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1393247831-5271-1-git-send-email-kraxel@redhat.com>
 <1393247831-5271-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393247831-5271-3-git-send-email-kraxel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [210.188.139.153]
x-forefront-prvs: 0132C558ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(13464003)(51704005)(377454003)(189002)(199002)(83072002)(56816005)(90146001)(83322001)(19580405001)(65816001)(80022001)(87936001)(74706001)(86362001)(93516002)(93136001)(85852003)(49866001)(47736001)(95416001)(74876001)(80976001)(2656002)(59766001)(76796001)(76576001)(87266001)(76786001)(77982001)(81342001)(81542001)(85306002)(66066001)(79102001)(50986001)(69226001)(4396001)(63696002)(47976001)(95666003)(56776001)(31966008)(47446002)(74366001)(81816001)(74316001)(53806001)(46102001)(54356001)(54316002)(81686001)(51856001)(76482001)(74662001)(19580395003)(74502001)(86612001)(94316002)(94946001)(92566001)(33646001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB224;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:210.188.139.153;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Monday, February 24, 2014 5:17 AM
> To: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; KY
> Srinivasan; Abhishek Gupta (LIS); Haiyang Zhang; jasowang@redhat.com;
> tomi.valkeinen@ti.com; devel@linuxdriverproject.org; Gerd Hoffmann
> Subject: [PATCH v3 2/4] vmbus: use resource for hyperv mmio region
> 
> Use a resource for the hyperv mmio region instead of start/size variables.
> Register the region properly so it shows up in /proc/iomem.
> 
Thanks Gerd.

K. Y
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/vmbus_drv.c | 16 ++++++++++------  include/linux/hyperv.h |  3
> +--
>  2 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c index
> 2352ae48..a14f603 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -43,10 +43,12 @@ static struct acpi_device  *hv_acpi_dev;  static struct
> tasklet_struct msg_dpc;  static struct completion probe_event;  static int irq;
> -u64 hyperv_mmio_start;
> -EXPORT_SYMBOL_GPL(hyperv_mmio_start);
> -u64 hyperv_mmio_size;
> -EXPORT_SYMBOL_GPL(hyperv_mmio_size);
> +
> +struct resource hyperv_mmio = {
> +	.name  = "hyperv mmio",
> +	.flags = IORESOURCE_MEM,
> +};
> +EXPORT_SYMBOL_GPL(hyperv_mmio);
> 
>  static int vmbus_exists(void)
>  {
> @@ -902,8 +904,8 @@ static acpi_status vmbus_walk_resources(struct
> acpi_resource *res, void *ctx)
>  		break;
> 
>  	case ACPI_RESOURCE_TYPE_ADDRESS64:
> -		hyperv_mmio_start = res->data.address64.minimum;
> -		hyperv_mmio_size = res->data.address64.address_length;
> +		hyperv_mmio.start = res->data.address64.minimum;
> +		hyperv_mmio.end = res->data.address64.maximum;
>  		break;
>  	}
> 
> @@ -933,6 +935,8 @@ static int vmbus_acpi_add(struct acpi_device *device)
> 
>  		if (ACPI_FAILURE(result))
>  			goto acpi_walk_err;
> +		if (hyperv_mmio.start && hyperv_mmio.end)
> +			request_resource(&iomem_resource,
> &hyperv_mmio);
>  	}
>  	ret_val = 0;
> 
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h index
> be3028f..c93e342 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1459,8 +1459,7 @@ int hv_vss_init(struct hv_util_service *);  void
> hv_vss_deinit(void);  void hv_vss_onchannelcallback(void *);
> 
> -extern u64 hyperv_mmio_start;
> -extern u64 hyperv_mmio_size;
> +extern struct resource hyperv_mmio;
> 
>  /*
>   * Negotiated version with the Host.
> --
> 1.8.3.1

