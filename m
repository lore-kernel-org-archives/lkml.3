Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab3GEJto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:49:44 -0400
Received: from mail.abilis.ch ([195.70.19.74]:28411 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083Ab3GEJtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:49:40 -0400
Date: Fri, 5 Jul 2013 11:49:01 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
Message-ID: <20130705094859.GA27196@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
 <51C23222.2060906@wwwdotorg.org>
 <20130626115051.GC7095@ab42.lan>
 <51CB279A.1090404@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51CB279A.1090404@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:40:42AM -0600, Stephen Warren wrote:
> On 06/26/2013 05:50 AM, Christian Ruppert wrote:
> > On Wed, Jun 19, 2013 at 04:35:14PM -0600, Stephen Warren wrote:
> >> On 06/18/2013 03:29 AM, Christian Ruppert wrote:
> [...]
> >>> +Example
> >>> +-------
> >>> +
> >>> +iomux: iomux@FF10601c {
> >>> +	compatible = "abilis,tb10x-iomux";
> >>> +	reg = <0xFF10601c 0x4>;
> >>> +	pctl_gpio_a: pctl-gpio-a {
> >>> +		pingrp = "gpioa_pins";
> >>> +	};
> >>> +	pctl_uart0: pctl-uart0 {
> >>> +		pingrp = "uart0_pins";
> >>> +	};
> >>> +};
> >>
> >> The two nodes pctl-gpio-a and pctl-uart0 seem to be missing data. The
> >> idea here is that you define nodes that says:
> >>
> >> * This node applies to these pin(s)/group(s).
> >> * Select mux function X on those pins/groups and/or apply these pin
> >> configuration options to those pins/groups.
> >>
> >> The examples above don't include any mux/config options, nor does the
> >> binding say how to do specify them.
> >>
> >> The set of pin groups defined by this binding should correspond directly
> >> to the set of pin groups that actually exist in HW. So, if you have 3
> >> pin groups (A, B, C) in HW each of which has two mux functions (X, Y),
> >> your DT binding should define just 3 pin groups (A, B, C), not 6 (A_X,
> >> A_Y, B_X, B_Y, C_X, C_Y). In other words, the pin group name shouldn't
> >> imply the mux function.
> > 
> > Can we consider it as agreed now that this implementation is acceptable
> > for the TB10x pin controller?
> 
> There are two issues here:
> 
> 1) What is a pin group:
> 
> 1a) Must it solely represent a group of pins that actually exists in HW
> (e.g. it's an RTL port, or a set of pins all controlled at once by a
> single bit/field in a register)
> 
> 1b) A SW-defined group of pins, simply because it's convenient to talk
> about that set of pins at once, even though HW doesn't impose that those
> pins are in a group in any way.
> 
> Defining groups for either of those reasons is fine, although this is
> the area where my preference and LinusW's differ.
> 
> 2) Can groups represent just a set of pins, or can it also imply that a
> particular mux function is selected on that group?
> 
> I believe that both LinusW and I are in agreement that a group is simply
> a list/set/group of pins. You select mux functions onto groups. A
> groups's definition can't imply that a particular mux function is
> selected onto it.
> 
> If we don't follow this rule, then you end up with a combinatorial
> explosion of groups; the cross-product of all possible groups of pins
> vs. the mux function to select on them, rather than simply having a list
> of groups of pins, which is a much smaller set/list.
> 
> So, in the DT example above, I still believe that you need an extra
> property that defines which mux function to select onto the specified
> group. The group name can't imply this, so there needs to be some way of
> specifying it.

In your opinion, would something in the lines of

pctl_spi1: pctl-spi1 {
	abilis,pingrp = "spi1";
	abilis,ioport = <4>;   /* spi1 is routed to port4 inside the
				pin controller */
	abilis,ioconf = <1>;   /* spi1 is available in configuration 1
				of that port. */
};

be more appropriate? This nicely defines which pins of which port are
requested and what is the configuration required (and it reflects our
hardware very well).
In future, this could even be extended to allow several alternative
configurations for a given function, e.g.

pctl_spi3: pctl-spi3 {
	abilis,pingrp = "spi3";
	abilis,ioport = <6>;
	abilis,ioconf = <0 3>; /* spi3 is available in both
				configurations 0 and 3. Depending on
				what other functions are requested, the
				pinctrl driver can choose either of the
				two. */
};

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
