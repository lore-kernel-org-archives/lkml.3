Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbaHYVBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:01:21 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61583 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaHYVBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:01:20 -0400
Message-ID: <53FBA416.7060406@gmail.com>
Date: Mon, 25 Aug 2014 23:01:10 +0200
From: Marcin Jabrzyk <marcin.jabrzyk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mathieu Poirier <mathieu.poirier@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        00regkh@linuxfoundation.org, Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        Robert Marklund <robbelibobban@gmail.com>,
        Tony Armitstead <Tony.Armitstead@arm.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11 v4] coresight: adding support for beagle and beagleXM
References: <1408554231-24321-1-git-send-email-mathieu.poirier@linaro.org>	<1408554231-24321-10-git-send-email-mathieu.poirier@linaro.org>	<53FA5B55.4000603@gmail.com> <CANLsYkxCdVm6cPtM9ub3Vwc24G9x6Vy9pt5pVMSPMxcksw6VHA@mail.gmail.com>
In-Reply-To: <CANLsYkxCdVm6cPtM9ub3Vwc24G9x6Vy9pt5pVMSPMxcksw6VHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

W dniu 25.08.2014 o 16:02, Mathieu Poirier pisze:
> On 24 August 2014 15:38, Marcin Jabrzyk <marcin.jabrzyk@gmail.com> wrote:
>> Hi,
>>
>> W dniu 20.08.2014 o 19:03, mathieu.poirier@linaro.org pisze:
>>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>>
>>> Currently supporting ETM and ETB.  Support for TPIU
>>> and SDTI are yet to be added.
>> Did you tried running the drivers on board or are there any special
>> preparation needed?
>> I've BeagleBoard-xM Rev. C applied your patches and enabled the
>> functions the in menuconfig.
>> But on dmesg I see that:
>>
>> [    0.685028] of_amba_device_create(): amba_device_add() failed (-19)
>> for /etb@5401b000
>> [    0.685119] of_amba_device_create(): amba_device_add() failed (-19)
>> for /etm@54010000
>>
>> There are no nodes according coresight in /sys/kernel/debug/ .
> Right, that is because there is a problem in mainline with enabling
> "emu_src_ck".  The call to "clk_prepare_enable()" returns without
> waiting for the clock to effectively be enabled, preventing the
> components from being discovered properly.
>
> The work around (non-upstreamable) is to have a driver getting a hold
> of the clock before AMBA devices are probed.  I can send you that code
> (10 lines) if need be.
Ok I can confirm that this patch works fine for BeagleBoard-xM. After
applying workaround for that clock the devices are properly discovered
and visible through sysfs entries.

Thanks,
Marcin
>
>> Best regards,
>> Marcin
>>
>>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>>> ---
>>>  arch/arm/boot/dts/omap3-beagle-xm.dts | 28 ++++++++++++++++++++++++++++
>>>  arch/arm/boot/dts/omap3-beagle.dts    | 28 ++++++++++++++++++++++++++++
>>>  2 files changed, 56 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
>>> index 1becefc..eec73d8 100644
>>> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
>>> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
>>> @@ -145,6 +145,34 @@
>>>                       };
>>>               };
>>>       };
>>> +
>>> +     etb@5401b000 {
>>> +             compatible = "arm,coresight-etb10", "arm,primecell";
>>> +             reg = <0x5401b000 0x1000>;
>>> +
>>> +             coresight-default-sink;
>>> +             clocks = <&emu_src_ck>;
>>> +             clock-names = "apb_pclk";
>>> +             port {
>>> +                     etb_in: endpoint {
>>> +                             slave-mode;
>>> +                             remote-endpoint = <&etm_out>;
>>> +                     };
>>> +             };
>>> +     };
>>> +
>>> +     etm@54010000 {
>>> +             compatible = "arm,coresight-etm3x", "arm,primecell";
>>> +             reg = <0x54010000 0x1000>;
>>> +
>>> +             clocks = <&emu_src_ck>;
>>> +             clock-names = "apb_pclk";
>>> +             port {
>>> +                     etm_out: endpoint {
>>> +                             remote-endpoint = <&etb_in>;
>>> +                     };
>>> +             };
>>> +     };
>>>  };
>>>
>>>  &omap3_pmx_wkup {
>>> diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
>>> index 3c3e6da..a151daf 100644
>>> --- a/arch/arm/boot/dts/omap3-beagle.dts
>>> +++ b/arch/arm/boot/dts/omap3-beagle.dts
>>> @@ -140,6 +140,34 @@
>>>                       };
>>>               };
>>>       };
>>> +
>>> +     etb@540000000 {
>>> +             compatible = "arm,coresight-etb10", "arm,primecell";
>>> +             reg = <0x5401b000 0x1000>;
>>> +
>>> +             coresight-default-sink;
>>> +             clocks = <&emu_src_ck>;
>>> +             clock-names = "apb_pclk";
>>> +             port {
>>> +                     etb_in: endpoint {
>>> +                             slave-mode;
>>> +                             remote-endpoint = <&etm_out>;
>>> +                     };
>>> +             };
>>> +     };
>>> +
>>> +     etm@54010000 {
>>> +             compatible = "arm,coresight-etm3x", "arm,primecell";
>>> +             reg = <0x54010000 0x1000>;
>>> +
>>> +             clocks = <&emu_src_ck>;
>>> +             clock-names = "apb_pclk";
>>> +             port {
>>> +                     etm_out: endpoint {
>>> +                             remote-endpoint = <&etb_in>;
>>> +                     };
>>> +             };
>>> +     };
>>>  };
>>>
>>>  &omap3_pmx_wkup {

