Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3JKDVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 23:21:37 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55678 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3JKDVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 23:21:34 -0400
Message-ID: <52576EBA.9000502@linaro.org>
Date: Thu, 10 Oct 2013 23:21:30 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH 2/5] usb: gadget: s3c-hsotg: support configurable UTMI
 PHY width
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org> <1381140752-312-3-git-send-email-matt.porter@linaro.org> <20131010152922.GF28375@radagast> <5256DBD0.8030008@linaro.org> <20131010174620.GC19802@radagast> <A2CA0424C0A6F04399FB9E1CD98E030458E16893@US01WEMBX2.internal.synopsys.com> <5256FAFA.1020509@linaro.org>
In-Reply-To: <5256FAFA.1020509@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 03:07 PM, Matt Porter wrote:
> On 10/10/2013 01:57 PM, Paul Zimmerman wrote:
>>> From: Felipe Balbi [mailto:balbi@ti.com]
>>> Sent: Thursday, October 10, 2013 10:46 AM
>>>
>>> On Thu, Oct 10, 2013 at 12:54:40PM -0400, Matt Porter wrote:
>>>> On 10/10/2013 11:29 AM, Felipe Balbi wrote:
>>>>> On Mon, Oct 07, 2013 at 06:12:29AM -0400, Matt Porter wrote:
>>>>>> Extend dwc2 binding with an optional utmi phy width property.
>>>>>> Enable the s3c-hsotg.c driver to use standard dwc2 binding
>>>>>> and enable configuration of the UTMI phy width based on the
>>>>>> property.
>>>>>>
>>>>>> Signed-off-by: Matt Porter <matt.porter@linaro.org>
>>>>>> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
>>>>>> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
>>>>>> ---
>>>>>>   Documentation/devicetree/bindings/staging/dwc2.txt |  4 ++++
>>>>>>   drivers/usb/gadget/s3c-hsotg.c                     | 18
>>>>>> +++++++++++++++++-
>>>>>>   drivers/usb/gadget/s3c-hsotg.h                     |  1 +
>>>>>>   3 files changed, 22 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt
>>> b/Documentation/devicetree/bindings/staging/dwc2.txt
>>>>>> index 1a1b7cf..fb6b8ee 100644
>>>>>> --- a/Documentation/devicetree/bindings/staging/dwc2.txt
>>>>>> +++ b/Documentation/devicetree/bindings/staging/dwc2.txt
>>>>>> @@ -6,10 +6,14 @@ Required properties:
>>>>>>   - reg : Should contain 1 register range (address and length)
>>>>>>   - interrupts : Should contain 1 interrupt
>>>>>>
>>>>>> +Optional properties:
>>>>>> +- snps,phy-utmi-width: Must contain the UTMI data width (either 8
>>>>>> or 16)
>>>>>
>>>>> isn't this available in any of the configuration registers ?
>>>>
>>>> Yes and no. HWCFG4 has a UTMI data width field. However, it has 3
>>>> valid states, "8", "16", or "8 or 16". The BCM281xx implementation is
>>>> set to the latter and the attached phy is 8-bit.
>>>>
>>>> Looking at dwc2 prior to Matthijs Kooijman's patch [1] which starts
>>>> validating the value of phy_utmi_width in that driver, the pci.c
>>>> dwc2_module_params .phy_utmi_width field there even had the comment,
>>>> "/* 16 bits - NOT DETECTABLE */". The autodetect code in
>>>> dwc2_set_param_phy_utmi_width() will fail if HWCFG4 has the "8 or 16"
>>>> option as it just decides to default to a phy width of 16 if nothing
>>>> is configured by the platform glue. This property would also allow
>>>> this issue to be addressed in that driver.
>>>
>>> fair enough, but I'd really like to hear from DT folks if your suggested
>>> binding is acceptable. It seems like we can equally argue that it's a SW
>>> configuration or HW description.
>>
>> It's definitely a HW description - the width of the UTMI data connection.
>>
>> But, which PHY is this? Does it have a register that could tell what
>> the data width is? The dwc2 core has an (optional) PHY Vendor Control
>> Register that allows reading the PHY registers.
>
> This is the integrated PHY on the bcm28155 part (the entire
> bcm281xx/11351 family shares it). My register doc doesn't show the
> optional PHY vendor control register as being present in this dwc2
> implementation. I'll track down with the design team if this is
> accurate...but it appears we can't go that route.

The design team confirmed that we do not have any registers that can be 
accessed via the PHY Vendor Control Register. All PHY control registers 
are implemented in the MMIO control block which is supported in the PHY 
control driver later in this series.They also confirmed there's no other 
way to detect that it's an 8-bit data path.

-Matt

