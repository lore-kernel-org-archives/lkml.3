Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaE2V0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:26:08 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58243 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738AbaE2V0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:26:05 -0400
Message-ID: <5387A5E7.5040905@linaro.org>
Date: Thu, 29 May 2014 22:25:59 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>	<1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com>	<53875E17.6010406@linaro.org> <CAJAp7Ogi8s+_HHUA0zt3dM6ssDHxeQ1xNFvvO7AbSyz9o6n+9w@mail.gmail.com>
In-Reply-To: <CAJAp7Ogi8s+_HHUA0zt3dM6ssDHxeQ1xNFvvO7AbSyz9o6n+9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29/05/14 19:38, Bjorn Andersson wrote:
> On Thu, May 29, 2014 at 9:19 AM, Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org> wrote:
>>> +- reg:
>>> +       Usage: required
>>> +       Value type: <prop-encoded-array>
>>> +       Definition: two entries specifying the RPM's message ram and ipc
>>> register
>>> +
>>> +- reg-names:
>>> +       Usage: required
>>> +       Value type: <string-array>
>>> +       Definition: must contain the following, in order:
>>> +                   "msg_ram"
>>> +                   "ipc"
>>
>>
>> +1 for kumar's comment.
>>
>> cant enforce the order here. should fix it in the driver.
>>
>
> Yes I can, this is as decided by the devicetree maintainers. The order
> of e.g. reg and interrupts must be defined.
>
Does not make sense. Unless Am missing something obvious.
Having reg-names/interrupt-names would give driver flexibility to get 
the resources by name, as long as the order of reg and reg-names match.

So the order of reg is really not really necessary. Unless the driver is 
coded to access it via index.

Hardly 1/2 bindings documents enforce this.


>>> += SUBDEVICES
>>> +
>>> +The RPM exposes resources to its subnodes. The below bindings specify the
>>> set
>>> +of valid subnodes that can operate on these resources.
>>
>>
>> Why should these devices be on sub nodes?
>>
>> Any reason not to implement it like this,
>>
>> rpm: rpm@108000 {
>>          compatible = "qcom,rpm-msm8960";
>>
>>          reg = <0x108000 0x1000 0x2011008 0x4>;
>>
>>          interrupts = <0 19 0>, <0 21 0>, <0 22 0>;
>>          interrupt-names = "ack", "err", "wakeup";
>> };
>>
>> pm8921_s1: pm8921-s1 {
>>          compatible = "qcom,rpm-pm8921-smps";
>>
>>          regulator-min-microvolt = <1225000>;
>>          regulator-max-microvolt = <1225000>;
>>          regulator-always-on;
>>
>>          qcom,rpm = <&rpm QCOM_RPM_PM8921_S1>;
>>          qcom,switch-mode-frequency = <3200000>;
>>          qcom,hpm-threshold = <100000>;
>> };
>>
>> This would simplify the driver code too and handle the interface neatly then
>> depending on device hierarchy.
>> rpm would be a interface library to the clients. Makes the drivers more
>> independent, and re-usable if we do this way.
>
> The subnodes doesn't describe separate pieces of hardware but rather
> pieces of the rpm, that's why they should live inside the rpm. There
> will not be any re-use of these drivers outside having a rpm as
> parent.
>
> I do have some patches for family b, where I'm moving things around a
> little bit in the implementation to be able to re-use child-devices
> where that makes sense (clock implementation is the same for the two).
> But that is implementation specific and does not affect the dt.
>
Good point, Am more of thinking of some other SOCs might have similar pmic.

>
> Implementation wise, having the individual subnodes as children in the
> device model makes a lot of sense, as the children should be probed
> when the rpm appears and when the rpm goes away it should bring down
> all subnodes. If there was any power management it would be the same
> thing.
Thats great, you have already thought about it.
>
> So I think this makes for a cleaner implementation; all I need to do
> is to call of_platform_populate at the end of the probe and in remove
> I need to tell the children that they should go away. I do not need to
> support any phandle based lookups and separate life cycle management.
>
Am ok with either approaches.

>>
>> [...
>>
>>> +- qcom,force-mode-none:
>>> +       Usage: optional (default if no other qcom,force-mode is specified)
>>> +       Value type: <empty>
>>> +       Defintion: indicates that the regulator should not be forced to
>>> any
>>> +                  particular mode
>>> +
>>> +- qcom,force-mode-lpm:
>>> +       Usage: optional
>>> +       Value type: <empty>
>>> +       Definition: indicates that the regulator should be forced to
>>> operate in
>>> +                   low-power-mode
>>> +
>>> +- qcom,force-mode-auto:
>>> +       Usage: optional (only available for 8960/8064)
>>> +       Value type: <empty>
>>> +       Definition: indicates that the regulator should be automatically
>>> pick
>>> +                   operating mode
>>> +
>>> +- qcom,force-mode-hpm:
>>> +       Usage: optional (only available for 8960/8064)
>>> +       Value type: <empty>
>>> +       Definition: indicates that the regulator should be forced to
>>> operate in
>>> +                   high-power-mode
>>> +
>>> +- qcom,force-mode-bypass: (only for 8960/8064)
>>> +       Usage: optional (only available for 8960/8064)
>>> +       Value type: <empty>
>>> +       Definition: indicates that the regulator should be forced to
>>> operate in
>>> +                   bypass mode
>>> +
>>
>> ...]
>>
>> Probably qcom,force-mode:
>>          Usage: optional.
>>          Value type: <string>
>>
>>          Definition: must be one of:
>>          "none"
>>          "lpm"
>>          "auto"
>>          "hpm"
>>          "bypass"
>>
>> Makes it much simpler, as they seems to be mutually exclusive. simillar
>> comments apply to other bindings too.
>
> Please see my answer to Kumar.
>
Ok. I don’t have a strong feeling on any of those 3 approaches.

Thanks,
srini
>
> Thanks for the comments!
>
> Regards,
> Bjorn
>
