Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbaGOHM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:12:58 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18919 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830AbaGOHMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:12:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jul 2014 00:01:40 -0700
Message-ID: <53C4D472.9010507@nvidia.com>
Date: Tue, 15 Jul 2014 10:12:50 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] ata: Add support for the Tegra124 SATA controller
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com> <1403101406-15439-7-git-send-email-mperttunen@nvidia.com> <20140708132216.GA4979@htj.dyndns.org> <53C3DCF0.3030001@redhat.com>
In-Reply-To: <53C3DCF0.3030001@redhat.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heh, what you are describing is the v1 of this series :)

However,

17/06/14 Thierry Reding wrote:
 > I would've preferred tegra_powergate_sequence_power_up() to be used
 > consistently in all drivers. I'm still not convinced that using the
 > platform AHCI driver this way is really the best option, since we're
 > bending over backwards to fit into what this driver dictates. There
 > shouldn't be a need for that.

As you probably noticed, the issue is that on Tegra we want to use 
tegra_powergate_sequence_power_up to enable the SATA power rail. That 
function assumes that it gets a disabled clock and returns with the 
clock enabled. If we use ahci_platform's resource management functions,
this is not doable, since it wants to handle clocks by itself.

To be honest, I too would prefer handling the resources in the driver. 
The driver needs other resources than what ahci_platform currently 
manages (at least reset_controls and multiple regulators, later we might 
get more) and managing them in the driver allows the driver to do proper 
error handling and manage all resources consistently and in one place. 
Also, I don't think it is sensible to add support for loading every 
possible kind of DT resource to ahci_platform, since most drivers won't 
need them. Other subsystems I've been in don't have this kind of helper 
library, so diverging here seems weird.

That said, if you feel strongly about this, I can do what you described.

Thanks,
Mikko

On 14/07/14 16:36, Hans de Goede wrote:
> Hi,
>
> On 07/08/2014 03:22 PM, Tejun Heo wrote:
>> (cc'ing Hans)
>>
>> Hans, can you please review this patch?
>
> Done.
>
> Mikko, it looks like you are doing a lot of stuff
> the DIY way. I can see there are good reasons for
> that though.
>
> Still it would be nice if you could use a little bit
> more of the helper functions provided by libahci_platform.c
>
> Specifically I think it would be better if you used
> ahci_platform_get_resources, that would remove a lot of
> duplicate code from the new driver.
>
> To be specific I would like to suggest that you
> raise AHCI_MAX_CLKS to 4, and then specify an order
> in which the clks must be listed in the devicetree
> binding. Then you can put that order in an enum
> and use hpriv->clks[CLK_FOO] in your driver, where
> CLK_FOO comes from the enum.
>
> This way you should be able to use ahci_platform_get_resources
> and drop doing the iomap of the base registers, all the
> clk_gets and the phy_get yourself.
>
> You could then also use ahci_platform_disable_clks() in
> tegra_ahci_power_off
>
> Regards,
>
> Hans
>
