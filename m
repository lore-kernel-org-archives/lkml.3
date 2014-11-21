Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKUTAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:00:43 -0500
Received: from mail-bl2on0133.outbound.protection.outlook.com ([65.55.169.133]:17577
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986AbaKUTAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:00:42 -0500
X-WSS-ID: 0NFEKSV-08-6B4-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] PCI: quirk AMD/ATI VGA cards to avoid PM reset
Thread-Topic: [PATCH 2/4] PCI: quirk AMD/ATI VGA cards to avoid PM reset
Thread-Index: AQHQBbhgsI4pmA0aVkmuqD1BzzIbV5xrbw6A
Date: Fri, 21 Nov 2014 19:00:32 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D05995CAA6@satlexdag05.amd.com>
References: <20141121180322.26669.65689.stgit@gimli.home>
 <20141121182414.26669.48397.stgit@gimli.home>
In-Reply-To: <20141121182414.26669.48397.stgit@gimli.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Alexander.Deucher@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(377454003)(189002)(51704005)(13464003)(19580395003)(92566001)(19580405001)(84676001)(31966008)(95666004)(44976005)(2501002)(92726001)(23676002)(120916001)(2656002)(97736003)(105586002)(68736004)(87936001)(54356999)(76176999)(55846006)(50986999)(21056001)(46102003)(64706001)(77156002)(106466001)(33656002)(62966003)(53416004)(47776003)(20776003)(107046002)(106116001)(50466002)(77096003)(86362001)(4396001)(101416001)(99396003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 0402872DA1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB421;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sALJ0owf020306

> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, November 21, 2014 1:24 PM
> To: bhelgaas@google.com
> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Alex
> Williamson; Deucher, Alexander
> Subject: [PATCH 2/4] PCI: quirk AMD/ATI VGA cards to avoid PM reset
> 
> Some AMD/ATI GPUs report that they support PM reset (NoSoftRst-) but
> initiating such a reset has no apparent affect on the device.  The
> monitor remains sync'd, the framebuffer contents are retained, etc.
> Callers of pci_reset_function() don't necessarily have a way to
> validate whether a reset was effective, so we really want to avoid
> making use of a known non-effective reset.  Returning an error in
> such cases appears to be the better option.  For users like vfio-pci,
> this allows the driver to escalate to the bus reset interfaces.
> 
> If a device lives on the root bus, there's really no further
> escalation path, so we exempt PM reset as potentially better than
> nothing.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>

Acked-by: Alex Deucher <alexander.deucher@amd.com>

> ---
> 
>  drivers/pci/quirks.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 90acb32..561e10d 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3008,6 +3008,27 @@
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_REALTEK, 0x8169,
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, PCI_ANY_ID,
>  			 quirk_broken_intx_masking);
> 
> +static void quirk_no_pm_reset(struct pci_dev *dev)
> +{
> +	/*
> +	 * A non-effective PM reset may be better than nothing
> +	 * if we can't do a bus reset
> +	 */
> +	if (!pci_is_root_bus(dev->bus))
> +		dev->dev_flags |= PCI_DEV_FLAGS_NO_PM_RESET;
> +}
> +
> +/*
> + * Some AMD/ATI GPUS (HD8570 - Oland) report supporting PM reset via
> D3->D0
> + * transition (NoSoftRst-).  This reset mechanims seems to have no effect
> + * whatsoever on the device, even retaining the framebuffer contents and
> + * monitor sync.  Advertising this support makes other layers, like VFIO
> + * assume pci_reset_function() is viable for this device.  Mark it as
> + * unavailable to skip it when testing reset methods.
> + */
> +DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> +			       PCI_CLASS_DISPLAY_VGA, 8,
> quirk_no_pm_reset);
> +
>  #ifdef CONFIG_ACPI
>  /*
>   * Apple: Shutdown Cactus Ridge Thunderbolt controller.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
