Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaG2SN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:13:58 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:50529 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaG2SN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:13:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ75kXYJL4jD=81NYPYpji9grJQkzMKdgLhRMA=YFstHzzZ0=A@mail.gmail.com>
References: <5386F2C7.8080400@redhat.com>
	<1524296.Cxrf5UDWlv@vostro.rjw.lan>
	<CAHTgTXXUcDNvPD0g82q1HFCy+EZZdF8hwyAzRu8cijs5dy9mBQ@mail.gmail.com>
	<CAHTgTXV8RtMwO0bKrc7LmfVcAQzkBra=RWQ6AGo7H8NsaxQx9A@mail.gmail.com>
	<CAHTgTXXB2rfYyLwBM9BF7pw6kTVnixXhKWweKKZtsH64drAhQw@mail.gmail.com>
	<CAJ75kXYJL4jD=81NYPYpji9grJQkzMKdgLhRMA=YFstHzzZ0=A@mail.gmail.com>
Date: Tue, 29 Jul 2014 11:13:55 -0700
Message-ID: <CAHTgTXV_kJ=bUOEQjbxM8+tZ+Df--xrZxH5bwkGFqffLd5h9LA@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 2623 at drivers/pnp/pnpacpi/core.c:96 pnpacpi_set_resource
From: Vinson Lee <vlee@twopensource.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 2:53 AM, William Dauchy <wdauchy@gmail.com> wrote:
> Hi Vinson,
>
> On Mon, Jul 28, 2014 at 9:11 PM, Vinson Lee <vlee@twopensource.com> wrote:
>> The warning first happens with 3.14-rc1. The warning does not occur with 3.13.0.
>
> Hitting the same issue here with a similar trace on 3.14.x. Did you
> start bisecting?
>
> Regards,
> --
> William


I bisected the warning that I'm seeing to this commit.

commit 202317a573b20d77a9abb7c16a3fd5b40cef3d9d
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Fri Nov 22 21:54:37 2013 +0100

    ACPI / scan: Add acpi_device objects for all device nodes in the namespace

    Modify the ACPI namespace scanning code to register a struct
    acpi_device object for every namespace node representing a device,
    processor and so on, even if the device represented by that namespace
    node is reported to be not present and not functional by _STA.

    There are multiple reasons to do that.  First of all, it avoids
    quite a lot of overhead when struct acpi_device objects are
    deleted every time acpi_bus_trim() is run and then added again
    by a subsequent acpi_bus_scan() for the same scope, although the
    namespace objects they correspond to stay in memory all the time
    (which always is the case on a vast majority of systems).

    Second, it will allow user space to see that there are namespace
    nodes representing devices that are not present at the moment and may
    be added to the system.  It will also allow user space to evaluate
    _SUN for those nodes to check what physical slots the "missing"
    devices may be put into and it will make sense to add a sysfs
    attribute for _STA evaluation after this change (that will be
    useful for thermal management on some systems).

    Next, it will help to consolidate the ACPI hotplug handling among
    subsystems by making it possible to store hotplug-related information
    in struct acpi_device objects in a standard common way.

    Finally, it will help to avoid a race condition related to the
    deletion of ACPI namespace nodes.  Namely, namespace nodes may be
    deleted as a result of a table unload triggered by _EJ0 or _DCK.
    If a hotplug notification for one of those nodes is triggered
    right before the deletion and it executes a hotplug callback
    via acpi_hotplug_execute(), the ACPI handle passed to that
    callback may be stale when the callback actually runs.  One way
    to work around that is to always pass struct acpi_device pointers
    to hotplug callbacks after doing a get_device() on the objects in
    question which eliminates the use-after-free possibility (the ACPI
    handles in those objects are invalidated by acpi_scan_drop_device(),
    so they will trigger ACPICA errors on attempts to use them).

    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
