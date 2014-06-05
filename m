Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaFEUKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:10:49 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:57889 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaFEUKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:10:47 -0400
MIME-Version: 1.0
In-Reply-To: <5390C5A9.5070900@gmail.com>
References: <1401398496-4624-1-git-send-email-dianders@chromium.org>
	<1401467562-5585-1-git-send-email-dianders@chromium.org>
	<CAD=FV=W8-M5iOMDG190WGaeSySTd=qcp30k-H8DMUs_C5Pdwog@mail.gmail.com>
	<5390C19A.9060201@gmail.com>
	<CAD=FV=UZsEh+bOQxc8CP+yG5a5Sbp2eTyq8B_iq9u5io5G0B6A@mail.gmail.com>
	<5390C5A9.5070900@gmail.com>
Date: Thu, 5 Jun 2014 13:10:46 -0700
X-Google-Sender-Auth: P0dayMp1zdgxx5Kp4hm7jPvEyXc
Message-ID: <CAD=FV=Ucn20GDib=t=OOT+8YjGuk6uoWrP1qourY=YfrLJj1WA@mail.gmail.com>
Subject: Re: [PATCH v2] clk: exynos5420: Keep aclk66_peric enabled during boot
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, Jun 5, 2014 at 12:31 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> One more question that just came to my mind: Why it is just the
> aclk66_peri and not its children related to UARTs?

Can you re-read out the original patch description and see if it
answers that?  Basically: the UART was left on by the bootloader and
that's a requirement of earlyprintk but the common clock framework is
messing with aclk66_peric which is what's killing us.


> Exynos5420 clock driver still needs a little clean-up, so I'm okay with
> any fix for now and changing this later if needed, but is this gate
> clock for ACLK66_PERIC even needed? It seems to be marked with
> CLK_IGNORE_UNUSED which suggests that it is not needed in this driver at
> all, along with other similar clocks. AFAIK for power management
> purposes our fine-grained approach is fine and we shouldn't need to use
> the big gates.

Right, another option is to remove this gate from the clock tree (and
reparent all children on the gate's parent) and that would also fix
us.  The main advantages of the "big gate" as I see it:

1. There's a reasonable chance that our clock tree description is not
complete.  Patches to add previously undocumented clocks seems to be a
relatively common occurrence.  If one of those undocumented clocks
happens to be a child of aclk66_peric then we'll no longer be gating
it.

2. There might be a small amount of power saved by gating the clock
higher in the tree.

3. Having a more complete description of the clock tree is nice in
case someone outside the kernel does something.  If a stray pointer
(or a nonstandard bootloader) gates the clock then our tree won't show
problems, but the clock will still be gated.


Of course as soon as the first child of aclk66_peric is activated then
points #1 and #2 are invalid.  ...and #3 is a bit bogus because there
are A LOT of gates that we already don't model.


Also: the CLK_IGNORE_UNUSED is a bit bogus here.  That's not really a
useful flag in the case that you've got children that are enabled and
disabled.  Once your first child is enabled and disabled you'll be
disabled!

---

Hmmm, I think I've convinced myself that your suggestion of just
removing this gate from the table is the right thing to do.  Patch
will be coming up soon.

-Doug
