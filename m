Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaKDLQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:16:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48379 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaKDLQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:16:33 -0500
Message-ID: <5458B55F.2010201@ti.com>
Date: Tue, 4 Nov 2014 16:45:43 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/3] arm: mach-omap2: omap_hwmod_43xx_data: add hwmod
 support for tscadc on am43x-evm
References: <1414741603-18233-1-git-send-email-vigneshr@ti.com> <1414741603-18233-3-git-send-email-vigneshr@ti.com> <20141031134459.GB24708@kahuna>
In-Reply-To: <20141031134459.GB24708@kahuna>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 31 October 2014 07:14 PM, Nishanth Menon wrote:
> On 13:16-20141031, Vignesh R wrote:
>> This patch adds hwmod support for tscadc to work on am43xx-evm. The am33xx
>> hwmod structures of tscadc has been moved to ipblock_data so that it can
>> be reused in am43xx. The clock domain names are separately set for am33xx
>> and am43xx. Thus tscadc dt entries can now be added to am43xx board
>> dt files.
>>
>> Signed-off-by: Vignesh R <vigneshr@ti.com>
>> ---
>>  .../mach-omap2/omap_hwmod_33xx_43xx_common_data.h  |  1 +
>>  .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c | 64 ++++++++++++++++++++++
>>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c         | 49 -----------------
>>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c         |  1 +
>>  4 files changed, 66 insertions(+), 49 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
>> index 6e57b8ad0db5..b92a7c7825fa 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
>> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
>> @@ -65,6 +65,7 @@ extern struct omap_hwmod_ocp_if am33xx_l4_ls__timer4;
>>  extern struct omap_hwmod_ocp_if am33xx_l4_ls__timer5;
>>  extern struct omap_hwmod_ocp_if am33xx_l4_ls__timer6;
>>  extern struct omap_hwmod_ocp_if am33xx_l4_ls__timer7;
>> +extern struct omap_hwmod_ocp_if am33xx_l4_wkup__adc_tsc;
>>  extern struct omap_hwmod_ocp_if am33xx_l3_main__tpcc;
>>  extern struct omap_hwmod_ocp_if am33xx_l3_main__tptc0;
>>  extern struct omap_hwmod_ocp_if am33xx_l3_main__tptc1;
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
>> index 7f44922ab540..ef14e56a3968 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
>> @@ -151,6 +151,54 @@ struct omap_hwmod_class am33xx_wkup_m3_hwmod_class = {
>>  };
>>  
>>  /*
>> + * 'adc/tsc' class
>> + * TouchScreen Controller (Anolog-To-Digital Converter)
>> + */
>> +static struct omap_hwmod_class_sysconfig am33xx_adc_tsc_sysc = {
>> +	.rev_offs	= 0x00,
>> +	.sysc_offs	= 0x10,
>> +	.sysc_flags	= SYSC_HAS_SIDLEMODE,
>> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>> +			SIDLE_SMART_WKUP),
>> +	.sysc_fields	= &omap_hwmod_sysc_type2,
>> +};
>> +
>> +static struct omap_hwmod_class am33xx_adc_tsc_hwmod_class = {
>> +	.name		= "adc_tsc",
>> +	.sysc		= &am33xx_adc_tsc_sysc,
>> +};
>> +
>> +struct omap_hwmod am33xx_adc_tsc_hwmod = {
>> +	.name		= "adc_tsc",
>> +	.class		= &am33xx_adc_tsc_hwmod_class,
>> +	.clkdm_name	= "l4_wkup_clkdm",
>> +	.main_clk	= "adc_tsc_fck",
>> +	.prcm		= {
>> +		.omap4  = {
>> +			.modulemode     = MODULEMODE_SWCTRL,
>> +		},
>> +	},
>> +};
>> +
>> +/* L4 WKUP -> ADC_TSC */
>> +static struct omap_hwmod_addr_space am33xx_adc_tsc_addrs[] = {
>> +	{
>> +		.pa_start	= 0x44E0D000,
>> +		.pa_end		= 0x44E0D000 + SZ_8K - 1,
>> +		.flags		= ADDR_TYPE_RT
>> +	},
>> +	{ }
>> +};
> 
> NAK. we dont want to see phy addresses in hwmod anymore. please add that
> to DT. I suggest doing that clean up prior to this patch.
> 

