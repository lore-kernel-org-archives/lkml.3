Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3L2D6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:58:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3L2D6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 22:58:45 -0500
Date: Sat, 28 Dec 2013 19:59:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH][tentative] PCI / ACPI: Rework PCI host bridge removal to
 avoid sysfs warnings
Message-ID: <20131229035925.GC26111@kroah.com>
References: <37552283.kG1L4S8Daa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37552283.kG1L4S8Daa@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 12:20:22AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The device_del(&host_bridge->dev) in pci_stop_root_bus() is
> problematic, because it causes all sysfs directories below
> the host bridge to be removed recursively and when
> pci_remove_root_bus() attempts to remove devices on the root
> bus (whose sysfs directories are gone now along with all their
> subdirectories), it causes warnings similar to this one to be
> printed:
> 
> WARNING: CPU: 0 PID: 6 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
> sysfs group ffffffff819ac5c0 not found for kobject '0001:ff:10.2'
> Modules linked in: <irrelevant list>
> CPU: 0 PID: 6 Comm: kworker/u512:0 Tainted: G        W    3.13.0-rc5+ #11
> Hardware name:
> Workqueue: kacpi_hotplug acpi_hotplug_work_fn
>  0000000000000009 ffff8808738d3bd8 ffffffff815d84ea ffff8808738d3c20
>  ffff8808738d3c10 ffffffff8106594d 0000000000000000 ffffffff819ac5c0
>  ffff880871b9d0a8 ffff8a07d1895000 0000000000000103 ffff8808738d3c70
> Call Trace:
>  [<ffffffff815d84ea>] dump_stack+0x45/0x56
>  [<ffffffff8106594d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff810659bc>] warn_slowpath_fmt+0x4c/0x50
>  [<ffffffff8122b52e>] ? sysfs_get_dirent_ns+0x4e/0x70
>  [<ffffffff8122c806>] sysfs_remove_group+0xc6/0xd0
>  [<ffffffff813b83f3>] dpm_sysfs_remove+0x43/0x50
>  [<ffffffff813ae105>] device_del+0x45/0x1c0
>  [<ffffffff812e51f6>] pci_remove_bus_device+0x66/0xd0
>  [<ffffffff812e5363>] pci_remove_root_bus+0x73/0x80
>  [<ffffffff813276ab>] acpi_pci_root_remove+0x42/0x4f
>  [<ffffffff81323070>] acpi_bus_trim+0x56/0x89
>  [<ffffffff81323052>] acpi_bus_trim+0x38/0x89
>  [<ffffffff813245df>] acpi_device_hotplug+0x137/0x33b
>  [<ffffffff8131efba>] acpi_hotplug_work_fn+0x1c/0x27
>  [<ffffffff81080f1b>] process_one_work+0x17b/0x460
>  [<ffffffff81081ccb>] worker_thread+0x11b/0x400
>  [<ffffffff81081bb0>] ? rescuer_thread+0x3e0/0x3e0
>  [<ffffffff81088a12>] kthread+0xd2/0xf0
>  [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
>  [<ffffffff815e823c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
> 
> To avoid that, the host bridge device has to be deleted after all of
> its children, so merge pci_stop_root_bus() and pci_remove_root_bus()
> into one function, pci_stop_and_remove_root_bus(), that first will
> use pci_stop_and_remove_bus_device() to stop and remove all devices
> on the root bus and then will delete the host bridge device, remove
> its bus and drop the final reference to it.
> 
> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Hi,
> 
> I can't really test this patch, but I don't know how it can break anything.
> 
> The only user of pci_stop_root_bus() and pci_remove_root_bus() is
> acpi_pci_root_remove() and the code ordering there seems to be somewhat
> arbitrary.  If you are aware of any reason why it may not work, please let
> me know. :-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
