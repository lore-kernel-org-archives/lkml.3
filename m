Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3LAAwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 19:52:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53949 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751239Ab3LAAwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 19:52:43 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/12] PCI: Destroy pci dev only once
Date: Sun, 01 Dec 2013 02:05:35 +0100
Message-ID: <2691826.V0kc3nrim3@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385851238-21085-5-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org> <1385851238-21085-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 30, 2013 02:40:30 PM Yinghai Lu wrote:
> Mutliple removing via /sys will call pci_destroy_dev two times.
> 
> | When concurent removing pci devices which are in the same pci subtree
> | via sysfs, such as:
> | echo -n 1 > /sys/bus/pci/devices/0000\:10\:00.0/remove ; echo -n 1 >
> | /sys/bus/pci/devices/0000\:1a\:01.0/remove
> | (1a:01.0 device is downstream from the 10:00.0 bridge)
> |
> | the following warning will show:
> | [ 1799.280918] ------------[ cut here ]------------
> | [ 1799.336199] WARNING: CPU: 7 PID: 126 at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
> | [ 1799.433093] list_del corruption, ffff8807b4a7c000->next is LIST_POISON1 (dead000000100100)
> | [ 1800.276623] CPU: 7 PID: 126 Comm: kworker/u512:1 Tainted: G        W    3.12.0-rc5+ #196
> | [ 1800.508918] Workqueue: sysfsd sysfs_schedule_callback_work
> | [ 1800.574703]  0000000000000009 ffff8807adbadbd8 ffffffff8168b26c ffff8807c27d08a8
> | [ 1800.663860]  ffff8807adbadc28 ffff8807adbadc18 ffffffff810711dc ffff8807adbadc68
> | [ 1800.753130]  ffff8807b4a7c000 ffff8807b4a7c000 ffff8807ad089c00 0000000000000000
> | [ 1800.842282] Call Trace:
> | [ 1800.871651]  [<ffffffff8168b26c>] dump_stack+0x55/0x76
> | [ 1800.933301]  [<ffffffff810711dc>] warn_slowpath_common+0x8c/0xc0
> | [ 1801.005283]  [<ffffffff810712c6>] warn_slowpath_fmt+0x46/0x50
> | [ 1801.074081]  [<ffffffff8135a343>] __list_del_entry+0x63/0xd0
> | [ 1801.141839]  [<ffffffff8135a3c1>] list_del+0x11/0x40
> | [ 1801.201320]  [<ffffffff813734da>] pci_remove_bus_device+0x6a/0xe0
> | [ 1801.274279]  [<ffffffff8137356e>] pci_stop_and_remove_bus_device+0x1e/0x30
> | [ 1801.356606]  [<ffffffff8137b20b>] remove_callback+0x2b/0x40
> | [ 1801.423412]  [<ffffffff81251848>] sysfs_schedule_callback_work+0x18/0x60
> | [ 1801.503744]  [<ffffffff8108eab5>] process_one_work+0x1f5/0x540
> | [ 1801.573640]  [<ffffffff8108ea53>] ? process_one_work+0x193/0x540
> | [ 1801.645616]  [<ffffffff8108f2ac>] worker_thread+0x11c/0x370
> | [ 1801.712337]  [<ffffffff8108f190>] ? rescuer_thread+0x350/0x350
> | [ 1801.782178]  [<ffffffff8109731d>] kthread+0xed/0x100
> | [ 1801.841661]  [<ffffffff81097230>] ? kthread_create_on_node+0x160/0x160
> | [ 1801.919919]  [<ffffffff8169cc3c>] ret_from_fork+0x7c/0xb0
> | [ 1801.984608]  [<ffffffff81097230>] ? kthread_create_on_node+0x160/0x160
> | [ 1802.062825] ---[ end trace d77f2054de000fb7 ]---
> |
> | This issue is related to the bug 54411:
> | https://bugzilla.kernel.org/show_bug.cgi?id=54411
> 
> Add is_removed to record if pci_destroy_dev is called already.
> 
> During second calling, still have extra dev ref hold via
> device_schedule_call, so we are safe to check dev->is_removed.
> 
> It fixes the problem In Gu's test.
> 
> -v2: add partial changelog from Gu Zheng <guz.fnst@cn.fujitsu.com>
>      refresh after patch of moving device_del from Rafael.
> -v3: use atomic operations to prevent racing that Rafael and Bjorn concern.

And this is not enough as I said, can you please stop ignoring me openly?

You've already commented the last patch I posted, so why don't we finish
that discussion first?

Rafael

