Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaBDPud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:50:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37240 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaBDPua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:50:30 -0500
Message-ID: <52F10C3D.7000507@ti.com>
Date: Tue, 4 Feb 2014 17:50:21 +0200
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Fritz <chf.fritz@googlemail.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>
Subject: Re: OMAP: clock DT conversion issues with omap36xx
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>
In-Reply-To: <1390994505.5023.32.camel@mars>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 01:21 PM, Christoph Fritz wrote:
> On Tue, 2014-01-28 at 18:02 +0100, Christoph Fritz wrote:
>> On Tue, 2014-01-28 at 15:40 +0200, Tero Kristo wrote:
>>>
>>>>> Due to a regression since next-20140122 the following errors are present:
>>>>>
>>>>>    - pin sys_clkout2, which gets configured to 24 Mhz by the fourth patch
>>>>>      in this set, erroneously outputs only 12 Mhz.
>>>>>      Just out of curiosity, configuring it to 48 Mhz puts out desired 24 Mhz.
>>>>>
>>>>>    - omap_dss, which gets configured by the third patch in this set, fails
>>>>>      to do 'dss_set_fck_rate(fck);' in
>>>>>      drivers/video/omap2/dss/dss.c:dss_setup_default_clock() which leads to:
>>>>>
>>>>>       | omapdss_dss: probe of omapdss_dss failed with error -22
>>>>>       | omapdss CORE error: Failed to initialize DSS platform driver
>>>>>       | panel-dpi panel-dpi.0: failed to find video source 'dpi.0
>>>>>
>>>>>     Both regressions seem to have something to do with the clock framework.
>>>>>     Could this be related to the DT clock conversion patches?
>>>>
>>>
>>> Yea its definitely possible, as the clock DT conversion touches pretty
>>> much everything. Have you tried whether this works properly with legacy
>>> boot? Personally I don't have access to any omap3 devices that would
>>> have display and have no possibility to check this out myself. Anyway,
>>> my initial guess is that some clock divider setup might be wrong with
>>> omap3, or we are missing some ti,set-rate-parent flag for some clock
>>> node which prevents escalating clk_set_rate properly. However, it should
>>> be easy to debug this by looking at the clock node in question, and its
>>> parent nodes to see if there are any problems.
>>
>> Currently I only analyzed sys_clkout2 (see attachments for full
>> clk_summary files):
>>
>> clk_summary__next-20140115__works_as_expected:
>>               dpll4_m2_ck        1           1            96000000
>>                  dpll4_m2x2_ck   1           1            96000000
>>                     omap_192m_alwon_fck 1           1            96000000
>>                        omap_96m_alwon_fck 1           2            96000000
>>                           per_96m_fck 0           6            96000000
>>                              mcbsp4_fck 0           1            96000000
>>                              mcbsp3_fck 0           2            96000000
>>                              mcbsp2_fck 0           2            96000000
>>                           cm_96m_fck 2           3            96000000
>>                              clkout2_src_ck 1           1            96000000
>>                                 sys_clkout2 1           1            24000000
>>
>> For real, on pin sys_clkout2 are correctly 24 Mhz measured.
>>
>> clk_summary__next-20140124__sysclkout2_dss_fails:
>>               dpll4_m2_ck        1           1            96000000
>>                  dpll4_m2x2_mul_ck 1           1            192000000
>>                     dpll4_m2x2_ck 1           1            192000000
>>                        omap_192m_alwon_fck 0           0            192000000
>>                        omap_96m_alwon_fck 1           2            192000000
>>                           per_96m_fck 0           6            192000000
>>                              mcbsp4_fck 0           1            192000000
>>                              mcbsp3_fck 0           2            192000000
>>                              mcbsp2_fck 0           2            192000000
>>                           cm_96m_fck 2           3            192000000
>>                              clkout2_src_ck 1           1            192000000
>>                                 sys_clkout2 1           1            24000000
>>
>> For real, on pin sys_clkout2 are only ~12 Mhz measured.

Hey Christoph,

I had a chance to look at this in more detail, and it looks like your 
patch above was almost the correct one (except that I think you modified 
wrong property and also modified the clock node for all omap3 variants.) 
Can you give this one a shot? Can you also send me the clk-summary dump 
with this patch (with the relevant nodes)?

From: Tero Kristo <t-kristo@ti.com>
Date: Tue, 4 Feb 2014 17:37:37 +0200
Subject: [PATCH] ARM: dts: omap36xx: fix omap96m_alwon_fck

OMAP36xx has different hardware implementation for the omap96m_alwon_fck
compared to other OMAP3 variants. Reflect this properly in the dts file.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
  arch/arm/boot/dts/omap36xx-clocks.dtsi |    4 ++++
  1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap36xx-clocks.dtsi 
b/arch/arm/boot/dts/omap36xx-clocks.dtsi
index 2fcf253..24869cb 100644
--- a/arch/arm/boot/dts/omap36xx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap36xx-clocks.dtsi
@@ -70,6 +70,10 @@
  	};
  };

+&omap_96m_alwon_fck {
+	clock-div = <2>;
+};
+
  &cm_clockdomains {
  	dpll4_clkdm: dpll4_clkdm {
  		compatible = "ti,clockdomain";
-- 
1.7.9.5

