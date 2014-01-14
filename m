Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaANXJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:09:08 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54831 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751918AbaANXIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:08:36 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/3] PM: Mechanism to avoid resuming runtime-suspended devices during system suspend
Date: Wed, 15 Jan 2014 00:12:29 +0100
Message-ID: <5420830.W4laSGaAU9@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following experimental series of 3 patches implements a mechanism allowing
subsystems to avoid resuming runtime-suspended devices during system suspend.

As far as the PM core goes, it introduces a new flag, power.no_suspend, that
will be set by the core for devices which can stay suspended.  The idea is that
subsystems should know which devices can stay suspended over system suspend
and to allow them to tell the core about that patch [1/3] changes the calling
convention of the device PM .prepare() callback so that it can return a positive
value on success to be interpreted as "this device has been runtime-suspended
and doesn't need to be resumed" information.  If .prepare() returns a positive
number for certain device, the core will set power.no_suspend and will not run
suspend callbacks for device with that flag set going forward (during this
particular system suspend transition).

However, parents may generally need to be resumed so that the suspend of their
children can be carried out, so the PM core will clear power.no_suspend for
the parents of devices whose power.no_suspend is not set (unless those parents
have power.ignore_children set).

Patch [2/3] adds a new runtime PM helper function that subsystems can use to
check whether or not a given device is runtime-suspended when .prepare() is being
executed for it.

Patch [3/3] implements the subsystem part for the ACPI PM domain, because that
is relatively straightforward.  If the general approach makes sense, I'll think
about doing the same for PCI.

Comments welcome!

Thanks,
Rafael

