Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab3FYMAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:00:39 -0400
Received: from mail.abilis.ch ([195.70.19.74]:14345 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab3FYMAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:00:37 -0400
Date: Tue, 25 Jun 2013 13:59:51 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
Message-ID: <20130625115950.GB30827@ab42.lan>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
 <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
 <51BA3BC1.3090109@wwwdotorg.org>
 <20130614091241.GA23745@ab42.lan>
 <51C1F42E.5090107@wwwdotorg.org>
 <51C1F82C.4020502@wwwdotorg.org>
 <20130620115710.GB942@ab42.lan>
 <51C4C2ED.5090505@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51C4C2ED.5090505@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 03:17:33PM -0600, Stephen Warren wrote:
> On 06/20/2013 05:57 AM, Christian Ruppert wrote:
> > Hello Stephen,
> > 
> > On Wed, Jun 19, 2013 at 12:27:56PM -0600, Stephen Warren wrote:
> >> On 06/19/2013 12:10 PM, Stephen Warren wrote:
> >>> On 06/14/2013 03:12 AM, Christian Ruppert wrote:
> >>>> On Thu, Jun 13, 2013 at 03:38:09PM -0600, Stephen Warren wrote:
> >>>>> On 06/13/2013 06:55 AM, Christian Ruppert wrote:
> >> [...]
> >>>>> The potential advantage of this patch is that the pinctrl-side of the
> >>>>> mapping can be a group name rather than pin IDs, which might reduce the
> >>>>> size of the mapping list if you have an extremely sparse or non-linear
> >>>>> mapping /and/ parts of that mapping just happen to align with the pin
> >>>>> groups in the pin controller HW, since each entry in the gpio-ranges
> >>>>> property can be sparse/non-linear, rather than being a small linear
> >>>>> chunk of the mapping.
> >>>>
> >>>> Pin controller authors have the freedom to define pin groups just for
> >>>> the purpose of "predefining" the pinctrl side of GPIO ranges.
> >>>
> >>> Hmm. I suppose that's true. I'm not sure how enthusiastic I am about
> >>> doing this though... The reason I'm unsure is because it starts using
> >>> pin groups from something other than groups of pins in HW that are all
> >>> affected by the same mux or config bits in a register, and starts using
> >>> pin groups for something else; GPIO<->pinmux pins mapping. Perhaps it's
> >>> OK though, considering the other abuses of pin groups that are already
> >>> present, such as using pin groups to represent default/common uses of
> >>> groups of pins that don't actually exist in HW.
> > 
> > The reason for these "abuses" might just be that every company (or maybe
> > even hardware team) has a different understanding of how pin muxing
> > should be implemented in hardware. There are probably as many different
> > pin muxing architectures out there as companies (maybe even more).
> > Finding a "one size fits all"-approach to this is extremely difficult
> > and driver authors adapt the kernel infrastructure as well as they can
> > to the hardware they have. As an example, see below for a fundamental
> > cultural difference between your hardware/integration team and ours.
> 
> The issues I'm talking about are more SW issues; people have created
> "pin groups" that represent both a set of pins/groups *and* the function
> the is muxed onto them (and perhaps pin config settings too), rather
> than having the driver create "pin groups" that actually represent just
> groups of pins, and then using the DT pinctrl bindings as intended to
> select which mux/config settings to use for that group.

It looks like the TB10x is similar to this, see below for the details
and our reasoning.

> >> I've realized what I don't like about this.
> >>
> >> Pin groups are supposed to be something that represents some property of
> >> the pinctrl HW itself. So, if you have register "X" bits 3-0 that define
> >> the mux function for pins 8, 9, 10, and 11, then there really is a pin
> >> group that exists in HW, and that pin group will still exist with that
> >> same definition no matter what SoC you put the pinctrl HW into. If this
> >> changes, it's not the same pinctrl HW module.
> > 
> > Let me see if I get this right (Let's take the example in the section
> > "What is pinmuxing" of Documentation/pinctrl.txt in Linux-3.10-rc6 which
> > is similar to TB10x):
> > If I understand you correctly, you define two pin groups in this
> > example: 
> > gpr1 = {A5, A6, A7, A8, B5};
> > grp2 = {A1, B1, C1, D1, E1, F1, G1, G2, G3, G4, H1};
> > 
> > grp1 has three configurations: allgpio, i2c and spi
> > grp2 has five configurations: allgpio, mmc2, mmc2_spi, mmc4, mmc4_spi, mmc8
> 
> No, I don't think so at all.
> 
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

To define some terminology, let's call a set of pins affected by the
same register / bit field a "port".

> 4) Depending on HW design, all register fields might be of type
> described at (2) above, or all of the type described at (3) above, or a
> mixture of both. Tegra is a mixture.

