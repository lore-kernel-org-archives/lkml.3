Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaHFPDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:03:06 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54841 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768AbaHFPDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:03:04 -0400
Message-ID: <1407337366.2475.108.camel@iivanov-dev>
Subject: Re: [PATCH RESEND v2 1/4] pinctrl: Update Qualcomm pm8xxx GPIO
 parameters definitions
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Wed, 06 Aug 2014 18:02:46 +0300
In-Reply-To: <1406301329.2475.25.camel@iivanov-dev>
References: <1405610748-7583-5-git-send-email-iivanov@mm-sol.com>
	 <1405626085-14069-1-git-send-email-iivanov@mm-sol.com>
	 <20140722214643.GH19700@sonymobile.com> <53D04996.2030902@codeaurora.org>
	 <CACRpkdbNqNO8Hy5XndWs4gLBGWR+2_VaQveBUaeREUeVXv27dQ@mail.gmail.com>
	 <53D1A371.1000108@codeaurora.org> <1406301329.2475.25.camel@iivanov-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 18:15 +0300, Ivan T. Ivanov wrote:
> On Thu, 2014-07-24 at 17:23 -0700, Stephen Boyd wrote:
> > On 07/24/14 08:40, Linus Walleij wrote:
> > > On Thu, Jul 24, 2014 at 1:47 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > >
> > >>> Please add these constants to the table of valid power-source values and use
> > >>> something like I did to translate them to register values - it makes the DT
> > >>> much more readable.
> > >> The DT could be similarly readable if we had a bunch of #defines for the
> > >> different VIN settings that resolved to the final register value for
> > >> that pmic. Something like PM8921_GPIO1_14_VPH, PM8921_GPIO19_36_VPH,
> > >> etc. There would be a lot of them, but then the driver could be really
> > >> simple and just jam whatever value is in the DT into the register
> > >> without having to bounce through a mapping table in software to figure
> > >> out the register value. 

This is ok.

> If we did this for the functions also then I
> > >> believe we achieve readability without requiring a bunch of drivers for
> > >> each and every single pmic?


> > > Not sure but it sounds like you want to make the device tree a jam table,
> > > (know about individual register offsets, sequences etc). That has been
> > > throrougly NACKed in the past, because DT is not Open Firmware.
> > >
> > > The exception is pinctrl-single which is restricted to single register
> > > per pin use cases and is still a point of contention...
> > >
> > 
> > I'm not proposing a jam table. I'm proposing that we make the
> > function/source property convenient to the driver by having the actual
> > function field value encoded there instead of some string that has to be
> > translated through a table in a driver. There's still going to be
> > shifting and masking of bits in the driver to put the value in the right
> > place in the register, but we avoid needing N number of drivers for each
> > pmic just to translate strings into integers (for functions) and
> > integers into other integers (for the power source). 
> 
> This sounds good to me. Drawback is that we will have custom 
> function parsing code, but I will try and see what that looks like.

Hm, I played with this, using numbers for functions. Unfortunately it is
not easy possible to hack existing DT pin-control parsing code to use
numbers instead strings, so I ended coping Samsung parsing code, but unless
this is separated in library we will end with huge code duplication for
little benefit.

Furthermore meaning of number 2 and 3, which represent PMIC GPIO Special
Function 1 and 2 are not consistent across PMIC chips. For example KEYPD
function in PM8038 is encoded with 3, but in PM8058 it is 2.

I tend to agree with Bjorn that "function" property should be "normal", 
"paired", "func1", "func2","dtest1", "dtest2", "dtest3", "dtest4" and we
can add new property "qcom,mode" which will select between digital/analog
input/output.

In DT include file we can still have something like this:

/* To be used with "function = <>" */
#define QCOM_GPIO_FUNC_NORMAL		"normal"
#define QCOM_GPIO_FUNC_PAIRED		"paired"
#define QCOM_GPIO_FUNC_FUNC1		"func1"
#define QCOM_GPIO_FUNC_FUNC2		"func2"
...

#define PM8038_GPIO1_2_LPG_DRV		QCOM_GPIO_FUNC_FUNC1
#define PM8038_GPIO3_5V_BOOST_EN	QCOM_GPIO_FUNC_FUNC1
#define PM8038_GPIO4_SSBI_ALT_CLK	QCOM_GPIO_FUNC_FUNC1
#define PM8038_GPIO5_6_EXT_REG_EN	QCOM_GPIO_FUNC_FUNC1
#define PM8038_GPIO10_11_EXT_REG_EN	QCOM_GPIO_FUNC_FUNC1
#define PM8038_GPIO6_7_CLK		QCOM_GPIO_FUNC_FUNC1
#define PM8038_GPIO9_BAT_ALRM_OUT	QCOM_GPIO_FUNC_FUNC1
#define PM8038_GPIO6_12_KYPD_DRV	QCOM_GPIO_FUNC_FUNC2

#define PM8058_GPIO7_8_MP3_CLK		QCOM_GPIO_FUNC_FUNC1
#define PM8058_GPIO7_8_BCLK_19P2MHZ	QCOM_GPIO_FUNC_FUNC2
#define PM8058_GPIO9_26_KYPD_DRV	QCOM_GPIO_FUNC_FUNC1
#define PM8058_GPIO21_23_UART_TX	QCOM_GPIO_FUNC_FUNC2
#define PM8058_GPIO24_26_LPG_DRV	QCOM_GPIO_FUNC_FUNC2
#define PM8058_GPIO33_BCLK_19P2MHZ	QCOM_GPIO_FUNC_FUNC1
#define PM8058_GPIO34_35_MP3_CLK	QCOM_GPIO_FUNC_FUNC1
#define PM8058_GPIO36_BCLK_19P2MHZ	QCOM_GPIO_FUNC_FUNC1
#define PM8058_GPIO37_UPL_OUT		QCOM_GPIO_FUNC_FUNC1
#define PM8058_GPIO37_UART_M_RX		QCOM_GPIO_FUNC_FUNC2
#define PM8058_GPIO38_XO_SLEEP_CLK	QCOM_GPIO_FUNC_FUNC1
#define PM8058_GPIO38_39_CLK_32KHZ	QCOM_GPIO_FUNC_FUNC2
#define PM8058_GPIO39_MP3_CLK		QCOM_GPIO_FUNC_FUNC1
#define PM8058_GPIO40_EXT_BB_EN		QCOM_GPIO_FUNC_FUNC1

#define PM8917_GPIO9_18_KEYP_DRV	QCOM_GPIO_FUNC_FUNC1
#define PM8917_GPIO20_BAT_ALRM_OUT	QCOM_GPIO_FUNC_FUNC1
#define PM8917_GPIO21_23_UART_TX	QCOM_GPIO_FUNC_FUNC2
#define PM8917_GPIO25_26_EXT_REG_EN	QCOM_GPIO_FUNC_FUNC1
#define PM8917_GPIO37_38_XO_SLEEP_CLK	QCOM_GPIO_FUNC_FUNC1
#define PM8917_GPIO37_38_MP3_CLK	QCOM_GPIO_FUNC_FUNC2
...


