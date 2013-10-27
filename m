Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3J0VNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:13:32 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:36647 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3J0VNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxuVpDo3LvmG9j-Hu7sENLTcsB6_CY2TA4mE-k+CuTeGg@mail.gmail.com>
References: <525BD08C.2080101@t-online.de>
	<CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
	<CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
	<alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
	<CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
	<CA+55aFyb72qoZ1Tjpb+=q-6+GmwoOXjfntY_zZnf300gg3d1Hg@mail.gmail.com>
	<CA+55aFxuVpDo3LvmG9j-Hu7sENLTcsB6_CY2TA4mE-k+CuTeGg@mail.gmail.com>
Date: Sun, 27 Oct 2013 21:13:29 +0000
X-Google-Sender-Auth: vi_yR2Dt2YdpRFt0WxnSdFCBX0Y
Message-ID: <CA+55aFz9ewd7VhCKDxJUzY4PGH7E3N-xMr=pDGQxf1PyNd1W1w@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. and one more case of freeing a delayed work object (likely a kobject again):

This time it looks like it's in the PCI layer, freeing the msi irq information.

It looks like that code simply does

    kobject_del(&entry->kobj);
    kobject_put(&entry->kobj);
    list_del(&entry->list);
    kfree(entry);

and the problem is that the "entry->kobj" may have *other* references
to it, thanks to people accessing it through /sys, so despite doing a
kojbect_del/kobject_put(), it's not at all ok to then do a "kfree()"
on it. The embedded kobj might still be in use.

Afaik, that code should do the kfree() on the kobject in the _release_
method, not synchronously like that.

We already have a msi_kobj_release(), I'm wondering why that doesn't
do the kfree().

Bjorn? Yinghai? Greg, comments about that msi kobj usage?

            Linus

---

  [ 2373.142964] mei_me 0000:00:16.0: stop
  [ 2373.143023] kobject: 'pn544' (ffff88011808f810): kobject_release,
parent           (null) (delayed)
  [ 2373.143076] kobject: '59' (ffff8800d268f648): kobject_release,
parent           (null) (delayed)
  [ 2373.143080] ------------[ cut here ]------------
  [ 2373.143087] WARNING: CPU: 3 PID: 2922 at lib/debugobjects.c:260
debug_print_object+0x83/0xa0()
  [ 2373.143094] ODEBUG: free active (active state 0) object type:
timer_list hint: delayed_work_timer_fn+0x0/0x20
  [ 2373.143096] Modules linked in: fuse ipt_MASQUERADE ip6t_REJECT
xt_conntrack bnep bluetooth ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6ta$
  [ 2373.143159] CPU: 3 PID: 2922 Comm: rmmod Tainted: G        W
3.12.0-rc6-00331-ga2ff82065b5b #2
  [ 2373.143162] Hardware name: Sony Corporation SVP11213CXB/VAIO,
BIOS R0270V7 05/17/2013
  [ 2373.143164]  0000000000000009 ffff8800b74b5c20 ffffffff8160d4a2
ffff8800b74b5c68
  [ 2373.143170]  ffff8800b74b5c58 ffffffff810514e8 ffff8800b74a4f00
ffffffff81c365e0
  [ 2373.143174]  ffffffff819f9133 ffffffff81f4c1b0 0000000000000001
ffff8800b74b5cb8
  [ 2373.143179] Call Trace:
  [ 2373.143189]  [<ffffffff8160d4a2>] dump_stack+0x45/0x56
  [ 2373.143195]  [<ffffffff810514e8>] warn_slowpath_common+0x78/0xa0
  [ 2373.143200]  [<ffffffff81051557>] warn_slowpath_fmt+0x47/0x50
  [ 2373.143204]  [<ffffffff812f8883>] debug_print_object+0x83/0xa0
  [ 2373.143209]  [<ffffffff8106aa90>] ? execute_in_process_context+0x90/0x90
  [ 2373.143214]  [<ffffffff812f99fb>] debug_check_no_obj_freed+0x20b/0x250
  [ 2373.143219]  [<ffffffff8132d213>] ? free_msi_irqs+0x103/0x150
  [ 2373.143224]  [<ffffffff8115db59>] kfree+0x89/0x160
  [ 2373.143227]  [<ffffffff8132d213>] free_msi_irqs+0x103/0x150
  [ 2373.143232]  [<ffffffff8132dc8d>] pci_disable_msi+0x3d/0x60
  [ 2373.143241]  [<ffffffffa01d2211>] mei_me_remove+0x61/0xb0 [mei_me]
  [ 2373.143248]  [<ffffffff81317796>] pci_device_remove+0x36/0xb0
  [ 2373.143254]  [<ffffffff813c6bea>] __device_release_driver+0x7a/0xe0
  [ 2373.143260]  [<ffffffff813c7568>] driver_detach+0xc8/0xd0
  [ 2373.143266]  [<ffffffff813c6816>] bus_remove_driver+0x96/0x120
  [ 2373.143273]  [<ffffffff813c7b77>] driver_unregister+0x27/0x50
  [ 2373.143278]  [<ffffffff813167ec>] pci_unregister_driver+0x1c/0x90
  [ 2373.143286]  [<ffffffffa01d3098>] mei_me_driver_exit+0x10/0xf78 [mei_me]
  [ 2373.143291]  [<ffffffff810b857d>] SyS_delete_module+0x15d/0x2c0
  [ 2373.143299]  [<ffffffff81002929>] ? do_notify_resume+0x59/0x90
  [ 2373.143305]  [<ffffffff8161b9a2>] system_call_fastpath+0x16/0x1b
  [ 2373.143308] ---[ end trace 25f53c192da70827 ]---
  [ 2373.143313] kobject: 'msi_irqs' (ffff880037327a18):
kobject_release, parent ffff880119bb40a8 (delayed)
  [ 2373.143458] kobject: 'misc' (ffff8800d6487500): kobject_release,
parent ffff880119bb40a8 (delayed)
  [ 2373.143463] kobject: 'mei' (ffff8800d35f3410): kobject_release,
parent           (null) (delayed)
  [ 2373.143607] kobject: 'mei_me' (ffff88003717ce00):
kobject_release, parent ffff8801194b2818 (delayed)
  [ 2373.143670] kobject: 'drivers' (ffff8800d6487600):
kobject_release, parent ffffffffa01d5330 (delayed)
  [ 2373.143678] kobject: 'holders' (ffff8800d6714700):
kobject_release, parent ffffffffa01d5330 (delayed)
  [ 2373.143682] kobject: 'notes' (ffff8800d6714600): kobject_release,
parent ffffffffa01d5330 (delayed)