TB10x is all (3).

> 5) I expect the concept of a pin group to solely represent the various
> groups of pins affected by each register field; in (2) above one pin per
> group, in (3) above many pins per group.

In our example above, TB10x would have two ports, i.e. two bit fields in
its pinctrl register. Each of those bit fields would allow selecting one
of the configurations for grp1 and grp2 respectively.
Do I understand your explanation correctly: You would implement the TB10x
pinctrl exactly like the example above, two pin groups with three and
five configurations?

> Thus, to my mind, a pin group is purely a HW concept, and dictated
> purely by HW design.
> 
> > Let's assume that unused pins are automatically configured as GPIOs in
> > each configuration. The pin controller thus requires a second list of
> > pins (for each of the modes), defining for which pins in each group it
> > can grant gpio_requests in a given mode. Furthermore, the mmc node will
> > have to "know" if mode "mmc2" or "mmc2_spi" must be selected for a given
> > setup, making the thing somewhat unorthogonal.
> 
> The Linux pinctrl subsystem specifically doesn't provide mutual
> exclusion between "mux function" and GPIO usage within a pin group,
> although perhaps a driver could internally.

The TB10x driver does.

> Consider a pin group in HW that encompasses 10 pins, but you've selected
> a function onto it that only actually uses 6 pins for that logical
> function. The other 4 pins aren't used, and can be GPIO. However, all
> pins in the group are "claimed" because some mux function has been
> selected onto the group that includes those 10 pins. In order to allow
> some of those pins to be claimed as a GPIO, the pinctrl core simply
> allows GPIO usage and mux function usage to be claimed on each
> individual pin without regard for each-other.

This might be the main source of confusion. I admit that I hadn't
understood (and still think it is at least unorthogonal if not
semantically wrong) that an entire port must be claimed if just one
interface inside the port is required. Probably many other driver
authors (those you mention above) didn't understand this either.

> Now, it would indeed be possible for each combination of (pin group, mux
> function) to be associated with a list of pins from the group that could
> be used as GPIO, and then for the pinctrl core to additionally enforce
> that only those pins be claimed for GPIO usage. However, the pinctrl
> core does not do this at present.

This is why it is implemented inside the TB10x driver.

> It's also a little difficult to completely validate that. Consider a mux
> function that routes the pins to a HW module that considers some of the
> signals to be optional. If one of those optional signals is used, then
> the pin that would have carried it shouldn't be claimed as a GPIO, but
> it the signal isn't used, then the pin will be free to use as a GPIO.
> The selection of whether to use that optional signal may be outside the
> realm of the pinctrl HW, i.e. in the HW module associated with the
> selected mux function. Hence, pinctrl can't know whether the optional
> signal is actually used, and hence can't conditionally allow it to be
> used as a GPIO.

If the assumption you make below is correct and pinctrl hardware is
generally implemented as shown in diagram (3), the pin controller cannot
be completely agnostic of the fact that a given pin is either a GPIO or
part of an interface.

> To avoid pinctrl having to be completely nit-picky and
> complex, it implements a simple approach and just allows absolutely any
> GPIO/mux-function co-existence, with the expectation that if someone
> attempts to use the HW incorrectly, it won't work, and they'll just fix
> their SW/DT to actually request the correct configuration.

I'm perfectly happy with that: Today we have both options, let the
pinctrl driver manage conflicts or let the software/device tree author
manage everything manually. Every SoC vendor can decide for every
product which strategy to employ and depending on the context both can
make perfect sense.

> > When writing our pinctrl driver, my understanding was slightly
> > different: I define seven pin groups:
> > spi1 = {A5, A6, A7, A8};
> > i2c = {A5, B5};
> > mmc2 = {A1, B1};
> > mmc4 = {A1, B1, C1, D1};
> > mmc8 = {A1, B1, C1, D1, E1, F1, G1, H1};
> > spi2 = {G1, G2, G3, G4};
> > gpios = {A1, A5, A6, A7, A8, B1, B5, C1, D1, E1, F1, G1, G2, G3, G4, H1};

Do I understand your explanation on the very top correctly that this is
actually the strategy you said was wrongly employed in several other
drivers?

