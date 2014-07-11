Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaGKQBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:01:41 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:37828 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbaGKQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:01:39 -0400
Message-ID: <53C00A57.5070102@kapsi.fi>
Date: Fri, 11 Jul 2014 19:01:27 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
CC: pdeschrijver@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-6-git-send-email-mperttunen@nvidia.com> <20140711145146.GA6523@ulmo>
In-Reply-To: <20140711145146.GA6523@ulmo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:be5f:f4ff:fe47:6518
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 05:51 PM, Thierry Reding wrote:
> On Fri, Jul 11, 2014 at 05:18:30PM +0300, Mikko Perttunen wrote:
>> Add binding documentation for the nvidia,tegra124-emc device tree
>> node.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>>   .../bindings/memory-controllers/tegra-emc.txt      | 42 ++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
>>
>> diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
>> new file mode 100644
>> index 0000000..2dde17e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
>> @@ -0,0 +1,42 @@
>> +Tegra124 SoC EMC controller
>> +
>> +Required properties :
>> +- compatible : "nvidia,tegra124-emc".
>> +- reg : Should contain 1 or 2 entries:
>> +  - EMC register set
>> +  - MC register set : Required only if no node with
>> +    'compatible = "nvidia,tegra124-mc"' exists. The MC register set
>> +    is first read from the MC node. If it doesn't exist, it is read
>> +    from this property.
>
> No can do. Memory regions shouldn't be shared between drivers like this.
> It makes it impossible to ensure that they don't stump on each others'
> toes.

In this case, all the registers that will be written are such that the 
MC driver will never need to write them. They are shadowed registers, 
meaning that all writes are stored and are only effective starting from 
the next time the EMC rate change state machine is activated, so writing 
them from anywhere except than the EMC driver would be pointless.

I can find two users of these registers in downstream:
1) mc.c saves and loads them on suspend/restore (I don't know why, that 
shouldn't do anything. They will be overridden anyway during the next 
EMC rate change).
2) tegra12x_la.c reads MC_EMEM_ARB_MISC0 during a core_initcall to 
calculate a value which it then writes to a register that is also 
shadowed and that is part of downstream burst registers so that doesn't 
do anything either.

The reason I implemented two ways to specify the MC register area was 
that this could be merged before an MC driver and retain 
backwards-compatibility after the MC driver arrives.

If this is not acceptable, we can certainly wait for the MC driver to be 
merged first. (Although with the general rate of things, I hope I won't 
be back at school at that point..) I assume that this is blocked on the 
IOMMU bindings discussion? In that case, there are several options: the 
MC driver could have its own tables for each EMC rate or we could just 
make the EMC tables global (i.e. not under the EMC node). In any case, 
the MC driver would need to implement a function that would just write 
these values but be guaranteed to not do anything else, since that could 
cause nasty things during the EMC rate change sequence.

Yet another option is to just not write to these registers at all. In my 
tests, that would entail a 20-25% penalty to memory throughput for most 
timings.

>
> One possibility to make this work is to export global functions from the
> memory controller driver that this driver can call into. Perhaps if you
> want you can be extra explicit by linking them in DT, like this:
>
> 	mc: memory-controller@0,70019000 {
> 		compatible = "nvidia,tegra124-mc";
> 		reg = <0x0 0x70019000 0x0 0x00001000>;
> 		...
> 	};
>
> 	memory-controller@0,7001b000 {
> 		compatible = "nvidia,tegra124-emc";
> 		reg = <0x0 0x7001b000 0x0 0x00001000>;
> 		memory-controller = <&mc>;
> 		...
> 	};
>
> But I think it's safe enough to assume that there will only be a single
> memory controller/EMC pair in the device.
>
> Thierry
>

