Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaJAWl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:41:28 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63742 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752050AbaJAWl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:41:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 02/15] Driver core: Unified device properties interface for platform firmware
Date: Thu, 02 Oct 2014 01:01:18 +0200
Message-ID: <1736273.lW0BdXdkei@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4390403.PNxQqnBDGX@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <7365448.TlsV4zB2It@wuerfel> <4390403.PNxQqnBDGX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 02, 2014 12:09:44 AM Rafael J. Wysocki wrote:
> On Wednesday, October 01, 2014 09:47:40 AM Arnd Bergmann wrote:
> > On Wednesday 01 October 2014 04:10:03 Rafael J. Wysocki wrote:
> > > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> > > 
> > > Add a uniform interface by which device drivers can request device
> > > properties from the platform firmware by providing a property name
> > > and the corresponding data type.  The purpose of it is to help to
> > > write portable code that won't depend on any particular platform
> > > firmware interface.
> > > 
> > > Three general helper functions, device_get_property(),
> > > device_read_property() and device_read_property_array() are provided.
> > > The first one allows the raw value of a given device property to be
> > > accessed.  The remaining two allow the value of a numeric or string
> > > property and multiple numeric or string values of one array
> > > property to be acquired, respectively.  Static inline wrappers are also
> > > provided for the various property data types that can be passed to
> > > device_read_property() or device_read_property_array() for extra type
> > > checking.
> > 
> > These look great!
> > 
> > > In addition to that, new generic routines are provided for retrieving
> > > properties from device description objects in the platform firmware
> > > in case a device driver needs/wants to access properties of a child
> > > object of a given device object.  There are cases in which there is
> > > no struct device representation of such child objects and this
> > > additional API is useful then.  Again, three functions are provided,
> > > device_get_child_property(), device_read_child_property(),
> > > device_read_child_property_array(), in analogy with device_get_property(),
> > > device_read_property() and device_read_property_array() described above,
> > > respectively, along with static inline wrappers for all of the propery
> > > data types that can be used.  For all of them, the first argument is
> > > a struct device pointer to the parent device object and the second
> > > argument is a (void *) pointer to the child description provided by
> > > the platform firmware (either ACPI or FDT).
> > 
> > I still have my reservations against the child accessors, and would
> > like to hear what other people think. Passing a void pointer rather
> > than struct fw_dev_node has both advantages and disadvantages, and
> > I won't complain about either one if enough other people on the DT
> > side would like to see the addition of the child functions.
> 
> I actually would rather like to know if the people on the DT side have any
> problems with the child functions.
> 
> Because, suppose that they wouldn't like those functions at all.  What are we
> supposed to do, then, honestly?  Add the whole DT vs ACPI logic to the leds-gpio
> and gpio_keys_polled drivers?  But these drivers have no reason whatsoever
> to include that.  Zero.
> 
> So suggestions welcome.
> 
> [BTW, In principle we also could use something like
> 
> typedef union dev_node {
> 	struct acpi_device *acpi_node;
> 	struct device_node *of_node;
> } dev_node_t;
> 
> instead of the (void *) for more type safety.  It still is useful to pass the
> parent pointer along with that, though.]
> 
> > > Finally, device_for_each_child_node() is added for iterating over
> > > the children of the device description object associated with a
> > > given device.
> > > 
> > > The interface covers both ACPI and Device Trees.
> > > 
> > > This change set includes material from Mika Westerberg and Aaron Lu.
> > > 
> > 
> > Regarding device_for_each_child_node(), the syntax is inconsistent
> > with what we normally use, which can probably be changed. All of the
> > DT for_each_* helpers are macros that are used like
> > 
> > 	struct device *dev = ...;
> > 	void *child; /* iterator */
> > 
> > 	device_for_each_child_node(dev, child) {
> > 		u32 something;
> > 		device_child_property_read_u32(dev, child, "propname", &something);
> > 
> > 		do_something(dev, something);
> > 	}
> > 
> > If we get a consensus on having the child interfaces, I'd rather see
> > them done this way than with a callback pointer, for consistency
> > reasons.
> 
> That certainly is doable, although the resulting macro would generate a rather
> large chunk of code each time it is used.

On a second thought I'm not so sure, because we need to iterate either this
way or that way depending on a condition evaluated at run time.  I have no
idea how to do that in a macro at the moment.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
