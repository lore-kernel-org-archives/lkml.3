Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaDZA2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:28:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39742 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaDZA2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:28:08 -0400
Message-ID: <535AFD96.90505@gmail.com>
Date: Fri, 25 Apr 2014 17:28:06 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com> <1398259168.4724.217.camel@iivanov-dev>
In-Reply-To: <1398259168.4724.217.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/2014 6:19 AM, Ivan T. Ivanov wrote:
> 
> Hi,
> 
> On Tue, 2014-04-22 at 17:31 -0700, Courtney Cavin wrote:
>> From: Josh Cartwright <joshc@codeaurora.org>
>>
>> The Qualcomm 8941 and 8841 PMICs are components used with the Snapdragon
>> 800 series SoC family.  This driver exists largely as a glue mfd component,
>> it exists to be an owner of an SPMI regmap for children devices
>> described in device tree.
>>
> 
> Thanks. This is exactly what I have planed to do :-)
> 
>> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
>> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
>> ---
>>  drivers/mfd/Kconfig  | 13 +++++++++++
>>  drivers/mfd/Makefile |  1 +
>>  drivers/mfd/pm8x41.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 77 insertions(+)
>>  create mode 100644 drivers/mfd/pm8x41.c
>>
> 
> <snip>
> 
>> +
>> +static int pm8x41_probe(struct spmi_device *sdev)
>> +{
>> +	struct regmap *regmap;
>> +
>> +	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
>> +	if (IS_ERR(regmap)) {
>> +		dev_dbg(&sdev->dev, "regmap creation failed.\n");
>> +		return PTR_ERR(regmap);
>> +	}
>> +
>> +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> 
> I think that this will not going to work. For example in this particular
> case, both controllers have "qcom,qpnp-revid" peripheral which is
> located at offset 0x100.
> 
> And the result is:
> 
> [    0.963944] sysfs: cannot create duplicate filename '/bus/platform/devices/100.revid'

The duplicate filename error is because pm8x41_probe() is calling of_platform_populate()
directly.

If that call is removed then there is no attempt to create a revid file in
/sys/bus/platform/devices.  If I add your pm8841@4 node to my dts file, then
the 100.revid file is properly created at

  /sys/firmware/devicetree/base/soc/qcom,spmi@fc4cf000/pm8841@4/qcom,revid@100

and no attempt is made to create /sys/bus/platform/devices/100.revid

This appears to be correct to me, because I do not think revid should be created as
a platform device.

> 
> DT looks like this:
> 
> spmi {
> 	compatible = "qcom,spmi-pmic-arb";
> 	reg-names = "core", "intr", "cnfg";
> 	reg = <0xfc4cf000 0x1000>,
> 	      <0xfc4cb000 0x1000>,
> 	      <0xfc4ca000 0x1000>;
> 
> 	interrupt-names = "periph_irq";
> 	interrupts = <0 190 0>;
> 
> 	qcom,ee = <0>;
> 	qcom,channel = <0>;
> 
> 	#address-cells = <2>;
> 	#size-cells = <0>;
> 
> 	interrupt-controller;
> 	#interrupt-cells = <4>;
> 
> 	pm8941@0 {
> 		compatible = "qcom,pm8941";
> 		reg = <0x0 SPMI_USID>;
> 
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		revid@100 {
> 			compatible = "qcom,qpnp-revid";
> 			reg = <0x100 0x100>;
> 		};
> 	};
> 
> 	pm8841@4 {

        ^^^^^^^^  typo nit - that should be pm8941@4.
                  The nit does not change what you reported though.

> 		compatible = "qcom,pm8941";
> 		reg = <0x4 SPMI_USID>;
> 
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		revid@100 {
> 			compatible = "qcom,qpnp-revid";
> 			reg = <0x100 0x100>;
> 		};
> 	};
> };
> 
> Any suggestions?

Remove of_platform_populate() from pm8x41_probe().  Do you know of any
other reason it can not be removed?

-Frank