Will drop this and pass address from DT

>> +
>> +struct omap_hwmod_ocp_if am33xx_l4_wkup__adc_tsc = {
>> +	.master		= &am33xx_l4_wkup_hwmod,
>> +	.slave		= &am33xx_adc_tsc_hwmod,
>> +	.clk		= "dpll_core_m4_div2_ck",
>> +	.addr		= am33xx_adc_tsc_addrs,
>> +	.user		= OCP_USER_MPU,
>> +};
>> +
>> +/*
>>   * 'pru-icss' class
>>   * Programmable Real-Time Unit and Industrial Communication Subsystem
>>   */
>> @@ -1370,6 +1418,7 @@ static void omap_hwmod_am33xx_clkctrl(void)
>>  	CLKCTRL(am33xx_timer5_hwmod, AM33XX_CM_PER_TIMER5_CLKCTRL_OFFSET);
>>  	CLKCTRL(am33xx_timer6_hwmod, AM33XX_CM_PER_TIMER6_CLKCTRL_OFFSET);
>>  	CLKCTRL(am33xx_timer7_hwmod, AM33XX_CM_PER_TIMER7_CLKCTRL_OFFSET);
>> +	CLKCTRL(am33xx_adc_tsc_hwmod, AM33XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET);
>>  	CLKCTRL(am33xx_smartreflex0_hwmod,
>>  		AM33XX_CM_WKUP_SMARTREFLEX0_CLKCTRL_OFFSET);
>>  	CLKCTRL(am33xx_smartreflex1_hwmod,
>> @@ -1398,6 +1447,18 @@ static void omap_hwmod_am33xx_clkctrl(void)
>>  	CLKCTRL(am33xx_aes0_hwmod , AM33XX_CM_PER_AES0_CLKCTRL_OFFSET);
>>  }
>>  
>> +static void am33xx_hwmod_clockdomain(void)
>> +{
>> +	am33xx_l4_hs_hwmod.clkdm_name = "l4hs_clkdm";
>> +	am33xx_adc_tsc_hwmod.clkdm_name = "l4_wkup_clkdm";
>> +}
>> +
>> +static void am43xx_hwmod_clockdomain(void)
>> +{
>> +	am33xx_l4_hs_hwmod.clkdm_name = "l3_clkdm";
>> +	am33xx_adc_tsc_hwmod.clkdm_name = "l3s_tsc_clkdm";
>> +}
>> +
> 
> maybe do something similar to CLKCTRL macro?
> 

OK, I will create a macro for clkdm_name.

