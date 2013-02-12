Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155Ab3BLErY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:47:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59146 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab3BLErW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:47:22 -0500
Message-ID: <5119C958.1030304@wwwdotorg.org>
Date: Mon, 11 Feb 2013 21:47:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "marvin24@gmx.de" <marvin24@gmx.de>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 3/3] ARM: tegra: Unify Device tree board files
References: <1360562743-21689-1-git-send-email-hdoyu@nvidia.com><1360562743-21689-3-git-send-email-hdoyu@nvidia.com><5119849B.1070300@wwwdotorg.org> <20130212.061240.2083183700176617607.hdoyu@nvidia.com>
In-Reply-To: <20130212.061240.2083183700176617607.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 09:12 PM, Hiroshi Doyu wrote:
> Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 12 Feb 2013 00:54:03 +0100:
> 
>>> -obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra.o
>>> -obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
>>> -obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= board-dt-tegra114.o
>>> +obj-y					+= tegra.o
>>> +
>>
>> I think I'd be tempted to move that line together with all the others
>> that don't depend on some config option.
> 
> In arch/arm/mach-tegra/Makefile, we have:
> 
> obj-y                                   += common.o
> obj-y                                   += io.o
> obj-y                                   += irq.o
> obj-y					+= fuse.o
> obj-y					+= pmc.o
> .....
> 
> Should we have a single entry for them as well?
> 
> obj-y:= common.o io.o irq.o fuse.o pmc.o flowctrl.o powergate.o apbio.o pm.o \
> 	reset.o reset-handler.o sleep.o tegra.o
> 
> I think that this moval could be done another patch.

I just meant put the lines next to each-other. We definitely shouldn't
merge the lines together or it'll make it more painful to change the
list of files later.

>>>  static void __init harmony_init(void)
>>>  {
>>> -#ifdef CONFIG_TEGRA_PCI
>>>  	int ret;
>>>  
>>>  	ret = harmony_pcie_init();
>>>  	if (ret)
>>>  		pr_err("harmony_pcie_init() failed: %d\n", ret);
>>> -#endif
>>>  }
>>
>> Why drop those ifdefs? Does the code still compile (link) if built for
>> Tegra30-only or Tegra114-only, where the Tegra PCI driver won't be
>> enabled, and hence those functions don't exist?
> 
> This function itself will be dropped by the following IS_ENABLED().
> 
>>>  static void __init paz00_init(void)
>>> @@ -129,6 +128,9 @@ static void __init tegra_dt_init_late(void)
>>>  
>>>  	tegra_init_late();
>>>  
>>> +	if (IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
>>> +		return;
>>
>> I don't think that's going to help any link issues, so I'd drop it and
>> keep this function simple.
> 
> As explained in the above, a complier will drop unnecessary functions
> automatically with this IS_ENABLED(), which could save many ifdefs.

That sounds extremely brittle. Have you validated this on a wide variety
of compiler versions?

>> After all, what if someone wants to add some
>> non-PCI-related entry into board_init_funcs[]?
> 
> I originally thought that one should try to solve those board specific
> problems with DT basically and this tegra specific board_init_funcs[]
> was left only for the legacy support during DT transition.

That's the intent right now, but who knows what else might end up
getting added there. It seems simplest just to maintain the ifdefs since
they're already there.
