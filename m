Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3IWUqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:46:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51113 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3IWUqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:46:10 -0400
Message-ID: <5240A88D.8030309@wwwdotorg.org>
Date: Mon, 23 Sep 2013 14:46:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>, Mark Brown <broonie@kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com> <20130919083050.GH16984@lee--X1> <20130919115501.GM21013@sirena.org.uk> <20130919120051.GG22389@lee--X1> <523AEE07.9090405@nvidia.com> <20130919122240.GI22389@lee--X1>
In-Reply-To: <20130919122240.GI22389@lee--X1>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 06:22 AM, Lee Jones wrote:
>>>>> Do the sub-nodes have their own properties? If so, it would be worth
>>>>> breaking them up as other OSes could reuse the specifics. If they do,
>>>>> then you need so put them in the binding. If they don't, then you do
>>>>> not require sub-nodes. The MFD core will ensure the sub-devices are
>>>>> probed and there is no requirement for the of_node to be assigned.
>>>> You do see some reusable IP blocks (like the regualtors on the wm831x
>>>> PMICs for example, they're repeated blocks) which can be reused but
>>>> generally they have a register base as part of the binding.  Personally
>>>> if it's just a property or two I'd probably just put them on the root
>>>> node for the device.
>>> Agreed. Besides, there doesn't seem to be *any* sub-device properties
>>> defined in the binding document. So what are you trying to achieve
>>> with the child nodes?
>>
>> I wanted to have the DT like:
>>
>> as3722 {
>>                 compatible = "ams,as3722";
>>                 reg = <0x40>;
>>
>>                 #interrupt-controller;
>>                 .....
>>
>>
>>                 regulators {
>>                             ldo1-in-supply = <..>;
>>                             ....
>>                             sd0 {
>>                                     regulator-name = "vdd-cpu";
>>                                     .....
>>                             };
>>                             sd1 {
>>                                     regulator-name = "vdd-ddr";
>>                                     .....
>>                             };
>>                             ....
>>             };
>> };
>>
>> And regulator driver should get the regulator node by their
>> pdev->dev.of_node.
>> Currently, in most of driver, we are having the code on regulator
>> driver to get "regulators" node from parent node which I want to
>> avoid.
> 
> Ah, I see. Yes, I believe the regulators should have their own node,

The use of a "regulators" node to keep all the regulator configuration
in one place seems fine...

> complete with a compatible string.

... but I see not reason why that node has to have a separate compatible
property, or /has/ to have a separate driver.

I think having a compatible value in this node would only be required if
the HW block that implements those registers is actually expected to be
shared between n different chips, and hence it's likely that you'd get
re-use out of a separate binding, driver, etc.

It's perfectly reasonable for the regulator MFD driver to know that the
binding for the top-level PMIC node has a regulators child node, and go
find it by name, and read whatever properties/nodes it needs directly
out of it. Writing code that way in no ways implies a need for a
compatible value.

> To have each regulator listed
> separately in the parent node seems a little messy. Just out of
> interest, how many regulators are we talking about here?
