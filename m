Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3CMOxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:53:22 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:47371 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3CMOxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:53:21 -0400
Message-ID: <514092DC.5020500@openvz.org>
Date: Wed, 13 Mar 2013 18:53:16 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 3.9.0-rc1: kexec not working: root disk does not show up
References: <20130308171704.GE8219@redhat.com> <20130312192922.GA2268@redhat.com> <51402ED5.6000902@openvz.org> <20130313135351.GB11528@redhat.com>
In-Reply-To: <20130313135351.GB11528@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------050604030401020909000706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050604030401020909000706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Vivek Goyal wrote:
> On Wed, Mar 13, 2013 at 11:46:29AM +0400, Konstantin Khlebnikov wrote:
>
> [..]
>>> Ok, some more observation.
>>>
>>> - Problem seems to be in during shutdown path. Because older kernel 3.8
>>>    can kexec into newer kernel 3.9.rc1 but not vice-a-versa.
>>>
>>> I did git bisecting and following commit seems to be problem.
>>>
>>> commit 7897e6022761ace7377f0f784fca059da55f5d71
>>> Author: Konstantin Khlebnikov<khlebnikov@openvz.org>
>>> Date:   Mon Feb 4 15:55:58 2013 +0400
>>>
>>>      PCI: Disable Bus Master unconditionally in pci_device_shutdown()
>>>
>>>      Commit b566a22c23 ("PCI: disable Bus Master on PCI device shutdown")
>>>      used pci_disable_device(), but that doesn't disable Bus Mastering
>>>      unconditionally; we allow nested enable/disable calls, and only the
>>>      last disable call actually does anything.
>>>
>>>      This uses pci_clear_master() to unconditionally clear the Bus Master
>>>      bit.
>>>
>>>      Matthew Garrett and Alan Cox said (see LKML link below) that clearing
>>> Bus
>>>      Master for all PCI devices may lead to unpredictable consequences:
>>> some
>>>      devices ignores this bit and continue DMA, some of them hang after
>>> that or
>>>      crash the whole system.  But we're already trying to clear Bus Master
>>> in
>>>      general because of b566a22c23; this merely deals with the cases where
>>>      drivers haven't shut down the device correctly.
>>>
>>>      [bhelgaas: changelog]
>>>      Link: https://lkml.org/lkml/2012/6/6/278
>>>      Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>>>      Signed-off-by: Bjorn Helgaas<bhelgaas@google.com>
>>>      Acked-by: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
>>>
>>> I reverted above commit and things work again. Just that I get following
>>> warning during shutdown.
>>>
>>> [   54.252516] ------------[ cut here ]------------
>>> [   54.257199] WARNING: at drivers/pci/pci.c:1397
>>> pci_disable_device+0x90/0xa0()
>>> [   54.264387] Hardware name: HP xw6600 Workstation
>>> [   54.269061] Device pci
>>> disabling already-disabled device
>>> [   54.274341] Modules linked in: floppy
>>> [   54.278403] Pid: 5272, comm: kexec Not tainted 3.9.0-rc2+ #207
>>> [   54.284289] Call Trace:
>>> [   54.286801]  [<ffffffff8133c600>] ? pci_disable_device+0x60/0xa0
>>> [   54.292864]  [<ffffffff8103e49f>] warn_slowpath_common+0x7f/0xc0
>>> [   54.298926]  [<ffffffff8103e596>] warn_slowpath_fmt+0x46/0x50
>>> [   54.304727]  [<ffffffff8133c592>] ? do_pci_disable_device+0x52/0x60
>>> [   54.311050]  [<ffffffff8133c630>] pci_disable_device+0x90/0xa0
>>> [   54.316938]  [<ffffffff8133e1a4>] pci_device_shutdown+0x44/0x50
>>> [   54.322915]  [<ffffffff81462b2d>] device_shutdown+0x1d/0x180
>>> [   54.328631]  [<ffffffff81056ba6>] kernel_restart_prepare+0x36/0x50
>>> [   54.334866]  [<ffffffff810a16c0>] kernel_kexec+0x50/0x80
>>> [   54.340235]  [<ffffffff81056e35>] sys_reboot+0x1f5/0x260
>>> [   54.345604]  [<ffffffff811621b9>] ? mntput_no_expire+0x49/0x160
>>> [   54.351578]  [<ffffffff811622f6>] ? mntput+0x26/0x40
>>> [   54.356601]  [<ffffffff81144539>] ? __fput+0x1a9/0x280
>>> [   54.361798]  [<ffffffff8105fae4>] ? task_work_run+0xc4/0xe0
>>> [   54.367428]  [<ffffffff810029a5>] ? do_notify_resume+0x75/0x80
>>> [   54.373319]  [<ffffffff81882742>] system_call_fastpath+0x16/0x1b
>>> [   54.379382] ---[ end trace ea6ecbf97debf2e2 ]---
>>> [   54.385157] Starting new kernel
>>>
>>>
>>> I am leaving the logs from previous mail intact so that newly CCed
>>> people can have a look at it and don't go hunting for old mail in
>>> lkml archives.
>>>
>>> Thanks
>>> Vivek
>>>
>>
>> Look like I fixed one bug and added another.
>> After ->shutdown() device can be in D3-cold state and config space is unreachable.
>>
>> try this patch
>>
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -385,6 +385,12 @@ static void pci_device_shutdown(struct device *dev)
>>
>>          if (drv&&  drv->shutdown)
>>                  drv->shutdown(pci_dev);
>> +
>> +       if (pci_dev->current_state == PCI_D3cold) {
>> +               WARN_ON(pci_dev->msi_enabled || pci_dev->msix_enabled);
>> +               return;
>> +       }
>> +
>>          pci_msi_shutdown(pci_dev);
>>          pci_msix_shutdown(pci_dev);
>>
>>
>
> Hi,
>
> So this patch is supposed to fix the warning? This warning showed up
> only after reverting your patch. So do you agree that your original
> patch should be reverted?

