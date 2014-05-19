Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaESMHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:07:14 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:51105 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaESMHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:07:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware core driver
Date: Mon, 19 May 2014 14:06:36 +0200
Message-ID: <5671513.YgJm44AVLV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5376748B.7080302@ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <22200719.Jb5jnJylJH@wuerfel> <5376748B.7080302@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LOfFdmcTTHYJ4yVnnVYz8qKJDvORPDqvJymrvcGqL+0
 G7c/plXGmae8gG0RLx95IYPPvybzHfPyUj5mKE4GJOnJcrj69Z
 zmdnvPV2NtFyhVw96V/8lwvDZmYTgNmm3MBWrf6PTFzGsCmqzh
 vCENHtzLVzskG4YYts60kTj+koLDs3qij293cRfQHJ5yOph9bL
 PDw8RonuaekB8UHO7tgEffVScvyiL4YyBJV9Slx52p9biqU+Am
 aLUUIok0QuRjhL6S74GIv96QYzNh1sb7JA8EQL1uQFsQDW6oXc
 eU0cFIkGf1QxwaCvH7XxNaG46L3pmmejm8UyR8oIRveaI4DmNL
 QUu52d3GdLAmhxWlE9Uc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2014 16:26:51 Murali Karicheri wrote:
> On 5/15/2014 2:20 PM, Arnd Bergmann wrote:
> > On Thursday 15 May 2014 13:45:08 Murali Karicheri wrote:
> >>>> +#ifdef CONFIG_PCI_KEYSTONE
> >>>> +/*
> >>>> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
> >>>> + */
> >>>> +static void quirk_limit_readrequest(struct pci_dev *dev)
> >>>> +{
> >>>> +    int readrq = pcie_get_readrq(dev);
> >>>> +
> >>>> +    if (readrq > 256)
> >>>> +            pcie_set_readrq(dev, 256);
> >>>> +}
> >>>> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
> >>>> +#endif /* CONFIG_PCI_KEYSTONE */
> >>> This doesn't work: you can't just limit do this for all devices just based
> >>> on PCI_KEYSTONE being enabled, you have to check if you are actually using
> >>> this controller.
> >>>
> >>>        Arnd
> >>    I assume, I need to check if PCI controller's vendor ID/ device ID
> >> match with the keystone
> >>    PCI controller's ID and call pcie_set_readrq() for all of the slave
> >> PCI devices and do this fixup.
> >> Is this correct understanding?  If you can point me to an example code
> >> for this that will be
> >> really helpful so that I can avoid re-inventing the wheel.
> > I think it would be best to move the quirk into the keystone pci driver
> > and compare compare the dev->driver pointer of the PCI controller device.
> >
> >       Arnd
> Arnd,
> 
> I will move this quirk to keystone pci driver. So in that case, I guess 
> your original comment
> is not applicable as  this quirk gets enabled only with PCI keystone 
> driver enabled. Right?

Of course you still have to fix the bug, not just move the code into
the driver. Otherwise it's still broken for every machine after the keystone
driver is enabled.

I also agree with Jason that changing the PCI core to call
pcie_bus_configure_settings() would be a better way of dealing with this
if it solves the problem.

	Arnd
