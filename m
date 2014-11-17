Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaKQPCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:02:32 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43478 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbaKQPCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:02:31 -0500
Date: Mon, 17 Nov 2014 15:01:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/11] arm: perf: document PMU affinity binding
Message-ID: <20141117150145.GA25416@leverpostej>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
 <1415377536-12841-8-git-send-email-mark.rutland@arm.com>
 <CAL_Jsq+u9--tP-pYBut0V6oAnRDbwqpaJ9UMyW55AhCNFV10sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+u9--tP-pYBut0V6oAnRDbwqpaJ9UMyW55AhCNFV10sA@mail.gmail.com>
Thread-Topic: [PATCH 07/11] arm: perf: document PMU affinity binding
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

I appear to have typo'd your address when posting this. Sorry about
that; I'll make sure it doesn't happen again.

On Mon, Nov 17, 2014 at 02:32:57PM +0000, Rob Herring wrote:
> On Fri, Nov 7, 2014 at 10:25 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > To describe the various ways CPU PMU interrupts might be wired up, we
> > can refer to the topology information in the device tree.
> >
> > This patch adds a new property to the PMU binding, interrupts-affinity,
> > which describes the relationship between CPUs and interrupts. This
> > information is necessary to handle systems with heterogeneous PMU
> > implementations (e.g. big.LITTLE). Documentation is added describing the
> > use of said property.
> >
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > ---
> >  Documentation/devicetree/bindings/arm/pmu.txt | 104 +++++++++++++++++++++++++-
> >  1 file changed, 103 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/pmu.txt b/Documentation/devicetree/bindings/arm/pmu.txt
> > index 75ef91d..23a0675 100644
> > --- a/Documentation/devicetree/bindings/arm/pmu.txt
> > +++ b/Documentation/devicetree/bindings/arm/pmu.txt
> > @@ -24,12 +24,114 @@ Required properties:
> >
> >  Optional properties:
> >
> > +- interrupts-affinity : A list of phandles to topology nodes (see topology.txt) describing
> > +            the set of CPUs associated with the interrupt at the same index.
> 
> Are there cases beyond PMUs we need to handle? I would think so, so we
> should document this generically.

That was what I tried way back when I first tried to upstream all of
this, but in the mean time I've not encountered other devices which are
really CPU-affine which use SPIs and hence need a CPU<->IRQ relationship
described.

That said, I'm happy to document whatever approach for referring to a
set of CPUs that we settle on, if that seems more general than PMU IRQ
mapping.

> > -Example:
> > +Example 1 (A single CPU):
> 
> Isn't this a single cluster of 2 cpus?

Yes, it is. My bad.

> >  pmu {
> >          compatible = "arm,cortex-a9-pmu";
> >          interrupts = <100 101>;
> >  };
> > +
> > +Example 2 (Multiple clusters with single interrupts):
> 
> The meaning of single could be made a bit more clear especially if you
> consider Will's case. But I haven't really thought of better
> wording...

How about "A cluster of homogeneous CPUs"?

> > +
> > +cpus {
> > +       #address-cells = <1>;
> > +       #size-cells = <1>;
> > +
> > +       CPU0: cpu@0 {
> > +               reg = <0x0>;
> > +               compatible = "arm,cortex-a15-pmu";
> > +       };
> > +
> > +       CPU1: cpu@1 {
> > +               reg = <0x1>;
> > +               compatible = "arm,cotex-a15-pmu";
> > +       };
> > +
> > +       CPU100: cpu@100 {
> > +               reg = <0x100>;
> > +               compatible = "arm,cortex-a7-pmu";
> > +       };
> > +
> > +       cpu-map {
> > +               cluster0 {
> > +                       CORE_0_0: core0 {
> > +                               cpu = <&CPU0>;
> > +                       };
> > +                       CORE_0_1: core1 {
> > +                               cpu = <&CPU1>;
> > +                       };
> > +               };
> > +               cluster1 {
> > +                       CORE_1_0: core0 {
> > +                               cpu = <&CPU100>;
> > +                       };
> > +               };
> > +       };
> > +};
> > +
> > +pmu_a15 {
> > +       compatible = "arm,cortex-a15-pmu";
> > +       interrupts = <100>, <101>;
> > +       interrupts-affinity = <&CORE0>, <&CORE1>;
> 
> The phandle names are wrong here.

Whoops. I've fixed that up locally now.

Thanks,
Mark.