Please see more accurate patch in attachment.

My patch for pci_device_shutdown() just uncovers another problem.
Also that warning actually also mine. =)

Or probably you found hardware where bus-master bit cannot be cleared.
Matthew Garrett and Alan Cox already warned us about such hardware.
(see your citation of my comment above)

My patch (which you want to revert) just fixes bug in potentially broken hack.
After that this hack actually starts working.

>
> I applied this patch and warning is still there (After reverting your
> original patch).
>
> I thought we would first address the issue of why kexec is not working
> with your patch.
>
> Thanks
> Vivek
>
> [   38.048452] tg3 0000:0e:00.0: System wakeup enabled by ACPI
> [   38.266774] sd 5:0:0:0: [sdd] Synchronizing SCSI cache
> [   38.272116] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
> [   38.277361] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
> [   38.282661] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   38.288467] ------------[ cut here ]------------
> [   38.293151] WARNING: at drivers/pci/pci.c:1397
> pci_disable_device+0x90/0xa0()
> [   38.300339] Hardware name: HP xw6600 Workstation
> [   38.305014] Device pci
> disabling already-disabled device
> [   38.310294] Modules linked in: floppy
> [   38.314356] Pid: 5258, comm: kexec Not tainted 3.9.0-rc2+ #209
> [   38.320243] Call Trace:
> [   38.322755]  [<ffffffff8133c600>] ? pci_disable_device+0x60/0xa0
> [   38.328818]  [<ffffffff8103e49f>] warn_slowpath_common+0x7f/0xc0
> [   38.334880]  [<ffffffff8103e596>] warn_slowpath_fmt+0x46/0x50
> [   38.340681]  [<ffffffff8133c592>] ? do_pci_disable_device+0x52/0x60
> [   38.347003]  [<ffffffff8133c630>] pci_disable_device+0x90/0xa0
> [   38.352892]  [<ffffffff8133f2d4>] pci_device_shutdown+0x54/0x80
> [   38.358868]  [<ffffffff81462b5d>] device_shutdown+0x1d/0x180
> [   38.364584]  [<ffffffff81056ba6>] kernel_restart_prepare+0x36/0x50
> [   38.370820]  [<ffffffff810a16c0>] kernel_kexec+0x50/0x80
> [   38.376188]  [<ffffffff81056e35>] sys_reboot+0x1f5/0x260
> [   38.381558]  [<ffffffff811621b9>] ? mntput_no_expire+0x49/0x160
> [   38.387532]  [<ffffffff811622f6>] ? mntput+0x26/0x40
> [   38.392555]  [<ffffffff81144539>] ? __fput+0x1a9/0x280
> [   38.397753]  [<ffffffff8187a0ee>] ? _raw_spin_unlock_irq+0xe/0x30
> [   38.403901]  [<ffffffff8105fae4>] ? task_work_run+0xc4/0xe0
> [   38.409531]  [<ffffffff810029a5>] ? do_notify_resume+0x75/0x80
> [   38.415420]  [<ffffffff81882742>] system_call_fastpath+0x16/0x1b
> [   38.421479] ---[ end trace 61d35d2d55ce5d3d ]---
> [   38.427241] Starting new kernel
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
>


--------------050604030401020909000706
Content-Type: text/plain;
 name="pci-fix-access-to-disconnected-devices-in-pci_device_shutdown"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="pci-fix-access-to-disconnected-devices-in-pci_device_shutdow";
 filename*1="n"

PCI: Don't try to disable Bus Master on disconnected PCI devices

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

This is fix for commit 7897e6022761ace7377f0f784fca059da55f5d71 from v3.9-rc1
("PCI: Disable Bus Master unconditionally in pci_device_shutdown()")
in turn that was fix for b566a22c23327f18ce941ffad0ca907e50a53d41 from v3.5-rc1
("PCI: disable Bus Master on PCI device shutdown")

Unfortunately fixing one bug uncovers another: after ->shutdown() device can be
already disconnected from the bus and configuration space in no longer available

Link: https://lkml.org/lkml/2013/3/12/529
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci-driver.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 1fa1e48..79277fb 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -390,9 +390,10 @@ static void pci_device_shutdown(struct device *dev)
 
 	/*
 	 * Turn off Bus Master bit on the device to tell it to not
-	 * continue to do DMA
+	 * continue to do DMA. Don't touch devices in D3cold or unknown states.
 	 */
-	pci_clear_master(pci_dev);
+	if (pci_dev->current_state <= PCI_D3hot)
+		pci_clear_master(pci_dev);
 }
 
 #ifdef CONFIG_PM

--------------050604030401020909000706--
