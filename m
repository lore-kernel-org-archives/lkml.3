Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaJTWBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:01:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61363 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752836AbaJTWBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:01:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 09/12] Driver core: Unified interface for firmware node properties
Date: Tue, 21 Oct 2014 00:22:09 +0200
Message-ID: <5981363.HuOrK2kMZG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3213594.3tCDm06Aee@wuerfel>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <7821406.D7i8JfDpzX@vostro.rjw.lan> <3213594.3tCDm06Aee@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2014 04:19:57 PM Arnd Bergmann wrote:
> On Monday 20 October 2014 01:46:00 Rafael J. Wysocki wrote:
> > 
> > > Something like:
> > > 
> > > #define define_fwnode_accessors(__type, __devprop_type) \
> > > int device_property_read_##__type(struct device *dev, \
> > >                               const char *propname, __type *val) \
> > > { \
> > >       if (IS_ENABLED(CONFIG_OF) && dev->of_node) \
> > >               return of_property_read_##__type(dev->of_node, propname, val); \
> > >       return acpi_dev_prop_read(ACPI_COMPANION(dev), propname, \
> > >                                 __devprop_type, val); \
> > > } \
> > > int fwnode_property_read_##__type(struct fwnode_handle *fwnode, \
> > >                               const char *propname, __type *val) \
> > > { \
> > >       if (IS_ENABLED(CONFIG_OF) && is_of_node(fwnode)) \
> > >               return of_property_read_##__type(of_node(fwnode), propname, val); \
> > >       else if (IS_ENABLED(CONFIG_ACPI) && is_acpi_node(fwnode)) \
> > >               return acpi_dev_prop_read(acpi_node(fwnode), propname, \
> > >                                         __devprop_type, val); \
> > >       return -ENXIO; \
> > > }
> > > 
> > > define_fwnode_accessors(u8, DEV_PROP_U8);
> > > define_fwnode_accessors(u16, DEV_PROP_U16);
> > > define_fwnode_accessors(u32, DEV_PROP_U32);
> > > define_fwnode_accessors(u64, DEV_PROP_U64);
> > > 
> > > That significantly reduces the code size for these things.
> > 
> > So I was considering to do that, but eventually decided not to, because (1)
> > adding kerneldoc comments to such things looks odd and (2) (which IMO is
> > more important) this breaks LXR (for example, the thing at lxr.free-electrons.com
> > that some people, including me in particular, occasionally use to check how things
> > are defined).  And even if you used the old good grep to look for a definition of
> > fwnode_property_read_u8, say, this wouldn't work exactly as expected I'm afraid. 
> 
> Agreed, I'd also prefer your proposed code over Grant's macros.
> 
> > I would very much like to retain the headers at least for this reason, if that's
> > not a big deal.
> > 
> > What I can do, however, is to use macros for generating the bodies of those
> > functions.
> 
> Yes, just don't do any concatenation to generate the names of the called
> functions, i.e.
> 
> 	return fwnode_call(of_property_read_u32, acpi_dev_prop_read, DEV_PROP_U32, node, propname, val);
> 
> is better than
> 
> 	return fwnode_call(u32, DEV_PROP_U32, node, propname, val);
> 
> because it's easier to understand the call chain.

There is one concatenation like that in the code I have today, but it was
already present in the $subject series, in the of_dev_prop_read_array macro
in patch #2 (and it actually makes sense to me).

Rafael

