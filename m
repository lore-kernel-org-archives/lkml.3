Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3LSH2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:28:43 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5032 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3LSH2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:28:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Dec 2013 23:29:56 -0800
Message-ID: <52B2A01D.2000207@nvidia.com>
Date: Thu, 19 Dec 2013 12:58:29 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] ARM: tegra: add ams AS3722 device to Venice2 DT
References: <1387371179-16725-1-git-send-email-ldewangan@nvidia.com> <1387371179-16725-2-git-send-email-ldewangan@nvidia.com> <52B20BB4.50506@wwwdotorg.org>
In-Reply-To: <52B20BB4.50506@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 December 2013 02:25 AM, Stephen Warren wrote:
> On 12/18/2013 05:52 AM, Laxman Dewangan wrote:
>> Add ams AS3722 entry for gpio/pincontrol and regulators
>> to venice2 DT.
> This patch still causes:
>
>> [    0.726545] as3722-pinctrl as3722-pinctrl: pin gpio0 already requested by as3722-pinctrl; cannot claim for as3722-regulator
>> [    0.737681] as3722-pinctrl as3722-pinctrl: pin-0 (as3722-regulator) status -22
>> [    0.744895] as3722-pinctrl as3722-pinctrl: could not request pin 0 (gpio0) from group gpio0  on device as3722-pinctrl
>> [    0.755500] as3722-regulator as3722-regulator: Error applying setting, reverse things back

This error is nothing related to the ams dt or driver. This came from 
the framework from the driver/base for adding pinmux call before calling 
any diver's probe.
Here is my finding:
Frameworks calls the pinctrl_bind_pins() before calls the driver's probe 
(drivers/base/dd.c) and pinctrl_bind_pins() calls the pinmux mapping and 
try to set the default (drvers/base/pinctrl.c).

AMS AS3722 DT is flat type on which all sub devices of AS3722 have the 
property on parent node only, there is no subnode for each sub driver 
like palmas. In this case all sub drivers of_node is initialized as 
parent->of_node in mfd-core.c (mfd_add_devices).

mfd-core.c: mfd_add_device()
        if (!pdev->dev.of_node)
                 pdev->dev.of_node = parent->of_node;

So all sub devices of AS3722 has the parent node.
This node has the default pinmux configuration and so it tries to set 
the default pinmux before sud-driver's probe get called.
The first one (for pinmux driver) it is success but for regulator and 
rtc, it is failed as pins are owned by the pinmux drivers.

This does not have any side impact as currently, pinctrl_bind_pins() 
only return the success or ERPOBE_DEFER

I was testing the patch with linux-next-common of your branch and 
chrome-os/kernel-next with linux-next's pinctrl/regulator/mfd and not 
able to repro this because driver/base changes was not there.




