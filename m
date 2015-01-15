Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbbAOJWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:22:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53186 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750997AbbAOJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:22:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [RFC][PATCH] PCI / PM: Avoid resuming PCI devices during system suspend
Date: Thu, 15 Jan 2015 10:45:05 +0100
Message-ID: <2648963.rfs1ehcxce@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1501121134480.1707-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1501121134480.1707-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2015 11:39:18 AM Alan Stern wrote:
> On Mon, 12 Jan 2015, Rafael J. Wysocki wrote:
> 
> > On Thursday, January 08, 2015 10:51:06 AM Alan Stern wrote:
> > > On Thu, 8 Jan 2015, Rafael J. Wysocki wrote:
> > > 
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Commit f25c0ae2b4c4 (ACPI / PM: Avoid resuming devices in ACPI PM
> > > > domain during system suspend) modified the ACPI PM domain's system
> > > > suspend callbacks to allow devices attached to it to be left in the
> > > > runtime-suspended state during system suspend so as to optimize
> > > > the suspend process.
> > > > 
> > > > This was based on the general mechanism introduced by commit
> > > > aae4518b3124 (PM / sleep: Mechanism to avoid resuming runtime-suspended
> > > > devices unnecessarily).
> > > > 
> > > > Extend that approach to PCI devices by modifying the PCI bus type's
> > > > ->prepare callback to return 1 for devices that are runtime-suspended
> > > > when it is being executed and that are in a suitable power state and
> > > > need not be resumed going forward.
> > > 
> > > Does this correctly handle PCI devices that aren't included in the ACPI
> > > tables?  For example, add-on PCI cards?
> > 
> > Well, it would if it took the case when a device was configured for remote
> > wakeup at run time but was not supposed to wakeup the system from sleep into
> > account.
> > 
> > That needs to be checked in pci_dev_keep_suspended() rather than in the platform
> > callback to cover all devices.
> > 
> > Updated patch follows.
> > 
> > Rafael
> 
> This looks better, thank you.

Well, it still has the problem that the current ACPI wakeup setting may not be
suitable depending on the PM_QOS_FLAG_REMOTE_WAKEUP value which I overlooked
before.

I need to restore the check against adev->wakeup.prepare_count in
acpi_pci_need_resume() to cover that I think.

Will post a v2 with that fixed.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
