Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaHAK1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:27:51 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:47675
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754765AbaHAK1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:27:49 -0400
From: "arnab.basu@freescale.com" <arnab.basu@freescale.com>
To: Yijing Wang <wangyijing@huawei.com>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Paul.Mundt@huawei.com" <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Thread-Topic: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Thread-Index: AQHPqHuv0hVCMUCelEShL+OakTcOY5u7k8dQ
Date: Fri, 1 Aug 2014 10:27:46 +0000
Message-ID: <c6d34fe1bbe9457ea8cff7dcd97902b8@DM2PR03MB317.namprd03.prod.outlook.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(53754006)(199002)(377454003)(52604005)(189002)(51704005)(19580395003)(81342001)(106356001)(19580405001)(107046002)(110136001)(95666004)(74502001)(46102001)(74662001)(83322001)(83072002)(99286002)(76576001)(85306004)(105586002)(31966008)(33646002)(106116001)(79102001)(64706001)(54356999)(50986999)(76176999)(74316001)(66066001)(77982001)(86362001)(76482001)(21056001)(99396002)(101416001)(4396001)(20776003)(81542001)(85852003)(2656002)(92566001)(87936001)(80022001)(108616003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB317;H:DM2PR03MB317.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yijing

> -----Original Message-----
> From: Yijing Wang [mailto:wangyijing@huawei.com]
> Sent: Saturday, July 26, 2014 8:39 AM
> To: linux-kernel@vger.kernel.org
> Cc: Xinwei Hu; Wuyun; Bjorn Helgaas; linux-pci@vger.kernel.org;
> Paul.Mundt@huawei.com; James E.J. Bottomley; Marc Zyngier; linux-arm-
> kernel@lists.infradead.org; Russell King; linux-arch@vger.kernel.org;
> Basu Arnab-B45036; virtualization@lists.linux-foundation.org; Hanjun Guo;
> Yijing Wang
> Subject: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
> 
> Hi all,
> 	The series is a draft of generic MSI driver that supports PCI and
> Non-PCI device which have MSI capability. If you're not interested it,
> sorry for the noise.
> 

Thanks for sending out these patches, I have some (very basic) questions.

> The series is based on Linux-3.16-rc1.
> 
> MSI was introduced in PCI Spec 2.2. Currently, kernel MSI driver codes
> are bonding with PCI device. Because MSI has a lot advantages in design.
> More and more non-PCI devices want to use MSI as their default interrupt.
> The existing MSI device include HPET. HPET driver provide its own MSI
> code to initialize and process MSI interrupts. In the latest GIC v3 spec,
> legacy device can deliver MSI by the help of a relay device named
> consolidator.
> Consolidator can translate the legacy interrupts connected to it to
> MSI/MSI-X. And new non-PCI device will be designed to support MSI in
> future. So make the MSI driver code be generic will help the non-PCI
> device use MSI more simply.

As per my understanding the GICv3 provides a service that will convert writes to a specified address to IRQs delivered to the core and as you mention above MSIs are part of the PCI spec. So I can see a strong case for non-PCI devices to want MSI like functionality without being fully compliant with the requirements of the MSI spec.

My question is do we necessarily want to rework so much of the PCI-MSI layer to support non PCI devices? Or will it be sufficient to create a framework to allow non PCI devices to hook up with a device that can convert their writes to an IRQ to the core.

As I understand it, the msi_chip is (almost) such a framework. The only problem being that it makes some PCI specific assumptions (such as PCI specific writes from within msi_chip functions). Won't it be sufficient to make the msi_chip framework generic enough to be used by non-PCI devices and let each bus/device manage any additional requirements (such as configuration flow, bit definitions etc) that it places on message based interrupts?

Thanks
Arnab
