Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaJBIji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:39:38 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62228 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaJBIje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:39:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org, mark.rutland@arm.com,
        graeme.gregory@linaro.org, marc.zyngier@arm.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, astone@redhat.com,
        grant.likely@linaro.org, hanjun.guo@linaro.org, Sudeep.Holla@arm.com,
        olof@lixom.net, jason@lakedaemon.net, "Duran, Leo" <leo.duran@amd.com>,
        Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH 1/4] ata: ahci_platform: Add ACPI support for AMD Seattle SATA controller
Date: Thu, 02 Oct 2014 10:39:18 +0200
Message-ID: <4872185.h11DQxW6kP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <542C6FE9.10903@amd.com>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com> <20140917012614.GA31214@srcf.ucam.org> <542C6FE9.10903@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:g+Hw0Uy8IOMTKaXb/5DURDCs7tV/So3wfJgiqNMAlzF
 33B+YJkSfkQJ6xNeuGrFlU7YAutC4u8Pq0YdjsIftkDH/D6bOz
 gtoPRz8kYr74+jphlmptJdFOoyW1KdoQqlOz31ii5qVfoogOzh
 0clr7vbBkXheluwZY8kozL0Pw9n2UXXkdV92ebYgake9FR2oC/
 vdbgu0w6+gctmTzgw2ny6F7RV7PGYAmYF20Vq5xhPIxkMSyFU/
 w2jTQkTtsot8PEIdBTGTAEXg/CNoO92/xYEvHnnNaLy2QfbIZL
 G6zBPTJEVR4MRGVAa2Wge2tBu9zOiMT9o8pDy0BeMSMaizWab2
 RBEeVvc7pGPf1qViWJbI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 16:19:37 Suravee Suthikulanit wrote:
> On 9/16/2014 8:26 PM, Matthew Garrett wrote:
> > On Mon, Sep 15, 2014 at 07:47:23PM -0500, suravee.suthikulpanit@amd.com wrote:
> >> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> >>
> >> This patch adds ACPI match table in ahci_platform. The table includes
> >> the acpi_device_id to match AMD Seattle SATA controller with following
> >> asl structure in DSDT:
> >>
> >>      Device (SATA0)
> >>      {
> >>        Name(_HID, "AMDI0600")        // Seattle AHSATA
> >
> > There really ought to be a well-defined PNPID for AHCI, so you can _HID
> > to AMD and _CID to something generic. That way we won't have:
> >
> >> +#ifdef CONFIG_ATA_ACPI
> >> +static const struct acpi_device_id ahci_acpi_match[] = {
> >> +    { "AMDI0600", 0 }, /* AMD Seattle AHCI */
> >> +    { },
> >> +};
> >
> > utter sadness here. Really, please don't end up in a situation where we
> > need to add device-specific IDs to a generic driver.
> >
> Matthew,
> 
> Currently, there is no _CID defined for generic AHCI. We will work on 
> proposing one, and provide update patches for including the new ID.
> 

I think part of the problem is that there is no specification for what
an AHCI device should look like when it's not connected to a PCI
bus, the AHCI document published by Intel just states:

"AHCI is a PCI class device that acts as a data movement engine
between system memory and Serial ATA devices."

It also requires the PCI config space to have the PM capability
registers and (optionally) the MSI capability registers.
There are lots of chips we support in Linux with the ahci-platform
driver, but they are not actually compliant because they cannot
use the pmcap registers but instead typically rely on setting
external clock/phy/regulator/pinctrl registers.

The ARM SBSA document just requires any SATA controller to be AHCI
compliant but does not explain what that means in the case where
it's not a PCI device.

	Arnd
