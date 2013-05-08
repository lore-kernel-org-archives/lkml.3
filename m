Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3EHRiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:38:03 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:49355 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756924Ab3EHRiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:38:00 -0400
Message-ID: <518A8C1D.3090600@st.com>
Date: Wed, 08 May 2013 18:32:13 +0100
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
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com> <201305081650.23264.arnd@arndb.de>
In-Reply-To: <201305081650.23264.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou for your comments.
On 08/05/13 15:50, Arnd Bergmann wrote:
> On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> This patch introduces syscon_claim, syscon_read, syscon_write,
>> syscon_release APIs to help drivers to use syscon registers in much more
>> flexible way.
>>
>> With this patch, a driver can claim few/all bits in the syscon registers
>> and do read/write and then release them when its totally finished with
>> them, in the mean time if another driver requests same bits or registers
>> the API will detect conflit and return error to the second request.
>>
>> Reason to introduce this API.
>> System configuration/control registers are very basic configuration
>> registers arranged in groups across ST Settop Box parts. These registers
>> are independent of IP itself. Many IPs, clock, pad and other functions
>> are wired up to these registers.
>>
>> In many cases a single syconf register contains bits related to multiple
>> devices, and therefore it need to be shared across multiple drivers at
>> bit level. The same IP block can have different syscon mappings on
>> different SOCs.
>>
>> Typically in a SOC there will be more than hundreds of these registers,
>> which are again divided into groups.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> CC: Stuart Menefy <stuart.menefy@st.com>
> My feeling is that syscon is the wrong place for this functionality,
> since regmap already handles (some of?) these issues. If you need
> additional synchronization, it's probably best to extend regmap
> as needed so other code besides syscon can take advantage of that
> as well.
Its not just synchronisation that we are looking for.
It also the usability, drivers want to just refer to a syscon
register/bits of it from device trees/non-devicetrees.

The extent of syscon usage is very high in ST set-top-box parts.
As example, ST pinctrl driver uses use bits of the syscon register to
control alternate functions, and many other parameters of pinconf.

In device tree we do something like:
        syscfg_sbc: syscon@fe600000{
            compatible      = "syscon";
            reg        = <0xfe600000 0xb4>;         
        };
and in pinctrl dts file
    st,alt-control    = <&syscfg_sbc  0 0 31>;
    st,od-control    = <&syscfg_sbc  9 0 7>;

the pinctrl driver calls syconf_claim(np, "st,alt-control) to get a
field and then do a read/write on the field.

Just in pinctrl driver we use around 50-100 sysconf registers scatters
across different groups.

Without these new APIs, its very difficult to pass this information to
the drivers.

Thanks,
srini
>
> 	Arnd
>

