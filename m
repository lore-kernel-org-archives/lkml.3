Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab3BGLze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:55:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3BGLzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:55:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
Date: Thu, 7 Feb 2013 11:55:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org, arm@kernel.org,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
References: <1358891160-9534-1-git-send-email-robdclark@gmail.com> <3969096.QosOfOb9QT@wuerfel> <511392B0.4040409@ti.com>
In-Reply-To: <511392B0.4040409@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302071155.12565.arnd@arndb.de>
X-Provags-ID: V02:K0:3LCYF3rqWZBi+6j6JYwNDTCHF2v6yX39t9hbPoxXYgM
 F2MWzb/72X7ahmYvc7pT+JQ7IIcH+TpQnzltQNDqfsTYpZ87Mi
 Hgo8TjE4RSLGB0Ho/WTejKdzCd4vEECscDICAYwvIKQjP0qfwS
 hIYY5Dor5f3qBg4NRV/1YpTpWvFZ/Xh6geKKvlK+1S/GpQm/km
 QP08hcgfj86fIUb5oPgEq9F4IsjnUsZ/5fFm9wl5Ehlf21D0LK
 LdWape7GOCUq2RaYZQskpFqM2qAbHwm63RJKfl/lLef930gygQ
 1fgspvwotCmtDwUYx2hj4hjeoLf7Nc1zd8CbFnw7DBAn6iQtkz
 3hyNvZe55sCShNxrVHPo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomi Valkeinen wrote:
> On 2013-02-06 16:29, Arnd Bergmann wrote:
> > On Wednesday 06 February 2013 16:15:57 Tomi Valkeinen wrote:
> 
> >> I have patches to add the ARCH_MULTIPLATFORM for omapdss, and to fix the
> >> omap_vout and omapdrm Kconfig files. Each of them changes only one line.
> >> Arnd, are you ok with queuing those patches via arm-soc/fixes? Or should
> >> I send them individually to respective maintainers?
> >>
> >> I can send the patches properly for review, but I've also attached them
> >> here so Rob can test.
> > 
> > The second and third attachment in your mail seem to contain identical
> > patches. I suggested a similar patch myself, but Rob thought his
> 
> Hmm? They look different to me...
> 0002-omap_vout-fix-the-dependency-on-OMAPDSS.patch fixes the dependency
> for omap_vout, 0003-omapdrm-fix-the-dependency-on-OMAPDSS.patch for omapdrm.

Right, my mistake.

> > version was nicer to give better build coverage. We only need either
> > Rob's patch or yours, but not both, as far as I can tell.
> 
> I read the related posts, but I'm a bit confused here. Let me summarize
> what has happened and what are the issues:
> 
> I changed omapdss, omapfb and omap panel drivers to be platform
> independent, and after that they compiled fine on OMAP and x86, and
> should compile fine on any other platform as well. I thus removed the
> Kconfig build dependencies for OMAP. This is what I sent for 3.8 merge
> window.
> 
> However, Linus complained that now he's getting asked if he wants to
> enable omapdss driver when he's building x86 kernel. So Tony made a
> patch that added the ARCH_OMAP2PLUS dependency to omapdss (and some
> other omap drivers), which went in.
> 
> Now, if I'm not mistaken, Rob then added possibility to build omapdrm on
> ARCH_MULTIPLATFORM. No problem with that as such, but omapdrm's Kconfig
> uses select to enable omapdss, which does not work. omapdss was not made
> to work with others using "select" to enable it, but one should "depend
> on" to it.
> 
> This caused omapdss to be enabled partially when omapdrm is enabled on
> ARCH_MULTIPLATFORM, causing build failure.

All correct, yes.

> So the real fix to the issue is the 0003 patch, which changes omapdrm to
> use "depend on", not "select". However, adding only that patch will
> prevent omapdrm to be built on ARCH_MULTIPLATFORM, as omapdss is not
> enabled on ARCH_MULTIPLATFORM. That one can be enabled with the 0001 patch.
> 
> Adding only 0001 patch will also "fix" the build issue, as then omapdss
> is properly enabled on allyesconfig ARCH_MULTIPLATFORM build, even if
> omapdrm erroneously uses select to enable omapdss. However, adding only
> 0001 will still allow the user to manually break the build by disabling
> omapdss (I think, I didn't test that).

omapdrm still has the 'select' statement in it if you only send the
first patch, so it should not be possible to disable omapdss when
it is actually needed.

> The difference between my 0001 patch and Rob's patch is that Rob only
> enables omapdss to be built on ARCH_MULTIPLATFORM, leaving omapfb and
> omap panel drivers out. Leaving omapfb is not an issue, but if the panel
> drivers are left out, I don't see how omapdrm can function properly,
> even if compilation works fine.

I suggested doing only the minimum that is needed to unbreak the
allyesconfig build, which is to enable just omapdss but not omapfb
and the displays, in case they don't actually build on anything else.

> > Olof can correct me, but I think we currently don't have any other
> > patches queued in arm-soc for 3.8 (after Linus announced he did
> > not want any of the less urgent ones), so I think it would be more
> > fitting if you send one of the patches to Linus, rather than having
> > an arm-soc pull request that only contains one patch in your domain.
> 
> Ok, I'll do that. I'm still not sure if I should send only the 0001
> patch, or all three. I guess I'll go for all three if nobody objects.
> 
> Rob, can you test the patches so we're sure they do what they are
> supposed to?

I would suggest only the first patch, since Linus quite specifically
asked only for serious bug fixes. I think an allyesconfig build
breakage is serious enough, but doing multiple patches for one
bug should not be necessary and is much harder to justify.

	Arnd
