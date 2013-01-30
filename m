Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3A3NaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:30:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:32907 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab3A3NaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:30:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ACPI scan handlers
Date: Wed, 30 Jan 2013 14:36:22 +0100
Message-ID: <2835860.8PoYodXXnK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359511110.15120.77.camel@misato.fc.hp.com>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <4311642.nDd2RCVeDc@vostro.rjw.lan> <1359511110.15120.77.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 06:58:30 PM Toshi Kani wrote:
> On Mon, 2013-01-28 at 13:58 +0100, Rafael J. Wysocki wrote:
> > On Thursday, January 24, 2013 01:26:56 AM Rafael J. Wysocki wrote:
> > > Hi All,
> > > 
> > > There is a considerable amount of confusion in the ACPI subsystem about what
> > > ACPI drivers are used for.  Namely, some of them are used as "normal" device
> > > drivers that bind to devices and handle them using ACPI control methods (like
> > > the fan or battery drivers), but some of them are just used for handling
> > > namespace events, such as the creation or removal of device nodes (I guess it
> > > would be fair to call that an abuse of the driver core).  These two roles are
> > > quite distinct, which is particularly visible from the confusion about the role
> > > of the .remove() callback.
> > > 
> > > For the "normal" drivers this callback is simply used to handle situations in
> > > which the driver needs to be unbound from the device, because one of them
> > > (either the device or the driver) is going away.  That operation can't really
> > > fail, it just needs to do the necessary cleanup.
> > > 
> > > However, for the namespace events handling "drivers" .remove() means that not
> > > only the device node in question, but generally also the whole subtree below it
> > > needs to be prepared for removal, which may involve deleting multiple device
> > > objects belonging to different bus types and so on and which very well may fail
> > > (for example, those devices may be used for such things like swap or they may be
> > > memory banks used by the kernel and it may not be safe to remove them at the
> > > moment etc.).  Moreover, for these things the removal of the "driver" doesn't
> > > really make sense, because it has to be there to handle the namespace events it
> > > is designed to handle or else things will go remarkably awry in some places.
> > > 
> > > To resolve all that mess I'd like to do the following, which in part is inspired
> > > by the recent Toshi Kani's hotplug framework proposal and in part is based on
> > > some discussions I had with Bjorn and others (the code references made below are
> > > based on the current contens of linux-pm.git/linux-next).
> > > 
> > > 1) Introduce a special data type for "ACPI namespace event handlers" like:
> > > 
> > > struct acpi_scan_handler {
> > > 	const struct acpi_device_id *ids;
> > > 	struct list_head list_node;
> > > 	int (*attach)(struct acpi_device *adev);
> > > 	int (*untie)(struct acpi_device *adev);
> > > 	int (*reclaim)(struct acpi_device *adev);
> > > 	void (*detach)(struct acpi_device *adev);
> > > };
> > 
> > After some reconsideration I think that the "untie" and "reclaim" things won't
> > be really useful at this level.  This means that I only need ACPI scan handlers
> > to do .attach() and .detach() and all of that becomes really simple, so I don't
> > see reason to wait with that change.
> > 
> > The following patches introduce ACPI scan handlers and make some use of them.
> > 
> > [1/4] Introduce struct acpi_scan_handler for configuration tasks depending on
> >       device IDs.
> > 
> > [2/4] Make ACPI PCI root driver use struct acpi_scan_handler.
> > 
> > [3/4] Make ACPI PCI IRQ link driver use struct acpi_scan_handler.
> > 
> > [4/4] Use struct acpi_scan_handler for creating platform devices enumerated via ACPI.
> 
> For the series:
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
