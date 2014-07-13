Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaGMSaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:30:05 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38572
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaGMS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:29:59 -0400
X-IronPort-AV: E=Sophos;i="5.01,654,1400018400"; 
   d="scan'208";a="71264665"
Date: Sun, 13 Jul 2014 20:29:56 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Himangi Saraogi <himangi774@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ambakmi - Use managed interfaces
In-Reply-To: <20140713182123.GM21766@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1407132029080.2060@localhost6.localdomain6>
References: <20140713173051.GA4299@himangi-Dell> <20140713175308.GL21766@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1407132010130.2060@localhost6.localdomain6> <20140713182123.GM21766@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2014, Russell King - ARM Linux wrote:

> On Sun, Jul 13, 2014 at 08:11:29PM +0200, Julia Lawall wrote:
> > On Sun, 13 Jul 2014, Russell King - ARM Linux wrote:
> > 
> > > On Sun, Jul 13, 2014 at 11:00:51PM +0530, Himangi Saraogi wrote:
> > > > @@ -23,6 +23,7 @@
> > > >  #include <linux/clk.h>
> > > >  
> > > >  #include <asm/io.h>
> > > > +#include <linux/io.h>
> > > 
> > > NAK - please include either linux/io.h _or_ asm/io.h but not both.
> > > 
> > > > @@ -112,19 +113,10 @@ static int amba_kmi_probe(struct amba_device *dev,
> > > >  {
> > > >  	struct amba_kmi_port *kmi;
> > > >  	struct serio *io;
> > > > -	int ret;
> > > > -
> > > > -	ret = amba_request_regions(dev, NULL);
> > > > -	if (ret)
> > > > -		return ret;
> > > 
> > > I'm /really/ not happy about that going.
> > 
> > Could you explain why?  I looked at the code several times, and I couldn't 
> > see how it was different than request_mem_region, which is merged into 
> > devm_ioremap_resource.
> 
> Check what gets used for the name of the resource.
> 
> Now, consider that most devices when they are registered have their
> resource names set to the device name.
> 
> Then realise that devm_ioremap_resource() uses the resource name or
> the device name again.  So, what you end up with in /proc/iomem is
> a load of stupidity - you don't get to see there which drivers are
> making use of the resources, only a load of duplicated information
> about what devices are using the regions.
> 
> This is contary to other bus types (like PCI) where the _device_ takes
> the non-busy parent resource, and the driver takes the busy resource
> using the _driver_ name, not the device name.  The exception to this
> is network drivers which have in the past used the network device
> name.
> 
> Here's an example.  x86:
> 
>   fc000000-fc01ffff : 0000:00:19.0	<--- device name
>     fc000000-fc01ffff : e1000e		<--- driver name
>   fc020000-fc023fff : 0000:00:1b.0	<--- device name
>     fc020000-fc023fff : ICH HD audio	<--- driver name
>   fc024000-fc024fff : 0000:00:03.3
>   fc025000-fc025fff : 0000:00:19.0	<--- device name
>     fc025000-fc025fff : e1000e		<--- driver name
>   fc226000-fc2267ff : 0000:00:1f.2	<--- device name
>     fc226000-fc2267ff : ahci		<--- driver name
> 
> etc.  When using devm_ioremap_resource() this ends up as:
> 
> 02184000-021841ff : /soc/aips-bus@02100000/usb@02184000
>   02184000-021841ff : /soc/aips-bus@02100000/usb@02184000
> 02184200-021843ff : /soc/aips-bus@02100000/usb@02184200
>   02184200-021843ff : /soc/aips-bus@02100000/usb@02184200
> 
> which is really pointless duplicating the resource name like that.  It
> conveys no additional useful information.

OK, thanks very much.

julia
