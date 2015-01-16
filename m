Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbbAPPol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:44:41 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:55771 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbbAPPoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:44:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>, Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Date: Fri, 16 Jan 2015 16:43:42 +0100
Message-ID: <2910949.nk5sbjdE0p@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1809831.d9GPSfLUEN@wuerfel>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <20150116153320.GU7091@arm.com> <1809831.d9GPSfLUEN@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:80XW7V41T67vsVQIhr9iIZi1/svo8wNSnrJ6MFszMrmc/AJfXci
 8/VuvT3eR3hQ0oLd8r2PQchUpzdnF1inC/0LAJZ6DJZj4IM+HJPhDY7TO4oufRWo7Y1Scv3
 5UldjbBSdf7i4MqxNvdmjk5k7KcoM4MSV/Xab7qojOG/WdUou4tSVS8EkG85HD0Xkn0naPv
 AihOB5WPKAfBf/xzyJqWg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 16:40:28 Arnd Bergmann wrote:
> On Friday 16 January 2015 15:33:20 Will Deacon wrote:
> > On Fri, Jan 16, 2015 at 03:14:13PM +0000, Arnd Bergmann wrote:
> > > On Friday 16 January 2015 14:55:45 Will Deacon wrote:
> > > > On Fri, Jan 16, 2015 at 02:45:30PM +0000, Tom Lendacky wrote:
> > > > > I have tested ACPI-enablement patches for the amd-xgbe/amd-xgbe-phy
> > > > > drivers that I'm about to submit upstream with the V7 patch series
> > > > > on the AMD Seattle server platform. There does not appear to be support
> > > > > for the _CCA attribute in this patch series. The amd-xgbe driver will
> > > > > setup the device domain and cache attributes based on the presence of
> > > > > this attribute, but it requires the arch support to assign the proper
> > > > > DMA operations in order for it to all work correctly.
> > > > > 
> > > > > Overriding the _CCA attribute in the driver, I was able to successfully
> > > > > test the driver and this patch series.
> > > > 
> > > > Hopefully this will all be addressed when the IORT parts of ACPI have
> > > > settled down (the current proposal allows for these attributes to be
> > > > described as well as their interaction with things like IOMMUs).
> > > > 
> > > > In the meantime, are you falling back to non-coherent DMA? If so, what
> > > > attributes have you settled on? We need to be really careful not to
> > > > corrupt data during cache invalidatation when mapping a non-coherent
> > > > buffer for the CPU.
> > > 
> > > I think in case of ACPI we should use cache-coherent as the default,
> > > as this is what all servers will use for DMA masters.
> > 
> > I don't agree. The dma-coherent we have for device-tree isn't nearly
> > expressive enough for the kind of things we want to describe and there's
> > no reason to make the same mistake in ACPI, especially as it *is* being
> > addressed by IORT. If we run with _CCA, then we're going to be stuck
> > supporting something that isn't fit for purpose and which will likely be
> > abused to describe both fixed features of the system and software
> > configuration preferences. It also opens up a can of worms if we have to
> > support a mixture of _CCA and IORT in the future.
> > 
> > Or are you suggesting that we ignore _CCA and just assume cache-coherency?
> > In that case, how do we support systems that aren't cache coherent, where
> > not being cache coherent includes devices that require either device or
> > IOMMU configuration to enable cacheable transactions?
> 
> I was thinking we'd ignore _CCA because as you say a simple on/off flag
> would not be enough to describe what we have to do for noncoherent
> devices. I can't think of any reason why a server hardware would include
> noncoherent devices, so if they are configurable they should be configured
> into coherent mode by the firmware.

To clarify: I don't think we should just ignore _CCA in Linux, but instead
see if it lists the device as coherent and warn loudly if it's configured
as noncoherent, then set the dma-mask pointer to NULL to prevent DMA from
being started on it.

	Arnd
