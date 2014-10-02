Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaJBQaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:30:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58310 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751473AbaJBQaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:30:07 -0400
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
Date: Thu, 02 Oct 2014 18:50:05 +0200
Message-ID: <3362983.vANcYgNxxP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <6092163.dWXI6rWTCu@wuerfel>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <4390403.PNxQqnBDGX@vostro.rjw.lan> <6092163.dWXI6rWTCu@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 02, 2014 09:46:29 AM Arnd Bergmann wrote:
> On Thursday 02 October 2014 00:09:44 Rafael J. Wysocki wrote:
> > On Wednesday, October 01, 2014 09:47:40 AM Arnd Bergmann wrote:
> > > On Wednesday 01 October 2014 04:10:03 Rafael J. Wysocki wrote:
> > > I still have my reservations against the child accessors, and would
> > > like to hear what other people think. Passing a void pointer rather
> > > than struct fw_dev_node has both advantages and disadvantages, and
> > > I won't complain about either one if enough other people on the DT
> > > side would like to see the addition of the child functions.
> > 
> > I actually would rather like to know if the people on the DT side have any
> > problems with the child functions.
> 
> Sure, any kind of feedback would be helpful really. 
> 
> > Because, suppose that they wouldn't like those functions at all.  What are we
> > supposed to do, then, honestly?  Add the whole DT vs ACPI logic to the leds-gpio
> > and gpio_keys_polled drivers?  But these drivers have no reason whatsoever
> > to include that.  Zero.
> > 
> > So suggestions welcome.
> > 
> > [BTW, In principle we also could use something like
> > 
> > typedef union dev_node {
> > 	struct acpi_device *acpi_node;
> > 	struct device_node *of_node;
> > } dev_node_t;
> > 
> > instead of the (void *) for more type safety.  It still is useful to pass the
> > parent pointer along with that, though.]
> 
> Yes, I'm not worried about the implementation details.
> 
> > > > Finally, device_for_each_child_node() is added for iterating over
> > > > the children of the device description object associated with a
> > > > given device.
> > > > 
> > > > The interface covers both ACPI and Device Trees.
> > > > 
> > > > This change set includes material from Mika Westerberg and Aaron Lu.
> > > > 
> > > 
> > > Regarding device_for_each_child_node(), the syntax is inconsistent
> > > with what we normally use, which can probably be changed. All of the
> > > DT for_each_* helpers are macros that are used like
> > > 
> > > 	struct device *dev = ...;
> > > 	void *child; /* iterator */
> > > 
> > > 	device_for_each_child_node(dev, child) {
> > > 		u32 something;
> > > 		device_child_property_read_u32(dev, child, "propname", &something);
> > > 
> > > 		do_something(dev, something);
> > > 	}
> > > 
> > > If we get a consensus on having the child interfaces, I'd rather see
> > > them done this way than with a callback pointer, for consistency
> > > reasons.
> > 
> > That certainly is doable, although the resulting macro would generate a rather
> > large chunk of code each time it is used.
> 
> 
> #define device_for_each_child_node(dev, child) \
> 	for (child = device_get_next_child_node(dev, NULL), child, \
> 	     child = device_get_next_child_node(dev, child))
> 
> void *device_get_next_child_node(struct device *dev, void *child)
> {
> 	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> 		return of_get_next_child(dev->of_node, child);
> 	else if (IS_ENABLED(CONFIG_ACPI) && ...)
> 		return acpi_get_next_child(dev, child);
> 	return NULL;
> }
> 
> Not any more code than what we have today for the DT-only case, and it's
> really just a function call in a loop.

OK, I see what you mean.

Now we have the if () on every iteration instead of just doing that once
upfront.  Not a big deal I suppose, but slightly ugly to me.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
