Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaHSQwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:52:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33134 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbaHSQwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:52:11 -0400
Date: Tue, 19 Aug 2014 17:51:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@linaro.org" <rob.herring@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [RFC PATCH 2/9] ACPI: Document ACPI device specific properties
Message-ID: <20140819165148.GO3302@leverpostej>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-3-git-send-email-mika.westerberg@linux.intel.com>
 <20140818105429.GF14559@leverpostej>
 <20140819054546.GA11444@dvhart-mac01.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819054546.GA11444@dvhart-mac01.local>
Thread-Topic: [RFC PATCH 2/9] ACPI: Document ACPI device specific properties
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 06:45:46AM +0100, Darren Hart wrote:
> On Mon, Aug 18, 2014 at 11:54:29AM +0100, Mark Rutland wrote:
> > Hi Mika,
> >
> > While I am very much in favour of having a structured way of describing
> > device specific data in ACPI I am very concerned by the idea of assuming
> > (a false) equivalence with DT. More on that below.
>
> Hi Mark,

Hi Darren,

> The equivalence is intended in the sense that we should be able to represent any
> of the existing schemas with the same properties in ACPI as in DT.
>
> ...
>
> > > +An example device where we might need properties is a GPIO keys device.
> > > +In addition to the GpioIo/GpioInt resources the driver needs to know how
> > > +to map each GpioIo resource to the corresponding Linux input event.
> > > +
> > > +To solve this we add the following ACPI device properties from the
> > > +gpio-keys schema:
> > > +
> > > +       Device (KEYS) {
> > > +               Name (_DSD, Package () {
> > > +                       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > +                       Package () {
> > > +                               Package () {"poll-interval", 100},
> > > +                               Package () {"autorepeat", 1}
> > > +                       }
> > > +               })
> > > +
> > > +               Device (BTN0) {
> > > +                       Name (_DSD, Package () {
> > > +                               ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > +                               Package () {
> > > +                                       Package () {"linux,code", 105},
> > > +                                       Package () {"linux,input-type", 1},
> >
> > The leakage of Linux implementation details into DTBs is bad enough. I
> > would really not like to see this kind of thing in ACPI tables.
> >
> > Leaking this into HW description of any sort completely rids said
> > description of any OS independence, and it's usually short-sighted,
> > nonsensical, or ill-defined (what does 'autorepeat' actually mean?).
> >
> > I am very worried by the prospect of _DSD making it harder rather than
> > easier for an arbitrary OS to use ACPI data due to assumptions being
> > made about (a particular revision of) a particular OS.
>
> This is perhaps not the best example to include in the documentation. A guiding
> principle has been to only represent in the DSD that which is an actual property
> of the hardware.

We follow the same principle in DT, but we still have to fight against
bad bindings which do not follow this principle.

Ideally all examples would align with that principle.

> It is also a goal of the mechanism to enable ACPI systems to reuse the 200+
> existing OF-aware drivers in the kernel today. If those schemas are
> ill-conceived, we should work to improve the schemas.
>
> On the point of OS-independence, while I agree that using something like the USB
> keycodes here would be better, the namespacing employed in these properties
> makes it possible to use the same DSD for muliple OSes as another OS could add
> it's own keycode, for example, without conflict. Again, that is really an issue
> with the schemas, not the _DSD mechanism itself.

It's true that the issues are with the individual bindings, and that
_DSD is simply a mechanism for conveying them. We certainly need to fix
up those bindings, but for legacy reasons some bad bindings will have to
stay supported when provided from a DTB. However is no reason for an
ACPI system to pick up any of the linux,* DT properties.

So we must treat ACPI and DTB as different providers of information, and
we need to be careful not to assume a false equivalence.

I'm not a big fan of providing different OSs with different views of the
world. I thought everyone using ACPI hated _OSI and the mess that
usually results in?

> Perhaps we should use a different example in the documentation as I would agree
> this is not a model schema.

Yes please.

> > > +Of course the device driver then needs to iterate over these devices but
> > > +it can be done easily via the ->children field of the companion ACPI
> > > +device. This will be demonstrated later on in the document.
> > > +
> > > +If there is an existing Device Tree binding for a device, it is expected
> > > +that the same bindings are used with ACPI properties, so that the driver
> > > +dealing with the device needs only minor modifications if any.
> >
> > For simple devices like a UART which just has a "clock-frequency"
> > property in DT, importing both the concept of the property and the key
> > name itself is a sensible approach.
> >
> > However, I do not think this makes sense as a general design rule. ACPI
> > and DT already have different idioms for describing certain things (e.g.
> > GPIOs, interrupts) and care needs to be taken to distinguish simple
> > device-specific properties from class-specific properties or implied
> > linkages between devices.
>
> I believe we have GPIO handled well in this series. In DT terms, ACPI is the
> controller, providing a list of GpioIO|GpioInt resources in the CRS of the
> referenced object. Arguments are Resource Index, Pin Index, Polarity. The rest
> of the properties are handled via the GpioIO|GpioInt resources in the _CRS.

The description provided in this documentation is extremely vague. The
argument format you mention above is not described.  Was that the format
for a specific controller, or a format you expect all controllers to
follow?

I see an instance of #gpio-cells = <1>, which does not match the format
you mention.

Given that this is only similar to the way GPIOs are described in DT
rather than being identical, I don't see why these GPIOs need be
described through _DSD rather than adding a new standard ACPI resource
type for GPIOs. Either way the same high-level gpio_get* interface can
be used along with similar/identical names or indices; consumers
shouldn't be looking at the underlying representation anyway.

To me it feels like using _DSD to describe the connection of GPIOs is
working around a deficiency in ACPI rather than being the sensible
"native" way of describing GPIO connectivity. Especially so given this
usage is not actually described in the ACPI spec.

As I see it, _DSD makes sense for device-specific properties like
"num-slots" or "broken-cd" which can be handled within an individual
driver. I do not think that _DSD is the correct mechanism for describing
the linkage of devices; certainly not without that linkage description
becoming standardised.

> > The "#clock-cells" and "#pwm-cells" _DSD examples in ACPI 5.1 are
> > complete nonsense. They import an idiom from DT into ACPI without
>
> Yeah... coming up with good examples for a generic mechanism which are both
> descriptive and universally unobjectionable. Good point. We might be able to
> improve this via an errata update. What would you recommend?

It is an unfortunate fact that spec work is a hard and unrewarding task
where only the problems will be commented upon.

Do we expect to describe clocks and PWMs through _DSD rather than
something ACPI "native"? If not, I'd drop examples with #x-cells style
properties and references between nodes.

If we do expect to describe things in that way then I'd recommend that
we get a formal description together in the ACPI spec, and use an
example derived from that.

As I mention elsewhere I am very much not keen on describing device
linkages in _DSD.

> > considering the surrounding context (cells, lack of typing, phandles,
>
> How are the phandles not covered via the ACPI namespace references?

If ACPI namespace references are functionally equivalent, then please
ignore the above. From prior discussions I was under the impression that
they behaved differently, but I guess I am mistaken there?

> The point on cells is a good one, and I believe some of this can be mitigated by
> providing subsystem specific accessors as we have for GPIO, for example.

I'm happy with having common high-level accessors. My disagreement is
with trying to copy across the low-level representation from DT into
ACPI.

> > etc). As an example, I worry that why it may be trivial to map pinctrl
> > bindings into ACPI _DSD, there is no clear way that they would interact
> > with ACPI's HW management. This is going to significantly expand our
> > problem surface area.
>
> Pinctrl is an area where I suspect we will need more specific support, but
> it is still on my list for a detailed review.

Ok. I take it you'll get in touch with Linus W when you get the time to
look into that?

> > There are known deficiencies with many DT bindings that we can't fix for
> > legacy reasons on the DT side (e.g. the clock detection for ARM
> > primecell devices). Some of these issues can be trivially fixed for a
> > legacy-free environment like ACPI _DSD.
> >
> > We have a lot of stupid (and broken) DT bindings that were either
> > ill-designed or which newer hardware has exposed weaknesses in. I don't
> > want us to turn these into even more broken ACPI _DSD bindings.
>
> That's surely the case. Could you provide a concrete example or two I can use to
> build context?

Off the top of my head:

* The primecell class bindings expect clocks in a certain order, the
  primecell code doesn't care about order and acquires by name, and the
  primecell drivers typically acquire by index. This means that
  primecell drivers may pick up the apb_pclk (which drives the bus)
  rather than the clock they intended to.

* The L2x0 cache bindings still require some platform-specific data not
  provided through DT due to the way things were partially transitioned
  from board files to DT. I suspect there are several other drivers for
  which this is true, certainly there are still drivers which acquire
  clocks which aren't described in the DT.

* It's painful to have a GPIO line that's also used for an interrupt,
  because the interrupt flags aren't in the gpio-specifier. So you
  either need a separate interrupts property or separate flags property.
  Neither are fantastic.

* Typo workarounds or other legacy properties which never need to be
  available with ACPI _DSD (e.g. "ti,coordiante-readouts")

* Bindings which represent a software construct (e.g. IIO-HWMON). We
  also have properties like "autorepeat" which are tightly coupled to
  the design on the input subsystem.

* Resources named for the output of the provider, not the input of the
  consumer. I don't have an example to hand for this.

* For some recent additions like IOMMU bindings, devices are currently
  in the process of migrating to the new bindings.

* I don't think we really know how to generically describe interrupt
  line switches like the TI crossbar which aren't quite secondary
  interrupt controllers.

* The few drivers which require an entry in /aliases are likely to be
  problematic.

> > For the reasons above I am against having a single API which accesses
> > both interfaces. I believe at present it is better to separate the two.
> > For those devices which truly need a small amount of data there will not
> > be much duplication. For those which need large amounts of data we
> > clearly need to consider whether those bindings are sensible to pull
> > across into ACPI at all.
>
> The issue here is there are over 200 drivers in the kernel today that are not
> usable by ACPI systems, and many more external to the kernel which are only
> usable via board files. The alternative would be to modify every one of these
> drivers with an ACPI-specific pdata creation function and to create a new schema
> library for ACPI which would differ from DT. Ultimiately it would be preferable
> for the hardware vendor to define the properties required to describe the
> hardware in a way independent from the firmware implementation.

Of those 200 drivers, how many are likely to be useful on an ACPI
system? I would expect that we do not need the vast majority of the
SoC-specific drivers which I believe make up the bulk, but I could be
wrong.

I suspect that modifications will be necessary anyway for the subset of
drivers we actually need/want to enable for use with ACPI. I would like
to see some oversight being applied to these.

I'm not sure hardware vendors will do a better job describing their
hardware, given some bindings I have seen proposed by hardware vendors.
Perhaps if a vendors is actively targeting more than a single OS and
cares about maintaining their driver(s).

> > > +2. Formal definition of properties
> > > +----------------------------------
> > > +The following chapters define the currently supported properties. For
> > > +these there exists a helper function that can be used to extract the
> > > +property value.
> > > +
> > > +2.1 Integer types
> > > +-----------------
> > > +ACPI integers are always 64-bit. However, for drivers the full range is
> > > +typically not needed so we provide a set of functions which convert the
> > > +64-bit integer to a smaller Linux integer type.
> >
> > Does that always make sense, or should that be left to the driver?
> >
>
> I don't follow - the driver chooses which size integer to request. Josh has
> suggested these functions should check for overflow, which I thought made sense.

Sorry, this was a misunderstanding on my behalf.

> > In some cases properties form DT having a max value of 0xffffffff is
> > simply a result of using the default DT number representation rather
> > than a conscious decision that 32 bits are enough.
> >
> > > +An integer property looks like this:
> > > +
> > > +       Package () {"poll-interval", 100},
> > > +       Package () {"i2c-sda-hold-time-ns", 300},
> > > +       Package () {"clock-frequency", 400000},
> > > +
> > > +To read a property value, use a unified property accessor as shown
> > > +below:
> > > +
> > > +       u32 val;
> > > +       int ret;
> > > +
> > > +       ret = device_property_read(dev, "poll-interval", DEV_PROP_U32, &val);
> > > +       if (ret)
> > > +               /* Handle error */
> > > +
> > > +The function returns 0 if the property is copied to 'val' or negative
> > > +errno if something went wrong (or the property does not exist).
> > > +
> > > +2.2 Integer arrays
> > > +------------------
> > > +An integer array is a package holding only integers. Arrays can be used to
> > > +represent different things like Linux input key codes to GPIO mappings, pin
> > > +control settings, dma request lines, etc.
> >
> > As I mentioned above, I am extremely concerned that it is not sensible
> > to blindly import the class bindings you mention here.
> >
> > > +An integer array looks like this:
> > > +
> > > +       Package () {
> > > +               "max8952,dvs-mode-microvolt",
> > > +               Package () {
> > > +                       1250000,
> > > +                       1200000,
> > > +                       1050000,
> > > +                       950000,
> > > +               }
> > > +       }
> > > +
> > > +The above array property can be accessed like:
> > > +
> > > +       u32 voltages[4];
> > > +       int ret;
> > > +
> > > +       ret = device_property_read_array(dev, "max8952,dvs-mode-microvolt",
> > > +                                        DEV_PROP_U32, voltages,
> > > +                                        ARRAY_SIZE(voltages));
> > > +       if (ret)
> > > +               /* Handle error */
> > > +
> > > +
> > > +All functions copy the resulting values cast to a requested type to the
> > > +caller supplied array. If you pass NULL in the value pointer ('voltages' in
> > > +this case), the function returns number of items in the array. This can be
> > > +useful if caller does not know size of the array beforehand.
> >
> > On the DT side we have of_property_count_u{8,16,32,64}_elems. Having
> > separate functions makes the code easier to read.
>
> That makes sense to me, especially as we would be replacing such usage in
> existing drivers, it would be nice for it to be as close to a direct mapping as
> possible.
>
> ...
>
> > > +An object reference looks like this:
> > > +
> > > +       Package () {"clock", \_SB.CLK0},
> >
> > For examples I would strongly recommend using something slightly more
> > abstract so that (for example) it is not assumed that this is the
> > canonical way to describe a clock using _DSD.
> >
>
> Agreed.
>
> > > +At the time of writing this, there is no unified device_property_* accessor
> > > +for references so one needs to use the following ACPI helper function:
> > > +
> > > +       int acpi_dev_get_property_reference(struct acpi_device *adev,
> > > +                                           const char *name,
> > > +                                           const char *size_prop, int index,
> > > +                                           struct acpi_reference_args *args);
> > > +
> > > +The referenced ACPI device is returned in args->adev if found.
> > > +
> > > +In addition to simple object references it is also possible to have object
> > > +references with arguments. These are represented in ASL as follows:
> > > +
> > > +       Device (\_SB.PCI0.PWM) {
> > > +               Name (_DSD, Package () {
> > > +                       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > +                       Package () {
> > > +                               Package () {"#pwm-cells", 2}
> > > +                       }
> > > +               })
> > > +       }
> > > +
> > > +       Device (\_SB.PCI0.BL) {
> > > +               Name (_DSD, Package () {
> > > +                       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > +                       Package () {
> > > +                               Package () {
> > > +                                       "pwms",
> > > +                                       Package () {
> > > +                                               \_SB.PCI0.PWM, 0, 5000000,
> > > +                                               \_SB.PCI0.PWM, 1, 4500000,
> > > +                                       }
> >
> > I'm not all that familiar with ASL so perhaps this is not possible, but
> > IMO it would make far more sense to have the two elements described as
> > individual packages:
> >
> > Package {
> >       "pwms",
> >       Package () { \ref1, 0, 5235 }
> >       Package () { \ref2, 1, 42423 }
> > }
> >
> > That way there's no need for #x-cells properties, it's possible to do
> > better type checking, variadic arguments can be supported, etc.
>
> While the above is valid ASL (minus a comma), the prp_uuid doesn't allow for
> multiple "values" in the key value pairs. If wanted to encapsulate each pwm
> entry, we would need to give each a unique name, "pwm0", "pwm1" etc. The above
> is intended to parallel the DT to make it easiest to reuse drivers.

That is unfortunate.

The phandle + args cases are precisely where we only need the high-level
interface to be the same, and I believe using individual packages for
each tuple would have allowed for better sanity checking and error
reporting.

> >
> > As it stands this live in the intersection of the limitations of both
> > ACPI and DT, and I suspect this will only cause pain on both sides.
> >
> > > +                               }
> > > +                       }
> > > +               })
> > > +       }
> > > +
> > > +In the above example, the referenced device declares a property that
> > > +returns the number of expected arguments (here it is "#pwm-cells"). If
> > > +no such property is given we assume that all the integers following the
> > > +reference are arguments.
> > > +
> > > +In the above example PWM device expects 2 additional arguments. This
> > > +will be validated by the ACPI property core.
> > > +
> > > +The additional arguments must be integers. Nothing else is supported.
> >
> > Is that an ASL limitation or a Linux limitation?
>
> This is a Linux implementation (or our choice of) limitation. Are there other
> argument types we should be considering?

Ok. I am not immediately aware of anything else that needs support. It's
just that the phrase "Nothing else is supported" was ambiguous, and I
was curious.

> > > +It is possible, as in the above example, to have multiple references
> > > +with varying number of integer arguments. It is up to the referenced
> > > +device to declare how many arguments it expects. The 'index' parameter
> > > +selects which reference is returned.
> > > +
> > > +One can use acpi_dev_get_property_reference() as well to extract the
> > > +information in additional parameters:
> > > +
> > > +       struct acpi_reference_args args;
> > > +       struct acpi_device *adev = /* this will point to the BL device */
> > > +       int ret;
> > > +
> > > +       /* extract the first reference */
> > > +       acpi_dev_get_property_reference(adev, "pwms", "#pwm-cells", 0, &args);
> > > +
> > > +       BUG_ON(args.nargs != 2);
> > > +       BUG_ON(args.args[0] != 0);
> > > +       BUG_ON(args.args[1] != 5000000);
> > > +
> > > +       /* extract the second reference */
> > > +       acpi_dev_get_property_reference(adev, "pwms", "#pwm-cells", 1, &args);
> > > +
> > > +       BUG_ON(args.nargs != 2);
> > > +       BUG_ON(args.args[0] != 1);
> > > +       BUG_ON(args.args[1] != 4500000);
> > > +
> > > +In addition to arguments, args.adev now points to the ACPI device that
> > > +corresponds to \_SB.PCI0.PWM.
> > > +
> > > +It is intended that this function is not used directly but instead
> > > +subsystems like pwm implement their ACPI support on top of this function
> > > +in such way that it is hidden from the client drivers, such as via
> > > +pwm_get().
> >
> > If we're expecting device class bindings to use high-level interfaces
> > (like pwm_get, clk_get, etc) then as far as I can see there is no reason
> > that the low-level representation in ACPI and DT need to be identical.
>
> There are properties that will not be subsystem specific, or rather that are
> simple key:value pairs that are convenient to access with the common mechanism.
> Even if we get a number of these abstractions in place, there is still value in
> a simple common property API in that it enables drivers to be ignorant of the
> underlying firmware-mechanism.

When you say not "subsystem specific" do you mean device-specific
properties or properties which are applicable to more than a particular
device or subsystem?

I can see that there will be common/equivalent properties. I can also
see that there will be cases where only DT or ACPI might have a
particular property (for legacy reasons or because information is not
implicit in ACPI where it is in DT).

I am of the opinion that handling the ACPI and DT cases separately is
preferable. I do not think that it is likely drivers for anything more
than trivial devices will be able to be ignorant of their underlying
firmware, especially if one platform requires the OS to manage clocks
and regulators while another manages this through AML (and we're in for
a world of hurt if another platform expects a mixture).

So far _DSD has been prototyped on reference platforms. I expect that
real implementations will be far more varied now that they have the
option to be.

> We have an example in this series for gpiolib - is this a good example in your
> opinion? Would adding examples/mechanism for pwm_get etc in the series help?
>
> > Importing DT bindings wholesale into ACPI only optimises for getting
> > things supported quickly, not getting things supported sanely.
> >
> > Thanks,
> > Mark.
>
> We're also trying to lower the barriers to enabling and writing new drivers that
> work on both DT and ACPI based systems without domain specific knowledge of
> each.

While that's the ideal case, I don't think it's as simple as mapping DT
bindings on to ACPI types. It will work in prototyping but I don't
believe it's going to stand up very well once we get a range of
differing HW designs trying to target it.

Are we going to get class properties standardized in ACPI, or is Linux
going to end up as the only OS supporting these properties?

> Thanks for taking the time to review and comment Mark, very much appreciated.

...and thanks for taking the time to reply. Let's see where this goes :)

Thanks,
Mark.
