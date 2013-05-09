Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3EIKZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:25:01 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:54057 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab3EIKY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:24:59 -0400
Message-ID: <518B77C1.70107@st.com>
Date: Thu, 09 May 2013 11:17:37 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: dong.aisheng@linaro.org, sameo@linux.intel.com,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <201305081650.23264.arnd@arndb.de> <518A8C1D.3090600@st.com> <201305082148.10933.arnd@arndb.de>
In-Reply-To: <201305082148.10933.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
Thankyou for extending the discussion.

On 08/05/13 20:48, Arnd Bergmann wrote:
> On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
>> the pinctrl driver calls syconf_claim(np, "st,alt-control) to get a
>> field and then do a read/write on the field.
>>
>> Just in pinctrl driver we use around 50-100 sysconf registers scatters
>> across different groups.
>>
>> Without these new APIs, its very difficult to pass this information to
>> the drivers.
> But are those necessarily things you would configure using DT?
In last comment.
>
> If there are so many registers that are shared between mutliple
> subsystems, maybe using drivers/mfd/syscon for that is taking things
> further than you should, since it is unlike what any of the other
> SoC families need from syscon.
I agree, my initial approach was having a dedicated driver specific to
ST syscon, however syscon seems to do things very much similar to what
we want, so I have integrated those 3 functions in syscon.
Am happy to go back with my first approach of adding ST specific syscon
driver if no one is actually going to benefit with such a change to
syscon driver.

>
> Can you describe how your syscon registers are laid out?
On STiH416 SOC we have 9 SYSCONF(aka System Configuration
Registers)named banks/groups, each bank has its own memory map.
Each sysconf bank has number of 32 bit registers which vary from bank to
bank, like sysconf bank "sbc" has range from SYSTEM_CONFIG0 to
SYSTEM_CONFIG999 where as  sysconf bank "front" has range of
SYSTEM_CONFIG1000 to SYSTEM_CONFIG1999 and so on.

Each register is assigned with a unique SYCONF number, example:
SYSTEM_CONFIG100, SYSTEM_CONFIG101 , .. and so on.
Each sysconf contains bits of the IP configurations wired-up to the
sysconf register bits.

As example:

- Each pinctrl entry for set of 8 pins uses around 8-10 sysconfig
register to control pinconf and pin functions.
- IPs like Ethernet have few bit like Ethernet-Mode selection external
or internal phyclk wired up to bits in sysconf registers,
- Few clocks are controlled by sysconf registers.
- Reset to IPs are wired up to bits of sysconf same registers.
- ARM core soft reset is wired up to the sysconf registers...
And most of the IPs have similar requirements ......

Total layout of the sysconf changes per SOC, and the bit arrangements
aswell, however the core IP(pinctrl, etherenet ...) and logic to drive
those bits remains exactly same.

As the code remains the same, the information about the hardware
configuration and offsets to the registers are passed by device trees
using the node properties.

In general the requirements of the sysconf support to the SOC/driver
support is.
1> It should be able to read/write a sysconf register bits without
having to "if" each SOC in the code. So that code is totally abstracted.
Which is currently achieved by passing the information from the device
trees and the driver just uses the property to get it.
2> The infrastructure should protect the claimed registers from
over-writing by other drivers. We do this by claim-read/write-release
style API.
3> The driver should be able to set a group of sysconf registers bits to
a particular values before initialises the IP. I was thinking of doing
this in a same way as pinctrl state.

Any suggestion is most appreciated?

Thanks,
srini

> Which subsystems beside pinctrl need to directly interact
> with it? Is there any logical structure in it or do you just
> have tons of bits scattered around an MMIO area?
>
> 	Arnd
>

