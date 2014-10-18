Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaJRJrv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 05:47:51 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:65199 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaJRJrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 05:47:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
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
Date: Sat, 18 Oct 2014 11:47:41 +0200
Message-ID: <2997291.LjjH2RgEUW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <E99B44D9-C9E3-4C0B-8B18-450121793EB5@arndb.de>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <1510578.dSiEYPPI9m@vostro.rjw.lan> <E99B44D9-C9E3-4C0B-8B18-450121793EB5@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DaQpddX7SRVzwRZnqFnbCPPphsrwGAAZ+Btu33C94Bh
 McTJWcC7/124uxRM07J3Iu2KIGutTmqGunwE0iNu8AUxvuFr4x
 VOC+JGcnXSKsWtWsj8KCiEUeTFltdwfoetUTLj2mZyJTECC3js
 EKd1ujyvN+yxHKuEWKac2AFsSG8A1H8F3YkX0wSwaymNV83J4w
 GJtms5qyDLId8KfIx1pPTzwWO4790RiVjeSXRVrEewlhVwva1s
 kktKDJ8+H/bEUhNCRj5eLYmyxhd08FqGIWsNrPpGTyuzyhFAvv
 XOm1FUfwK13SHO+bphWDgkRDH6EqnVYIX+YiR6fCpKklBCmHXf
 n4k84D2HXxkYV38zYt8M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2014 20:09:51 Arnd Bergmann wrote:
> On October 17, 2014 2:16:00 PM CEST, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> >From: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> >Some drivers need to deal with only firmware representation of its
> >GPIOs. An example would be a GPIO button array driver where each button
> >is described as a separate firmware node in device tree. Typically
> >these
> >child nodes do not have physical representation in the Linux device
> >model.
> >
> >In order to help device drivers to handle such firmware child nodes we
> >add dev[m]_get_named_gpiod_from_child() that takes a child firmware
> >node pointer as its second argument (the first one is the parent device
> >itself), finds the GPIO using whatever is the underlying firmware
> >method, and requests the GPIO properly.
> 
> Could we also have a wrapper around this function without a "name" argument,
> using just the index?

Expanding on this thought: I think we should mandate for new bindings
that they use either a name and no index, or an index but not name,
and I also think that for named gpios, we should try to converge on a
common naming scheme. As discussed, we will probably want to support all
the existing ways to do this even with ACPI and with the unified
interface, but it doesn't have to be the obvious way.

We could do it like this:

// internal implementation, may be called from drivers with legacy bindings 
struct gpio_desc *__fwnode_get_gpiod_from_property(struct fwnode_handle *fwnode,
                                           const char *propname, int index)
{
	... /* your current code */
}

// recommended interface
static inline struct gpio_desc *fwnode_get_gpiod(struct fwnode_handle *fwnode,
						  int index)
{
	return __fwnode_get_gpiod_from_property(fwnode, "gpios", index);
}

// alternative interface
struct gpio_desc *fwnode_get_gpiod(struct fwnode_handle *fwnode, const char *name)
{
	char propname[64];
	int ret;
	
	ret = snprintf(propname, sizeof(propname), "%s-gpios", name);
	if (ret > sizeof(propname))
		return -EINVAL;

	return __fwnode_get_gpiod_from_property(fwnode, propname, 0);
}

The above is just a suggestion, I'm hoping for the GPIO maintainers to
provide more guidance if they have other ideas.

	Arnd
