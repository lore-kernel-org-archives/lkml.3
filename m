Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3GYEQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:16:00 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47299 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3GYEPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:15:09 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: The future of DT binding maintainership
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, devicetree@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <2962401.WRRoYlXkRr@flatron>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com> <20130720034647.2B7B43E14BF@localhost> <2962401.WRRoYlXkRr@flatron>
Date: Wed, 24 Jul 2013 15:11:12 +0100
Message-Id: <20130724141112.464623E09C5@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jul 2013 15:49:21 +0200, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Saturday 20 of July 2013 04:46:47 Grant Likely wrote:
> > A number of us had a face-to-face meeting in Dublin last week to talk
> > about DT maintainership and the fact that it simply isn't working right
> > now. Neither Rob nor I can keep up with the load and there are a lot of
> > poorly designed bindings appearing in the tree.
> > 
> > Device tree binding maintainership needs to be split off to a separate
> > group, and we've started with a few people willing to help, Pawel Moll,
> > Mark Rutland, Stephen Warren and Ian Campbell.
> > 
> > (BTW, even though I've already sent a patch adding that group
> > MAINTAINERS, this is not set in stone. Anyone else wanting to help
> > maintain should volunteer)
> > 
> > Another thing discussed is that we need to start validating DT schema
> > with an extension to dtc. Tomasz Figa has volunteered to do this work
> > and has support from his employer to spend time on it. What I'm hoping
> > to have is that the DT schema will get checked as part of the dts build
> > process so that any DT file that doesn't match the documented schema
> > will get flagged, and that the schema files will be human readable and
> > will double as documentation.
> > 
> > There is not yet any process for binding maintainership. We talked about
> > a few ideas, but they really need to be hashed out here on the mailing
> > list. A couple of the questions:
> > 
> > - How are bindings allowed to be merged? Through subsystem trees, or
> >   only through the bindings tree?
> >   - Through the bindings tree is more work but it will provide more
> >     control.
> >   - Through subsystem trees means drivers and bindings get merged
> >     together.
> >   - If we have a schema tool that reports errors on missing or
> >     unapproved schema, then spliting the driver from the binding won't
> >     matter that much.
> > - Do we need to differentiate between 'staging' and 'stable' bindings?
> > - What is the schedule for splitting the bindings and .dts files out of
> >   the kernel?
> >   - Ian Campbell is maintaining a DT bindings and .dts mirror tree which
> > should eventually become the 'master' for merging DT bindings.
> 
> I remember getting to a conclusion that:
>  - bindings should enter staging state after being introduced,
>  - from time to time a binding review meeting should take place (on IRC 
> possibly) and discuss which of introduced staging bindings are ready to 
> enter stable state,
>  - in stable state such binding would be considered an ABI.
> 
> From remaining questions I remember:
>  - How should we mark bindings as staging and stable? (i.e. 
> documentation/schema files in different folders or something else?)

I think having a different folder for staged bindings is going to be the
most managable. The other option would be a tag in the file indicating
that it is stable, but I suspect that will require more work in the long
run. At least with a staging directory you can tell at a glance which
bindings are in draft form. Any bindings used from the staging directory
should trigger a warning from DTC, but we probably want to consolidate
all 'staging' binding warnings into a single message so that dtc output
doesn't get too chatty.

Once a binding is moved into the stable directory, only backwards
compatible changes should be allowed.

>  - Should we also split parts of dts/dtsi using staging bindings from 
> those using stable ones? (This could mean including stable dts/dtsi file 
> from inside unstable one, which would allow having a stable dts with basic 
> functionality that could be extended over the time after validating 
> staging bindings used in unstable part.)

Good question. Need to try it out and see how it works from a
maintainership standpoint.

> As for my part, I'm now looking into existing infrastructure inside of dtc 
> to get some hints that would allow me to design the initial schema syntax 
> in a most dtc-friendly way. Give me a bit more time and I will then write 
> down everything I have and post to the ML to start a discussion.

I think for any given schema, it should probably have the following
elements or sections:

1) A set of properties/characteristics to match against.
  - The most likely case here will be entries in the compatible
    property, but there are a few device_type and name matches that will
    need to be supported
2) a set of required/optional properties and child nodes
3) a set of 'inhereted' schema.
  - for example, the vast majority of device bindings will want to
    inherit from the common 'reg' and 'interrupts' definitions.
  - Another example: a gpio controller will want to inherit the generic
    gpio controller schema.

I wouldn't get to hung up about trying to reuse the same file format as
the .dts files. Most of the bindings are going to be very flat in
nature, and schemas need to be expresive in a different way from the
.dts files themselves.

We'll want to have an easy way to define trivial bindings. There are a
lot of devices that only define a new 'compatible' string, but they
don't actually require anything more than reg and interrupts. Can we
maybe have a schema file that lists trivial bindings?

There will need to be a way to describe cross-schema interactions. For
example, consider the gpio-leds binding and the gpio controller binding.
The gpio-controller node needs to have inherited the gpio controller
schema. Similarly, the gpio-leds schema will need the gpio-consumer
binding, but it will also need to verify that the gpio-controller
conforms to the gpio controller schema.

Here's a really rough draft at a few schema files. This is /not/ a
really good syntax yet. One problematic part is figuring out how to
dereference values from other nodes.

core-reg.dtschema:
	required: reg = <[%address% %size%]*> // '*' indicates one or more tuples
	%address%: size = parent.#address-cells * 4;
	%size%: size = parent.#size-cells * 4;

core-interrupt.dtschema:
	required: interrupts = <[%intspec%]*>
	%intspec%: size = %interrupt-parent%:#interrupt-cells;
	optional: interrupt-parent = <%interrupt-phandle%> // need a way to search up the tree

core-interrupt-controller.dtschema:
	required: interrupt-controller;
	required: #interrupt-cells = <num>;
	%intspec%: size = interrupt-parent:#interrupt-cells;

arm-gic.dtschema:
	match: compatible = ".*arm,{cortex-{a15,a9,a7},arm11mp}-gic.*"
	inherit-required: core-reg;
	inherit-required: core-interrupt-controller;
	inherit-optional: core-interrupt;
	required: #interrupt-cells = <3>;

g.
