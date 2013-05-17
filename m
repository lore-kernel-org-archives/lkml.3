Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3EQOhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:37:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab3EQOhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:37:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: srinivas.kandagatla@st.com
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
Date: Fri, 17 May 2013 16:36:49 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: dong.aisheng@linaro.org, sameo@linux.intel.com,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <201305082148.10933.arnd@arndb.de> <518B77C1.70107@st.com>
In-Reply-To: <518B77C1.70107@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305171636.49627.arnd@arndb.de>
X-Provags-ID: V02:K0:evgwKotYjcdYmuKOhdQjZz+46OujDkgvR79iThsl8n1
 NNKOHE+5qJrcwyUjP1DA/S/jlKPiyyP7jtxDOYVreeqejeQ62O
 +1Bvr4k5eLMhKQfdWQiT8Sy70DfiNsKLmR01pPh2wJXdV9wPDo
 faC85B35unUDP7hV5HuUoTg5/NB8L/hXz/ptBzzXq3FHTdJevB
 Dyh69A9Gc2R/UgfjJXoj0WER8sJk/2HsIslI7qRdAuSyAvFq/Z
 9piYnFWJohpiFKQGe+C0kZhmCdz2EVpxfl2MCys/sGH36tn1Xa
 hGeSDsNWm9lGJlvtceIIovpuxrgjwlmuRmtPoDjH5VQ3XBQc0o
 SzhO7umIaaaw3VWpCVTY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 May 2013, Srinivas KANDAGATLA wrote:
> On 08/05/13 20:48, Arnd Bergmann wrote:
> I agree, my initial approach was having a dedicated driver specific to
> ST syscon, however syscon seems to do things very much similar to what
> we want, so I have integrated those 3 functions in syscon.
> Am happy to go back with my first approach of adding ST specific syscon
> driver if no one is actually going to benefit with such a change to
> syscon driver.

That would at least be less controversial.

> > Can you describe how your syscon registers are laid out?
> On STiH416 SOC we have 9 SYSCONF(aka System Configuration
> Registers)named banks/groups, each bank has its own memory map.
> Each sysconf bank has number of 32 bit registers which vary from bank to
> bank, like sysconf bank "sbc" has range from SYSTEM_CONFIG0 to
> SYSTEM_CONFIG999 where as  sysconf bank "front" has range of
> SYSTEM_CONFIG1000 to SYSTEM_CONFIG1999 and so on.
> 
> Each register is assigned with a unique SYCONF number, example:
> SYSTEM_CONFIG100, SYSTEM_CONFIG101 , .. and so on.
> Each sysconf contains bits of the IP configurations wired-up to the
> sysconf register bits.

Ok.

> As example:
> 
> - Each pinctrl entry for set of 8 pins uses around 8-10 sysconfig
> register to control pinconf and pin functions.
> - IPs like Ethernet have few bit like Ethernet-Mode selection external
> or internal phyclk wired up to bits in sysconf registers,
> - Few clocks are controlled by sysconf registers.
> - Reset to IPs are wired up to bits of sysconf same registers.
> - ARM core soft reset is wired up to the sysconf registers...
> And most of the IPs have similar requirements ......
> 
> Total layout of the sysconf changes per SOC, and the bit arrangements
> aswell, however the core IP(pinctrl, etherenet ...) and logic to drive
> those bits remains exactly same.

It sounds like you really need a driver with high-level interfaces
for the bits that change by each core and are needed by otherwise
identical drivers, like the Ethernet driver you mention.

I would not go as far as you did describing the individual bits in
the device node using these however. That driver can be layered on
top of the existing syscon driver, but hardcode the bits for each
SoC it knows of.

For drivers that are essentially just wrappers around sysconf,
I would make them one driver per SoC and use a low-level interface
but still hardcode the offsets in the driver instead of using DT
to find the registers.

The pinctrl and reset drivers are examples of this.

> In general the requirements of the sysconf support to the SOC/driver
> support is.
> 1> It should be able to read/write a sysconf register bits without
> having to "if" each SOC in the code. So that code is totally abstracted.
> Which is currently achieved by passing the information from the device
> trees and the driver just uses the property to get it.

The goal sounds fine, just the method is a bit more complex than necessary
here I think.

> 2> The infrastructure should protect the claimed registers from
> over-writing by other drivers. We do this by claim-read/write-release
> style API.

I don't understand this part. Is it about atomicity of accesses to
32-bit registers when you only want to change a bit? That is something
the regmap interface handles already.

If this is about drivers touching registers they should not touch
in the first place, I think it should not be needed at all, because
that would be a driver bug, and you can't really protect yourself
from broken drivers anyway.

> 3> The driver should be able to set a group of sysconf registers bits to
> a particular values before initialises the IP. I was thinking of doing
> this in a same way as pinctrl state.

That does not fit well with the model we use for other subsystems. If possible,
try to use the existing abstractions for clock, regulator, pinctrl, reset,
etc. and call generic interfaces from the driver. When that does not work,
create a high-level function call from your sysconf driver to do a particular
thing (e.g. stih_sysconf_ethernet_set_phy_mode()) rather than set up random
bits from the driver.

	Arnd
