Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaHRQFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:05:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:40974 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaHRQFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:05:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,886,1400050800"; 
   d="scan'208";a="586430396"
Date: Mon, 18 Aug 2014 19:05:01 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        grant.likely@linaro.org, rob.herring@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com
Subject: Re: [RFC PATCH 2/9] ACPI: Document ACPI device specific properties
Message-ID: <20140818160422.GC1660@lahna.fi.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-3-git-send-email-mika.westerberg@linux.intel.com>
 <20140818105429.GF14559@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818105429.GF14559@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:54:29AM +0100, Mark Rutland wrote:
> Hi Mika,
> 
> While I am very much in favour of having a structured way of describing
> device specific data in ACPI I am very concerned by the idea of assuming
> (a false) equivalence with DT. More on that below.
> 
> On Sun, Aug 17, 2014 at 07:04:12AM +0100, Mika Westerberg wrote:
> > This document describes the data format and interfaces of ACPI device
> > specific properties.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> > ---
> >  Documentation/acpi/properties.txt | 359 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 359 insertions(+)
> >  create mode 100644 Documentation/acpi/properties.txt
> > 
> > diff --git a/Documentation/acpi/properties.txt b/Documentation/acpi/properties.txt
> > new file mode 100644
> > index 000000000000..a1e93267c1fa
> > --- /dev/null
> > +++ b/Documentation/acpi/properties.txt
> > @@ -0,0 +1,359 @@
> > +ACPI device properties
> > +======================
> > +This document describes the format and interfaces of ACPI device
> > +properties as specified in "Device Properties UUID For _DSD" available
> > +here:
> > +
> > +http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> > +
> > +1. Introduction
> > +---------------
> > +In systems that use ACPI and want to take advantage of device specific
> > +properties, there needs to be a standard way to return and extract
> > +name-value pairs for a given ACPI device.
> > +
> > +An ACPI device that wants to export its properties must implement a
> > +static name called _DSD that takes no arguments and returns a package of
> > +packages:
> > +
> > +       Name (_DSD, Package () {
> > +               ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +               Package () {
> > +                       Package () {"name1", <VALUE1>},
> > +                       Package () {"name2", <VALUE2>}
> > +               }
> > +       })
> > +
> > +The UUID identifies contents of the following package. In case of ACPI
> > +device properties it is daffd814-6eba-4d8c-8a91-bc9bbf4aa301.
> > +
> > +In each returned package, the first item is the name and must be a string.
> > +The corresponding value can be a string, integer, reference, or package. If
> > +a package it may only contain strings, integers, and references.
> > +
> > +An example device where we might need properties is a GPIO keys device.
> > +In addition to the GpioIo/GpioInt resources the driver needs to know how
> > +to map each GpioIo resource to the corresponding Linux input event.
> > +
> > +To solve this we add the following ACPI device properties from the
> > +gpio-keys schema:
> > +
> > +       Device (KEYS) {
> > +               Name (_DSD, Package () {
> > +                       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +                       Package () {
> > +                               Package () {"poll-interval", 100},
> > +                               Package () {"autorepeat", 1}
> > +                       }
> > +               })
> > +
> > +               Device (BTN0) {
> > +                       Name (_DSD, Package () {
> > +                               ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +                               Package () {
> > +                                       Package () {"linux,code", 105},
> > +                                       Package () {"linux,input-type", 1},
> 
> The leakage of Linux implementation details into DTBs is bad enough. I
> would really not like to see this kind of thing in ACPI tables.
> 
> Leaking this into HW description of any sort completely rids said
> description of any OS independence, and it's usually short-sighted,
> nonsensical, or ill-defined (what does 'autorepeat' actually mean?).
> 
> I am very worried by the prospect of _DSD making it harder rather than
> easier for an arbitrary OS to use ACPI data due to assumptions being
> made about (a particular revision of) a particular OS.

You are right - the above example is bad in that sense. The reason why
we have the above is that we tested the implementation on Minnowboard
and the two devices we converted used these descriptions.

We should pick a better example that describes the HW independent of the
OS.

> 
> > +                                       ...
> > +                               }
> > +                       })
> > +               }
> > +
> > +               ...
> > +       }
> > +
> > +Of course the device driver then needs to iterate over these devices but
> > +it can be done easily via the ->children field of the companion ACPI
> > +device. This will be demonstrated later on in the document.
> > +
> > +If there is an existing Device Tree binding for a device, it is expected
> > +that the same bindings are used with ACPI properties, so that the driver
> > +dealing with the device needs only minor modifications if any.
> 
> For simple devices like a UART which just has a "clock-frequency"
> property in DT, importing both the concept of the property and the key
> name itself is a sensible approach.
> 
> However, I do not think this makes sense as a general design rule. ACPI
> and DT already have different idioms for describing certain things (e.g.
> GPIOs, interrupts) and care needs to be taken to distinguish simple
> device-specific properties from class-specific properties or implied
> linkages between devices.

