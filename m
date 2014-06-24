Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaFXUeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:34:20 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:54683
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756097AbaFXUeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:34:13 -0400
From: Rajat Jain <rajatjain@juniper.net>
To: Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain.linux@gmail.com>
Subject: RE: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
 bit when clearing the Slot Status register's event bits
Thread-Topic: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
 bit when clearing the Slot Status register's event bits
Thread-Index: AQHPinP9EC6THgfjuUKVXz+u2q+L+Jt16ZKAgArPvXA=
Date: Tue, 24 Jun 2014 20:34:03 +0000
Message-ID: <aa91dac8e0f4416bb5f8b901b4da8f22@DM2PR05MB671.namprd05.prod.outlook.com>
References: <20140617192734.30783.71260.stgit@amt.stowe>
 <CAErSpo7t2kXj2ZULLXCJSWb_awS+DCtCg51dnLbb8ztWmQdYog@mail.gmail.com>
 <53A0C763.7080003@roeck-us.net>
In-Reply-To: <53A0C763.7080003@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.14]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02524402D6
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(43544003)(164054003)(377454003)(479174003)(51704005)(13464003)(24454002)(92566001)(86362001)(83072002)(85852003)(4396001)(74316001)(77982001)(101416001)(33646001)(64706001)(80022001)(79102001)(66066001)(20776003)(81342001)(95666004)(74502001)(99286002)(50986999)(106116001)(105586002)(87936001)(31966008)(83322001)(19580405001)(19580395003)(2656002)(74662001)(76176999)(46102001)(99396002)(54356999)(76482001)(85306003)(81542001)(21056001)(76576001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR05MB672;H:DM2PR05MB671.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5OKaSYi000703

Hello,

Sorry, I missed this email.

Please see below. 

> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
> owner@vger.kernel.org] On Behalf Of Guenter Roeck
> Sent: Tuesday, June 17, 2014 3:56 PM
> To: Bjorn Helgaas; Myron Stowe
> Cc: linux-pci@vger.kernel.org; Kenji Kaneshige; linux-
> kernel@vger.kernel.org; Rajat Jain
> Subject: Re: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
> bit when clearing the Slot Status register's event bits
> 
> On 06/17/2014 02:07 PM, Bjorn Helgaas wrote:
> > On Tue, Jun 17, 2014 at 1:27 PM, Myron Stowe
> <myron.stowe@redhat.com> wrote:
> >> During PCIe hot-plug initialization - pciehp_probe - data structures
> >> related to slot capabilities are set up.  As part of this set up,
> >> ISRs are put in place to handle slot events and all event bits are cleared
> out.
> >>
> >> This patch adds the Data Link Layer State Changed
> >> (PCI_EXP_SLTSTA_DLLSC) Slot Status bit to the event bits that are
> >> cleared out during initialization.
> >
> > I think this is related to e48f1b67f668 ("PCI: pciehp: Use link change
> > notifications for hot-plug and removal").  Prior to that, pcie_isr()
> > didn't look at the PCI_EXP_SLTSTA_DLLSC bit.
> >
> > Apparently there's a non-public report of spurious messages like this
> > at boot-time, with no actual hotplug events:
> >
> >    pciehp 0000:82:04.0:pcie24: slot(4): Link Up event
> >    pciehp 0000:82:04.0:pcie24: Device 0000:83:00.0 already exists at
> > 0000:83:00, cannot hot-add
> >    pciehp 0000:82:04.0:pcie24: Cannot add device at 0000:83:00
> >
> 
> I think I have seen that message once in a while in our systems.
> Rajat, didn't we talk about this a while ago ?

Essentially my hiccup was that I was not sure whether the driver should or should not take care of the link change events that have happened BEFORE the driver gets loaded. This has more impact if the pciehp is built as a kernel module.

As an example:

It is common for the platform init code built into the kernel, to take the PCI devices on the board out of reset. And that can happen after the PCI enumeration but before the pciehp driver gets loaded. Thus in this condition, with this patch, the pciehp will ignore the linkup event, thus device will not be visible. The only way (other than a rescan) to do hot-add the device would be to apply-and-remove-reset-signal to the device again. At which point pciehp may give a warning about about an attempt to remove a non-existent card, and then will proceed fine with hot-add.

The patch looks good, only wanted to make sure that we understand and agree that the pciehp should NOT process and link events that have happened before the pciehp was loaded.

Acked-by: Rajat Jain <rajatjain@juniper.net>

Thanks,

Rajat


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
