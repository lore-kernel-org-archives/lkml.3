Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab3H1SvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:51:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3H1SvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:51:17 -0400
Date: Wed, 28 Aug 2013 11:53:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] driver core / ACPI: Avoid device hot remove locking
 issues
Message-ID: <20130828185337.GA3471@kroah.com>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan>
 <1592448.YZbpON5n7n@vostro.rjw.lan>
 <26495758.n1zOCiG3iV@vostro.rjw.lan>
 <1454842.9oJVGeLlzB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454842.9oJVGeLlzB@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 03:48:11PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> device_hotplug_lock is held around the acpi_bus_trim() call in
> acpi_scan_hot_remove() which generally removes devices (it removes
> ACPI device objects at least, but it may also remove "physical"
> device objects through .detach() callbacks of ACPI scan handlers).
> Thus, potentially, device sysfs attributes are removed under that
> lock and to remove those attributes it is necessary to hold the
> s_active references of their directory entries for writing.
> 
> On the other hand, the execution of a .show() or .store() callback
> from a sysfs attribute is carried out with that attribute's s_active
> reference held for reading.  Consequently, if any device sysfs
> attribute that may be removed from within acpi_scan_hot_remove()
> through acpi_bus_trim() has a .store() or .show() callback which
> acquires device_hotplug_lock, the execution of that callback may
> deadlock with the removal of the attribute.  [Unfortunately, the
> "online" device attribute of CPUs and memory blocks is one of them.]
> 
> To avoid such deadlocks, make all of the sysfs attribute callbacks
> that need to lock device hotplug, for example store_online(), use
> a special function, lock_device_hotplug_sysfs(), to lock device
> hotplug and return the result of that function immediately if it is
> not zero.  This will cause the s_active reference of the directory
> entry in question to be released and the syscall to be restarted
> if device_hotplug_lock cannot be acquired.
> 
> [show_online() actually doesn't need to lock device hotplug, but
> it is useful to serialize it with respect to device_offline() and
> device_online() for the same device (in case user space attempts to
> run them concurrently) which can be done with the help of
> device_lock().]
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
