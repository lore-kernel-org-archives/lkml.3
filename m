Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaLORx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:53:27 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:60563 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaLORxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:53:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
Date: Fri, 12 Dec 2014 18:21:37 +0100
Message-ID: <1790462.K12S5vem48@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <548B2120.4080207@broadcom.com>
References: <1418351817-14898-3-git-send-email-rjui@broadcom.com> <2190666.DfrpWiLTCc@wuerfel> <548B2120.4080207@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:a26srnl066voI7l2DhVNknZuhRJlXnkAjKIf+8BIOZOxhc2NxrX
 C+VIDWPrklAwWKV6JJ6LzESeaDldjoiufhntz6B5GfqLjlPqcBaO9Q0mUaQQFZ/KYpeBfSi
 +hml2EtbisH9I6prFjXJ9Ep9iXyslS6T4AObsDvL/zO+I9qtCdNaVU/9zmHe8fjcMpTiTuY
 Y12DmDx0gWLq4BuDouUeA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2014 09:08:48 Ray Jui wrote:
> 
> On 12/12/2014 4:29 AM, Arnd Bergmann wrote:
> > On Thursday 11 December 2014 18:36:55 Ray Jui wrote:
> >> Add initial version of the Broadcom iProc PCIe driver. This driver
> >> has been tested on NSP and Cygnus and is expected to work on all iProc
> >> family of SoCs that deploys the same PCIe host controller
> >>
> >> The driver also supports MSI
> >
> > Overall, I'm not convinced it's worth continuing this driver. While it
> > supports more features, Hauke's version seemed much cleaner, and I'd
> > rather see his driver merged and have you add the additional features.
> >
> > Why did you drop him from Cc again?
> >
> In fact, Hauke is on the "to" list of all v2 patchset that I sent out. I 
> added him to the "to" list because he mentioned during v1 patchset 
> review that he'll help to test this on North Star.

Sorry, my mistake. I looked through the Cc list multiple times but failed
to see him there.
 
> Doesn't Hauke's driver depends on BCMA? In that case, how does it work 
> on the SoCs that do not have the IP block to support BCMA?

I hadn't realized that there are some SoCs that are not BCMA based.
As the host controller implementation is closely related, we will
have to come up with some solution.

One way to solve this would be by turning the driver into a library
the same way as the pcie-dw driver, and have separate front-ends
for it for platform_device and bcma_device.

As I mentioned in my other reply, we will likely have the same problem
in a number of other drivers too, so we could try to come up with
a way to make bcma_device fit better into the platform_device
infrastructure, but I wouldn't know how to do that without giving
it more thought.

> >> +static void iproc_pcie_reset(struct iproc_pcie *pcie)
> >> +{
> >> +	u32 val;
> >> +
> >> +	/* send a downstream reset */
> >> +	val = EP_MODE_SURVIVE_PERST | RC_PCIE_RST_OUTPUT;
> >> +	writel(val, pcie->reg + CLK_CONTROL_OFFSET);
> >> +	udelay(250);
> >> +	val &= ~EP_MODE_SURVIVE_PERST;
> >> +	writel(val, pcie->reg + CLK_CONTROL_OFFSET);
> >> +	mdelay(250);
> >> +}
> >
> > 250ms delay is not acceptable. Please find a way to call this function
> > from a context in which you can sleep.
> >
> This is called from driver probe, where runs in the process context 
> where you can sleep. Is my understanding correct? I can change mdelay to 
> msleep so the CPU does not waste time spinning.

Right, that sounds good.

> >> +	if (nlw == 0) {
> >> +		/* try GEN 1 link speed */
> >> +#define PCI_LINK_STATUS_CTRL_2_OFFSET 0xDC
> >> +#define PCI_TARGET_LINK_SPEED_MASK    0xF
> >> +#define PCI_TARGET_LINK_SPEED_GEN2    0x2
> >> +#define PCI_TARGET_LINK_SPEED_GEN1    0x1
> >> +		pci_bus_read_config_dword(&bus, 0,
> >> +				PCI_LINK_STATUS_CTRL_2_OFFSET, &val);
> >> +		if ((val & PCI_TARGET_LINK_SPEED_MASK) ==
> >> +				PCI_TARGET_LINK_SPEED_GEN2) {
> >> +			val &= ~PCI_TARGET_LINK_SPEED_MASK;
> >> +			val |= PCI_TARGET_LINK_SPEED_GEN1;
> >> +			pci_bus_write_config_dword(&bus, 0,
> >> +					PCI_LINK_STATUS_CTRL_2_OFFSET, val);
> >> +			pci_bus_read_config_dword(&bus, 0,
> >> +					PCI_LINK_STATUS_CTRL_2_OFFSET, &val);
> >> +			mdelay(100);
> >
> > Too much delay.
> >
> Need to confirm with the ASIC engineer. The delay may be what's needed.

If you can turn it into msleep here, it's fine. Just don't waste 100
million CPU cycles for no reason.

> >> +static int __init iproc_pcie_init(void)
> >> +{
> >> +	return platform_driver_probe(&iproc_pcie_driver,
> >> +			iproc_pcie_probe);
> >> +}
> >> +subsys_initcall(iproc_pcie_init);
> >
> > module_init()? Doesn't seem necessary to have this early.
> >
> > 	Arnd
> >
> Will look into this. Forgot why we use subsys_initcall here...

Probably copied from other drivers. It used to be required.

	Arnd
