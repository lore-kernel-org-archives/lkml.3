Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab3HELvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:51:45 -0400
Received: from mail.abilis.ch ([195.70.19.74]:18607 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3HELvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:51:43 -0400
Date: Mon, 5 Aug 2013 13:51:19 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
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
Message-ID: <20130805115118.GF20936@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 12:35:03AM +0200, Linus Walleij wrote:
> Sorry for taking eternities to look into this.
> 
> On Tue, Jun 18, 2013 at 11:29 AM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> 
> > The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
> > Used to control the pinmux and is a prerequisite for the GPIO driver.
> >
> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> (...)
> > +The following pin groups are available:
> > +  - GPIO ports: gpioa_pins, gpiob_pins, gpioc_pins, gpiod_pins, gpioe_pins,
> > +                gpiof_pins, gpiog_pins, gpioh_pins, gpioi_pins, gpioj_pins,
> > +                gpiok_pins, gpiol_pins, gpiom_pins, gpion_pins
> 
> I would not attempt to define groups for all GPIO pins.
> 
> (...)
> > +gpioa: gpio@FF140000 {
> > +       compatible = "abilis,tb10x-gpio";
> > +       reg = <0xFF140000 0x1000>;
> > +       gpio-controller;
> > +       #gpio-cells = <2>;
> > +       ngpio = <3>;
> > +       gpio-ranges = <&iomux 0 0>;
> > +       gpio-ranges-group-names = "gpioa_pins";
> 
> This uses that feature to define GPIO ranges from a group does
> it not? I'm not certain about that feature.

It does. The idea is that the entire pin data base is defined inside the
pin controller (or the pin controller device tree nodes) and the rest of
the world just uses symbolic names. The possibility of non-contiguous
ranges comes for free. What is the argument against this? In my
understanding it was agreed that this was a desired feature, patch
c8587eeef8fc219e806e868c6f0c7170c769efab is the first step in this
direction?

> I don't see any of the port concept creeping into the device tree
> in this version and that is how I think it should be kept:
> the "port" particulars is a thing for the driver and not the
> device tree.

I'm not sure if everybody is aligned here (or if we even understand each
other): In my terminology, a "port" is a set of pins controlled by the
same register/bit field. An "interface" is a set of pins which form a
functional unit, e.g. an SPI interface. One port can contain several
interfaces which may or may not be mapped at the same time. Inversely
(especially if every pin can be configured separately), mapping of an
interface might require the configuration of more than one ports. The
concept of interfaces is on a higher level of abstraction (in the sense
"further away from physical pinmux configuration") than the concept of a
port.

In the driver under discussion, pin groups are defined for every
"interface" to make sure that interfaces can be requested in an
orthogonal way by different modules and modules don't have to be "aware"
of which interfaces are grouped into which port (and which other modules
request which other interfaces). A request either succeeds or fails.
Resource management (which interfaces can be mapped simultaneously) is
done inside the pinctrl driver.

If I understand Stephen correctly, the traditional way of requesting pin
configurations is at "port" level, e.g. a configuration is defined by a
port and its mux setting. The TB10x driver works on a higher level of
abstraction ("interface" level), where interfaces are requested and the
driver internally decides which configuration(s) to apply to which
port(s). Ports are not used in the device tree indeed, but interfaces
are.

Based on this, I don't quite understand your comment: You say you don't
like ports starting to leak outside of the pinctrl driver but according
to Stephen that's what is common practice today? Did you mean
interfaces? The TB10x driver's configuration nodes are currently defined
based on interfaces.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
