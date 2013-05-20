Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3ETM5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:57:06 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:34687 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796Ab3ETM5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:57:02 -0400
Message-ID: <519A1BBB.2070903@st.com>
Date: Mon, 20 May 2013 13:48:59 +0100
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
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <201305082148.10933.arnd@arndb.de> <518B77C1.70107@st.com> <201305171636.49627.arnd@arndb.de>
In-Reply-To: <201305171636.49627.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
Thankyou for the comments.

On 17/05/13 15:36, Arnd Bergmann wrote:
> On Thursday 09 May 2013, Srinivas KANDAGATLA wrote:
>> On 08/05/13 20:48, Arnd Bergmann wrote:
>> I agree, my initial approach was having a dedicated driver specific to
>> ST syscon, however syscon seems to do things very much similar to what
>> we want, so I have integrated those 3 functions in syscon.
>> Am happy to go back with my first approach of adding ST specific syscon
>> driver if no one is actually going to benefit with such a change to
>> syscon driver.
> 
> That would at least be less controversial.

yes I agree.
> 
>> Total layout of the sysconf changes per SOC, and the bit arrangements
>> aswell, however the core IP(pinctrl, etherenet ...) and logic to drive
>> those bits remains exactly same.
> 
> It sounds like you really need a driver with high-level interfaces
> for the bits that change by each core and are needed by otherwise
> identical drivers, like the Ethernet driver you mention.
> 
> I would not go as far as you did describing the individual bits in
> the device node using these however. That driver can be layered on
> top of the existing syscon driver, but hardcode the bits for each
> SoC it knows of.
Some of the drivers like Ethernet already provide higher level
interfaces via callbacks. We did implement such a callbacks per each SOC
in non-DT case, and ended up having code duplicated for each SOC.

On the other hand using device trees to describe the HW
configuration(sysconfs) made more sense and got rid of SOC specific
callbacks.

> 
> For drivers that are essentially just wrappers around sysconf,
> I would make them one driver per SoC and use a low-level interface
> but still hardcode the offsets in the driver instead of using DT
> to find the registers.
> 
> The pinctrl and reset drivers are examples of this.

In pinctrl bindings case, I think we could do better job by replacing
the existing bindings of sysconfs for a group of banks with just two
integer offsets. This would mean that, we can still use the a common
driver across the SOCs.

And w.r.t to reset, we are planning on using sysconf based
reset-controller API sitting underneath the reset-controller subsystem.
Passing the information from device trees would be much clear and
flexible than adding new driver per/SOC.

>> 2> The infrastructure should protect the claimed registers from
>> over-writing by other drivers. We do this by claim-read/write-release
>> style API.
> 
> I don't understand this part. Is it about atomicity of accesses to
> 32-bit registers when you only want to change a bit? That is something
> the regmap interface handles already.

I forget to mention a important point here, the protection is at bit
level for the sysconfs. Some of sysconfs have bits shared across IPs, so
protecting them while the IP is still using it is what we are trying to
achieve with sysconf-claim/release apis.
While it may be overkill, but In past it has found bugs and been helpful
with a meaning full debug output.

>> 3> The driver should be able to set a group of sysconf registers bits to
>> a particular values before initialises the IP. I was thinking of doing
>> this in a same way as pinctrl state.
> 
> That does not fit well with the model we use for other subsystems. If possible,
> try to use the existing abstractions for clock, regulator, pinctrl, reset,
> etc. and call generic interfaces from the driver. When that does not work,
> create a high-level function call from your sysconf driver to do a particular
> thing (e.g. stih_sysconf_ethernet_set_phy_mode()) rather than set up random
> bits from the driver.
I agree going for a higher level api in this case makes sense.

Thanks,
srini

> 
> 	Arnd
> 
> 

