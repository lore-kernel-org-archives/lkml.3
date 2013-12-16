Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3LPS0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:26:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40174 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3LPS0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:26:41 -0500
Message-ID: <52AF45DB.9050302@wwwdotorg.org>
Date: Mon, 16 Dec 2013 11:26:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, swarren@nvidia.com, will.deacon@arm.com,
        thierry.reding@gmail.com, robherring2@gmail.com, joro@8bytes.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, galak@codeaurora.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 04/12] driver/core: populate devices in order for IOMMUs
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-5-git-send-email-hdoyu@nvidia.com> <20131212113920.70E8BC40637@trevor.secretlab.ca> <20131213021402.GB14192@kroah.com>
In-Reply-To: <20131213021402.GB14192@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 07:14 PM, Greg KH wrote:
> On Thu, Dec 12, 2013 at 11:39:20AM +0000, Grant Likely wrote:
>> On Thu, 12 Dec 2013 09:57:05 +0200, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
>>> IOMMU devices on the bus need to be poplulated first, then iommu
>>> master devices are done later.
>>>
>>> With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
>>> whether a device can be an iommu msater or not. If a device can, we'll
>>> defer to populate that device till an iommu device is populated. Then,
>>> those deferred iommu master devices are populated and configured with
>>> help of the already populated iommu device.

>>> This is related to the following discussion:
>>>   [RFC PATCH] Documentation: devicetree: add description for generic bus properties
>>>   http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/215042.html

>>> diff --git a/drivers/base/dd.c b/drivers/base/dd.c

>>> @@ -273,6 +274,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>>>  
>>>  	dev->driver = drv;
>>>  
>>> +	ret = of_iommu_attach(dev);
>>> +	if (ret)
>>> +		goto probe_failed;
>>> +
>>
>> As discussed before, I really don't think hooking in to dd.c is the
>> right thing to do here, and certainly not as a device tree specific
>> function. ACPI or PCI described devices may have the same constraints
>> and those won't have DT descriptions.
> 
> I agree, this shouldn't be in the driver core.

I don't think I agree. It'd greatly simplify driver probe() routines if
the driver core could acquire/set up as many resources as it could on
behalf of drivers. It'd be nice if it pre-mapped any registers, acquired
clocks, regulators, ... That way, we wouldn't need to write all that
code in each individual driver's probe() routine. Now, in many cases
this is rather difficult since there's currently no way for the driver
core to know which resources a driver needs, but when the driver core
can/does know this, shouldn't it simplify the life of drivers?
Longer-term, perhaps drivers can provide the driver core with some
specification of the resources it needs (such as a list of clock,
regulator, ... names), to fill in the missing information.
