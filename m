Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaIZOWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:22:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51953 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753458AbaIZOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:22:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <dvhart@infradead.org>,
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
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Fri, 26 Sep 2014 16:42:28 +0200
Message-ID: <4111948.OqsXPJi3b5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1957255.2hxfTldm4Q@wuerfel>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <20140926032131.GC40523@vmdeb7> <1957255.2hxfTldm4Q@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 26, 2014 10:36:06 AM Arnd Bergmann wrote:
> On Thursday 25 September 2014 20:21:32 Darren Hart wrote:
> > On Wed, Sep 24, 2014 at 11:12:36AM +0200, Arnd Bergmann wrote:
> > > How would you feel about a more general way of probing LED, using
> > > a new helper in the leds-core that iterates over the child nodes
> > > and parses the standard properties but calls into a driver specific
> > > callback to parse the specific properties?
> > > It's probably much more work than your current approach, but it seems
> > > to me that there is more to gain by solving the problem for LED
> > > drivers in particular to cut down the per-driver duplication
> > > at the same time as the per-firmware-interface duplication.
> > > 
> > > As a start, we could probably take the proposed device_for_each_child_node
> > > and move that into the leds-core, changing the fw_dev_node argument
> > > for an led_classdev with the addition of the of_node and acpi_object
> > > members. It would still leave it up to the gpio-leds driver to do
> > > 
> > > 	if (led_cdev->of_node)
> > > 		gpiod = devm_of_get_gpiod(led_cdev->of_node, ...);
> > > 	else
> > > 		gpiod = devm_acpi_get_gpiod(led_cdev->acpi_object, ...);
> > 
> > So as Mika has pointed out, LEDs aren't the only ones affected. Several drivers
> > will need to walk through non-device child nodes, and it seems to me that having
> > a firmware-independent mechanism to do so benefits the drivers by both making
> > them smaller and by increasing the reusability of new drivers and drivers
> > updated to use the new API across platforms.
> > 
> > I fear we might be entering bike shed territory as we seem to be repeating
> > points now. Can you restate your concern with the interface and why this level
> > of abstraction is worse for the kernel? I'm not seeing this point, so I'm not
> > sure what to address in my response.
> 
> I think we should have abstractions for all common interfaces but make
> them as simple as possible. In the discussions at the kernel summit,
> everyone agreed that we should have common accessors for simple properties
> (bool, int, string, ...) based on device pointers, as well as subsystem
> specific accessors to handle the high-level abstractions (registers,
> interrupts, gpio, regulator, pinctrl, dma, reset, pwm, ...).
> 
> Having generalized accessors for the same properties in child nodes of
> the device goes beyond that, and I think this is the wrong trade-off
> between interface simplicity and generality since only few drivers will
> be able to use those. I think we will always have to live with a leaky
> abstraction because some drivers need to do things beyond what we can
> do with a common API.

Some drivers do, but then we can avoid adding DT/ACPI knowledge to some
drivers by adding general accessors for properties in child nodes.  In my
opinion, drivers should not do things specific to DT/ACPI unless that is
unavoidable.

> 
> > Grant, Linus W? Thoughts?
> 
> I definitely want to hear other voices on this too. This is really not
> a fundamental debate I think, but more a question of how far the abstraction
> should go.

Right.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
