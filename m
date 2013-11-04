Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3KDNOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:14:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65029 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752018Ab3KDNOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:14:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 3/3] ACPI / hotplug: Merge device hot-removal routines
Date: Mon, 04 Nov 2013 14:26:18 +0100
Message-ID: <1495379.L9vZXsvTcv@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5913958.7oJcoqqQ9l@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <5913958.7oJcoqqQ9l@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 04, 2013 01:21:46 AM Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The only substantial difference between acpi_bus_device_eject() and
> acpi_bus_hot_remove_device() is the get_device() done by the former
> which is supposed to be done by callers of the latter.  However,
> at least one caller of acpi_bus_hot_remove_device(), which is
> handle_root_bridge_removal(), doesn't do that and generally it
> won't be necessary to do that at all if ACPI handles, rather than
> struct acpi_device objects, are passed between ACPI hotplug routines,
> because the correctness of those routines already depends on the
> persistence of ACPI handles (that may not be an entirely correct
> assumption in theory, but in practice it has been good enough for a
> long time).
> 
> For this reason, modify acpi_bus_device_eject() to take two
> arguments, an ACPI handle and event code, and make
> acpi_bus_hot_remove_device() call it internally.  Moreover, rework
> acpi_bus_hot_remove_device() so that it only takes one argument,
> an ACPI handle, and make acpi_scan_bus_device_check() queue up
> acpi_bus_hot_remove_device() instead of acpi_bus_device_eject()
> itself.  After these changes, handle_root_bridge_removal() may
> be replaced with async execution of acpi_bus_hot_remove_device()
> with the ACPI handle of the root passed to it as the argument.
> 
> However, since acpi_eject_store() also needs to execute
> acpi_bus_device_eject() asynchronously and it needs to pass a
> special event code, ACPI_OST_EC_OSPM_EJECT, to that function,
> introduce a separate wrapper around acpi_bus_device_eject(),
> acpi_eject_store_work(), that will be queued up by
> acpi_eject_store() instead of acpi_bus_hot_remove_device().
> This allows acpi_eject_store() to be simplified and it allows
> struct acpi_eject_event to be dropped entirely, as there's
> no more users of that structure.

Well, scratch this (and the follow-up), it didn't go in the right direction.

I'll send a new series shortly.

Rafael