>>  static void omap_hwmod_am33xx_rst(void)
>>  {
>>  	RSTCTRL(am33xx_pruss_hwmod, AM33XX_RM_PER_RSTCTRL_OFFSET);
>> @@ -1409,6 +1470,7 @@ void omap_hwmod_am33xx_reg(void)
>>  {
>>  	omap_hwmod_am33xx_clkctrl();
>>  	omap_hwmod_am33xx_rst();
>> +	am33xx_hwmod_clockdomain();
>>  }
>>  
>>  static void omap_hwmod_am43xx_clkctrl(void)
>> @@ -1443,6 +1505,7 @@ static void omap_hwmod_am43xx_clkctrl(void)
>>  	CLKCTRL(am33xx_timer5_hwmod, AM43XX_CM_PER_TIMER5_CLKCTRL_OFFSET);
>>  	CLKCTRL(am33xx_timer6_hwmod, AM43XX_CM_PER_TIMER6_CLKCTRL_OFFSET);
>>  	CLKCTRL(am33xx_timer7_hwmod, AM43XX_CM_PER_TIMER7_CLKCTRL_OFFSET);
>> +	CLKCTRL(am33xx_adc_tsc_hwmod, AM43XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET);
>>  	CLKCTRL(am33xx_smartreflex0_hwmod,
>>  		AM43XX_CM_WKUP_SMARTREFLEX0_CLKCTRL_OFFSET);
>>  	CLKCTRL(am33xx_smartreflex1_hwmod,
>> @@ -1482,4 +1545,5 @@ void omap_hwmod_am43xx_reg(void)
>>  {
>>  	omap_hwmod_am43xx_clkctrl();
>>  	omap_hwmod_am43xx_rst();
>> +	am43xx_hwmod_clockdomain();
>>  }
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
>> index ce7d260495cb..c3ff14828850 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
>> @@ -88,37 +88,6 @@ static struct omap_hwmod am33xx_wkup_m3_hwmod = {
>>  };
>>  
>>  /*
>> - * 'adc/tsc' class
>> - * TouchScreen Controller (Anolog-To-Digital Converter)
>> - */
>> -static struct omap_hwmod_class_sysconfig am33xx_adc_tsc_sysc = {
>> -	.rev_offs	= 0x00,
>> -	.sysc_offs	= 0x10,
>> -	.sysc_flags	= SYSC_HAS_SIDLEMODE,
>> -	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>> -			SIDLE_SMART_WKUP),
>> -	.sysc_fields	= &omap_hwmod_sysc_type2,
>> -};
>> -
>> -static struct omap_hwmod_class am33xx_adc_tsc_hwmod_class = {
>> -	.name		= "adc_tsc",
>> -	.sysc		= &am33xx_adc_tsc_sysc,
>> -};
>> -
>> -static struct omap_hwmod am33xx_adc_tsc_hwmod = {
>> -	.name		= "adc_tsc",
>> -	.class		= &am33xx_adc_tsc_hwmod_class,
>> -	.clkdm_name	= "l4_wkup_clkdm",
>> -	.main_clk	= "adc_tsc_fck",
>> -	.prcm		= {
>> -		.omap4	= {
>> -			.clkctrl_offs	= AM33XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET,
>> -			.modulemode	= MODULEMODE_SWCTRL,
>> -		},
>> -	},
>> -};
>> -
>> -/*
>>   * Modules omap_hwmod structures
>>   *
>>   * The following IPs are excluded for the moment because:
>> @@ -426,24 +395,6 @@ static struct omap_hwmod_ocp_if am33xx_l4_wkup__gpio0 = {
>>  	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>>  };
>>  
>> -/* L4 WKUP -> ADC_TSC */
>> -static struct omap_hwmod_addr_space am33xx_adc_tsc_addrs[] = {
>> -	{
>> -		.pa_start	= 0x44E0D000,
>> -		.pa_end		= 0x44E0D000 + SZ_8K - 1,
>> -		.flags		= ADDR_TYPE_RT
>> -	},
>> -	{ }
>> -};
>> -
>> -static struct omap_hwmod_ocp_if am33xx_l4_wkup__adc_tsc = {
>> -	.master		= &am33xx_l4_wkup_hwmod,
>> -	.slave		= &am33xx_adc_tsc_hwmod,
>> -	.clk		= "dpll_core_m4_div2_ck",
>> -	.addr		= am33xx_adc_tsc_addrs,
>> -	.user		= OCP_USER_MPU,
>> -};
>> -
>>  static struct omap_hwmod_ocp_if am33xx_l4_hs__cpgmac0 = {
>>  	.master		= &am33xx_l4_hs_hwmod,
>>  	.slave		= &am33xx_cpgmac0_hwmod,
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
>> index fea01aa3ef42..3ce8d28c0f9a 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
>> @@ -809,6 +809,7 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
>>  	&am33xx_l4_ls__timer5,
>>  	&am33xx_l4_ls__timer6,
>>  	&am33xx_l4_ls__timer7,
>> +	&am33xx_l4_wkup__adc_tsc,
>>  	&am33xx_l3_main__tpcc,
>>  	&am33xx_l4_ls__uart2,
>>  	&am33xx_l4_ls__uart3,
>> -- 
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
