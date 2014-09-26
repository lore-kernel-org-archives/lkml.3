Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaIZDVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:21:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaIZDVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:21:35 -0400
Date: Thu, 25 Sep 2014 20:21:32 -0700
From: Darren Hart <dvhart@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <david.woodhouse@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device
 properties interface
Message-ID: <20140926032131.GC40523@vmdeb7>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <2809308.3y5s7TV5Ip@wuerfel>
 <D04730D8.A9DB0%dvhart@linux.intel.com>
 <6744174.JquHLt80n3@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6744174.JquHLt80n3@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:12:36AM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 14:15:47 Darren Hart wrote:
> > Arnd, I think you meant:
> > 
> >         Return gpio_leds_create_acpi(pdev) ?
> 
> Yes, sorry for the confusion on my part.

Hi Arnd,

No problem, just wanted to make sure I knew what you meant.

> 
> > This is what we did early on to prototype this concept, but the problem
> > with this approach we duplicate all of the creation code, which leads to
> > maintenance errors, and is inconsistent with the goals of the _DSD which
> > is to reuse the same schemas for ACPI and FDT. If we have separate pdata
> > creation functions anyway, we are leaving much of the advantage of the
> > common schema on the table. Namely the ability to reuse drivers relatively
> > easily across firmware implementations. We don't want driver authors to
> > have to care if it's ACPI or FDT.
> 
> I think we are absolutely in agreement about the basic principle here,
> but disagree on how far we'd want to take the abstraction.
> 
> I got a little confused by the leds-gpio example, as I initially saw
> that as generic infrastructure rather than a specific driver. As I just
> wrote in my reply to Rafael, I generally believe we should strive to
> have generic driver-side interfaces so drivers don't have to care,
> but keep the differences in subsystem specific code.
> 
> > We would have preferred to have deprecated the of property interface in
> > favor of the new generic device_property interface, but Grant specifically
> > requested that we update drivers individually rather than all at once,
> > which means we can't just kill the OF interface.
> 
> I don't actually have a strong opinion on that matter, having only the
> device property interface does have some advantages as well, but I also
> agree that we are somewhat better off not having to change all the drivers.
> 
> > We agreed to that, somewhat reluctantly as it adds more work in updating
> > the drivers over time which will slow adoption, but I understand the
> > desire not to make large sweeping changes due to the risk of breaking
> > things inadvertently as we cannot expect to be able to test all of them.
> > That said, I don't want to forget that the goal is to use the common
> > interface over time as we convert individual drivers, and using the common
> > interface means we need a common iterator function and that we not have fw
> > implementation specific pdata create functions.
> 
> I've looked a bit closer at how the LED subsystem handles sub-nodes
> in DT at the moment. It seems that there is some duplication between
> the drivers already, as they all implement a variation of the sub-node
> parsing code.
> 
> There are other non-LED drivers with similar loops, but they seem to be
> either very specialized, or explicitly for DT abstractions, so I'm still
> not convinced we need a generic loop-through-child-nodes-and-parse-properties
> interface.
> 
> How would you feel about a more general way of probing LED, using
> a new helper in the leds-core that iterates over the child nodes
> and parses the standard properties but calls into a driver specific
> callback to parse the specific properties?
> It's probably much more work than your current approach, but it seems
> to me that there is more to gain by solving the problem for LED
> drivers in particular to cut down the per-driver duplication
> at the same time as the per-firmware-interface duplication.
> 
> As a start, we could probably take the proposed device_for_each_child_node
> and move that into the leds-core, changing the fw_dev_node argument
> for an led_classdev with the addition of the of_node and acpi_object
> members. It would still leave it up to the gpio-leds driver to do
> 
> 	if (led_cdev->of_node)
> 		gpiod = devm_of_get_gpiod(led_cdev->of_node, ...);
> 	else
> 		gpiod = devm_acpi_get_gpiod(led_cdev->acpi_object, ...);

So as Mika has pointed out, LEDs aren't the only ones affected. Several drivers
will need to walk through non-device child nodes, and it seems to me that having
a firmware-independent mechanism to do so benefits the drivers by both making
them smaller and by increasing the reusability of new drivers and drivers
updated to use the new API across platforms.

I fear we might be entering bike shed territory as we seem to be repeating
points now. Can you restate your concern with the interface and why this level
of abstraction is worse for the kernel? I'm not seeing this point, so I'm not
sure what to address in my response.

Grant, Linus W? Thoughts?

> 
> but there seems little benefit in abstracting this because there is
> only one driver that needs it.
> 
> 	Arnd
> 

-- 
Darren Hart
Intel Open Source Technology Center
