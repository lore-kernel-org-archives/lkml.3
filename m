Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3KZUNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:13:53 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49682 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3KZUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:13:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQW0_0Mi1WLk2o0phdG22LC6imeO62LG7Jsn7D7e0e_Vhg@mail.gmail.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<1385429290-25397-5-git-send-email-yinghai@kernel.org>
	<CAErSpo7umvs=U1_X--Vxx29hf6+pnm8KQ0bUKG4FZkNS+ffR8Q@mail.gmail.com>
	<CAE9FiQW0_0Mi1WLk2o0phdG22LC6imeO62LG7Jsn7D7e0e_Vhg@mail.gmail.com>
Date: Tue, 26 Nov 2013 12:13:50 -0800
X-Google-Sender-Auth: l4qsAmJhaQ3C4xi4sKZ8sj1oMbQ
Message-ID: <CAE9FiQVMQvLFnkoBRSv35f97mfYuSxwsct-Mv5-Hd4s-1QWW3Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:34 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Nov 25, 2013 at 7:38 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Mon, Nov 25, 2013 at 6:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Mutliple removing via /sys will call pci_destroy_dev two times.
>>>
>>> | When concurent removing pci devices which are in the same pci subtree
>>> | via sysfs, such as:
>>> | echo -n 1 > /sys/bus/pci/devices/0000\:10\:00.0/remove ; echo -n 1 >
>>> | /sys/bus/pci/devices/0000\:1a\:01.0/remove
>>> | (1a:01.0 device is downstream from the 10:00.0 bridge)
>>> |
>>> | the following warning will show:
>>> | [ 1799.280918] ------------[ cut here ]------------
>>> | [ 1799.336199] WARNING: CPU: 7 PID: 126 at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
>>> | [ 1799.433093] list_del corruption, ffff8807b4a7c000->next is LIST_POISON1 (dead000000100100)
>>> | [ 1800.276623] CPU: 7 PID: 126 Comm: kworker/u512:1 Tainted: G        W    3.12.0-rc5+ #196
>>> | [ 1800.508918] Workqueue: sysfsd sysfs_schedule_callback_work
>>> | [ 1800.574703]  0000000000000009 ffff8807adbadbd8 ffffffff8168b26c ffff8807c27d08a8
>>> | [ 1800.663860]  ffff8807adbadc28 ffff8807adbadc18 ffffffff810711dc ffff8807adbadc68
>>> | [ 1800.753130]  ffff8807b4a7c000 ffff8807b4a7c000 ffff8807ad089c00 0000000000000000
>>> | [ 1800.842282] Call Trace:
>>> | [ 1800.871651]  [<ffffffff8168b26c>] dump_stack+0x55/0x76
>>> | [ 1800.933301]  [<ffffffff810711dc>] warn_slowpath_common+0x8c/0xc0
>>> | [ 1801.005283]  [<ffffffff810712c6>] warn_slowpath_fmt+0x46/0x50
>>> | [ 1801.074081]  [<ffffffff8135a343>] __list_del_entry+0x63/0xd0
>>> | [ 1801.141839]  [<ffffffff8135a3c1>] list_del+0x11/0x40
>>> | [ 1801.201320]  [<ffffffff813734da>] pci_remove_bus_device+0x6a/0xe0
>>> | [ 1801.274279]  [<ffffffff8137356e>] pci_stop_and_remove_bus_device+0x1e/0x30
>>> | [ 1801.356606]  [<ffffffff8137b20b>] remove_callback+0x2b/0x40
>>> | [ 1801.423412]  [<ffffffff81251848>] sysfs_schedule_callback_work+0x18/0x60
>>> | [ 1801.503744]  [<ffffffff8108eab5>] process_one_work+0x1f5/0x540
>>> | [ 1801.573640]  [<ffffffff8108ea53>] ? process_one_work+0x193/0x540
>>> | [ 1801.645616]  [<ffffffff8108f2ac>] worker_thread+0x11c/0x370
>>> | [ 1801.712337]  [<ffffffff8108f190>] ? rescuer_thread+0x350/0x350
>>> | [ 1801.782178]  [<ffffffff8109731d>] kthread+0xed/0x100
>>> | [ 1801.841661]  [<ffffffff81097230>] ? kthread_create_on_node+0x160/0x160
>>> | [ 1801.919919]  [<ffffffff8169cc3c>] ret_from_fork+0x7c/0xb0
>>> | [ 1801.984608]  [<ffffffff81097230>] ? kthread_create_on_node+0x160/0x160
>>> | [ 1802.062825] ---[ end trace d77f2054de000fb7 ]---
>>> |
>>> | This issue is related to the bug 54411:
>>> | https://bugzilla.kernel.org/show_bug.cgi?id=54411
>>>
>>> Add is_removed to record if pci_destroy_dev is called already.
>>>
>>> During second calling, still have extra dev ref hold via
>>> device_schedule_call, so we are safe to check dev->is_removed.
>>>
>>> It fixs the problem In Gu's test.
>>>
>>> -v2: add partial changelog from Gu Zheng <guz.fnst@cn.fujitsu.com>
>>>      refresh after patch of moving device_del from Rafael.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> ---
>>>  drivers/pci/remove.c | 8 +++++---
>>>  include/linux/pci.h  | 1 +
>>>  2 files changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
>>> index f452148..b090cec 100644
>>> --- a/drivers/pci/remove.c
>>> +++ b/drivers/pci/remove.c
>>> @@ -20,9 +20,11 @@ static void pci_stop_dev(struct pci_dev *dev)
>>>
>>>  static void pci_destroy_dev(struct pci_dev *dev)
>>>  {
>>> -       device_del(&dev->dev);
>>> -
>>> -       put_device(&dev->dev);
>>> +       if (!dev->is_removed) {
>>> +               device_del(&dev->dev);
>>> +               dev->is_removed = 1;
>>
>> As Rafael pointed out, this looks like a race.  What prevents two
>> concurrent calls to pci_destroy_dev() from seeing "dev->is_removed ==
>> 0" and both calling device_del() on the same device?
>

hope you are happy with this one:

-v3: use atomic operations to prevent racing that Rafael and Bjorn concern.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/probe.c  |    2 ++
 drivers/pci/remove.c |    8 +++++---
 include/linux/pci.h  |    1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -20,9 +20,11 @@ static void pci_stop_dev(struct pci_dev

 static void pci_destroy_dev(struct pci_dev *dev)
 {
-    device_del(&dev->dev);
-
-    put_device(&dev->dev);
+    if (atomic_inc_and_test(&dev->removed_count)) {
+        device_del(&dev->dev);
+        put_device(&dev->dev);
+    } else
+        atomic_dec(&dev->removed_count);
 }

 void pci_remove_bus(struct pci_bus *bus)
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -316,6 +316,7 @@ struct pci_dev {
     struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and
memory regions + expansion ROMs */

     bool match_driver;        /* Skip attaching driver */
+    atomic_t    removed_count;    /* pci_destroy_dev is called */
     /* These fields are used by common fixups */
     unsigned int    transparent:1;    /* Subtractive decode PCI bridge */
     unsigned int    multifunction:1;/* Part of multi-function device */
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1398,6 +1398,8 @@ void pci_device_add(struct pci_dev *dev,
     dev->match_driver = false;
     ret = device_add(&dev->dev);
     WARN_ON(ret < 0);
+
+    atomic_set(&dev->removed_count, -1);
 }

 struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
