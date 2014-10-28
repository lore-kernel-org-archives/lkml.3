Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaJ1MoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:44:04 -0400
Received: from mail-by2on0127.outbound.protection.outlook.com ([207.46.100.127]:34304
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750786AbaJ1MoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:44:02 -0400
X-WSS-ID: 0NE5ND5-08-ROW-02
X-M-MSG: 
Date: Tue, 28 Oct 2014 20:15:17 +0800
From: Huang Rui <ray.huang@amd.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 18/19] PCI: Add quirk to prevent AMD NL USB3 DRD to
 bind with xHCI driver
Message-ID: <20141028121516.GA3208@hr-slim.amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-19-git-send-email-ray.huang@amd.com>
 <544F86C7.3060100@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <544F86C7.3060100@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(189002)(199003)(164054003)(377454003)(479174003)(24454002)(86362001)(575784001)(102836001)(44976005)(19580405001)(4396001)(19580395003)(83506001)(84676001)(46406003)(85306004)(23726002)(31966008)(110136001)(33656002)(92566001)(50466002)(101416001)(20776003)(92726001)(64706001)(47776003)(54356999)(21056001)(85852003)(76176999)(97736003)(87936001)(80022003)(46102003)(105586002)(107046002)(97756001)(68736004)(53416004)(50986999)(76482002)(106466001)(120916001)(95666004)(77096002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:06:31PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 10/28/2014 2:54 PM, Huang Rui wrote:
> 
> >The AMD Nolan (NL) SoC contains a DesignWare USB3 Dual-Role Device that can
> >be operated either as a USB Host or a USB Device.  In the AMD NL platform,
> >this device ([1022:7912]) has a class code of PCI_CLASS_SERIAL_USB_XHCI
> >(0x0c0330), which means the xhci driver will claim it.
> 
> >But the dwc3 driver is a more specific driver for this device, and we'd
> >prefer to use it instead of xhci.  To prevent xhci from claiming the
> >device, change the class code to 0x0c03fe, which the PCI r3.0 spec defines
> >as "USB device (not host controller)".  The dwc3 driver can then claim it
> >based on its Vendor and Device ID.
> 
> >Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >Cc: Bjorn Helgaas <bhelgaas@google.com>
> >Cc: Jason Chang <jason.chang@amd.com>
> >Signed-off-by: Huang Rui <ray.huang@amd.com>
> >---
> >  drivers/pci/quirks.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> 
> >diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> >index 90acb32..1152bef 100644
> >--- a/drivers/pci/quirks.c
> >+++ b/drivers/pci/quirks.c
> >@@ -379,6 +379,26 @@ static void quirk_ati_exploding_mce(struct pci_dev *dev)
> >  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
> >
> >  /*
> >+ * In the AMD NL platform, this device ([1022:7912]) has a class code of
> >+ * PCI_CLASS_SERIAL_USB_XHCI (0x0c0330), which means the xhci driver will
> >+ * claim it.
> >+ * But the dwc3 driver is a more specific driver for this device, and we'd
> >+ * prefer to use it instead of xhci. To prevent xhci from claiming the
> >+ * device, change the class code to 0x0c03fe, which the PCI r3.0 spec
> >+ * defines as "USB device (not host controller)". The dwc3 driver can then
> >+ * claim it based on its Vendor and Device ID.
> >+ */
> >+static void quirk_amd_nl_class(struct pci_dev *pdev)
> >+{
> >+	/*
> >+	 * Use 'USB Device' (0x0x03fe) instead of PCI header provided
> 
>     0x0c03fe, you mean?

Yes. That's a typo, 'USB Device' class code should be 0x0c03fe, will
update.

> 
> >+	 */
> >+	pdev->class = 0x0c03fe;
> >+}
> >+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB,
> 
>    I'm not sure it was a good idea to declare the ID in pci_ids.h --
> it's been long discouraged.
> 

You're right. But PCI_DEVICE_ID_AMD_NL_USB will be used on two
drivers(pci and dwc3). It also might be used for identifying AMD NL
chip for another drivers in future.

Thanks,
Rui
