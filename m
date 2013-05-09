Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3EIMEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:04:09 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:34350 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761Ab3EIMEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:04:05 -0400
Message-ID: <518B8F49.5020902@st.com>
Date: Thu, 09 May 2013 12:58:01 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, dong.aisheng@linaro.org,
        sameo@linux.intel.com, Rob Landley <rob@landley.net>,
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
        Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com> <201305081650.23264.arnd@arndb.de> <20130508150141.GA5057@opensource.wolfsonmicro.com> <518A8E6C.6070907@st.com> <20130509095143.GB7478@sirena.org.uk>
In-Reply-To: <20130509095143.GB7478@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/13 10:51, Mark Brown wrote:
> On Wed, May 08, 2013 at 06:42:04PM +0100, Srinivas KANDAGATLA wrote:
> 
> Fix your mailer to word wrap within paragraphs.
> 
Sorry about that.
>> Ultimately the syscon_write use the regmap_update_bits, however we
>> really want is the flexibility in using/referring the syscon
>> registers/bits in both device-trees and non-device tree cases.
> 
> So what you're looking for here is some way to offload discovery of
> register fields from the driver?

Exactly,

As the System configuration registers change per each SOC, and the
logic/code to drive still remain same across SOCs.

It makes sense to abstract the information of sysconf register and its
offsets from the driver, as we do not want to change the driver per each
SOC.

> 
>> The reason for these APIs, is the extent of syscon usage is very high
>> in ST set-top-box parts.
> 
>> Without these new APIs, its very difficult to pass this information to
>> the drivers.
> 
> I'm not 100% convinced that putting all this information into DT is a
> good idea,

Currently, we have two bits of information which come from device trees.
1> The syscon bank/group definition itself.
2> syscon register offsets and bits information to the drivers.

These are the 2 things which keep changing per each SOC.

There is no other way to pass this information to the drivers other than
passing them as part of their own device node and syscon node.

>  and to the extent that it is sensible it feels like something
> which might be useful with any device using register maps, not just
> syscon.

If you think this is going to be useful for other drivers, Am happy to
move this out of syscon to regmap something like adding
of_regmap_field_claim/regmap_field_claim/regmap_field_read/regmap_field_write/regmap_field_release
functions.

so any exiting drivers can still use the old syscon API to get the
regmap instance.
Alternatively they can use the new regmap APIs directly.

regmap_field_claim to claim bits of the register
of_regmap_field_claim DT version of reg_map_field_claim.
regmap_field_write to write to bits of register
regmap_field_read to bit of the register.
regmap_field_release to release the bits of the register.

For DT version it might involve adding new member to struct
regmap_config to lookup regmap by phandle, so that regmap can get hold
of regmap instance from device tree phandle.
syscon driver already does this in syscon_regmap_lookup_by_phandle()

On the device tree side it will look like:
syscfg_sbc:syscon@fe600000{
	compatible	= "syscon";
	reg		= <0xfe600000 0x1000>;
};

node {
	property-1 = <&syscfg_sbc 10 0 31>;
};

property has "phandle", register_offset, lsb, msb.

On the driver side, it can just use the API's like

field = of_regmap_field_claim(np, "property-1");
regmap_field_write(field, val);
regmap_field_release(field);

All this involves is very minimal code change in syscon and a new APIs
and DT awareness into regmap.

What do you think?

Thanks,
srini

>  For example many MFDs have similar needs - essentially the
> system controllers are just a particular kind of MFD.  To me that says
> that this should be outside syscon so other things can use it.

> 

