Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3EXQPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:15:51 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:56113 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721Ab3EXQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:15:48 -0400
Message-ID: <519F900E.308@st.com>
Date: Fri, 24 May 2013 17:06:38 +0100
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
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Stephen GALLIMORE <stephen.gallimore@st.com>
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <201305171636.49627.arnd@arndb.de> <519A1BBB.2070903@st.com> <201305232344.11974.arnd@arndb.de>
In-Reply-To: <201305232344.11974.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/13 22:44, Arnd Bergmann wrote:
Thankyou Arnd for extending this discussion.
> On Monday 20 May 2013, Srinivas KANDAGATLA wrote:
>> On 17/05/13 15:36, Arnd Bergmann wrote:
>>
>> On the other hand using device trees to describe the HW
>> configuration(sysconfs) made more sense and got rid of SOC specific
>> callbacks.
> 
> I'm sure it's possible to reduce the duplication without going all
> the way to describing every bit in DT.

Yes, I agree with you. I think just passing the offset information from
DT would enough in cases like Ethernet or USB where the sysconf
registers tend to be mostly standard. And the generic higher level
function should be able to do the rest.

>> I forget to mention a important point here, the protection is at bit
>> level for the sysconfs. Some of sysconfs have bits shared across IPs, so
>> protecting them while the IP is still using it is what we are trying to
>> achieve with sysconf-claim/release apis.
>> While it may be overkill, but In past it has found bugs and been helpful
>> with a meaning full debug output.
> 
> Can you give an example of something that is shared across multiple IPs?
> 
> Are those always done in the way that you have e.g. the ethernet pinctrl
> in the same register as the usb pinctrl, or could you have an ethernet
> pinctrl setting mixed together with the usb clock setting for instance?
> 
> If the hardware has been designed in a sensible way rather than just
> grown by randomly adding bits in open spaces, I would assume that it's
> possible to have high-level interfaces built around ranges of registers
> rather than arbitrary subsets of registers.

We have decided to go with using higher level functions as you
suggested, hopefully based on regmap with some helper functions on top
of it.

System configuration registers in the past used to very much shared
across IPs, However with the new chips they seems be mostly dedicated
registers for specific IP configurations.
As we have no plans to support very old chips, So I think I can move
this out bit level information from device tree and add a higher level
functions to be accessed by the drivers.

As an example the below sysconf register for a STi7105 chip(Very old
SOC) looks like:
SYSTEM_CONFIG7 Comms/Ethernet config control register

[31:28] RESERVED
[27] ENMII:
	1: MII mode 0: Reverse MII mode
[26:25] PHY_INTF_SELECT: Selects the type of Ethernet mode
	00: MII mode (Default)
	01: Reserved
	1x: Reserved
[23] GLOBAL_POWER_DOWN:
	1: Activate low power
[24] RESERVED
	0: Normal mode
[22] DAA_CONFIG_CTRL: DAA configuration control
[21] RESERVED
[20] MAC_SPEED_SEL:
	1: Indicates that the MAC is running at 100 Mbps speed
	0: Indicates that the MAC is running at 10 Mbps speed
[19] RESERVED
[18] RMII_MODE:
	1: RMII interface activated
	0: MII interface activated
[17] MIIM_DIO_SELECT:
	1: MIIM_DIO from external input, else from GMAC
	0: All MII pads in input mode
[16] ETHERNET_INTERFACE_ON:
	1: Ethernet on (pads enables controlled by MAC)
[15:13] RESERVED
[12] DAA_SERIAL_MODE: DAA serial interface mode select pin

[11] SC1_COND_VCC_ENABLE: Enables control of smart card VCC upon
bit in the PDES.
[10] SC_DETECT_VPP_POL:
	1: Output pin SC_NOT_SETVPP is inverted of PDES_SC_SETVPP
	0: Output pin SC_NOT_SETVPP is PDES_SC_SETVPP
[9] IRB_DATA_OUT_POL_OD: Selection of polarity of IRB output signal
routed as alternate function

...
...
Thanks,
srini

> 
> 	Arnd
> 
> 

