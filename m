Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaEMBMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:12:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58686 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752770AbaEMBL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:11:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [RFC][PATCH 0/3] PM / sleep: Avoid resuming runtime-suspended devices during system suspend
Date: Tue, 13 May 2014 03:02:05 +0200
Message-ID: <4649019.is79p6EySp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've discussed that at length here:

http://marc.info/?t=139950469000003&r=1&w=4

but I'm starting a new thread to refresh things a bit.

This is about adding a mechanism allowing us to avoid runtime-suspended
devices during system suspend.  The reason why it has to touch the PM core
is because that needs to be coordinated across the device hierarchy.

The idea is to add a new device PM flag and to modify the PM core as follows.

 - If ->prepare() returns a positive number for a device, that means "this
   device is runtime-suspended and you can leave it like that if you do the
   same for all of its descendants".

 - If that happens, the PM core sets the new flag for the device in
   question *if* the device is indeed runtime-suspended *and* *if*
   the transition is a suspend (and not hibernation, for example).
   Otherwise, it clears the flag for the device.  All of that happens in
   device_prepare().

 - In __device_suspend() the PM core clears the new flag for the device's
   parent if it is clear for the device to ensure that the flag will only
   be set for a device if it is also set for all of its descendants.

 - PM core skips ->suspend/late/noirq and ->resume/early/noirq for all devices
   having the flag set - so the flag can be called "direct_complete" as it
   causes the PM core to go directy for the ->complete() callback when set.

 - The ->complete() callback has to check direct_complete if ->prepare()
   returned a positive number previously and is responsible for further
   handling of the device.

That is introduced by patch [2/3].

To simplify things slightly it is helpful to move the invocation of
pm_runtime_barrier() from __device_suspend() to device_prepare(), but still
under pm_runtime_get_noresume() beforehand (patch [1/3]).

Patch [3/3] shows how this can be used by adding support for it to the ACPI
PM comain.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
