Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaEGSf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:35:59 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:53779 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaEGSfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:35:55 -0400
MIME-Version: 1.0
In-Reply-To: <1398259168.4724.217.camel@iivanov-dev>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
	<1398259168.4724.217.camel@iivanov-dev>
Date: Wed, 7 May 2014 13:35:54 -0500
Message-ID: <CAL_JsqLWxbmWEiE4qxBPK+4KHoBKP+s-7Ubg6ef6GdR9NMaDjQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
From: Rob Herring <robherring2@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <bjorn@kryo.se>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 8:19 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
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
>> +     struct regmap *regmap;
>> +
>> +     regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
>> +     if (IS_ERR(regmap)) {
>> +             dev_dbg(&sdev->dev, "regmap creation failed.\n");
>> +             return PTR_ERR(regmap);
>> +     }
>> +
>> +     return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
>
> I think that this will not going to work. For example in this particular
> case, both controllers have "qcom,qpnp-revid" peripheral which is
> located at offset 0x100.
>
> And the result is:
>
> [    0.963944] sysfs: cannot create duplicate filename '/bus/platform/devices/100.revid'
>
> DT looks like this:
>
> spmi {
>         compatible = "qcom,spmi-pmic-arb";
>         reg-names = "core", "intr", "cnfg";
>         reg = <0xfc4cf000 0x1000>,
>               <0xfc4cb000 0x1000>,
>               <0xfc4ca000 0x1000>;
>
>         interrupt-names = "periph_irq";
>         interrupts = <0 190 0>;
>
>         qcom,ee = <0>;
>         qcom,channel = <0>;
>
>         #address-cells = <2>;
>         #size-cells = <0>;
>
>         interrupt-controller;
>         #interrupt-cells = <4>;
>
>         pm8941@0 {
>                 compatible = "qcom,pm8941";
>                 reg = <0x0 SPMI_USID>;
>
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>
>                 revid@100 {
>                         compatible = "qcom,qpnp-revid";
>                         reg = <0x100 0x100>;
>                 };
>         };
>
>         pm8841@4 {
>                 compatible = "qcom,pm8941";
>                 reg = <0x4 SPMI_USID>;
>
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>
>                 revid@100 {
>                         compatible = "qcom,qpnp-revid";
>                         reg = <0x100 0x100>;
>                 };
>         };
> };
>

I've created a similar test case, but do not reproduce the duplicate
name issue. In my test, the lack of ranges property causes translation
to fail so devices are named dev.N. The above should have similar
behavior.1

Here's the test case:

/ {
        testcase-data {
                platform-tests {
                        #address-cells = <1>;
                        #size-cells = <1>;

                        test-device@0 {
                                compatible = "test-device";
                                reg = <0x0 0>;

                                #address-cells = <1>;
                                #size-cells = <1>;

                                dev@100 {
                                        compatible = "test-sub-device";
                                        reg = <0x100 0x100>;
                                };
                        };

                        test-device@1 {
                                compatible = "test-device";
                                reg = <0x1 0>;

                                #address-cells = <1>;
                                #size-cells = <1>;

                                dev@100 {
                                        compatible = "test-sub-device";
                                        reg = <0x100 0x100>;
                                };
                        };
                };
        };
};


Rob
