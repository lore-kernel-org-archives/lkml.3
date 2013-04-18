Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3DRJDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:03:46 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27791 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab3DRJDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:03:43 -0400
Date: Thu, 18 Apr 2013 11:03:11 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
Message-ID: <20130418090310.GA17636@ab42.lan>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
 <516EEAA0.10906@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <516EEAA0.10906@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Stephen and Linus,

I am responding to this message because it touches the core issue I was
wondering about when integrating pinctrl with GPIO. I think all
unrelated comments in your other messages are valid and will be
addressed in the next iteration of both drivers.

On Wed, Apr 17, 2013 at 12:32:00PM -0600, Stephen Warren wrote:
> On 04/10/2013 09:45 AM, Christian Ruppert wrote:
> > The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
> > Used to control the pinmux and is a prerequisite for the GPIO driver.
> 
> Linus already did a review of this, but I have a few extra comments:
> 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt b/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt
> 
> > +Abilis Systems TB10x pin controller
> > +===================================
> > +
> > +Required properties
> > +-------------------
> > +
> > +- #address-cells: should be <1>.
> > +- #size-cells: should be <1>;
> 
> What are those two used for? They would normally only be required if the
> child nodes of the pinctrl node contained "reg" properties. But, they
> don't in the examples later in this file.

Agree, this seems to be a mistake. The properties will be removed.

> > +Ports are defined (and referenced) by sub-nodes of the pin controller. Every
> > +sub-node defines exactly one port (i.e. a set of pins). Ports are defined by
> > +their names in the pin controller driver.
> 
> I'm not really sure what the implication here is. Does this mean that
> the driver isn't expected to contain tables which define which
> pins/groups/functions exist, but rather gets those lists/tables from the
> DT? I prefer not to do that, although it is acceptable to write the
> binding/driver this way.

We have the entire pin data base implemented in the pinctrl driver. This
includes if a pin can or cannot be used as GPIO and which range it
belongs to. Making this information redundant in both GPIO and pinctrl
drivers is a bad idea IMHO. Thus, the pin controller's sub nodes are
merely defined to have phandles so that we can use pinctrl core
functionality. The reasoning is the following:

We would like to avoid the use of Linux pin numbers in the device tree.
Customers are used to physical pin numbers and exposing the logical
Linux-internal numbering scheme through the device tree would generate
quite some confusion. There are two reasons why we cannot align the two:
  - Not all products supported by these drivers have the same pin outs.
  - GPIO ranges must be consecutive in the Linux pin numbering space
    which is generally not the case in physical pin numbering.

If I understand Documentation/devicetree/bindings/gpio/gpio.txt
correctly, the "standard" gpio-ranges definition does use Linux logical
pin numbers, however. This disqualifies gpio-ranges from being used in
our device tree. I haven't found a clean way around this dilemma, thus
the current implementation duplicating parts of the core system and
cross-calling pinctrl from GPIO.

I am well aware of the problem but I haven't found any documentation,
core functions or examples which solve this. The most elegant way would
be some core functionality allowing to define GPIO ranges by directly
querying the pin data base (or to preregister GPIO ranges in the pin
controller to which GPIO drivers can then "attach"). Is there something
like this I have missed?

As a side note, the same argument does not apply to gpio-base, btw, for
two reasons:
  - Our customer documentation does not talk about a global GPIO
    numbering scheme. In our products, GPIOs are organised in banks and
    there is no risk of confusion.
  - The Linux-internal GPIO numbering is already exposed to customers
    through the /sys/class/gpio interface.
That said, if we solve the cross-calling issue I can still move it to
the pin data base in the next patch set since you are right that there
is no real reason to make it "user-configurable" through DT.

> So there seems to be something huge missing here; the only property
> defined here for the child nodes is "pingrp". In the examples, there's
> nothing else used. I don't see how this binding allows the actual
> desired mux functions to be specified. All other pinctrl DT bindings
> have the child nodes contain something along the lines of:
> 
> * A list of pins/groups to apply the settings to.

This is what the pingrp string refers to. We really don't want to expose
Linux internal pin numbers!

> * A property defining the mux function to select on those pins/groups.

The muxing possibilities between the individual pin groups are part of
the pin database in the driver.

> * Other properties defining configuration for those pins/groups, such as
> pull-up/down, drive-type, drive-strength, etc.

These are not configurable in the TB10x series of chips.

> All that seems missing here. Surely it's required?
> 
> Perhaps this "abilis,simple-default" thing is intended to represent some
> specific default configuration? If so, I don't think that's the right
> way to go. Also, the DT binding should be as complete as possible from
> the start, rather than planning to define/implement part of it now and
> then keep adding to it later. This all implies that some extra
> properties really should be defined here.

The abilis,simple-default thing is simply there because I missed commit
ab78029ecc347debbd737f06688d788bd9d60c1d and followed
Documentation/pinctrl.txt a bit too closely. ("So if possible, handle
the pin control in platform code or some other place where you have
access to all the affected struct device * pointers.") Currently, our
platform code iterates through nodes compatible with
abilis,simple-pinctrl and sets up the pin controller accordingly. I'll
happily remove this mechanism.

Best regards and thanks for your valuable feedback,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
