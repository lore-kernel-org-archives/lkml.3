Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbaIOWex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:34:53 -0400
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:39552
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756222AbaIOWet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:34:49 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 18:34:49 EDT
From: Rajat Jain <rajatjain@juniper.net>
To: Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "rajatxjain@gmail.com" <rajatxjain@gmail.com>,
        "Guenter Roeck" <linux@roeck-us.net>
Subject: RE: [PATCH] PCI: Prevent NULL dereference during pciehp probe
Thread-Topic: [PATCH] PCI: Prevent NULL dereference during pciehp probe
Thread-Index: AQHPhCa99tmtRJwt0UaJ41jWBhDf35wDXTPg
Date: Mon, 15 Sep 2014 22:20:41 +0000
Message-ID: <580c2c85f8424369910b69a8f871f82e@DM2PR05MB671.namprd05.prod.outlook.com>
References: <1402347812-8059-1-git-send-email-andreas.noever@gmail.com>
In-Reply-To: <1402347812-8059-1-git-send-email-andreas.noever@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [66.129.239.14]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03355EE97E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(164054003)(377454003)(189002)(79102001)(76176999)(77982001)(50986999)(54356999)(74662001)(19580405001)(19580395003)(83322001)(74502001)(46102001)(107046002)(21056001)(15202345003)(76482001)(90102001)(74316001)(108616004)(15975445006)(97736003)(85306004)(101416001)(76576001)(86362001)(575784001)(2656002)(106356001)(87936001)(106116001)(85852003)(92566001)(83072002)(105586002)(81342001)(4396001)(80022001)(66066001)(33646002)(95666004)(99286002)(31966008)(99396002)(20776003)(81542001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR05MB527;H:DM2PR05MB671.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

I think this patch needs to be applied to all -stable branches (all the way back to 3.2).

I encounter this same issue on my platform that is running 3.14.y. 

Thanks,

Rajat

> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
> owner@vger.kernel.org] On Behalf Of Andreas Noever
> Sent: Monday, June 09, 2014 2:04 PM
> To: linux-kernel@vger.kernel.org; Bjorn Helgaas; linux-pci@vger.kernel.org
> Cc: Andreas Noever
> Subject: [PATCH] PCI: Prevent NULL dereference during pciehp probe
> 
> pciehp assumes that dev->subordinate exists. But we do not assign a bus if
> we run out of bus numbers during enumeration. This leads to a NULL
> dereference in init_slot (and other places).
> 
> Change pciehp_probe to return -ENODEV when no subordinate bus is
> present.
> 
> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
> ---
>  drivers/pci/hotplug/pciehp_core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/pci/hotplug/pciehp_core.c
> b/drivers/pci/hotplug/pciehp_core.c
> index 0e0a2ff..e5abcaf 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -255,6 +255,13 @@ static int pciehp_probe(struct pcie_device *dev)
>  	else if (pciehp_acpi_slot_detection_check(dev->port))
>  		goto err_out_none;
> 
> +	if (!dev->port->subordinate) {
> +		/* Can happen if we run out of bus numbers during probe */
> +		dev_err(&dev->device,
> +			"Hotplug bridge without secondary bus, ignoring\n");
> +		goto err_out_none;
> +	}
> +
>  	ctrl = pcie_init(dev);
>  	if (!ctrl) {
>  		dev_err(&dev->device, "Controller initialization failed\n");
> --
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
