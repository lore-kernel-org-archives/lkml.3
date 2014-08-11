Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaHKFkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:40:41 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46363 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaHKFkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <1407337366.2475.108.camel@iivanov-dev>
References: <1405610748-7583-5-git-send-email-iivanov@mm-sol.com>
	<1405626085-14069-1-git-send-email-iivanov@mm-sol.com>
	<20140722214643.GH19700@sonymobile.com>
	<53D04996.2030902@codeaurora.org>
	<CACRpkdbNqNO8Hy5XndWs4gLBGWR+2_VaQveBUaeREUeVXv27dQ@mail.gmail.com>
	<53D1A371.1000108@codeaurora.org>
	<1406301329.2475.25.camel@iivanov-dev>
	<1407337366.2475.108.camel@iivanov-dev>
Date: Sun, 10 Aug 2014 22:40:36 -0700
Message-ID: <CAJAp7OiaJBHCHFDO5AF_Dsd8NZE4RYp763V7sSRb7uH8StwuVw@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 1/4] pinctrl: Update Qualcomm pm8xxx GPIO
 parameters definitions
From: Bjorn Andersson <bjorn@kryo.se>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 8:02 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> On Fri, 2014-07-25 at 18:15 +0300, Ivan T. Ivanov wrote:
>> On Thu, 2014-07-24 at 17:23 -0700, Stephen Boyd wrote:
>> > On 07/24/14 08:40, Linus Walleij wrote:
>> > > On Thu, Jul 24, 2014 at 1:47 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> > >
>> > >>> Please add these constants to the table of valid power-source values and use
>> > >>> something like I did to translate them to register values - it makes the DT
>> > >>> much more readable.
>> > >> The DT could be similarly readable if we had a bunch of #defines for the
>> > >> different VIN settings that resolved to the final register value for
>> > >> that pmic. Something like PM8921_GPIO1_14_VPH, PM8921_GPIO19_36_VPH,
>> > >> etc. There would be a lot of them, but then the driver could be really
>> > >> simple and just jam whatever value is in the DT into the register
>> > >> without having to bounce through a mapping table in software to figure
>> > >> out the register value.
>
> This is ok.
>

I'm not sure I think the "optimization" is worth the cluttered names
of these defines, but I will give it a spin and see how it looks!

>> If we did this for the functions also then I
>> > >> believe we achieve readability without requiring a bunch of drivers for
>> > >> each and every single pmic?
>

Either we have a table like the other pinctrl drivers, or we just go
with custom parsing where we shove the register value straight into
devicetree. Although the latter would reduce the number of mapping
tables we need in the kernel, it seems to not follow the general way
of doing things with pinctrl.

[...]
>
> Furthermore meaning of number 2 and 3, which represent PMIC GPIO Special
> Function 1 and 2 are not consistent across PMIC chips. For example KEYPD
> function in PM8038 is encoded with 3, but in PM8058 it is 2.
>
> I tend to agree with Bjorn that "function" property should be "normal",
> "paired", "func1", "func2","dtest1", "dtest2", "dtest3", "dtest4" and we
> can add new property "qcom,mode" which will select between digital/analog
> input/output.
>

Note that for GPIOs we have normal/gpio, paried and a set of functions
(if we ignore the dtest ones). And for MPPs we have digital and analog
as paired and unpaired. Input/output should be controlled with the
separate means already available (gpio api, output-{low,high}.

> In DT include file we can still have something like this:
>
> /* To be used with "function = <>" */
> #define QCOM_GPIO_FUNC_NORMAL           "normal"
> #define QCOM_GPIO_FUNC_PAIRED           "paired"
> #define QCOM_GPIO_FUNC_FUNC1            "func1"
> #define QCOM_GPIO_FUNC_FUNC2            "func2"
> ...
>
> #define PM8038_GPIO1_2_LPG_DRV          QCOM_GPIO_FUNC_FUNC1
> #define PM8038_GPIO3_5V_BOOST_EN        QCOM_GPIO_FUNC_FUNC1
> #define PM8038_GPIO4_SSBI_ALT_CLK       QCOM_GPIO_FUNC_FUNC1
> #define PM8038_GPIO5_6_EXT_REG_EN       QCOM_GPIO_FUNC_FUNC1
> #define PM8038_GPIO10_11_EXT_REG_EN     QCOM_GPIO_FUNC_FUNC1
> #define PM8038_GPIO6_7_CLK              QCOM_GPIO_FUNC_FUNC1
> #define PM8038_GPIO9_BAT_ALRM_OUT       QCOM_GPIO_FUNC_FUNC1
> #define PM8038_GPIO6_12_KYPD_DRV        QCOM_GPIO_FUNC_FUNC2
>
> #define PM8058_GPIO7_8_MP3_CLK          QCOM_GPIO_FUNC_FUNC1
> #define PM8058_GPIO7_8_BCLK_19P2MHZ     QCOM_GPIO_FUNC_FUNC2
> #define PM8058_GPIO9_26_KYPD_DRV        QCOM_GPIO_FUNC_FUNC1
> #define PM8058_GPIO21_23_UART_TX        QCOM_GPIO_FUNC_FUNC2
> #define PM8058_GPIO24_26_LPG_DRV        QCOM_GPIO_FUNC_FUNC2
> #define PM8058_GPIO33_BCLK_19P2MHZ      QCOM_GPIO_FUNC_FUNC1
> #define PM8058_GPIO34_35_MP3_CLK        QCOM_GPIO_FUNC_FUNC1
> #define PM8058_GPIO36_BCLK_19P2MHZ      QCOM_GPIO_FUNC_FUNC1
> #define PM8058_GPIO37_UPL_OUT           QCOM_GPIO_FUNC_FUNC1
> #define PM8058_GPIO37_UART_M_RX         QCOM_GPIO_FUNC_FUNC2
> #define PM8058_GPIO38_XO_SLEEP_CLK      QCOM_GPIO_FUNC_FUNC1
> #define PM8058_GPIO38_39_CLK_32KHZ      QCOM_GPIO_FUNC_FUNC2
> #define PM8058_GPIO39_MP3_CLK           QCOM_GPIO_FUNC_FUNC1
> #define PM8058_GPIO40_EXT_BB_EN         QCOM_GPIO_FUNC_FUNC1
>
> #define PM8917_GPIO9_18_KEYP_DRV        QCOM_GPIO_FUNC_FUNC1
> #define PM8917_GPIO20_BAT_ALRM_OUT      QCOM_GPIO_FUNC_FUNC1
> #define PM8917_GPIO21_23_UART_TX        QCOM_GPIO_FUNC_FUNC2
> #define PM8917_GPIO25_26_EXT_REG_EN     QCOM_GPIO_FUNC_FUNC1
> #define PM8917_GPIO37_38_XO_SLEEP_CLK   QCOM_GPIO_FUNC_FUNC1
> #define PM8917_GPIO37_38_MP3_CLK        QCOM_GPIO_FUNC_FUNC2
> ...

If we're going to maintain this "table" in the kernel then I would
greatly prefer that we just stick with the standard way of
representing it in the pinctrl drivers. My concern is still related to
me lacking the appropriate documentation to create these tables.

I introduced the necessary tables for pm8058 and pm8921 and it looks
reasonable. I'll try to finish it up tomorrow and send out a copy for
you to have a look.

Regards,
Bjorn
