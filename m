Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaGGOnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:43:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:44155 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaGGOnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:43:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="539747985"
Message-ID: <1404744182.2291.56.camel@rzhang1-toshiba>
Subject: Re: ACPI resource change triggers loss of serial ports
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Andy Whitcroft <apw@canonical.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 07 Jul 2014 22:43:02 +0800
In-Reply-To: <3285666.Y2zL3buWBl@vostro.rjw.lan>
References: <20140619104130.GA11561@dm> <3285666.Y2zL3buWBl@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 14:57 +0200, Rafael J. Wysocki wrote:
> On Thursday, June 19, 2014 11:41:30 AM Andy Whitcroft wrote:
> > The recently merged change (in v3.14-rc6) to ACPI resource detection
> > (below) causes all zero length ACPI resources to be elided from the table:
> > 
> >   commit b355cee88e3b1a193f0e9a81db810f6f83ad728b
> >   Author: Zhang Rui <rui.zhang@intel.com>
> >   Date:   Thu Feb 27 11:37:15 2014 +0800
> > 
> >     ACPI / resources: ignore invalid ACPI device resources
> > 
> > This change has caused a regression in (at least) serial port detection
> > for a number of machines (see LP#1313981 [1]).  These seem to represent
> > their IO regions (presumably incorrectly) as a zero length region.
> > Reverting the above commit restores these serial devices.
> > 
> > For Zhang's case I wonder if this check could be tightened up to cover
> > only the zero base, something like the (untested) patch below.
> > 
> > -apw
> > 
> > [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1313981
> 
> I'm going to queue up the patch below for 3.16.
> 
> Rui, can you please have a look at this and let me know if there's
> anything wrong with it?
> 
> Rafael
> 
> 
> > From e5211c68278387ef65e483bcfedd5581a79ec783 Mon Sep 17 00:00:00 2001
> > From: Andy Whitcroft <apw@canonical.com>
> > Date: Thu, 19 Jun 2014 11:19:16 +0100
> > Subject: [PATCH] ACPI / Resources: only reject zero length resources based at
> >  address zero
> > 
> > The recently merged change (in v3.14-rc6) to ACPI resource detection
> > (below) causes all zero length ACPI resources to be elided from the
> > table:
> > 
> >   commit b355cee88e3b1a193f0e9a81db810f6f83ad728b
> >   Author: Zhang Rui <rui.zhang@intel.com>
> >   Date:   Thu Feb 27 11:37:15 2014 +0800
> > 
> >     ACPI / resources: ignore invalid ACPI device resources
> > 
> > This change has caused a regression in (at least) serial port detection
> > for a number of machines (see LP#1313981 [1]).  These seem to represent
> > their IO regions (presumably incorrectly) as a zero length region.
> > Reverting the above commit restores these serial devices.
> > 
> > Only elide zero length resources which lie at address 0.
> > 
> > Signed-off-by: Andy Whitcroft <apw@canonical.com>
The patch looks okay to me.

Acked-by: Zhang Rui <rui.zhang@intel.com>

thanks,
rui
> > ---
> >  drivers/acpi/resource.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> > index 0bdacc5..2ba8f02 100644
> > --- a/drivers/acpi/resource.c
> > +++ b/drivers/acpi/resource.c
> > @@ -77,7 +77,7 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
> >  	switch (ares->type) {
> >  	case ACPI_RESOURCE_TYPE_MEMORY24:
> >  		memory24 = &ares->data.memory24;
> > -		if (!memory24->address_length)
> > +		if (!memory24->minimum && !memory24->address_length)
> >  			return false;
> >  		acpi_dev_get_memresource(res, memory24->minimum,
> >  					 memory24->address_length,
> > @@ -85,7 +85,7 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
> >  		break;
> >  	case ACPI_RESOURCE_TYPE_MEMORY32:
> >  		memory32 = &ares->data.memory32;
> > -		if (!memory32->address_length)
> > +		if (!memory32->minimum && !memory32->address_length)
> >  			return false;
> >  		acpi_dev_get_memresource(res, memory32->minimum,
> >  					 memory32->address_length,
> > @@ -93,7 +93,7 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
> >  		break;
> >  	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> >  		fixed_memory32 = &ares->data.fixed_memory32;
> > -		if (!fixed_memory32->address_length)
> > +		if (!fixed_memory32->address && !fixed_memory32->address_length)
> >  			return false;
> >  		acpi_dev_get_memresource(res, fixed_memory32->address,
> >  					 fixed_memory32->address_length,
> > @@ -150,7 +150,7 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
> >  	switch (ares->type) {
> >  	case ACPI_RESOURCE_TYPE_IO:
> >  		io = &ares->data.io;
> > -		if (!io->address_length)
> > +		if (!io->minimum && !io->address_length)
> >  			return false;
> >  		acpi_dev_get_ioresource(res, io->minimum,
> >  					io->address_length,
> > @@ -158,7 +158,7 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
> >  		break;
> >  	case ACPI_RESOURCE_TYPE_FIXED_IO:
> >  		fixed_io = &ares->data.fixed_io;
> > -		if (!fixed_io->address_length)
> > +		if (!fixed_io->address && !fixed_io->address_length)
> >  			return false;
> >  		acpi_dev_get_ioresource(res, fixed_io->address,
> >  					fixed_io->address_length,
> > 
> 


