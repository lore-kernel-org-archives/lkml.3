Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3AaBZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:25:21 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:11613 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3AaBZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:25:18 -0500
Message-ID: <1359594912.15120.85.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH v2 01/12] Add sys_hotplug.h for system device
 hotplug framework
From: Toshi Kani <toshi.kani@hp.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, guohanjun@huawei.com,
        yinghai@kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Wed, 30 Jan 2013 18:15:12 -0700
In-Reply-To: <20130130044859.GD30002@kroah.com>
References: <1357861230-29549-1-git-send-email-toshi.kani@hp.com>
	 <5036592.TuXAnGzk4M@vostro.rjw.lan>
	 <1358177628.14145.49.camel@misato.fc.hp.com>
	 <2154272.qDAyBlTr8z@vostro.rjw.lan>
	 <1358190124.14145.79.camel@misato.fc.hp.com>
	 <20130130044859.GD30002@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 23:48 -0500, Greg KH wrote:
> On Mon, Jan 14, 2013 at 12:02:04PM -0700, Toshi Kani wrote:
> > On Mon, 2013-01-14 at 19:48 +0100, Rafael J. Wysocki wrote:
> > > On Monday, January 14, 2013 08:33:48 AM Toshi Kani wrote:
> > > > On Fri, 2013-01-11 at 22:23 +0100, Rafael J. Wysocki wrote:
> > > > > On Thursday, January 10, 2013 04:40:19 PM Toshi Kani wrote:
> > > > > > Added include/linux/sys_hotplug.h, which defines the system device
> > > > > > hotplug framework interfaces used by the framework itself and
> > > > > > handlers.
> > > > > > 
> > > > > > The order values define the calling sequence of handlers.  For add
> > > > > > execute, the ordering is ACPI->MEM->CPU.  Memory is onlined before
> > > > > > CPU so that threads on new CPUs can start using their local memory.
> > > > > > The ordering of the delete execute is symmetric to the add execute.
> > > > > > 
> > > > > > struct shp_request defines a hot-plug request information.  The
> > > > > > device resource information is managed with a list so that a single
> > > > > > request may target to multiple devices.
> > > > > > 
> > > >  :
> > > > > > +
> > > > > > +struct shp_device {
> > > > > > +	struct list_head	list;
> > > > > > +	struct device		*device;
> > > > > > +	enum shp_class		class;
> > > > > > +	union shp_dev_info	info;
> > > > > > +};
> > > > > > +
> > > > > > +/*
> > > > > > + * Hot-plug request
> > > > > > + */
> > > > > > +struct shp_request {
> > > > > > +	/* common info */
> > > > > > +	enum shp_operation	operation;	/* operation */
> > > > > > +
> > > > > > +	/* hot-plug event info: only valid for hot-plug operations */
> > > > > > +	void			*handle;	/* FW handle */
> > > > > 
> > > > > What's the role of handle here?
> > > > 
> > > > On ACPI-based platforms, the handle keeps a notified ACPI handle when a
> > > > hot-plug request is made.  ACPI bus handlers, acpi_add_execute() /
> > > > acpi_del_execute(), then scans / trims ACPI devices from the handle.
> > > 
> > > OK, so this is ACPI-specific and should be described as such.
> > 
> > Other FW interface I know is parisc, which has mod_index (module index)
> > to identify a unique object, just like what ACPI handle does.  The
> > handle can keep the mod_index as an opaque value as well.  But as you
> > said, I do not know if the handle works for all other FWs.  So, I will
> > add descriptions, such that the hot-plug event info is modeled after
> > ACPI and may need to be revisited when supporting other FW.
> 
> Please make it a "real" pointer, and not a void *, those shouldn't be
> used at all if possible.

How about changing the "void *handle" to acpi_dev_node below?   

   struct acpi_dev_node    acpi_node;

Basically, it has the same challenge as struct device, which uses
acpi_dev_node as well.  We can add other FW node when needed (just like
device also has *of_node).

Thanks,
-Toshi



