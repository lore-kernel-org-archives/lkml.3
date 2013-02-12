Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab3BLRcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:32:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57374 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab3BLRca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:32:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [v2 3/3] ARM: tegra: Unify Device tree board files
Date: Tue, 12 Feb 2013 17:32:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "marvin24@gmx.de" <marvin24@gmx.de>, "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5119849B.1070300@wwwdotorg.org> <201302121350.15683.arnd@arndb.de> <511A6F6C.8090205@wwwdotorg.org>
In-Reply-To: <511A6F6C.8090205@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121732.14960.arnd@arndb.de>
X-Provags-ID: V02:K0:YSgN0YyyRJfOkltxpLVyNhpDiUxRfrj1Uk5f7do9Qgm
 M43lGX7FJ1cqYKk1a2PPUG53Ew2hUiZDo9xu2JGhi33b0krp6V
 T0wC1ijPkkFaWuAYarQ3VFCnrXkWEt5fCrrMnxoKv/E/LNNU8H
 /b3Q3uadJmW/Auc02C1CefScKszVU6DeZFuhkHNQ3JYViOA16q
 popgmANZ9GCGAyNfXbbZB7/sRrNSkZ03C+pu7JA/7IeelSZlmt
 RYZohKuU0s1ARs3UURm+pAGTws2tTL9jIU82O9i7sh5EY8Uhzd
 xh0AOQsry/O3MLriIoQIKBCyPvfYFMQJpy4CkO8jG9IvScMnDL
 TlkUubBsTk55AApM6H70=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Stephen Warren wrote:
> >>>>> I don't think that's going to help any link issues, so I'd drop it and
> >>>>> keep this function simple.
> >>>>
> >>>> As explained in the above, a complier will drop unnecessary functions
> >>>> automatically with this IS_ENABLED(), which could save many ifdefs.
> >>>
> >>> That sounds extremely brittle. Have you validated this on a wide variety
> >>> of compiler versions?
> >>
> >> I verified with gcc-4.6.
> >> IIRC, that's the point of IS_ENABLED() being introduced. Arnd?
> > 
> > It's certainly expected to work with all compilers, yes. If a compiler
> > cannot remove conditional function calls that depend on a constant
> > expression, we have a lot of other problems alredy.
> 
> Removing the function calls isn't guaranteed to remove the body of the
> functions though. Those functions aren't implemented in some separate
> file that's optionally included, but rather are implemented in the same
> object file, now unconditionally, and they in turn reference (with no
> IS_ENABLED logic) other functions that are implemented in conditionally
> linked files.

I think gcc should remove all of that in this case, since board_init_funcs
becomes unused when the only code that references it cannot be reached,
and when that array is gone, the now unused functions would be removed
as well.

We have had bugs with prerelease gcc versions that did not handle cases
like this in the way we want it, but I think all releases get it right.
I don't think it's mandated anywhere in the C99 standard that this is
what happens, but we do rely on it anyway AFAIK.

> > static void __init harmony_init(void)
> > {
> >         int ret = 0;
> > 
> >         if (IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
> >               ret = harmony_pcie_init();
> >         if (ret)
> >                 pr_err("harmony_pcie_init() failed: %d\n", ret);
> > }
> > 
> > which will turn into an empty function if one of the two is disabled.
> 
> That would work.
> 
> However I'd like to avoid changing the body of those two functions at
> all if possible, since I hope the PCIe driver rework will be merged in
> 3.10, and that will allow the Harmony and TrimSlice init functions to be
> removed entirely. I'd rather not have conflicts with the removal patch.

Yes, makes sense.

> > Since we are not going to add any other board specfic init functions, you
> > can also unroll the loop and put everything into tegra_dt_init_late:
> 
> That's not necessarily true. While we certainly don't plan to, I don't
> think we can rule it out; after all, we don't have rfkill bindings and
> yet other boards will need them.

Ok.

	Arnd
