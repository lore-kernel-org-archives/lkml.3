Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3EQTsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:48:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34047 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3EQTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:48:39 -0400
Message-ID: <51968994.5030408@wwwdotorg.org>
Date: Fri, 17 May 2013 13:48:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: "'thierry.reding@avionic-design.de'" 
	<thierry.reding@avionic-design.de>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'bhelgaas@google.com'" <bhelgaas@google.com>,
        "'olof@lixom.net'" <olof@lixom.net>,
        "'mturquette@linaro.org'" <mturquette@linaro.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com> <1368010660-31465-4-git-send-email-jagarwal@nvidia.com> <518A8596.7070702@wwwdotorg.org> <C79B248886DD134989C8FF6B096A91AB91B4886B5D@BGMAIL01.nvidia.com> <C79B248886DD134989C8FF6B096A91AB91B4886B6C@BGMAIL01.nvidia.com>
In-Reply-To: <C79B248886DD134989C8FF6B096A91AB91B4886B6C@BGMAIL01.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 10:51 AM, Jay Agarwal wrote:
>>> On 05/08/2013 04:57 AM, Jay Agarwal wrote:
>>>> - Enable PCIe controller on Cardhu
>>>> - Only port 2 is connected on this board
>>>> - Add regulators required for Tegra30
>>>> - Patch is based on remotes/gitorious_thierryreding_linux/tegra/next
>>>> - and should be applied on top of this.
...
>>> So, if I apply this series, I do see the PCIe bridge and Ethernet
>>> device get enumerated, but I don't see the USB3 controller get
>>> enumerated. I believe that is a PCIe device behind the same bridge on the
>>> same Tegra PCIe port.
>>> Shouldn't this device show up?
>>
>> I have also reproduced this problem. I see somehow no non-
>> prefetchable memory is assigned to any of pcie devices.
>> Probably that is the reason for USB3 (pci 0000:04:00.0) not getting
>> enumerated since it uses only non-prefetchable memory.
> 
> 1. Bus4(on which usb3 device resides) always return 0xffffffff from it's config space. which means device is not present?
> 2. That's why it is not assigned any resources and hence no usb3 probe happens.
> 3. But same bus does return valid info like vendor/device id etc from it's config space in downstream kernel and hence usb3 probe does happen.
> 
> Thierry, Stephen,
> 4. Any idea why bus4 should return 0xffffffff values in upstream kernel? Anything missing?

Is there some reset/enable GPIO or regulator that needs to be programmed
to enable the PCIe USB3 controller? Take a look at the schematic. If you
can make it work by tweaking those GPIOs/... manually, then we can
ignore this issue and fix it up later, since it's not directly related
to the PCIe controller driver patches. It's more important to get this
Ethernet working than USB, I think.

> 5. Also, how config space of all pcie devices are mapped? I mean if I change the config space offset in dts file, then also I find correct vendor/device id etc for bus0/device0/fun0.
>     So how this mapping happens that even after changing the config space offset in PCIe address space, it always finds correct vendor/device id.

Can you please word-wrap your email less than 80 columns? It's quite
hard to read.

I don't quite understand your question. The PCIe driver implements the
functions that access config space. I don't recall that being influenced
by anything much in the device tree, except for the 3rd entry in the
top-level PCIe controller's reg property:

        pcie-controller {
                compatible = "nvidia,tegra30-pcie";
                device_type = "pci";
                reg = <0x00003000 0x00000800   /* PADS registers */
                       0x00003800 0x00000200   /* AFI registers */
                       0x10000000 0x10000000>; /* configuration space */

