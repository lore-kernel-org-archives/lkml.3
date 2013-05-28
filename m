Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab3E1Xqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:46:32 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:43581 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab3E1Xqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <4790010.08sMRz00G6@vostro.rjw.lan>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com>
	<4790010.08sMRz00G6@vostro.rjw.lan>
Date: Tue, 28 May 2013 16:46:30 -0700
X-Google-Sender-Auth: ZR07r82VnO06AX-1QwtPiPgPja0
Message-ID: <CAE9FiQUUQ8Nbw7y5yZYy=LnS6xMD64pO3UBiz+44LvsCPxD56A@mail.gmail.com>
Subject: Re: System slow down from udev
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 4:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, May 28, 2013 04:39:37 PM Yinghai Lu wrote:
>> Raphael:
>>
>> Found one commit in your linus-pm cause user space very slow...
>> at least from udev start...
>
> I obviously can't reproduce it, so it would be great if you could give me
> more details.
>
> Is there anything unusual about your test system?

they are normal nehalem ex, westmere ex and ivybridge ex 8 sockets system.

>
> Thanks,
> Rafael
>
>
>> bisect to
>>
>> ac212b6980d8d5eda705864fc5a8ecddc6d6eacc is the first bad commit
>> commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Date:   Fri May 3 00:26:22 2013 +0200
>>
>>     ACPI / processor: Use common hotplug infrastructure
>>
>>     Split the ACPI processor driver into two parts, one that is
>>     non-modular, resides in the ACPI core and handles the enumeration
>>     and hotplug of processors and one that implements the rest of the
>>     existing processor driver functionality.
>>
>>     The non-modular part uses an ACPI scan handler object to enumerate
>>     processors on the basis of information provided by the ACPI namespace
>>     and to hook up with the common ACPI hotplug infrastructure.  It also
>>     populates the ACPI handle of each processor device having a
>>     corresponding object in the ACPI namespace, which allows the driver
>>     proper to bind to those devices, and makes the driver bind to them
>>     if it is readily available (i.e. loaded) when the scan handler's
>>     .attach() routine is running.
>>
>>     There are a few reasons to make this change.
>>
>>     First, switching the ACPI processor driver to using the common ACPI
>>     hotplug infrastructure reduces code duplication and size considerably,
>>     even though a new file is created along with a header comment etc.
>>
>>     Second, since the common hotplug code attempts to offline devices
>>     before starting the (non-reversible) removal procedure, it will abort
>>     (and possibly roll back) hot-remove operations involving processors
>>     if cpu_down() returns an error code for one of them instead of
>>     continuing them blindly (if /sys/firmware/acpi/hotplug/force_remove
>>     is unset).  That is a more desirable behavior than what the current
>>     code does.
>>
>>     Finally, the separation of the scan/hotplug part from the driver
>>     proper makes it possible to simplify the driver's .remove() routine,
>>     because it doesn't need to worry about the possible cleanup related
>>     to processor removal any more (the scan/hotplug part is responsible
>>     for that now) and can handle device removal and driver removal
>>     symmetricaly (i.e. as appropriate).
>>
>>     Some user-visible changes in sysfs are made (for example, the
>>     'sysdev' link from the ACPI device node to the processor device's
>>     directory is gone and a 'physical_node' link is present instead
>>     and a corresponding 'firmware_node' is present in the processor
>>     device's directory, the processor driver is now visible under
>>     /sys/bus/cpu/drivers/ and bound to the processor device), but
>>     that shouldn't affect the functionality that users care about
>>     (frequency scaling, C-states and thermal management).
>>
>>     Tested on my venerable Toshiba Portege R500.
>>
>>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>     Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>     Reviewed-by: Toshi Kani <toshi.kani@hp.com>
>>
>> :040000 040000 24925fd62fd97295be145d62f8d849004eeca284
>> 30c7f7f9ff26f17eaabf1770eb7d0b69c2767ba8 M    drivers
>> :040000 040000 8374b2dcd64a21abc1f65d3c7779ffa71adb01ba
>> 9375e83719e970b6f4b9a61fe6080bd638dfc51c M    include
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
