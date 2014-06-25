Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaFYF0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:26:22 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:49518
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769AbaFYF0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:26:20 -0400
From: Rajat Jain <rajatjain@juniper.net>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Guenter Roeck <linux@roeck-us.net>, Myron Stowe <myron.stowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain.linux@gmail.com>
Subject: RE: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
 bit when clearing the Slot Status register's event bits
Thread-Topic: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
 bit when clearing the Slot Status register's event bits
Thread-Index: AQHPj/Ga6u5LZufISEuWfrI0X6/I3JuA8g0Q
Date: Wed, 25 Jun 2014 05:26:16 +0000
Message-ID: <de1a45e8e5d548b88b5f797348a39e0d@DM2PR05MB671.namprd05.prod.outlook.com>
References: <20140617192734.30783.71260.stgit@amt.stowe>
 <CAErSpo7t2kXj2ZULLXCJSWb_awS+DCtCg51dnLbb8ztWmQdYog@mail.gmail.com>
 <53A0C763.7080003@roeck-us.net>
 <aa91dac8e0f4416bb5f8b901b4da8f22@DM2PR05MB671.namprd05.prod.outlook.com>
 <CAErSpo4xWtBtL6a-vNh_s+MRHNVa6iEe3g8ZcgFPyHHD0ZrM9g@mail.gmail.com>
In-Reply-To: <CAErSpo4xWtBtL6a-vNh_s+MRHNVa6iEe3g8ZcgFPyHHD0ZrM9g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.239.14]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(164054003)(199002)(52604005)(43544003)(24454002)(189002)(51704005)(377454003)(479174003)(81542001)(106116001)(54356999)(106356001)(2656002)(83072002)(4396001)(19580395003)(76176999)(101416001)(85306003)(99396002)(86362001)(33646001)(74316001)(83322001)(19580405001)(80022001)(87936001)(81342001)(79102001)(77982001)(74662001)(20776003)(66066001)(50986999)(21056001)(105586002)(76482001)(92566001)(93886003)(74502001)(95666004)(99286002)(85852003)(46102001)(64706001)(76576001)(107046001)(31966008)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR05MB670;H:DM2PR05MB671.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5P5QQ34004125

Hello,

> >>
> >> On 06/17/2014 02:07 PM, Bjorn Helgaas wrote:
> >> > On Tue, Jun 17, 2014 at 1:27 PM, Myron Stowe
> >> <myron.stowe@redhat.com> wrote:
> >> >> During PCIe hot-plug initialization - pciehp_probe - data
> >> >> structures related to slot capabilities are set up.  As part of
> >> >> this set up, ISRs are put in place to handle slot events and all
> >> >> event bits are cleared
> >> out.
> >> >>
> >> >> This patch adds the Data Link Layer State Changed
> >> >> (PCI_EXP_SLTSTA_DLLSC) Slot Status bit to the event bits that are
> >> >> cleared out during initialization.
> >> >
> >> > I think this is related to e48f1b67f668 ("PCI: pciehp: Use link
> >> > change notifications for hot-plug and removal").  Prior to that,
> >> > pcie_isr() didn't look at the PCI_EXP_SLTSTA_DLLSC bit.
> >> >
> >> > Apparently there's a non-public report of spurious messages like
> >> > this at boot-time, with no actual hotplug events:
> >> >
> >> >    pciehp 0000:82:04.0:pcie24: slot(4): Link Up event
> >> >    pciehp 0000:82:04.0:pcie24: Device 0000:83:00.0 already exists
> >> > at 0000:83:00, cannot hot-add
> >> >    pciehp 0000:82:04.0:pcie24: Cannot add device at 0000:83:00
> >> >
> >>
> >> I think I have seen that message once in a while in our systems.
> >> Rajat, didn't we talk about this a while ago ?
> >
> > Essentially my hiccup was that I was not sure whether the driver should or
> should not take care of the link change events that have happened BEFORE
> the driver gets loaded. This has more impact if the pciehp is built as a kernel
> module.
> >
> > As an example:
> >
> > It is common for the platform init code built into the kernel, to take the PCI
> devices on the board out of reset. And that can happen after the PCI
> enumeration but before the pciehp driver gets loaded. Thus in this condition,
> with this patch, the pciehp will ignore the linkup event, thus device will not
> be visible. The only way (other than a rescan) to do hot-add the device would
> be to apply-and-remove-reset-signal to the device again. At which point
> pciehp may give a warning about about an attempt to remove a non-existent
> card, and then will proceed fine with hot-add.
> 
> When you saw these problems, was pciehp a module?

No, we did not actually hit *this* problem (DLLSC getting set before pciehp init). We had observed another HW specific problem where both link event and presence detect were toggling, hence 2 independent hot-plug interrupts events were coming, thus resulting in spurious messages.

> We changed it
> (c10cc483bf3f in v3.11) so it can't be a module any more, but if there can still
> be a significant window between enumeration and pciehp init, I'd like to
> understand more about it.

Oh, my bad. I did not ever try to actually build it as a module, I just assumed that it'd be possible. I was just thinking of corner cases I guess. 

> 
> > The patch looks good, only wanted to make sure that we understand and
> agree that the pciehp should NOT process and link events that have
> happened before the pciehp was loaded.
> 
> Currently (before this patch), we clear the Attention Button Pressed, Power
> Fault Detected, MRL Sensor Changed, Presence Detect Changed, and
> Command Completed bits, but we *don't* clear Data Link Layer State
> Changed.
> 
> That asymmetry seems hard to justify.

Agree.

 > For example, if a card were inserted
> after enumeration but before pciehp is initialized, we'd miss the PDC
> indication, so I think we would fail to notice the new device.
> That seems basically the same as missing the linkup event in your example.
> In both cases, I think we *should* notice the new device, so the fact that we
> don't is a problem.

Hummm, ok understood. So that means we have defined a problem statement at least :-). Yes, I understand that the window is very small here. Also I agree with your opinion whatever solution we put it to take care of events that happened before pciehp init, should be consistent for all events (not just link changes). The problem can wait to be solved I think.

> 
> But since pciehp can't be a module any more, the window between PCI
> enumeration and pciehp initialization should be relatively small.  I think the
> best way to fix this would be to integrate pciehp more closely into PCI
> enumeration, e.g., by doing pcie_init() at the point where we discover the
> bridge, before we enumerate any devices below the bridge.  This is
> somewhat tangled up with acpihp, so I don't know how complicated it would
> be to do this.
> 
> So I guess my argument is:
> 
>   - Ignoring events that happen before pciehp init decreases our dependency
> on BIOS

Agree.

>   - Handling all events consistently is very important

Agree.

>   - We currently have a problem with missing pre-pciehp events, but there is
> a way to fix this

Somewhat agree (I do not understand what that way is currently. But I think it can wait as we don't hit that problem today and also the window where it can occur is very small).

Thanks,

Rajat

> 
> > Acked-by: Rajat Jain <rajatjain@juniper.net>
> 
> Thanks for taking a look at this!
> 
> Bjorn
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
