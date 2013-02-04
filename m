Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3BDTWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:22:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59678 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3BDTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:22:43 -0500
Message-ID: <51100A72.6030909@ti.com>
Date: Mon, 4 Feb 2013 14:22:26 -0500
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "Nair, Sandeep" <sandeep_n@ti.com>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <20130204154153.GA18237@arwen.pp.htv.fi> <510FF1A6.403@mvista.com> <20130204164712.GB4269@arwen.pp.htv.fi> <510FF5C9.3030600@mvista.com> <20130204170216.GC4269@arwen.pp.htv.fi>
In-Reply-To: <20130204170216.GC4269@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 12:02 PM, Felipe Balbi wrote:
> Hi,
>
> On Mon, Feb 04, 2013 at 08:54:17PM +0300, Sergei Shtylyov wrote:
>>> On Mon, Feb 04, 2013 at 08:36:38PM +0300, Sergei Shtylyov wrote:
>>>>> opted out of it. From the top of my head we have CPPI 3.x, CPPI 4.1,
>>>>> Inventra DMA, OMAP sDMA and ux500 DMA engines supported by the driver.
>>
>>>>> Granted, CPPI 4.1 makes some assumptions about the fact that it's
>>>>> handling USB tranfers,
>>
>>>>     What CPPI 4.1 code makes this assumptions? MUSB DMA driver? Then it's just
>>
>>> HW makes the asumptions
>>
>>     Not true at all. There is a separate set of registers (at offset 0) which
>> copes with USB specifics, but CPPI 4.1 itself doesn't know about USB anything.
>
> CPPI 4.1 was made for USB transfers.
>

I have been dealing with CPPI hardware on KeyStone platforms (CPPI 4.2). 
  Our experiences with this DMA hardware may help with CPPI 4.1 on 
earlier generations.

CPPI 4.2 serves as a truly common interface to a number of hardware 
blocks on KeyStone SoCs - including Ethernet, RapidIO, Crypto 
accelerators, and a bunch of other accelerator thingies.  Given the 
commonality across subsystems, we've built a shared CPPI 4.2 DMA-Engine 
implementation.  You can take a sneak peek at this implementation at [1].

Based on our experience with fitting multiple subsystems on top of this 
DMA-Engine driver, I must say that the DMA-Engine interface has proven 
to be a less than ideal fit for the network driver use case.

The first problem is that the DMA-Engine interface expects to "push" 
completed traffic up into the upper layer as a part of its callback. 
This doesn't fit cleanly with NAPI, which expects to "pull" completed 
traffic from below in the NAPI poll.  We've somehow kludged together a 
solution around this, but it isn't very elegant.

The second problem is one of binding fixed DMA resources to fixed users. 
  AFAICT, the stock DMA-Engine mechanism works best when one DMA 
resource is as good as any other.  To get over this problem, we've added 
support for named channels, and drivers specifically request for a DMA 
resource by name.  Again, this is less than ideal.

We found that virtio devices offer a more elegant solution to this 
problem.  First, the virtqueue interface is a much better fit into NAPI 
(callback --> napi schedule, napi poll --> get_buf), and this eliminates 
the need for aforementioned kludges in the code.  Second, the virtio 
device infrastructure nicely uses the device model to solve the problem 
of binding DMA users to specific DMA resources.

These patches haven't (yet) been posted on the MLs, but you can peek at 
[2].  While we are on the topic, I'd certainly appreciate feedback on 
the concept of using virtqueues as an interface to peripheral 
independent packet oriented DMA hardware. :-)

Cheers
-- Cyril

[1] - 
http://arago-project.org/git/projects/?p=linux-keystone.git;a=shortlog;h=refs/heads/rebuild/23-drivers-dmaengine
[2] - 
http://arago-project.org/git/projects/?p=linux-keystone.git;a=shortlog;h=refs/heads/rebuild/21-drivers-virtio
