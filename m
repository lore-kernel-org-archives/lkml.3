Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3LMEnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 23:43:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51246 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751836Ab3LMEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 23:43:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [PATCH 7/10] ACPI / hotplug: Move container-specific code out of the core
Date: Fri, 13 Dec 2013 05:56:47 +0100
Message-ID: <4217831.DpCd0ng0jT@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52AA7760.20603@jp.fujitsu.com>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <81535269.SKoBMiGyoU@vostro.rjw.lan> <52AA7760.20603@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 13, 2013 11:56:32 AM Yasuaki Ishimatsu wrote:
> Hi Rafael,

Hi,

> Please share your more detailed idea. I started to implement the following
> idea. But the idea has one problem.
> 
> >>> The eject work flow can be:
> >>>     (1) an eject event occurs,
> >>>     (2) the container "physical" device fails offline in acpi_scan_hot_remove()
> >>>         emmitting, say, KOBJ_CHANGE for the "physical" device,
> >>>     (3) user space notices the KOBJ_CHANGE and does the cleanup as needed,
> >>>     (4) user space changes the "physical" container device flag controlling
> >>>         offline to 0,
> >>>     (5) user space uses the sysfs "eject" attribute of the ACPI container object
> >>>         to finally eject the container,
> >>>     (6) the offline in acpi_scan_hot_remove() is now successful, because the
> >>>         flag controlling it has been set to 0 in step (4),
> >>>     (7) the "physical" container device goes away before executing _EJ0,
> >>>     (8) the container is ejected.
> 
> I want to emit KOBJ_CHANGE before offlining devices on container device at (2).
> But acpi_scan_hot_remove() offlines devices on container device at first.
> So when offline container device, devices on container has been offlined.
> 
> Thus the idea cannot fulfill my necessary feature.

Well, in that case we need to treat containers in a special way at the ACPI
level.  Which is a bit unfortunate so to speak.

To that end I'd try to add a new flag to struct acpi_hotplug_profile, say
.verify_offline, such that if set, it would cause acpi_scan_hot_remove() to
check if all of the "physical" companions of the top-level device are offline
to start with, and if not, it would just emit KOBJ_CHANGE for the companions
that are not offline and bail out.

So the above algorithm would become:

(1) an eject event occurs,
(2) acpi_scan_hot_remove() checks the verify_offline flag in the target device's
    scan_handler structure,
(3) if set (it would always be set for containers), acpi_scan_hot_remove()
    checks the status of the target device's "physical" companions; if at least
    one of them is offline, KOBJ_CHANGE is emitted for that "physical" device,
    and acpi_scan_hot_remove() returns, [I guess we can just emit KOBJ_CHANGE
    for the first companion that is not offline at this point.]
(4) user space notices the KOBJ_CHANGE and does the cleanup as needed; in the
    process it carries out the offline operation for the container's "physical"
    companion (there's only one such companion for each container), [That
    operation for the container itself is trivial, but to succeed it requires
    all devices below the container to be taken offline in advance.]
(5) user space uses the sysfs "eject" attribute of the ACPI container object
    to finally eject the container,
(6) acpi_scan_hot_remove() is now successful, because the container's "physical"
    companion is now offline,
(7) the "physical" container device goes away before executing _EJ0,
(8) the container is ejected.

I think that should work for you.

Thanks,
Rafael

