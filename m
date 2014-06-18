Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965847AbaFRKbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:31:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40455 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965039AbaFRKbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:31:44 -0400
Message-ID: <53A169FC.70907@ti.com>
Date: Wed, 18 Jun 2014 15:59:16 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, "Menon, Nishanth" <nm@ti.com>, <kishon@ti.com>,
        <george.cherian@ti.com>, <balbi@ti.com>, <balajitk@ti.com>,
        <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v4 3/4] ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods
References: <1398274237-24510-1-git-send-email-rogerq@ti.com> <1398274559-24777-1-git-send-email-rogerq@ti.com> <53A14784.1030008@ti.com>
In-Reply-To: <53A14784.1030008@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2014 01:32 PM, Roger Quadros wrote:
> On 04/23/2014 08:35 PM, Roger Quadros wrote:
>> From: Nikhil Devshatwar <nikhil.nd@ti.com>
>>
>> Add hwmods for ocp2scp3 and sata modules.

>From what I see this is actually adding the ocp2scp3 data and fixing up some
of the sata data which is already added and erroneous.

It would help if this is split up and the changelog explains whats fixed up for
sata and why. Like for instance I see the opt clock data being removed but no
mention of why.
 
>>
>> [Roger Q] Clean up.
>>
>> CC: Benoit Cousson <bcousson@baylibre.com>
>> CC: Paul Walmsley <paul@pwsan.com>
>> Signed-off-by: Balaji T K <balajitk@ti.com>
>> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Tested-by: Roger Quadros <rogerq@ti.com>
> against 3.16-rc1, no dependency patches needed.
> 
> Nishant/Rajendra,
> 
> Could you please review this? We need this for 3.16 SATA support and
> Paul won't take this in without your reviewed-by tag. Thanks.
> 
> cheers,
> -roger
> 
>> ---
>>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 31 ++++++++++++++++++++++++++-----
>>  1 file changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> index 810c205..b02a4ab 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> @@ -1215,6 +1215,30 @@ static struct omap_hwmod dra7xx_ocp2scp1_hwmod = {
>>  	},
>>  };
>>  
>> +/* ocp2scp3 */
>> +static struct omap_hwmod dra7xx_ocp2scp3_hwmod;
>> +
>> +/* l4_cfg -> ocp2scp3 */
>> +static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp3 = {
>> +	.master		= &dra7xx_l4_cfg_hwmod,
>> +	.slave		= &dra7xx_ocp2scp3_hwmod,
>> +	.clk		= "l4_root_clk_div",
>> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>> +};

All hwmod data files are organized in a certain way with all the hwmod/IP block info on top
and Interface structs at the bottom. Can we follow the same for ocp2scp3? It helps with better
readability.
 
>> +
>> +static struct omap_hwmod dra7xx_ocp2scp3_hwmod = {
>> +	.name		= "ocp2scp3",
>> +	.class		= &dra7xx_ocp2scp_hwmod_class,
>> +	.clkdm_name	= "l3init_clkdm",

No main_clk?

regards,
Rajendra

>> +	.prcm = {
>> +		.omap4 = {
>> +			.clkctrl_offs = DRA7XX_CM_L3INIT_OCP2SCP3_CLKCTRL_OFFSET,
>> +			.context_offs = DRA7XX_RM_L3INIT_OCP2SCP3_CONTEXT_OFFSET,
>> +			.modulemode   = MODULEMODE_HWCTRL,
>> +		},
>> +	},
>> +};
>> +
>>  /*
>>   * 'qspi' class
>>   *
>> @@ -1268,9 +1292,6 @@ static struct omap_hwmod_class dra7xx_sata_hwmod_class = {
>>  };
>>  
>>  /* sata */
>> -static struct omap_hwmod_opt_clk sata_opt_clks[] = {
>> -	{ .role = "ref_clk", .clk = "sata_ref_clk" },
>> -};
>>  
>>  static struct omap_hwmod dra7xx_sata_hwmod = {
>>  	.name		= "sata",
>> @@ -1278,6 +1299,7 @@ static struct omap_hwmod dra7xx_sata_hwmod = {
>>  	.clkdm_name	= "l3init_clkdm",
>>  	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>>  	.main_clk	= "func_48m_fclk",
>> +	.mpu_rt_idx	= 1,
>>  	.prcm = {
>>  		.omap4 = {
>>  			.clkctrl_offs = DRA7XX_CM_L3INIT_SATA_CLKCTRL_OFFSET,
>> @@ -1285,8 +1307,6 @@ static struct omap_hwmod dra7xx_sata_hwmod = {
>>  			.modulemode   = MODULEMODE_SWCTRL,
>>  		},
>>  	},
>> -	.opt_clks	= sata_opt_clks,
>> -	.opt_clks_cnt	= ARRAY_SIZE(sata_opt_clks),
>>  };
>>  
>>  /*
>> @@ -2682,6 +2702,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>>  	&dra7xx_l4_per1__mmc4,
>>  	&dra7xx_l4_cfg__mpu,
>>  	&dra7xx_l4_cfg__ocp2scp1,
>> +	&dra7xx_l4_cfg__ocp2scp3,
>>  	&dra7xx_l3_main_1__qspi,
>>  	&dra7xx_l4_cfg__sata,
>>  	&dra7xx_l4_cfg__smartreflex_core,
>>
> 

