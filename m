Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3FNN4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:56:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37336 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab3FNN4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:56:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Subject: Re: [BUGFIX 2/9] ACPIPHP: fix device destroying order issue when handling dock notification
Date: Fri, 14 Jun 2013 16:05:48 +0200
Message-ID: <3541509.09EeuLnmd2@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51BB2075.5040600@gmail.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <2448481.HbOiE9Npmq@vostro.rjw.lan> <51BB2075.5040600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 09:53:57 PM Jiang Liu wrote:
> On 06/14/2013 03:59 AM, Rafael J. Wysocki wrote:
> > On Friday, June 14, 2013 12:32:25 AM Jiang Liu wrote:
> >> Current ACPI glue logic expects that physical devices are destroyed
> >> before destroying companion ACPI devices, otherwise it will break the
> >> ACPI unbind logic and cause following warning messages:
> >> [  185.026073] usb usb5: Oops, 'acpi_handle' corrupt
> >> [  185.035150] pci 0000:1b:00.0: Oops, 'acpi_handle' corrupt
> >> [  185.035515] pci 0000:18:02.0: Oops, 'acpi_handle' corrupt
> >> [  180.013656]  port1: Oops, 'acpi_handle' corrupt
> >> Please refer to https://bugzilla.kernel.org/attachment.cgi?id=104321
> >> for full log message.
> > 
> > So my question is, did we have this problem before commit 3b63aaa70e1?
> > 
> > If we did, then when did it start?  Or was it present forever?
> I think this issue should exist before commit "PCI: acpiphp: Do not use
> ACPI PCI subdriver mechanism". It may trace back to the changes to kill
> acpi_pci_bind()/acpi_pci_unbind().

I thought so.

> >> Above warning messages are caused by following scenario:
> >> 1) acpi_dock_notifier_call() queues a task (T1) onto kacpi_hotplug_wq
> >> 2) kacpi_hotplug_wq handles T1, which invokes acpi_dock_deferred_cb()
> >>    ->dock_notify()-> handle_eject_request()->hotplug_dock_devices()
> >> 3) hotplug_dock_devices() first invokes registered hotplug callbacks to
> >>    destroy physical devices, then destroys all affected ACPI devices.
> >>    Everything seems perfect until now. But the acpiphp dock notification
> >>    handler will queue another task (T2) onto kacpi_hotplug_wq to really
> >>    destroy affected physical devices.
> > 
> > Would not the solution be to modify it so that it didn't spawn the other
> > task (T2), but removed the affected physical devices synchronously?
> Yes, that's the way I'm going to fix this issue.
> 
> > 
> >> 4) kacpi_hotplug_wq finishes T1, and all affected ACPI devices have
> >>    been destroyed.
> >> 5) kacpi_hotplug_wq handles T2, which destroys all affected physical
> >>    devices.
> >>
> >> So it breaks ACPI glue logic's expection because ACPI devices are destroyed
> >> in step 3 and physical devices are destroyed in step 5.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >> Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: Yinghai Lu <yinghai@kernel.org>
> >> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >> Cc: linux-pci@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: stable@vger.kernel.org
> >> ---
> >> Hi Bjorn and Rafael,
> >>      The recursive lock changes haven't been tested yet, need help
> >> from Alexander for testing.
> > 
> > Well, let's just say I'm not a fan of recursive locks.  Is that unavoidable
> > here?
> Yeah, you are right, we encounter other deadlock issue here, as reported
> by Alexander. So need to find new solution here.

Can you please have a look at the patch I posted earlier in this thread?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
