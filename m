Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab3BLNud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 08:50:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3BLNuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:50:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [v2 3/3] ARM: tegra: Unify Device tree board files
Date: Tue, 12 Feb 2013 13:50:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "marvin24@gmx.de" <marvin24@gmx.de>, "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5119849B.1070300@wwwdotorg.org> <5119C958.1030304@wwwdotorg.org> <20130212.070456.532657136988541923.hdoyu@nvidia.com>
In-Reply-To: <20130212.070456.532657136988541923.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121350.15683.arnd@arndb.de>
X-Provags-ID: V02:K0:UHdakaAJt26Fz7T2yIniu4l4X0BnFPzvToJGKK1VUEN
 5epCZaf2cHpsRL2QsgrtwjaY+kAX5cXt2W63bN0ietdsRoHF66
 n2+AY8SMP2ZQIdDQhnCkfUnl0gUf1FrZktSrxEP0dDvxW72jsA
 MiN6cypj+M4SMxl23aJx684wQwfX4LY9h0Y8cZmZ86lZLpgx11
 mj5gt+0wS4IVDsisnsBxFPYqdQNd9ypw7Nfs92koNYOnDvsIj1
 YnkqSzBS9poTZMPG12ExjpMXt+8JMoF12m9Sffcnw8thwrAvyu
 IbhHi2+sN76J5rq9/GzJwLZHZUxzPhaX1GY7L2dAki02h6FEt5
 k0R2JGH72GkC+PoVgwt0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Hiroshi Doyu wrote:
> > >>>  static void __init paz00_init(void)
> > >>> @@ -129,6 +128,9 @@ static void __init tegra_dt_init_late(void)
> > >>>  
> > >>>   tegra_init_late();
> > >>>  
> > >>> + if (IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
> > >>> +         return;
> > >>
> > >> I don't think that's going to help any link issues, so I'd drop it and
> > >> keep this function simple.
> > > 
> > > As explained in the above, a complier will drop unnecessary functions
> > > automatically with this IS_ENABLED(), which could save many ifdefs.
> > 
> > That sounds extremely brittle. Have you validated this on a wide variety
> > of compiler versions?
> 
> I verified with gcc-4.6.
> IIRC, that's the point of IS_ENABLED() being introduced. Arnd?

It's certainly expected to work with all compilers, yes. If a compiler
cannot remove conditional function calls that depend on a constant
expression, we have a lot of other problems alredy.

However, from what I see above, you have the logic reversed (it
should return if neither TEGRA_2x nor PCI are enabled, rather
than return if one of them is enabled). and it becomes a little
confusing to read.

If you want to get rid of the #ifdef here, I would suggest you put those
into the functions directly, like

static void __init harmony_init(void)
{
        int ret = 0;

        if (IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
		ret = harmony_pcie_init();
        if (ret)
                pr_err("harmony_pcie_init() failed: %d\n", ret);
}

which will turn into an empty function if one of the two is disabled.

Since we are not going to add any other board specfic init functions, you
can also unroll the loop and put everything into tegra_dt_init_late:

/* Board specific fixups, try not add any new ones here */
static void __init tegra_dt_init_late(void)
{
	tegra_powergate_debugfs_init();

	/* so far, these all apply only to tegra2x */
	if (!IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
		return;

	if (of_machine_is_compatible("compal,paz00"))
		tegra_paz00_wifikill_init();
	if (IS_ENABLED(CONFIG_PCI) && of_machine_is_compatible("nvidia,harmony")
		harmony_pcie_init();
	if (IS_ENABLED(CONFIG_PCI) && of_machine_is_compatible("compulab,trimslice")
		tegra_pcie_init(true, true);
}

	Arnd
