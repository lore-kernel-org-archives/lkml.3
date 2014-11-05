Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaKEUjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:39:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61762 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750702AbaKEUjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:39:07 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index() when using properties
Date: Wed, 05 Nov 2014 21:59:51 +0100
Message-ID: <2251117.W1kfIOl2SD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5459646E.9000707@linux.intel.com>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com> <3196606.Sy6xFg88zg@vostro.rjw.lan> <5459646E.9000707@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 03:42:38 PM Darren Hart wrote:
> 
> On 11/4/14 14:54, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / property: Drop size_prop from acpi_dev_get_property_reference()
> > 
> > The size_prop argument of the recently added function
> > acpi_dev_get_property_reference() is not used by the only current
> > caller of that function and is very unlikely to be used at any time
> > going forward.
> > 
> > Namely, for a property whose value is a list of items each containing
> > a references to a device object possibly accompanied by some integers,
> > the number of items in the list can always be computed as the number
> > of elements of type ACPI_TYPE_LOCAL_REFERENCE in the property package.
> > Thus it should never be necessary to provide an additional "cells"
> > property with a value equal to the number of items in that list.
> 
> In this case, do we never expect a property to contain more than one
> ACPI_TYPE_LOCAL_REFERENCE?
> 
> Package () { "foobar",
>               Package () {
>                   "PCI0.FOO", "PCI0.BAR", 0, 1, 0,
>                   "PCI0.FOO", "PCI0.BAR2", 0, 1, 1
>               }
> }
> 
> This seems like it could be useful for connecting various types of
> devices together, but I confess not to have a specific exmaple in mind.
> It does concern me to limit the data format in this way.

We don't support this even with size_prop, so it doesn't seem to be relevant here.

Now, if we were to support this, I'd rather not use acpi_dev_get_property_reference()
for that, but add a new function specifically for it.  Moreover, I would extend the
format definition then so that we could do

Package () {
	"foobar", Package () {
			Package () {"PCI0.FOO", "PCI0.BAR", 0, 1, 0},
			Package () {"PCI0.FOO", "PCI0.BAR2", 0, 1, 1}
	}
}

in which case adding a special "size" property could be avoided.

That said, I have no idea why it might be necessary.  One reference in a property
value means that we're connecting the current node (the owner of the _DSD
containing that property) with some other node in the namespace.  Two references
in there would mean that the current node is to be connected with *two* other
nodes in the namespace at the same time.  That raises some questions that I'd
rather not consider in detail here, unless you insist. ;-)

> I suppose should such a case become necessary, we can deal with the
> issue then - and still avoid having a potential abuse point in the API
> from the start.

What we have today is sufficient for all of the cases we've considered so far.
If we find a case where it is not sufficient, we'll need to consider extending
the data format as well as the API.

Rafael