For things that ACPI already knows about, like GPIOs, we use them
instead of DT bindings. Some things, like referring a GPIO with name (or
DMA request channel) we rely on DT properties.

Same goes with MMIO addresses, IRQs etc. Those are coming from existing
ACPI descriptions, not from DT.

> 
> The "#clock-cells" and "#pwm-cells" _DSD examples in ACPI 5.1 are
> complete nonsense. They import an idiom from DT into ACPI without
> considering the surrounding context (cells, lack of typing, phandles,
> etc). As an example, I worry that why it may be trivial to map pinctrl
> bindings into ACPI _DSD, there is no clear way that they would interact
> with ACPI's HW management. This is going to significantly expand our
> problem surface area.

One of the driving ideas for this work was that we should be able to
stick DT description inside _DSD with some minor modifications to the
drivers, and it all should just work.

> There are known deficiencies with many DT bindings that we can't fix for
> legacy reasons on the DT side (e.g. the clock detection for ARM
> primecell devices). Some of these issues can be trivially fixed for a
> legacy-free environment like ACPI _DSD.
> 
> We have a lot of stupid (and broken) DT bindings that were either
> ill-designed or which newer hardware has exposed weaknesses in. I don't
> want us to turn these into even more broken ACPI _DSD bindings. 
> 
> For the reasons above I am against having a single API which accesses
> both interfaces. I believe at present it is better to separate the two.
> For those devices which truly need a small amount of data there will not
> be much duplication. For those which need large amounts of data we
> clearly need to consider whether those bindings are sensible to pull
> across into ACPI at all.
> 
> > +2. Formal definition of properties
> > +----------------------------------
> > +The following chapters define the currently supported properties. For
> > +these there exists a helper function that can be used to extract the
> > +property value.
> > +
> > +2.1 Integer types
> > +-----------------
> > +ACPI integers are always 64-bit. However, for drivers the full range is
> > +typically not needed so we provide a set of functions which convert the
> > +64-bit integer to a smaller Linux integer type.
> 
> Does that always make sense, or should that be left to the driver?

I think it should be left to the driver. We just provide functions that
help the driver a bit here.

> In some cases properties form DT having a max value of 0xffffffff is
> simply a result of using the default DT number representation rather
> than a conscious decision that 32 bits are enough.

OK

> > +An integer property looks like this:
> > +
> > +       Package () {"poll-interval", 100},
> > +       Package () {"i2c-sda-hold-time-ns", 300},
> > +       Package () {"clock-frequency", 400000},
> > +
> > +To read a property value, use a unified property accessor as shown
> > +below:
> > +
> > +       u32 val;
> > +       int ret;
> > +
> > +       ret = device_property_read(dev, "poll-interval", DEV_PROP_U32, &val);
> > +       if (ret)
> > +               /* Handle error */
> > +
> > +The function returns 0 if the property is copied to 'val' or negative
> > +errno if something went wrong (or the property does not exist).
> > +
> > +2.2 Integer arrays
> > +------------------
> > +An integer array is a package holding only integers. Arrays can be used to
> > +represent different things like Linux input key codes to GPIO mappings, pin
> > +control settings, dma request lines, etc.
> 
> As I mentioned above, I am extremely concerned that it is not sensible
> to blindly import the class bindings you mention here.