> > Now each peripheral can individually request the pins it requires,
> > independently of the others. Conflicts (e.g. between spi1 and i2c or
> > between mmc4 and the GPIO at D1) are managed by the program logic in the
> > pin controller. The advantages are the following:
> >  . The pin controller knows implicitly which pins are used for what and
> >    can easily grant or refuse pin and GPIO requests.
> >  . Conceptually, GPIO requests are now the same as any other
> >    configuration request.
> >  . The information of whether SPI2 is active or not is associated to
> >    spi2 and spi2 only. mmc does not need to know.
> >  . Implementation details of the pin controller hardware (which are the
> >    ports, which configuration to apply to a port to obtain a certain
> >    function) are confined in the pin controller driver.
> 
> I think that set of advantages is all true with the definition of a "pin
> group" that matches exactly what groups exist in HW, i.e. the definition
> I outlined above.

In my understanding, none of them applies:
  . If the pinctrl driver doesn't explicitly have special lists of
    available GPIOs in every mode, it is unable to manage GPIO/interface
    conflicts.
  . GPIO requests are something really special in case the pinctrl
    driver doesn't manage those conflicts: As you explain above the GPIO
    allocation system exists in parallel and completely independently of
    the interface pin claiming system in the pinctrl core.
  . In our example above, different interfaces inside the same port are
    not orthogonal: MMC needs to know if SPI2 is required or not when
    requesting its configuration.
  . Thus, implementation details (which configuration to apply to a
    given port to obtain a given set of functions) leak out of the
    pinctrl driver.

> >> However, the connectivity between GPIO HW module "pins" (i.e. the GPIOs)
> >> and pinctrl HW module "pins" (inputs to mux functions) is something that
> >> only exists at the top-level of the SoC; outside the GPIO HW module
> >> itself, and outside the pinctrl HW module itself.
> > 
> > Well, in the case TB10x, GPIO pins are just the same as any other pins:
> > They go through the pin controller all the same and there is really
> > nothing that distinguishes them from, say, the mmc port in the example
> > above - which can also be mapped either partially or completely. There's
> > no bypassing of the pin controller going on at the top level or such.
> 
> I'd imagine that is true on most chips. It's certainly true on Tegra,
> except for one minor irrelevant detail.
> 
> > And honestly: Have you ever seen a pin controller in which not only the
> > program logic but also the pin data base can be reused from one SOC to
> > another? At least I haven't.
> 
> Yes. A good few years ago I worked on some PPC chip where the pin
> controller itself was 100% generic. It simply provided muxing for each
> of N pins, each of which could have M mux functions (and indeed GPIO
> controllers were one of those mux functions, for at least some of the
> pins). From the pinctrl HW's perspective, the mux functions for each
> pins were just "input 0", "input 1", ... "input n-1". A driver for such
> HW would work no matter what SoC the pinctrl HW was placed into. The DT
> binding would presumably just have pins labelled "0" .. "n-1" and mux
> functions labelled "0" .. "n-1", and it would be up to the DT author to
> consult each specific SoC's datasheet to determine which mux function
> represented "MMC", "SPI", "I2C", ... for each pin. IIRC, IBM actually
> had separate documentation for:
> 
> * The pinmux registers for muxing.
> 
> * The connectivity between the pinmux "pin-side" and the chip
> pins/balls/pads.
> 
> * The GPIO registers.
> 
> * The connectivity between the GPIO controller's GPIO outputs, and the
> pinmux HW's "mux-side" inputs, and similarly for all the other HW
> modules that fed into the pinmux HW's muxes.
> 
> And honestly, I think likely all pinmux HW is this way.

Agreed.

> The only issue are:
> 
> * Datasheet authors tend to document the top-level connectivity of the
> chip as if it were somehow part of the pinmux HW rather than actually
> part of the top-level SoC routing.

This is what I call the pin data base above. You said in a previous mail
that you didn't like declaring pins and pin groups in the device tree. I
don't like that idea either. Thus, they must be part of the driver and
even if the control logic is the same for many chips, the pin data base
is not in most cases (It might not even be the same for different
packaging options of the same die).

> * Some pinmux HW is designed to fit into a specific chip, so connect to
> specific other HW modules, and hence not need to control every pin's mux
> function independantly. This leads to "pin groups" where a single
> register controls N pins at once. This reduces the number of registers
> and amount of flop storage the pinmux HW needs. The exact trade-offs are
> driven by the use-cases intended for the chip. This was the case on
> Tegra20.

It is also the case for TB10x.

