Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3KRL1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:27:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48168 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171Ab3KRL1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:27:23 -0500
Date: Mon, 18 Nov 2013 11:27:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "t.figa@samsung.com" <t.figa@samsung.com>
Subject: Re: [PATCH 3/4 v9] thermal: samsung: Add TMU support for
 Exynos5420 SoCs
Message-ID: <20131118112712.GB30853@e106331-lin.cambridge.arm.com>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
 <1384238225-24632-1-git-send-email-ch.naveen@samsung.com>
 <CAHfPSqAxs7qpx8pv_CnbtQBMrooyXzs7SBKPe7xrK-qmSELp=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHfPSqAxs7qpx8pv_CnbtQBMrooyXzs7SBKPe7xrK-qmSELp=g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 03:22:57AM +0000, Naveen Krishna Ch wrote:
> Hello All,
> 
> On 12 November 2013 12:07, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
> > Exynos5420 has 5 TMU channels, the TRIMINFO register is
> > misplaced for TMU channels 2, 3 and 4
> > TRIMINFO at 0x1006c000 contains data for TMU channel 3
> > TRIMINFO at 0x100a0000 contains data for TMU channel 4
> > TRIMINFO at 0x10068000 contains data for TMU channel 2
> >
> > This patch
> > 1 Adds the neccessary register changes and arch information
> >    to support Exynos5420 SoCs.
> > 2. Handles the gate clock for misplaced TRIMINFO register
> > 3. Updates the Documentation at
> >    Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> >
> > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> > ---
> > Changes since v8:
> > 1. rewrote the Documentation for device tree bindings
> > 2. Merged the https://lkml.org/lkml/2013/11/7/262 (as this is a fix)
> > 3. introduces "samsung,exynos5420-tmu-triminfo" and
> >    "samsung,exynos5420-tmu-triminfo-clk" to handle the TMU channels on
> >    Exynos5420 more appropriately
> >
> >  .../devicetree/bindings/thermal/exynos-thermal.txt |   45 +++++++++
> >  drivers/thermal/samsung/exynos_tmu.c               |   58 ++++++++++-
> >  drivers/thermal/samsung/exynos_tmu.h               |    2 +
> >  drivers/thermal/samsung/exynos_tmu_data.c          |  106 ++++++++++++++++++++
> >  drivers/thermal/samsung/exynos_tmu_data.h          |    8 ++
> >  5 files changed, 215 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > index 116cca0..5055b31 100644
> > --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > @@ -6,6 +6,11 @@
> >                "samsung,exynos4412-tmu"
> >                "samsung,exynos4210-tmu"
> >                "samsung,exynos5250-tmu"
> > +              "samsung,exynos5420-tmu" for TMU channel 0, 1 on Exynos5420
> > +              "samsung,exynos5420-tmu-triminfo" for TMU channel 2 Exynos5420
> > +                       (Must pass triminfo base)
> > +              "samsung,exynos5420-tmu-triminfo-clk" for TMU channel 3 and 4
> > +                       Exynos5420 (Must pass triminfo base and triminfo clock)

While this mentions what the differences the binding expects to, what is
fundamentally different about these blocks?

> >                "samsung,exynos5440-tmu"
> >  - interrupt-parent : The phandle for the interrupt controller
> >  - reg : Address range of the thermal registers. For soc's which has multiple
> > @@ -13,6 +18,18 @@
> >         interrupt related then 2 set of register has to supplied. First set
> >         belongs to each instance of TMU and second set belongs to second set
> >         of common TMU registers.
> > +
> > +  NOTE: On Exynos5420, the TRIMINFO register is misplaced for TMU
> > +       channels 2, 3 and 4
> > +       Use "samsung,exynos5420-tmu-triminfo" in cases, there is a misplaced
> > +       register but no need of another clock to access that base.
> > +       Use "samsung,exynos5420-tmu-triminfo-clk" in cases where there is a misplaced
> > +       register and we need another clock to access that base.

This would have made more sense to have next to the compatible strings.

Instead of this, you could have a boolean property
("samsung,misplaced-triminfo") to describe the misplaced triminfo
register(s), and the presence of an additional clock would imlpy that
it's required for accessing triminfo register(s).

> > +
> > +       TRIMINFO at 0x1006c000 contains data for TMU channel 3
> > +       TRIMINFO at 0x100a0000 contains data for TMU channel 4
> > +       TRIMINFO at 0x10068000 contains data for TMU channel 2
> > +
> >  - interrupts : Should contain interrupt for thermal system
> >  - clocks : The main clock for TMU device
> >  - clock-names : Thermal system clock name
> > @@ -43,6 +60,34 @@ Example 2):
> >                 clock-names = "tmu_apbif";
> >         };

I'd have expected the clock-names to have an addition. The names of the
clock inputs are presumably well known, or you should be able to come up
with some sensible names...

> >
> > +Example 3): (In case of Exynos5420 "with misplaced TRIMINFO register")
> > +       /* tmu for CPU2 */
> > +       tmu@10068000 {
> > +               compatible = "samsung,exynos5420-tmu-triminfo";
> > +               reg = <0x10068000 0x100>, <0x1006c000 0x4>;
> > +               interrupts = <0 184 0>;
> > +               clocks = <&clock 318>;
> > +               clock-names = "tmu_apbif";
> > +       };
> > +
> > +       /* tmu for CPU3 */
> > +       tmu@1006c000 {
> > +               compatible = "samsung,exynos5420-tmu-triminfo-clk";
> > +               reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
> > +               interrupts = <0 185 0>;
> > +               clocks = <&clock 318>;
> > +               clock-names = "tmu_apbif", "tmu_triminfo_apbif";

Each clock-names entry should correspond to an entry in clocks. The
"tmu_triminfo_apbif" entry here doesn't correspond to anything. I assume
a copy-paste error?

The "tmu_triminfo_apbif" clock name should be documented in the binding.

> > +       };
> > +
> > +       /* tmu for GPU */
> > +       tmu@100a0000 {
> > +               compatible = "samsung,exynos5420-tmu-triminfo-clk";
> > +               reg = <0x100a0000 0x100>, <0x10068000 0x4>;
> > +               interrupts = <0 215 0>;
> > +               clocks = <&clock 318>;
> > +               clock-names = "tmu_apbif", "tmu_triminfo_apbif";

Similarly here...

Thanks,
Mark.
