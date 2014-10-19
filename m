Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaJTAii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:38:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55100 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752003AbaJTAid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:38:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 10/12] gpio: Support for unified device properties interface
Date: Mon, 20 Oct 2014 01:58:57 +0200
Message-ID: <25715349.xM7UOyLcLb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2997291.LjjH2RgEUW@wuerfel>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <E99B44D9-C9E3-4C0B-8B18-450121793EB5@arndb.de> <2997291.LjjH2RgEUW@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 18, 2014 11:47:41 AM Arnd Bergmann wrote:
> On Friday 17 October 2014 20:09:51 Arnd Bergmann wrote:
> > On October 17, 2014 2:16:00 PM CEST, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> > >From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > >
> > >Some drivers need to deal with only firmware representation of its
> > >GPIOs. An example would be a GPIO button array driver where each button
> > >is described as a separate firmware node in device tree. Typically
> > >these
> > >child nodes do not have physical representation in the Linux device
> > >model.
> > >
> > >In order to help device drivers to handle such firmware child nodes we
> > >add dev[m]_get_named_gpiod_from_child() that takes a child firmware
> > >node pointer as its second argument (the first one is the parent device
> > >itself), finds the GPIO using whatever is the underlying firmware
> > >method, and requests the GPIO properly.
> > 
> > Could we also have a wrapper around this function without a "name" argument,
> > using just the index?
> 
> Expanding on this thought: I think we should mandate for new bindings
> that they use either a name and no index, or an index but not name,
> and I also think that for named gpios, we should try to converge on a
> common naming scheme. As discussed, we will probably want to support all
> the existing ways to do this even with ACPI and with the unified
> interface, but it doesn't have to be the obvious way.
> 
> We could do it like this:
> 
> // internal implementation, may be called from drivers with legacy bindings 
> struct gpio_desc *__fwnode_get_gpiod_from_property(struct fwnode_handle *fwnode,
>                                            const char *propname, int index)
> {
> 	... /* your current code */
> }
> 
> // recommended interface
> static inline struct gpio_desc *fwnode_get_gpiod(struct fwnode_handle *fwnode,
> 						  int index)
> {
> 	return __fwnode_get_gpiod_from_property(fwnode, "gpios", index);
> }
> 
> // alternative interface
> struct gpio_desc *fwnode_get_gpiod(struct fwnode_handle *fwnode, const char *name)
> {
> 	char propname[64];
> 	int ret;
> 	
> 	ret = snprintf(propname, sizeof(propname), "%s-gpios", name);
> 	if (ret > sizeof(propname))
> 		return -EINVAL;
> 
> 	return __fwnode_get_gpiod_from_property(fwnode, propname, 0);
> }
> 
> The above is just a suggestion, I'm hoping for the GPIO maintainers to
> provide more guidance if they have other ideas.

Actually, since the two last patches in the series, which currently are
the only users of these new functions, both pass "gpios" as the property
name and 0 as the index, I can simplify the functions so that (a)
fwnode_get_gpiod() takes fwnode and name and then simply passes 0 as the
index to either of_get_named_gpiod_flags() or acpi_get_gpiod_by_index()
and (b) devm_get_named_gpiod_from_child() takes only dev and fwnode (child)
and passes "gpios" as the property name to fwnode_get_gpiod().  The name
of devm_get_named_gpiod_from_child() could then be changed to something
like devm_get_gpiod_from_child() even.

If anyone in the future needs anything more general, they can simply
add more complexity to that code, but for now we can go for a simplified
interface just fine.

Rafael

