Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3LJI44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:56:56 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:59502 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3LJI4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:56:53 -0500
MIME-Version: 1.0
In-Reply-To: <5292EED4.2080708@ti.com>
References: <1384158778-27555-1-git-send-email-yuvaraj.cd@samsung.com>
	<1384158778-27555-3-git-send-email-yuvaraj.cd@samsung.com>
	<5292EED4.2080708@ti.com>
Date: Tue, 10 Dec 2013 14:26:52 +0530
Message-ID: <CAKuRcOK89Zvh+WD4-VC7UvdR1dp1WfJvr89Pej5TZ=9KRx4-rQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] ARM: dts: Enable ahci sata and sata phy
From: Yuvaraj Kumar <yuvaraj.cd@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, sachin.kamat@linaro.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Christoffer Dall <christoffer.dall@linaro.org>, aditya.ps@samsung.com,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 12:01 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Monday 11 November 2013 02:02 PM, Yuvaraj Kumar C D wrote:
>> This patch adds dt entry for ahci sata controller and its
>> corresponding phy controller.phy node has been added w.r.t
>> new generic phy framework.
>>
>> Changes since V1:
>>       1.Minor changes to node name convention
>>       2.Updated binding document.
>>
>> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
>> ---
>>  .../devicetree/bindings/ata/exynos-sata-phy.txt    |   19 +++++++++++++-----
>>  .../devicetree/bindings/ata/exynos-sata.txt        |   17 +++++++++++-----
>>  arch/arm/boot/dts/exynos5250-arndale.dts           |    9 ++++++++-
>>  arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 ++------
>>  arch/arm/boot/dts/exynos5250.dtsi                  |   21 ++++++++++++++++----
>>  5 files changed, 53 insertions(+), 21 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt b/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
>> index 37824fa..a679e17 100644
>> --- a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
>> +++ b/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
>> @@ -4,11 +4,20 @@ SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
>>  Each SATA PHY controller should have its own node.
>>
>>  Required properties:
>> -- compatible        : compatible list, contains "samsung,exynos5-sata-phy"
>> +- compatible        : compatible list, contains "samsung,exynos5250-sata-phy"
>
> What if someone is already using samsung,exynos5-sata-phy? You can mark the old
> one as deprecated and add the new compatible string.
AFAIK, there is no driver using it.In the initial version of sata phy
driver,only the DT part has been merged.So it was there
without any user.
>>  - reg               : <registers mapping>
>>
>>  Example:
>> -        sata@ffe07000 {
>> -                compatible = "samsung,exynos5-sata-phy";
>> -                reg = <0xffe07000 0x1000>;
>> -        };
>> +     sata_phy: sata-phy@12170000 {
>> +             compatible = "samsung,exynos5250-sata-phy";
>> +             reg = <0x12170000 0x1ff>;
>> +             clocks = <&clock 287>;
>> +             clock-names = "sata_phyctrl";
>> +             #phy-cells = <0>;
>> +             #address-cells = <1>;
>> +             #size-cells = <1>;
>> +             ranges;
>> +             sataphy-pmu {
>> +                     reg = <0x10040724 0x4>;
>> +                     };
>
> alignment problem..
ok
>> +     };
>> diff --git a/Documentation/devicetree/bindings/ata/exynos-sata.txt b/Documentation/devicetree/bindings/ata/exynos-sata.txt
>> index 0849f10..8ec7327 100644
>> --- a/Documentation/devicetree/bindings/ata/exynos-sata.txt
>> +++ b/Documentation/devicetree/bindings/ata/exynos-sata.txt
>> @@ -8,10 +8,17 @@ Required properties:
>>  - interrupts        : <interrupt mapping for SATA IRQ>
>>  - reg               : <registers mapping>
>>  - samsung,sata-freq : <frequency in MHz>
>> +- phys              : as mentioned in phy-bindings.txt
>> +- phy-names         : as mentioned in phy-bindings.txt
>>
>>  Example:
>> -        sata@ffe08000 {
>> -                compatible = "samsung,exynos5-sata";
>> -                reg = <0xffe08000 0x1000>;
>> -                interrupts = <115>;
>> -        };
>> +     sata@122F0000 {
>
> use lower case here..
ok
>> +             compatible = "snps,dwc-ahci";
>> +             samsung,sata-freq = <66>;
>> +             reg = <0x122F0000 0x1ff>;
> here too..
ok
>> +             interrupts = <0 115 0>;
>> +             clocks = <&clock 277>, <&clock 143>;
>> +             clock-names = "sata", "sclk_sata";
>> +             phys = <&sata_phy>;
>> +             phy-names = "sata-phy";
>> +     };
>> diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
>> index b77a37e..434e4f3 100644
>> --- a/arch/arm/boot/dts/exynos5250-arndale.dts
>> +++ b/arch/arm/boot/dts/exynos5250-arndale.dts
>> @@ -381,7 +381,14 @@
>>       };
>>
>>       i2c@121D0000 {
>> -             status = "disabled";
>> +             samsung,i2c-sda-delay = <100>;
>> +             samsung,i2c-max-bus-freq = <40000>;
>> +             samsung,i2c-slave-addr = <0x38>;
>> +
>> +             sata-phy {
>> +                     compatible = "sata-phy-i2c";
>
> Do you have documentation for this compatible string?
Sorry missed that.I will add in the next version.
>> +                     reg = <0x38>;
>> +             };
>>       };
>>
>>       mmc_0: mmc@12200000 {
>> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> index 13746df..eeeeef9 100644
>> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> @@ -90,16 +90,12 @@
>>               samsung,i2c-max-bus-freq = <40000>;
>>               samsung,i2c-slave-addr = <0x38>;
>>
>> -             sata-phy {
>> -                     compatible = "samsung,sata-phy";
>> +             sata-phy@38 {
>> +                     compatible = "sata-phy-i2c";
>>                       reg = <0x38>;
>>               };
>>       };
>>
>> -     sata@122F0000 {
>> -             samsung,sata-freq = <66>;
>> -     };
>> -
>>       i2c@12C80000 {
>>               samsung,i2c-sda-delay = <100>;
>>               samsung,i2c-max-bus-freq = <66000>;
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
>> index 80b5df5..d24db31 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -46,6 +46,7 @@
>>               i2c6 = &i2c_6;
>>               i2c7 = &i2c_7;
>>               i2c8 = &i2c_8;
>> +             i2c9 = &i2c_9;
>>               pinctrl0 = &pinctrl_0;
>>               pinctrl1 = &pinctrl_1;
>>               pinctrl2 = &pinctrl_2;
>> @@ -216,16 +217,28 @@
>>       };
>>
>>       sata@122F0000 {
>> -             compatible = "samsung,exynos5-sata-ahci";
>> +             compatible = "snps,dwc-ahci";
>> +             samsung,sata-freq = <66>;
>>               reg = <0x122F0000 0x1ff>;
>>               interrupts = <0 115 0>;
>>               clocks = <&clock 277>, <&clock 143>;
>>               clock-names = "sata", "sclk_sata";
>> +             phys = <&sata_phy>;
>> +             phy-names = "sata-phy";
>>       };
>>
>> -     sata-phy@12170000 {
>> -             compatible = "samsung,exynos5-sata-phy";
>> +     sata_phy: sata-phy@12170000 {
>> +             compatible = "samsung,exynos5250-sata-phy";
>>               reg = <0x12170000 0x1ff>;
>> +             clocks = <&clock 287>;
>> +             clock-names = "sata_phyctrl";
>> +             #phy-cells = <0>;
>> +             #address-cells = <1>;
>> +             #size-cells = <1>;
>> +             ranges;
>> +             sataphy-pmu {
>> +                     reg = <0x10040724 0x4>;
>> +                     };
>
> alignment problem here..
Ok
>
> Thanks
> Kishon
