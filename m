Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaIWU14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:27:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62234 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753947AbaIWU1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:27:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Darren Hart <dvhart@linux.intel.com>,
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
Date: Tue, 23 Sep 2014 22:47:36 +0200
Message-ID: <1579761.oeYleOAY1N@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2809308.3y5s7TV5Ip@wuerfel>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <2895905.coa5UvrkJk@vostro.rjw.lan> <2809308.3y5s7TV5Ip@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 23, 2014 06:26:07 PM Arnd Bergmann wrote:
> On Tuesday 23 September 2014 18:25:01 Rafael J. Wysocki wrote:
> > The problem is iteration over child nodes of a given one where there
> > may not be struct device objects.
> > 
> > For example (from patch [2/16]):
> > 
> > +int acpi_for_each_child_node(struct acpi_device *adev,
> > +                             int (*fn)(struct fw_dev_node *fdn, void *data),
> > +                             void *data)
> > +{
> > +       struct acpi_device *child;
> > +       int ret = 0;
> > +
> > +       list_for_each_entry(child, &adev->children, node) {
> > +               struct fw_dev_node fdn = { .acpi_node = child, };
> > +
> > +               ret = fn(&fdn, data);
> > +               if (ret)
> > +                       break;
> > +       }
> > +       return ret;
> > +}
> > 
> > and then fn() can be made work for both DTs and ACPI.  Without this we'd
> > need to have two versions of fn(), one for DTs and one for ACPI (and possibly
> > more for some other FW protocols), which isn't necessary in general (and
> > duplicates code etc.). 
> > 
> > That actually is used by some patches down in the series (eg. [10/16]).
> > 
> 
> Ok, I understand what you are doing now.
> 
> Looking at the example you point to (http://www.spinics.net/lists/devicetree/msg49502.html), I still feel
> that this is adding more abstraction than what is good for us, and
> I'd be happier with an implementation of gpio_leds_create() that
> has a bit more duplication and less abstraction.
> 
> The important part should be that the driver-side interface is
> sensible, other than that an implementation like
> 
> static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
> {
> 	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node)
> 		return gpio_leds_create_of(pdev);
> 	else if (IS_ENABLED(CONFIG_ACPI))
> 		return gpio_leds_create_of(acpi);
> 	return ERR_PTR(-ENXIO);
> }
> 
> would keep either side of it relatively simple, by leaving out the
> indirect function calls and new for_each_available_child_of_node()
> macro.

Quite frankly, I'm not sure what you're asking for.

It seems to mean "I kind of don't like the current implementation", but
then the last part is quite unclear to me.  Are you suggesting to add more
"if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) etc" type of checks to
device drivers?  That I'd like to avoid to be honest.

Instead of the current proposal we can introduce something like

int device_get_child_property(struct device *dev, void *child_node,
                              const char *propname, void **valptr);

(and analogously for device_read_property*) and use that in the drivers that
need to iterate over child nodes of a device.  Quite along the lines of what
Dmitry is suggesting.

Then, fn() in acpi_for_each_child_node() (and the of_ counterpart of it)
would become

int (*fn)(struct device *dev, void *child_node, void *data)

and so on.

Would you prefer that?


> How many other users of fw_dev_node do you have at the moment?

One more, gpio_keys_polled in patch [13/16] (https://patchwork.kernel.org/patch/4917311/).

Rafael