OK, I'll drop some of those like "Linux input key codes" and possibly
"pin control settings". Or drop the whole example here.

> > +An integer array looks like this:
> > +
> > +       Package () {
> > +               "max8952,dvs-mode-microvolt",
> > +               Package () {
> > +                       1250000,
> > +                       1200000,
> > +                       1050000,
> > +                       950000,
> > +               }
> > +       }
> > +
> > +The above array property can be accessed like:
> > +
> > +       u32 voltages[4];
> > +       int ret;
> > +
> > +       ret = device_property_read_array(dev, "max8952,dvs-mode-microvolt",
> > +                                        DEV_PROP_U32, voltages,
> > +                                        ARRAY_SIZE(voltages));
> > +       if (ret)
> > +               /* Handle error */
> > +
> > +
> > +All functions copy the resulting values cast to a requested type to the
> > +caller supplied array. If you pass NULL in the value pointer ('voltages' in
> > +this case), the function returns number of items in the array. This can be
> > +useful if caller does not know size of the array beforehand.
> 
> On the DT side we have of_property_count_u{8,16,32,64}_elems. Having
> separate functions makes the code easier to read.

We can add static inline wrapper functions that implement the above.

> > +2.3 Strings
> > +-----------
> > +String properties can be used to describe many things like labels for GPIO
> > +buttons, compability ids, etc.
> > +
> > +A string property looks like this:
> > +
> > +       Package () {"pwm-names", "backlight"},
> > +       Package () {"label", "Status-LED"},
> > +
> > +You can also use device_property_read() to extract strings:
> > +
> > +       const char *val;
> > +       int ret;
> > +
> > +       ret = device_property_read(dev, "label", DEV_PROP_STRING, &val);
> > +       if (ret)
> > +               /* Handle error */
> > +
> > +Note that the function does not copy the returned string but instead the
> > +value is modified to point to the string property itself.
> > +
> > +The memory is owned by the associated ACPI device object and released
> > +when it is removed. The user need not free the associated memory.
> > +
> > +2.4 String arrays
> > +-----------------
> > +String arrays can be useful in describing a list of labels, names for
> > +DMA channels, etc.
> > +
> > +A string array property looks like this:
> > +
> > +       Package () {"dma-names", Package () {"tx", "rx", "rx-tx"}},
> > +       Package () {"clock-output-names", Package () {"pll", "pll-switched"}},
> > +
> > +And these can be read in similar way that the integer arrrays:
> > +
> > +       const char *dma_names[3];
> > +       int ret;
> > +
> > +       ret = device_property_read_array(dev, "dma-names", DEV_PROP_STRING,
> > +                                        dma_names, ARRAY_SIZE(dma_names));
> > +       if (ret)
> > +               /* Handle error */
> > +
> > +The memory management rules follow what is specified for single strings.
> > +Specifically the returned pointers should be treated as constant and not to
> > +be freed. That is done automatically when the correspondig ACPI device
> > +object is released.
> > +
> > +2.5 Object references
> > +---------------------
> > +An ACPI object reference is used to refer to some object in the
> > +namespace. For example, if a device has dependencies with some other
> > +object, an object reference can be used.
> > +
> > +An object reference looks like this:
> > +
> > +       Package () {"clock", \_SB.CLK0},
> 
> For examples I would strongly recommend using something slightly more
> abstract so that (for example) it is not assumed that this is the
> canonical way to describe a clock using _DSD.

Good point. Maybe we can just say something like:

	Package () {"ref", \_SB.DEV0}

