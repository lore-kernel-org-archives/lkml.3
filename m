Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaILI0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:26:16 -0400
Received: from mail-bn1on0131.outbound.protection.outlook.com ([157.56.110.131]:32745
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752485AbaILI0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:26:11 -0400
X-WSS-ID: 0NBS4RD-08-8U7-02
X-M-MSG: 
Message-ID: <5412ADE9.2050708@amd.com>
Date: Fri, 12 Sep 2014 03:25:13 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Device Tree ML" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 00/10] Support for creating generic PCI host bridges
 from DT
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(189002)(377454003)(479174003)(51704005)(164054003)(199003)(31966008)(50466002)(86362001)(21056001)(36756003)(85852003)(83072002)(20776003)(76176999)(87266999)(33656002)(44976005)(80316001)(83322001)(54356999)(68736004)(65816999)(102836001)(50986999)(23746002)(4396001)(99396002)(77982001)(87936001)(95666004)(81542001)(79102001)(84676001)(64126003)(97736003)(101416001)(85306004)(107046002)(80022001)(92566001)(64706001)(83506001)(74502001)(106466001)(74662001)(92726001)(76482001)(46102001)(105586002)(65956001)(47776003)(90102001)(65806001)(59896002)(81342001)(41533002)(1121002)(921003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB282;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/2014 8:54 AM, Liviu Dudau wrote:
> This is my version 10 of the attempt at adding support for generic PCI host
> bridge controllers that make use of device tree information to
> configure themselves. This version reverses v9's attempt to create one function
> to drive the whole process of extracting the host bridge ranges, setup the
> host bridge driver and then scan the root bus behind the host bridge. While it
> would've been quite user friendly, I agree that it would've caused a lot of pain
> in the future.
>
> I would like to get ACKs for the remaining patches as I would like to integrate
> this into -next in the following week.
>
> This version marks an implementation break with the previous versions as
> of_create_pci_host_bridge() is now gone. It gets replaced by
> of_pci_get_host_bridge_resources() that only parses the DT and extracts the
> relevant ranges and converts them to resources. The updated host bridge drivers
> will have to follow the guidelines in this example code:
>
> static int foohb_probe(struct platform_device *pdev)
> {
> 	struct device_node *dn = pdev->dev.of_node;
> 	struct foohb_drv *drv;
> 	resource_size_t io_base = 0;  /* phys address for start of IO */
> 	struct pci_bus *bus;
> 	int err = 0;
> 	LIST_HEAD(res);
>
> 	.....
> 	err = of_pci_get_host_bridge_resources(dn, 0, 255, &res, &io_base);
> 	if (err)
> 		goto err_handling;
> 	err = foohb_setup(drv, ...., &res, &io_base);
> 	if (err)
> 		goto err_handling;

My understanding is that the "foohb_setup" above is supposed to be equivalent
to the "int (*setup)(struct pci_host_bridge *, resource_size_t)" in V9 that was
passed in as an argument of "of_create_pci_hot_bridge()".

The problem I have is I need an intermediate step between "pci_create_root_bus()"
and "pci_scan_child_bus()" in order to update the information such as the "pci_bus->msi"
before this is propagate down to the child bus during the "pci_scan_child_bus"
which is also called in the pci_scan_root_bus() function.

Does this mean that I should not be calling the pci_scan_root_bus(), and tries to
re-implement the same logic in my driver?

Thanks,

Suravee

> 	.....
> 	pci_add_flags(....);
> 	bus = pci_scan_root_bus(&pdev->dev, 0, &foohb_ops, drv, &res);
> 	if (!bus)
> 		goto err_handling;
> 	....
> 	return 0;
>
> err_handling:
> 	......
> 	return err;
> }
>


