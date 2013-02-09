Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3BIMTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 07:19:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab3BIMS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 07:18:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Date: Sat, 9 Feb 2013 12:18:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com> <20130208074720.GB21879@arwen.pp.htv.fi> <20130208.100942.592982910310763762.hdoyu@nvidia.com>
In-Reply-To: <20130208.100942.592982910310763762.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302091218.41699.arnd@arndb.de>
X-Provags-ID: V02:K0:Nz7CUJkheDGxLdh3+Oi5dyFZcKPr7sb3KdjCBKcvsUr
 6ctMVnEwuwXII5LtrO5LI18VWl4+XbsAVzXVL7lILWjFxuLqoM
 9e+s4/apyRTFZ7IeZfLFlFMFia+NdwFSVX3B4WUiedV3BYRPck
 aKjd0xHfZ6f2XXcZyisi6dzFpZqxS/OHU6fwOuUX1CFY2rKg/q
 zTuUaGpOEao5GKuwabughi45BJ/HadPzUmmV9V2N+cMuDX5IlB
 +Fe75LjFGpnqBRemdP+aJik9GFV127qAYOQQrHZvz9KAhLWTiO
 hrp8ooXXA7rRNz9U5CMMHUKyafllv/5nGu9l02KMkCtnRV/zvI
 HjT6BpozayEZz85MU/BM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2013, Hiroshi Doyu wrote:
> > > +#if defined(CONFIG_ARCH_TEGRA_3x_SOC)
> >
> > how about using:
> >
> > #if IS_BUILTIN(CONFIG_ARCH_TEGRA_3x_SOC)
> >
> > instead ?
> 
> Why is IS_BUILTIN() prefered?
> 

Inside of a function, if(IS_ENABLED(CONFIG_FOO)) or the respective IS_BUILTIN is
preferred over #ifdef because it provides better compile coverage and better
readability. Also, IS_ENABLED() is nice when you want to check if something
is builtin or module, without having to write a complex expression.

If you just replace the #ifdef with #if IS_BUILTIN as Felipe suggested, I see
no real benefit, but it would be nice to write this as


void __init tegra_hotplug_init(void)
{
	if (!IS_ENABLED(CONFIG_HOTPLUG_CPU))
		return;
	
	if (IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC)) && tegra_chip_id == TEGRA20)
		tegra_hotplug_shutdown = tegra20_hotplug_shutdown;
	if (IS_ENABLED(CONFIG_ARCH_TEGRA_3x_SOC)) && tegra_chip_id == TEGRA30)
		tegra_hotplug_shutdown = tegra30_hotplug_shutdown;
}

which completely avoids all preprocessor conditionals and replaces them
with compile-time choices based on constant expressions to eliminate the
code paths for disabled platforms.

	Arnd