> > +At the time of writing this, there is no unified device_property_* accessor
> > +for references so one needs to use the following ACPI helper function:
> > +
> > +       int acpi_dev_get_property_reference(struct acpi_device *adev,
> > +                                           const char *name,
> > +                                           const char *size_prop, int index,
> > +                                           struct acpi_reference_args *args);
> > +
> > +The referenced ACPI device is returned in args->adev if found.
> > +
> > +In addition to simple object references it is also possible to have object
> > +references with arguments. These are represented in ASL as follows:
> > +
> > +       Device (\_SB.PCI0.PWM) {
> > +               Name (_DSD, Package () {
> > +                       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +                       Package () {
> > +                               Package () {"#pwm-cells", 2}
> > +                       }
> > +               })
> > +       }
> > +
> > +       Device (\_SB.PCI0.BL) {
> > +               Name (_DSD, Package () {
> > +                       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +                       Package () {
> > +                               Package () {
> > +                                       "pwms",
> > +                                       Package () {
> > +                                               \_SB.PCI0.PWM, 0, 5000000,
> > +                                               \_SB.PCI0.PWM, 1, 4500000,
> > +                                       }
> 
> I'm not all that familiar with ASL so perhaps this is not possible, but
> IMO it would make far more sense to have the two elements described as
> individual packages:
> 
> Package {
> 	"pwms",
> 	Package () { \ref1, 0, 5235 }
> 	Package () { \ref2, 1, 42423 } 
> }

ASL allows that but the _DSD ACPI device property specification doesn't.

> That way there's no need for #x-cells properties, it's possible to do
> better type checking, variadic arguments can be supported, etc.
> 
> As it stands this live in the intersection of the limitations of both
> ACPI and DT, and I suspect this will only cause pain on both sides.
> 
> > +                               }
> > +                       }
> > +               })
> > +       }
> > +
> > +In the above example, the referenced device declares a property that
> > +returns the number of expected arguments (here it is "#pwm-cells"). If
> > +no such property is given we assume that all the integers following the
> > +reference are arguments.
> > +
> > +In the above example PWM device expects 2 additional arguments. This
> > +will be validated by the ACPI property core.
> > +
> > +The additional arguments must be integers. Nothing else is supported.
> 
> Is that an ASL limitation or a Linux limitation?

That is limitation we added on purpose to support DT <&phandle int int>
descriptions. So that we can validate that the returned package at least
contains types we expect.

> > +It is possible, as in the above example, to have multiple references
> > +with varying number of integer arguments. It is up to the referenced
> > +device to declare how many arguments it expects. The 'index' parameter
> > +selects which reference is returned.
> > +
> > +One can use acpi_dev_get_property_reference() as well to extract the
> > +information in additional parameters:
> > +
> > +       struct acpi_reference_args args;
> > +       struct acpi_device *adev = /* this will point to the BL device */
> > +       int ret;
> > +
> > +       /* extract the first reference */
> > +       acpi_dev_get_property_reference(adev, "pwms", "#pwm-cells", 0, &args);
> > +
> > +       BUG_ON(args.nargs != 2);
> > +       BUG_ON(args.args[0] != 0);
> > +       BUG_ON(args.args[1] != 5000000);
> > +
> > +       /* extract the second reference */
> > +       acpi_dev_get_property_reference(adev, "pwms", "#pwm-cells", 1, &args);
> > +
> > +       BUG_ON(args.nargs != 2);
> > +       BUG_ON(args.args[0] != 1);
> > +       BUG_ON(args.args[1] != 4500000);
> > +
> > +In addition to arguments, args.adev now points to the ACPI device that
> > +corresponds to \_SB.PCI0.PWM.
> > +
> > +It is intended that this function is not used directly but instead
> > +subsystems like pwm implement their ACPI support on top of this function
> > +in such way that it is hidden from the client drivers, such as via
> > +pwm_get().
> 
> If we're expecting device class bindings to use high-level interfaces
> (like pwm_get, clk_get, etc) then as far as I can see there is no reason
> that the low-level representation in ACPI and DT need to be identical.

Well, it is not 100% identical even now. For example ACPI already knows
GPIOs (throuh GpioIo/GpioInt) but there hasn't been any way to refer the
GPIO using name. So we use _CRS returned resources normally but get the
name using _DSD.

Whevever we can use the existing ACPI resources we certainly do, instead
of using DT properties.

> Importing DT bindings wholesale into ACPI only optimises for getting
> things supported quickly, not getting things supported sanely.
