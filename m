Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaG3Nkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:40:36 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1482 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaG3Nkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:40:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 30 Jul 2014 06:32:14 -0700
Message-ID: <53D8F578.1030409@nvidia.com>
Date: Wed, 30 Jul 2014 19:09:04 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if device
 node missing
References: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com> <1405339495.4627.3.camel@weser.hi.pengutronix.de> <20140730131846.GB14219@developer>
In-Reply-To: <20140730131846.GB14219@developer>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2014 06:48 PM, Eduardo Valentin wrote:
> Laxman,
>
> On Mon, Jul 14, 2014 at 02:04:55PM +0200, Lucas Stach wrote:
>> Am Montag, den 14.07.2014, 16:42 +0530 schrieb Laxman Dewangan:
>>> There are some mfd devices which supports junction thermal interrupt
>>> like ams,AS3722. The DT binding of these devices are defined as the
>>> flat and drivers for sub module of such devices are registered as
>>> the mfd_add_devices. In this method, the sub devices registered as
>>> platform driver and these do not have the of_node pointer on their
>>> device structure. In this case, use the parent of_node pointer to
>>> get the required of_node pointer.
>>>
>>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>>> ---
>>>   drivers/thermal/of-thermal.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
>>> index 04b1be7..85a7d71 100644
>>> --- a/drivers/thermal/of-thermal.c
>>> +++ b/drivers/thermal/of-thermal.c
>>> @@ -396,6 +396,8 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
>>>   		return ERR_PTR(-EINVAL);
>>>   
>>>   	sensor_np = dev->of_node;
>>> +	if (!sensor_np && dev->parent)
>>> +		sensor_np = dev->parent->of_node;
>>>   
>>>   	for_each_child_of_node(np, child) {
>>>   		struct of_phandle_args sensor_specs;
>> This seems like the wrong way around. If the MFD has subdev information
>> stored in the parent node it should be the MFD drivers responsibility to
>> populate the subdev of_node with its own node. The subdev should not be
>> forced to make such possible unsafe assumptions.
>>
> This is my understanding too. MFD device drivers must populate the
> required data onto their sub devices while creating them.
>

Sometime ago, Stephen sent patch on MFD to initialize the mfd sub 
devices of_node with parent node.

mfd: always assign of_node in mfd_add_device()
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/217482.html

But it has unforeseen issue and reverted with patch
mfd: Revert "mfd: Always assign of_node in mfd_add_device()"
https://groups.google.com/forum/#!msg/rtc-linux/2LeLipSPFs0/XfPCKpT1BnUJ

So we do not have any mechanism here to pass the parent of_node to the 
of-thermal.

Adding Stephen and Lee for more comment.
