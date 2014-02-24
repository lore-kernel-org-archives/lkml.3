Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaBXWGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:06:22 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.30]:10310 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbaBXWGU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:06:20 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        KY Srinivasan <kys@microsoft.com>,
        "Abhishek Gupta (LIS)" <abgupta@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: RE: [PATCH v3 3/4] hyperv-fb: add support for generation 2 virtual
 machines.
Thread-Topic: [PATCH v3 3/4] hyperv-fb: add support for generation 2 virtual
 machines.
Thread-Index: AQHPMWLVc1lKKiqPlk29xbSH9RKJkprE9ZiA
Date: Mon, 24 Feb 2014 22:05:45 +0000
Message-ID: <a0771ab44e4c4743817de8c8f41a3437@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
References: <1393247831-5271-1-git-send-email-kraxel@redhat.com>
 <1393247831-5271-4-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393247831-5271-4-git-send-email-kraxel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51704005)(13464003)(164054003)(199002)(189002)(377454003)(31966008)(94946001)(85306002)(47736001)(86612001)(76482001)(50986001)(95416001)(47976001)(94316002)(56776001)(93516002)(74662001)(54316002)(81686001)(66066001)(80022001)(65816001)(76796001)(76786001)(50466002)(74366001)(74876001)(51856001)(95666003)(4396001)(74706001)(33646001)(77982001)(59766001)(54356001)(74502001)(19580395003)(44976005)(19580405001)(83322001)(80976001)(6806004)(81342001)(69226001)(63696002)(47776003)(20776003)(53806001)(79102001)(47446002)(81542001)(90146001)(56816005)(84676001)(46102001)(93136001)(46406003)(23726002)(87266001)(92566001)(81816001)(87936001)(83072002)(85852003)(2656002)(49866001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.microsoft.com;FPR:202C65FE.9FDFD8CC.52D52B43.86E4EA13.2049A;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0132C558ED
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Monday, February 24, 2014 8:17 AM
> To: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; KY Srinivasan;
> Abhishek Gupta (LIS); Haiyang Zhang; jasowang@redhat.com;
> tomi.valkeinen@ti.com; devel@linuxdriverproject.org; Gerd Hoffmann; Jean-
> Christophe Plagniol-Villard
> Subject: [PATCH v3 3/4] hyperv-fb: add support for generation 2 virtual
> machines.
> 
> UEFI-based generation 2 virtual machines support vmbus devices only.
> There is no pci bus.  Thus they use a different mechanism for the graphics
> framebuffer:  Instead of using the vga pci bar a chunk of memory muct be
> allocated from the hyperv mmio region declared using APCI.  This patch
> implements support for it.
> 
> Based on a patch by Haiyang Zhang <haiyangz@microsoft.com>
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/video/hyperv_fb.c | 86 +++++++++++++++++++++++++++++++++---------
> -----
>  1 file changed, 60 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c index
> 130708f..135d8cd 100644
> --- a/drivers/video/hyperv_fb.c
> +++ b/drivers/video/hyperv_fb.c
> @@ -42,6 +42,7 @@
>  #include <linux/completion.h>
>  #include <linux/fb.h>
>  #include <linux/pci.h>
> +#include <linux/efi.h>
> 
>  #include <linux/hyperv.h>
> 
> @@ -212,6 +213,7 @@ struct synthvid_msg {
> 
>  struct hvfb_par {
>  	struct fb_info *info;
> +	struct resource mem;
>  	bool fb_ready; /* fb device is ready */
>  	struct completion wait;
>  	u32 synthvid_version;
> @@ -460,13 +462,13 @@ static int synthvid_connect_vsp(struct hv_device
> *hdev)
>  		goto error;
>  	}
> 
> -	if (par->synthvid_version == SYNTHVID_VERSION_WIN7) {
> +	if (par->synthvid_version == SYNTHVID_VERSION_WIN7)
>  		screen_depth = SYNTHVID_DEPTH_WIN7;
> -		screen_fb_size = SYNTHVID_FB_SIZE_WIN7;
> -	} else {
> +	else
>  		screen_depth = SYNTHVID_DEPTH_WIN8;
> -		screen_fb_size = SYNTHVID_FB_SIZE_WIN8;
> -	}
> +
> +	screen_fb_size = hdev->channel->offermsg.offer.
> +				mmio_megabytes * 1024 * 1024;
> 
>  	return 0;
> 
> @@ -627,26 +629,46 @@ static void hvfb_get_option(struct fb_info *info)
>  /* Get framebuffer memory from Hyper-V video pci space */  static int
> hvfb_getmem(struct fb_info *info)  {
> -	struct pci_dev *pdev;
> -	ulong fb_phys;
> +	struct hvfb_par *par = info->par;
> +	struct pci_dev *pdev  = NULL;
>  	void __iomem *fb_virt;
> +	int gen2vm = efi_enabled(EFI_BOOT);
> +	int ret;
> 
> -	pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
> +	par->mem.name = "hyperv_fb";

Please use KBUILD_MODNAME, so that the naming is consistent.

Thanks,
- Haiyang

> +	par->mem.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> +	if (gen2vm) {
> +		ret = allocate_resource(&hyperv_mmio, &par->mem,
> +					screen_fb_size,
> +					0, -1,
> +					screen_fb_size,
> +					NULL, NULL);
> +		if (ret != 0) {
> +			pr_err("Unable to allocate framebuffer memory\n");
> +			return -ENODEV;
> +		}
> +	} else {
> +		pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
>  			      PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
> -	if (!pdev) {
> -		pr_err("Unable to find PCI Hyper-V video\n");
> -		return -ENODEV;
> -	}
> +		if (!pdev) {
> +			pr_err("Unable to find PCI Hyper-V video\n");
> +			return -ENODEV;
> +		}
> 
> -	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
> -	    pci_resource_len(pdev, 0) < screen_fb_size)
> -		goto err1;
> +		if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
> +		    pci_resource_len(pdev, 0) < screen_fb_size)
> +			goto err1;
> 
> -	fb_phys = pci_resource_end(pdev, 0) - screen_fb_size + 1;
> -	if (!request_mem_region(fb_phys, screen_fb_size,
> KBUILD_MODNAME))
> -		goto err1;
> +		par->mem.end = pci_resource_end(pdev, 0);
> +		par->mem.start = par->mem.end - screen_fb_size + 1;
> +		ret = request_resource(&pdev->resource[0], &par->mem);
> +		if (ret != 0) {
> +			pr_err("Unable to request framebuffer memory\n");
> +			goto err1;
> +		}
> +	}
> 
> -	fb_virt = ioremap(fb_phys, screen_fb_size);
> +	fb_virt = ioremap(par->mem.start, screen_fb_size);
>  	if (!fb_virt)
>  		goto err2;
> 
> @@ -654,30 +676,42 @@ static int hvfb_getmem(struct fb_info *info)
>  	if (!info->apertures)
>  		goto err3;
> 
> -	info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
> -	info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
> -	info->fix.smem_start = fb_phys;
> +	if (gen2vm) {
> +		info->apertures->ranges[0].base = screen_info.lfb_base;
> +		info->apertures->ranges[0].size = screen_info.lfb_size;
> +	} else {
> +		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
> +		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
> +	}
> +
> +	info->fix.smem_start = par->mem.start;
>  	info->fix.smem_len = screen_fb_size;
>  	info->screen_base = fb_virt;
>  	info->screen_size = screen_fb_size;
> 
> -	pci_dev_put(pdev);
> +	if (!gen2vm)
> +		pci_dev_put(pdev);
> +
>  	return 0;
> 
>  err3:
>  	iounmap(fb_virt);
>  err2:
> -	release_mem_region(fb_phys, screen_fb_size);
> +	release_resource(&par->mem);
>  err1:
> -	pci_dev_put(pdev);
> +	if (!gen2vm)
> +		pci_dev_put(pdev);
> +
>  	return -ENOMEM;
>  }
> 
>  /* Release the framebuffer */
>  static void hvfb_putmem(struct fb_info *info)  {
> +	struct hvfb_par *par = info->par;
> +
>  	iounmap(info->screen_base);
> -	release_mem_region(info->fix.smem_start, screen_fb_size);
> +	release_resource(&par->mem);
>  }
> 
> 
> --
> 1.8.3.1

