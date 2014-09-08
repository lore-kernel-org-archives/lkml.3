Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaIHNzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:55:33 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39676 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaIHNzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:55:31 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Fix memory block alignment in
 early_init_dt_add_memory_arch()
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAMuHMdWZ_GDS_W-Y26ig7cKf7wdr82XF1kyLd8dFzc7Jb4_r-w@mail.gmail.com>
References: <1408547431-24001-1-git-send-email-geert+renesas@glider.be>
	<20140827103048.80BBBC409CB@trevor.secretlab.ca>
	<CAMuHMdWZ_GDS_W-Y26ig7cKf7wdr82XF1kyLd8dFzc7Jb4_r-w@mail.gmail.com>
Date: Mon, 08 Sep 2014 14:55:04 +0100
Message-Id: <20140908135505.07632C40C20@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 13:08:51 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Grant,
> 
> On Wed, Aug 27, 2014 at 12:30 PM, Grant Likely <grant.likely@linaro.org> wrote:
> > On Wed, 20 Aug 2014 17:10:31 +0200, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> >> If a memory block is not aligned to PAGE_SIZE, its base address must be
> >> rounded up, not down, and its size must be reduced.
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > Looks reasonable. What is the situation that exposed this problem?
> 
> When ARM switched from arm_add_memory() to early_init_dt_add_memory_arch()
> for DT-based platforms, I just noticed this when comparing the two
> implementations.
> 
> I don't know if it triggers in the wild.
> 
> > Should size be checked for page alignment also?
> 
> Size is already rounded down if it's not page aligned, cfr. the context below.

Indeed it is. Silly me. Applied, thanks.

g.

> 
> >> ---
> >>  drivers/of/fdt.c | 6 +++++-
> >>  1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> >> index f46a24ffa3fe..95fa81b8ca19 100644
> >> --- a/drivers/of/fdt.c
> >> +++ b/drivers/of/fdt.c
> >> @@ -928,7 +928,11 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
> >>  void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
> >>  {
> >>       const u64 phys_offset = __pa(PAGE_OFFSET);
> >> -     base &= PAGE_MASK;
> >> +
> >> +     if (!PAGE_ALIGNED(base)) {
> >> +             size -= PAGE_SIZE - (base & ~PAGE_MASK);
> >> +             base = PAGE_ALIGN(base);
> >> +     }
> >>       size &= PAGE_MASK;
> >>
> >>       if (base > MAX_PHYS_ADDR) {
> >> --
> >> 1.9.1
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

