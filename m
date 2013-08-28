Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3H1OsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:48:01 -0400
Received: from mail.abilis.ch ([195.70.19.74]:26804 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3H1Or7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:47:59 -0400
Date: Wed, 28 Aug 2013 16:47:36 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
Message-ID: <20130828144736.GA7066@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com>
 <20130805115118.GF20936@ab42.lan>
 <CACRpkdaXqHHF5oDsWSCyhzUOurrxfLhS40=csGJFT8fK4WkA4A@mail.gmail.com>
 <20130821155751.GB3046@ab42.lan>
 <5216704F.60007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5216704F.60007@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 02:10:55PM -0600, Stephen Warren wrote:
> On 08/21/2013 09:57 AM, Christian Ruppert wrote:
> > On Wed, Aug 14, 2013 at 06:53:56PM +0200, Linus Walleij wrote:
> >> On Mon, Aug 5, 2013 at 1:51 PM, Christian Ruppert
> >> <christian.ruppert@abilis.com> wrote:
> >>> [Me]
> >>>> I don't see any of the port concept creeping into the device tree
> >>>> in this version and that is how I think it should be kept:
> >>>> the "port" particulars is a thing for the driver and not the
> >>>> device tree.
> ...
> >>> In the driver under discussion, pin groups are defined for every
> >>> "interface" to make sure that interfaces can be requested in an
> >>> orthogonal way by different modules and modules don't have to be "aware"
> >>> of which interfaces are grouped into which port (and which other modules
> >>> request which other interfaces). A request either succeeds or fails.
> >>> Resource management (which interfaces can be mapped simultaneously) is
> >>> done inside the pinctrl driver.
> >>
> >> OK
> > 
> > This actually looks 100% coherent with Documentation/pinctrl.txt. But
> > then I don't understand Stephen's request to introduce the concept of
> > "ports" in the device tree. IMHO ports are a hardware limitation which
> > should be managed inside the pinctrl driver and if possible not leak
> > out of it. Also (as stated above), the concept of "ports" does not even
> > exist in the pinmux framework so why introduce it for DT?
> > 
> > I might have thoroughly misunderstood you here, Stephen. Please be
> > patient with me and explain once more.
> 
> I don't think I asked for ports to be represented in DT. Do you have
> more context?

Well, you never asked about ports but you asked specifically about pin
groups. The most concise definition of pin groups I have found in your
mails is from https://lkml.org/lkml/2013/6/21/462:

> When I pushed for the concept of groups, I intended it to mean precisely
> one single thing. The points below describe this.
> 
> 1) A pin is a single pin/ball/pad on the package.
> 
> 2) Some register fields affect just a single pin. For example, there may
> be a register field that affects pin A8's mux setting only.
> 
> 3) Some register fields affect multiple pins at once. For example,
> perhaps one register field affects both pin A8's an pin A7's mux setting
> at once.
> 
> 4) Depending on HW design, all register fields might be of type
> described at (2) above, or all of the type described at (3) above, or a
> mixture of both. Tegra is a mixture.
> 
> 5) I expect the concept of a pin group to solely represent the various
> groups of pins affected by each register field; in (2) above one pin per
> group, in (3) above many pins per group.
> 
> Thus, to my mind, a pin group is purely a HW concept, and dictated
> purely by HW design.

Point 5 clearly defines the "concept of a pin group to solely represent
the various groups of pins affected by each register field". The TB10x
definition of a "port" (concept which doesn't seem to exist in the pinctrl
framework) is the set of pins controlled by the same register field
(i.e. the same mux). In my understanding this matches point 5 but as I
said this is probably a misunderstanding and I would be grateful for
clarification. There are other comments which fuel that
misunderstanding, e.g. https://lkml.org/lkml/2013/6/19/589:

> Pin groups are supposed to be something that represents some property of
> the pinctrl HW itself. So, if you have register "X" bits 3-0 that define
> the mux function for pins 8, 9, 10, and 11, then there really is a pin
> group that exists in HW, and that pin group will still exist with that
> same definition no matter what SoC you put the pinctrl HW into. If this
> changes, it's not the same pinctrl HW module.

In TB10x, every function can be activated on exactly one pin group, and
Documentation/pinctrl.txt says "If only one possible group of pins is
available for the function, no group name need to be supplied.".

Maybe the answer to our concrete question of the tb10x driver is thus
renaming the pingrp device tree property of the original patch into
something like function (by which a pin group can be implied)?

For example:
iomux: iomux@FF10601c {
        compatible = "abilis,tb10x-iomux";
        reg = <0xFF10601c 0x4>;
        pctl_gpio_a: pctl-gpio-a {
                abilis,function = "gpioa";
        };
        pctl_uart0: pctl-uart0 {
                abilis,function = "uart0";
        };
};

What do you think?
  Christian
