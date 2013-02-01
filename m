Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3BAHVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:21:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:32985 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3BAHVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:21:14 -0500
Date: Fri, 1 Feb 2013 08:23:12 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH v2 01/12] Add sys_hotplug.h for system device hotplug
 framework
Message-ID: <20130201072312.GB1180@kroah.com>
References: <1357861230-29549-1-git-send-email-toshi.kani@hp.com>
 <20130130045830.GH30002@kroah.com>
 <1359601065.15120.156.camel@misato.fc.hp.com>
 <9860755.q4y3PrCFZx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9860755.q4y3PrCFZx@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 09:54:51PM +0100, Rafael J. Wysocki wrote:
> > > But, again, I'm going to ask why you aren't using the existing cpu /
> > > memory / bridge / node devices that we have in the kernel.  Please use
> > > them, or give me a _really_ good reason why they will not work.
> > 
> > We cannot use the existing system devices or ACPI devices here.  During
> > hot-plug, ACPI handler sets this shp_device info, so that cpu and memory
> > handlers (drivers/cpu.c and mm/memory_hotplug.c) can obtain their target
> > device information in a platform-neutral way.  During hot-add, we first
> > creates an ACPI device node (i.e. device under /sys/bus/acpi/devices),
> > but platform-neutral modules cannot use them as they are ACPI-specific.
> 
> But suppose we're smart and have ACPI scan handlers that will create
> "physical" device nodes for those devices during the ACPI namespace scan.
> Then, the platform-neutral nodes will be able to bind to those "physical"
> nodes.  Moreover, it should be possible to get a hierarchy of device objects
> this way that will reflect all of the dependencies we need to take into
> account during hot-add and hot-remove operations.  That may not be what we
> have today, but I don't see any *fundamental* obstacles preventing us from
> using this approach.

I would _much_ rather see that be the solution here as I think it is the
proper one.

> This is already done for PCI host bridges and platform devices and I don't
> see why we can't do that for the other types of devices too.

I agree.

> The only missing piece I see is a way to handle the "eject" problem, i.e.
> when we try do eject a device at the top of a subtree and need to tear down
> the entire subtree below it, but if that's going to lead to a system crash,
> for example, we want to cancel the eject.  It seems to me that we'll need some
> help from the driver core here.

I say do what we always have done here, if the user asked us to tear
something down, let it happen as they are the ones that know best :)

Seriously, I guess this gets back to the "fail disconnect" idea that the
ACPI developers keep harping on.  I thought we already resolved this
properly by having them implement it in their bus code, no reason the
same thing couldn't happen here, right?  I don't think the core needs to
do anything special, but if so, I'll be glad to review it.

thanks,

gre k-h
