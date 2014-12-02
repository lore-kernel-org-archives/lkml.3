Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaLBJdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:33:50 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:50932 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaLBJds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:33:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        russ.dill@gmail.com, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        linus.walleij@linaro.org
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
Date: Tue, 02 Dec 2014 10:33:32 +0100
Message-ID: <25485084.A6ydfR9Xle@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAD=FV=VT7gr504-ZgWPfha+40XDX5eShkzZ36bg=-4Oub1S27w@mail.gmail.com>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org> <20141201225057.GA11285@n2100.arm.linux.org.uk> <CAD=FV=VT7gr504-ZgWPfha+40XDX5eShkzZ36bg=-4Oub1S27w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xEjXhGEx7QykXtPb7c7bPlWfT1ZcXT/g8IZ0OOs+sLz
 hECYF0M819NiNjVNGlZKvQM9WSuTsUWslSy07nH5+42WjX1JuF
 y5pL0/4oSuV4vuOFXe7aheJWlEPJplX+asr5XcOVSOALA7Q8LI
 4OwVioLh3J6P+qLjOulzXxXy+E0fJP7HNFyPfPSIHh8k7XHdgM
 ycvmVZkDTvmsvq91ArZ0I6EXMZrF9UryJ4sicRo2fZrcM47OXM
 9PyF3tgA696XuAUcAZ2OqcWpgfkdpxTkK2QXbKcPQiC1293Z8K
 cjIlwVQA6P94NnSZsaM3lX8q5/qFFo0qSBUbJ9V9njU3yOUTCk
 71ExGHD54HImIDx2t+cc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 15:04:59 Doug Anderson wrote:
> Russel,
> 
> On Mon, Dec 1, 2014 at 2:50 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > What I see here is a load of complexity which achieves very little.
> > The result doesn't get rid of much assembly, but it does make stuff
> > more complicated.  And the diffstat speaks volumes about this:
> >
> >  10 files changed, 275 insertions(+), 94 deletions(-)
> >
> > There's a lot of words in the description, but it's missing the most
> > important bit: why do we want to take this approach - what benefits
> > does it bring?
> 
> Sure.  I guess the most important words in the description are:
> 
> > We convert the existing assembly resume code into C as proof that this
> > works and to prepare for linking in SDRAM reinit code.
> 
> I can't say that the SDRAM reinit code is ready for prime time yet,
> but you can get a preview of what it could look like at:
> 
> https://chromium-review.googlesource.com/#/c/227366/25/arch/arm/mach-rockchip/embedded/rk3288_ddr_resume.c
> 
> Adding that code in assembly seems like a very, very bad idea.
> Certainly my patch could wait until the DDR code is ready to be posted
> upstream if that made sense.  One advantage of waiting is that it's
> possible that the DDR code might end up moving elsewhere if it made
> sense to have it part of a memory controller driver or something like
> that.

I recently looked at another vendor tree (quantenna wifi access point,
based on arch/arc), which was putting arbitrary functions into SRAM
for performance reasons, in their case the entire hot path for network
switching. Having at least the infrastructure to do this seems like
a great idea, even though it's very hard to do in a general-purpose
kernel, as you'd have a hard time squeezing as much code as possible
into the available SRAM.

Unfortunately you already said that you're not that interested in
making it completely generic, and I also don't think I want to have
the infrastructure for it in mach-rockchip and would want to see that
at least shared across arch/arm if it's too hard to do
cross-architecture. If you were to include code from drivers/memory/
in the blob, you couldn't keep it in mach-rockchip anyway.

AFAICT, the quantenna implementation is similar to the itcm/dtcm
stuff we already have (but are not using upstream), so I wonder
why we can't use that here too, see Documentation/arm/tcm.txt

	Arnd
