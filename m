Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3HYVwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 17:52:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3HYVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 17:52:09 -0400
Date: Sun, 25 Aug 2013 14:54:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
Message-ID: <20130825215420.GB23446@kroah.com>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543475.L7gSB7lLAu@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 10:09:47PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> There are two mutexes, device_hotplug_lock and acpi_scan_lock, held
> around the acpi_bus_trim() call in acpi_scan_hot_remove() which
> generally removes devices (it removes ACPI device objects at least,
> but it may also remove "physical" device objects through .detach()
> callbacks of ACPI scan handlers).  Thus, potentially, device sysfs
> attributes are removed under these locks and to remove those
> attributes it is necessary to hold the s_active references of their
> directory entries for writing.
> 
> On the other hand, the execution of a .show() or .store() callback
> from a sysfs attribute is carried out with that attribute's s_active
> reference held for reading.  Consequently, if any device sysfs
> attribute that may be removed from within acpi_scan_hot_remove()
> through acpi_bus_trim() has a .store() or .show() callback which
> acquires either acpi_scan_lock or device_hotplug_lock, the execution
> of that callback may deadlock with the removal of the attribute.
> [Unfortunately, the "online" device attribute of CPUs and memory
> blocks and the "eject" attribute of ACPI device objects are affected
> by this issue.]
> 
> To avoid those deadlocks introduce a new protection mechanism that
> can be used by the device sysfs attributes in question.  Namely,
> if a device sysfs attribute's .store() or .show() callback routine
> is about to acquire device_hotplug_lock or acpi_scan_lock, it can
> first execute read_lock_device_remove() and return an error code if
> that function returns false.  If true is returned, the lock in
> question may be acquired and read_unlock_device_remove() must be
> called.  [This mechanism is implemented by means of an additional
> rwsem in drivers/base/core.c.]
> 
> Make the affected sysfs attributes in the driver core and ACPI core
> use read_lock_device_remove() and read_unlock_device_remove() as
> described above.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
