Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3JBO3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:29:34 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:6932
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab3JBO3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:29:31 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] hyperv-fb: add pci stub
Thread-Topic: [PATCH 1/2] hyperv-fb: add pci stub
Thread-Index: AQHOv2bVQASfGfm0ykyTRCW4KfZb6JnheAxg
Date: Wed, 2 Oct 2013 14:29:28 +0000
Message-ID: <465ef0cb45e04bcc94c4788c0d930c4d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
In-Reply-To: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 0987ACA2E2
x-forefront-antispam-report: SFV:NSPM;SFS:(52604005)(51704005)(377454003)(13464003)(189002)(199002)(76786001)(76796001)(83072001)(76576001)(33646001)(74366001)(77096001)(56816003)(31966008)(19580395003)(74662001)(54356001)(74876001)(74502001)(47446002)(80976001)(74706001)(65816001)(53806001)(4396001)(59766001)(77982001)(80022001)(66066001)(81816001)(81342001)(81542001)(81686001)(76482001)(56776001)(54316002)(46102001)(79102001)(51856001)(63696002)(47976001)(49866001)(47736001)(83322001)(19580405001)(50986001)(69226001)(74316001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Wednesday, October 02, 2013 4:55 AM
> Cc: Gerd Hoffmann; KY Srinivasan; Haiyang Zhang; Jean-Christophe Plagniol-
> Villard; Tomi Valkeinen; open list:Hyper-V CORE AND...; open list:FRAMEBUFFER
> LAYER; open list
> Subject: [PATCH 1/2] hyperv-fb: add pci stub
> 
> This patch adds a pci stub driver to hyper-fb.  The hyperv framebuffer
> driver will bind to the pci device then, so linux kernel and userspace
> know there is a proper kernel driver for the device active.  lspci shows
> this for example:
> 
> [root@dhcp231 ~]# lspci -vs8
> 00:08.0 VGA compatible controller: Microsoft Corporation Hyper-V virtual
> VGA (prog-if 00 [VGA controller])
>         Flags: bus master, fast devsel, latency 0, IRQ 11
>         Memory at f8000000 (32-bit, non-prefetchable) [size=64M]
>         Expansion ROM at <unassigned> [disabled]
>         Kernel driver in use: hyperv_fb
> 
> Another effect is that the xorg vesa driver will not attach to the
> device and thus the Xorg server will automatically use the fbdev
> driver instead.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/video/hyperv_fb.c | 40
> +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
> index 8ac99b8..8d456dc 100644
> --- a/drivers/video/hyperv_fb.c
> +++ b/drivers/video/hyperv_fb.c
> @@ -795,12 +795,21 @@ static int hvfb_remove(struct hv_device *hdev)
>  }
> 
> 
> +static DEFINE_PCI_DEVICE_TABLE(pci_stub_id_table) = {
> +	{
> +		.vendor      = PCI_VENDOR_ID_MICROSOFT,
> +		.device      = PCI_DEVICE_ID_HYPERV_VIDEO,
> +	},
> +	{ /* end of list */ }
> +};
> +
>  static const struct hv_vmbus_device_id id_table[] = {
>  	/* Synthetic Video Device GUID */
>  	{HV_SYNTHVID_GUID},
>  	{}
>  };
> 
> +MODULE_DEVICE_TABLE(pci, pci_stub_id_table);
>  MODULE_DEVICE_TABLE(vmbus, id_table);
> 
>  static struct hv_driver hvfb_drv = {
> @@ -810,14 +819,43 @@ static struct hv_driver hvfb_drv = {
>  	.remove = hvfb_remove,
>  };
> 
> +static int hvfb_pci_stub_probe(struct pci_dev *pdev,
> +			       const struct pci_device_id *ent)
> +{
> +	return 0;
> +}
> +
> +static void hvfb_pci_stub_remove(struct pci_dev *pdev)
> +{
> +}
> +
> +static struct pci_driver hvfb_pci_stub_driver = {
> +	.name =		KBUILD_MODNAME,
> +	.id_table =	pci_stub_id_table,
> +	.probe =	hvfb_pci_stub_probe,
> +	.remove =	hvfb_pci_stub_remove,
> +};
> 
>  static int __init hvfb_drv_init(void)
>  {
> -	return vmbus_driver_register(&hvfb_drv);
> +	int ret;
> +
> +	ret = vmbus_driver_register(&hvfb_drv);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = pci_register_driver(&hvfb_pci_stub_driver);
> +	if (ret != 0) {
> +		vmbus_driver_unregister(&hvfb_drv);
> +		return ret;
> +	}
> +
> +	return 0;
>  }
> 
>  static void __exit hvfb_drv_exit(void)
>  {
> +	pci_unregister_driver(&hvfb_pci_stub_driver);
>  	vmbus_driver_unregister(&hvfb_drv);
>  }
> 
> --
> 1.8.3.1
Gerd,

Thanks for doing this. This certainly will address some of the issues that are reported. I do have a question though - how would this work if we don't have PCI bus in the guest.

Regards,

K. Y
