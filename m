Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab3BMBz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 20:55:28 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:52840 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3BMBz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 20:55:27 -0500
MIME-Version: 1.0
In-Reply-To: <1837481.7dT8hTZ4MT@vostro.rjw.lan>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan>
Date: Tue, 12 Feb 2013 17:55:26 -0800
X-Google-Sender-Auth: _m1eOoL_Pj1FKnuXPl_WjaOSPuI
Message-ID: <CAE9FiQVR+0iXtYF4AcLZs5_SsOtUJp5dF5fpk0XZKTcVanoL6A@mail.gmail.com>
Subject: Re: [PATCH] ACPI / hotplug: Fix concurrency issues and memory leaks
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 4:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> This changeset is aimed at fixing a few different but related
> problems in the ACPI hotplug infrastructure.
>
> First of all, since notify handlers may be run in parallel with
> acpi_bus_scan(), acpi_bus_trim() and acpi_bus_hot_remove_device()
> and some of them are installed for ACPI handles that have no struct
> acpi_device objects attached (i.e. before those objects are created),
> those notify handlers have to take acpi_scan_lock to prevent races
> from taking place (e.g. a struct acpi_device is found to be present
> for the given ACPI handle, but right after that it is removed by
> acpi_bus_trim() running in parallel to the given notify handler).
> Moreover, since some of them call acpi_bus_scan() and
> acpi_bus_trim(), this leads to the conclusion that acpi_scan_lock
> should be acquired by the callers of these two funtions rather by
> these functions themselves.
>
> For these reasons, make all notify handlers that can handle device
> addition and eject events take acpi_scan_lock and remove the
> acpi_scan_lock locking from acpi_bus_scan() and acpi_bus_trim().
> Accordingly, update all of their users to make sure that they
> are always called under acpi_scan_lock.
>
> Furthermore, since eject operations are carried out asynchronously
> with respect to the notify events that trigger them, with the help
> of acpi_bus_hot_remove_device(), even if notify handlers take the
> ACPI scan lock, it still is possible that, for example,
> acpi_bus_trim() will run between acpi_bus_hot_remove_device() and
> the notify handler that scheduled its execution and that
> acpi_bus_trim() will remove the device node passed to
> acpi_bus_hot_remove_device() for ejection.  In that case, the struct
> acpi_device object obtained by acpi_bus_hot_remove_device() will be
> invalid and not-so-funny things will ensue.  To protect agaist that,
> make the users of acpi_bus_hot_remove_device() run get_device() on
> ACPI device node objects that are about to be passed to it and make
> acpi_bus_hot_remove_device() run put_device() on them and check if
> their ACPI handles are not NULL (make acpi_device_unregister() clear
> the device nodes' ACPI handles for that check to work).
>
> Finally, observe that acpi_os_hotplug_execute() actually can fail,
> in which case its caller ought to free memory allocated for the
> context object to prevent leaks from happening.  It also needs to
> run put_device() on the device node that it ran get_device() on
> previously in that case.  Modify the code accordingly.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>