> However, this isn't very flexible, and requires significant
> pinmux HW changes should the use-case change. I haven't actually talked
> to the Tegra HW designers about this, but I strongly suspect that's why
> Tegra30 now controls mux function individually per-pin, rather than in
> use-case-targeted groups.
> 
> > On the other hand, For all Abilis chips,
> > the program logic (the actual C functions) of the TB10x pinctrl could be
> > reused with very minor modifications. It would be easy to extend the
> > logic to a generic "Abilis pin controller" where all that needs to be
> > changed in function of the "compatible" string is the pointer to the pin
> > database.
> >
> >> In other words, you could have the exact same GPIO and pinctrl HW
> >> modules instantiated into two different SoCs, but with completely
> >> different mapping of GPIO IDs to pinctrl pin IDs.
> > 
> > Well, you could very well conect a 4 bit mmc port instead of an spi in
> > the above example without changing one thing in the pin controller or
> > the mmc block...
> 
> Right. I expect that's all mostly true of many/most pinmux HW.
> 
> >> As such, it isn't even generally possible for the pinctrl HW module to
> >> define pin groups that describe the mapping, because the mapping is not
> >> a property of the pinctrl HW module, and hence should not be defined,
> >> even partially, by the pinctrl HW module's driver.
> > 
> > This is clearly implementation dependent. In the case of our chips, the
> > opposite is actually the case:
> > 
> > Your remark seems to reflect one of the following two hardware
> > architectures:
> > 
> >                                                      +- SPI
> >                  Physical pins --- GPIO --- pinctrl -+- I2C
> >                                                      +- mmc
> 
> (that's diagram 1)
> 
> > 
> >                                 +- GPIO
> >                  Physical pins -+           +- SPI
> >                                 +- pinctrl -+- I2C
> >                                             +- mmc
> 
> (that's diagram 2)
> 
> > TB10x hardware architecture:
> > 
> >                                             +- SPI
> >                  Physical pins --- pinctrl -+- I2C
> >                                             +- mmc
> >                                             +- GPIO
> 
> (that's diagram 3)
> 
> No, I was thinking of diagram 3 above. I'm not sure if diagrams (1) or
> (2) are common or exist?

If you use per-pin muxing with GPIO functionality implemented inside the
per-pin mux this would e.g. correspond to diagram 2. If you use the same
approach with GPIO plus only one alternative input per pin (e.g. one
configuration bit) and another level of pinctrl for further muxing of
interfaces to that input that would be diagram 1.
At least per-pin-muxing with integrated GPIO functionality (diagram 2)
seems to be used in some cases.

> Certainly when I was contributing the Linux's
> pinctrl SW design, I didn't really consider (1) or (2).

OK, I think I misunderstood you there.

> The issue is this: If the pinctrl and GPIO modules are separate modules,
> then there is some wiring between them. Perhaps you're lucky and the
> GPIO IDs end up exactly matching the mux-side pin IDs in the pin
> controller HW. Perhaps that's not the case.
> 
> Now, inside the pinctrl HW, perhaps there's some other re-ordering;
> perhaps the order of register addresses for mux functions doesn't match
> the order of the datasheet's numbering of pins/bads/balls, or doesn't
> match the HW block's numbering of the mux-side inputs.
> 
> So, there can be multiple levels of GPIO ID <-> pin ID mapping required.
> 
> My point is that:
> 
> Any mapping inside the pinctrl HW block is static and part of the HW
> block's definition. This can be represented statically inside the
> pinctrl driver source, or perhaps with some custom DT properties.
> 
> In that case, it /might/ be appropriate to define pin groups to help
> define that mapping, since both pin groups and the mapping would be
> strictly part of the internal HW definition of the pinctrl HW block.
> 
> Any mapping between the pinctrl HW and the GPIO HW is something at the
> top-level of the SoC, and hence not something purely driven the the
> pinctrl HW's.
> 
> In that case, the pinctrl driver or DT binding really shouldn't define
> pin groups to help define that mapping, since the mapping is something
> that exists outside the realm of the pinctrl HW block itself.

I agree. This is why the proposed pinctrl driver defines mux-side pin
controller interfaces as pingroups (these are actual hardware interfaces
of the pinctrl RTL module). GPIOs (and any other interfaces) are
connected at the top level to those interfaces.

In the case of a non-GPIO interface, the driver (e.g. SPI) tells pinctrl
which mux-side interface it is connected to and that that interface
should be mapped to the physical pins using the "default" pinctrl-0
property.

In the case of a GPIO bank, the GPIO controller tells the pin controller
through GPIO ranges to which of these hardware mux-side interfaces it is
hooked up on the top level.

In our original patch (where GPIO ranges were still half managed inside
the drivers), both mechanisms used the same phandle semantics. The
second generation patch now still uses standard phandle semantics for
non-GPIO interfaces (managed through pinctrl-0) and strings directly
referencing the mux-side ports for GPIOs.

> I would furthermore argue that the gpio-ranges DT property should be
> only representing any mapping between the pinctrl and GPIO HW, not any
> mapping inside the pinctrl HW.

I agree, see above. In the TB10x case, everything pinctrl-internal is
managed inside the driver (by the tables in the beginning), the mux side
top-level connectivity is managed by gpio ranges and pinctrl-0
properties and the pin-side connectivity doesn't matter as long as
kernel-internal pin numbering doesn't leak out.

> However, I suppose I can see an argument that it might be useful to have
> gpio-ranges represent the combination of *both* mappings as a single
> mapping.

We actually tried to avoid that in the TB10x driver but maybe there are
some use cases for it.

> However, even in that case, I still don't think that the pinctrl HW
> should be defining pin groups to help define that mapping. To do so
> would encode information about the environment outside the pin
> controller into the pin controller driver and/or DT binding, and that
> information would not be purely driven by the pinmux HW itself.
> 
> And finally, I don't really like using pin groups for the purpose of
> defining these mappings, since I intended them to purely represent the
> mapping from register fields to the set of affected pins.

My philosophy of driver design is slightly different here: IMHO a driver
should provide some level of abstraction. The programming interface
should be independent of implementation details such as configuration
registers of the hardware block. Otherwise, why not just implement some
rudimentary locking mechanism and write to those registers directly?
This doesn't mean that hardware implementation and driver APIs must
never match but hardware implementation should (as far as possible) not
be a constraint for the driver API.

> However, I can
> see an argument for doing this, since the pin groups are in fact still
> representing /some/ aspect of the pinctrl internal HW.
> 
> >> In a similar fashion,
> >> the DT binding for the pinctrl HW module should describe only the HW
> >> module itself, and not the mapping/interaction with the outside world.
> >> In other words, the DT binding for the pinctrl HW module also can't
> >> define the names of any pin groups used in the GPIO<->pinctrl mapping,
> >> for the same reasons.
> > 
> > Except if this mapping is done _inside_ the pin controller, see above.
> 
> Yes, I got ahead of myself above. There are multiple places the mapping
> could occur. Some would perhaps be appropriate to influence pin groups,
> some not.
> 
> >> As such, I'm not sure that I conceptually agree with this patch series.
> >>
> >> Sure, it may make the gpio-ranges property more compact in some
> >> (unusual?) non-linear cases. However, it's representing things
> >> semantically incorrectly.
> > 
> > Is it really in the TB10x case?
> > To me it looks actually semantically more correct.
> 
> If they are purely representing a mapping internal to the pinctrl HW,
> then it may be fine.
> 
> >> So, I'd like to question the motivation for using names here again.
> >> Presumably the SoC vendor will write the gpio-ranges property for each
> >> SoC, and put that into the SoC's .dtsi file. As such, no customer is
> >> ever going to have to care about the property or its contents. So, I
> >> don't really see how this helps you with your issue re: wanting to hide
> >> details of multiple different ball-out options on similar SoCs, since
> >> even with a manually-written purely numeric gpio-ranges property, all
> >> that information is already essentially hidden; it's something that will
> >> be written once, and then never looked at.
> > 
> > Well, in the case of TB10x we are the SOC vendor and it was decided that
> > all dts and dtsi files we publish are customer-facing data and must thus
> > be coherent with the data sheet.
> 
> I would still tend to use gpio-ranges to represent the inter-module
> connectivity, and use some alternative approach to re-jig that mapping
> based on the mapping inside the pin controller.

But we DO use GPIO-ranges. We just predefine the pinctrl side of them
inside the driver to avoid kernel-internals leaking out.

> For Tegra, I ended up choosing pinctrl pin IDs such that there was a 1:1
> mapping between GPIO IDs and pinctrl pin IDs. I then ended up needing a
> table that mapped pinctrl pin IDs (actually, the pin group IDs that
> included those pins... and I would have needed this no matter what since
> Tegra20 at least uses pin groups not per-pin configuration) to HW
> register addresses. This is rather like saying that the pinctrl HW has
> named inputs GPIO 0..n which are connected 1:1 with the GPIO HW module's
> GPIO 0..n output signals, and then the pinctrl HW has a purely internal
> mapping between the pinctrl HW module's GPIO signals and the pinctrl HW
> module's pin/ball/pad-side pins.

If I understand this correctly, the only difference between this and
TB10x is that TB10x uses symbolic names instead of numeric values to
indicate start pin and pin count.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
