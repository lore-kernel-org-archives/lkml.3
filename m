Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3H1Svb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:51:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab3H1Sva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:51:30 -0400
Date: Wed, 28 Aug 2013 11:53:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] ACPI / hotplug: Remove containers synchronously
Message-ID: <20130828185350.GB3471@kroah.com>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan>
 <1592448.YZbpON5n7n@vostro.rjw.lan>
 <26495758.n1zOCiG3iV@vostro.rjw.lan>
 <1883675.1ifF1KoWz3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1883675.1ifF1KoWz3@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 03:51:41PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The current protocol for handling hot remove of containers is very
> fragile and causes acpi_eject_store() to acquire acpi_scan_lock
> which may deadlock with the removal of the device that it is called
> for (the reason is that device sysfs attributes cannot be removed
> while their callbacks are being executed and ACPI device objects
> are removed under acpi_scan_lock).
> 
> The problem is related to the fact that containers are handled by
> acpi_bus_device_eject() in a special way, which is to emit an
> offline uevent instead of just removing the container.  Then, user
> space is expected to handle that uevent and use the container's
> "eject" attribute to actually remove it.  That is fragile, because
> user space may fail to complete the ejection (for example, by not
> using the container's "eject" attribute at all) leaving the BIOS
> kind of in a limbo.  Moreover, if the eject event is not signaled
> for a container itself, but for its parent device object (or
> generally, for an ancestor above it in the ACPI namespace), the
> container will be removed straight away without doing that whole
> dance.
> 
> For this reason, modify acpi_bus_device_eject() to remove containers
> synchronously like any other objects (user space will get its uevent
> anyway in case it does some other things in response to it) and
> remove the eject_pending ACPI device flag that is not used any more.
> This way acpi_eject_store() doesn't have a reason to acquire
> acpi_scan_lock any more and one possible deadlock scenario goes
> away (plus the code is simplified a bit).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
