Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3HVV6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:58:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3HVV6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:58:09 -0400
Date: Thu, 22 Aug 2013 14:58:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-next list <linux-next@vger.kernel.org>, rusty@rustcorp.com.au,
        LKML <linux-kernel@vger.kernel.org>, rmk+kernel@arm.linux.org.uk
Subject: Re: [RFC PATCH v2 next]module: Fix mod->mkobj.kobj potentially freed
 too early
Message-ID: <20130822215808.GA3355@kroah.com>
References: <1377078598.2709.25.camel@ThinkPad-T5421>
 <20130821161819.GA14364@kroah.com>
 <1377138846.2633.25.camel@ThinkPad-T5421>
 <20130822040333.GB4821@kroah.com>
 <1377157075.2633.63.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377157075.2633.63.camel@ThinkPad-T5421>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 03:37:55PM +0800, Li Zhong wrote:
> DEBUG_KOBJECT_RELEASE helps to find the issue attached below.
> 
> After some investigation, it seems the reason is:
> The mod->mkobj.kobj(ffffffffa01600d0 below) is freed together with mod
> itself by module_free(mod, mod->module_core) in free_module(). However,
> its children still hold references to it, as the delay caused by
> DEBUG_KOBJECT_RELEASE. So when the child('holders' below) tries to
> decrease the reference count to its parent in kobject_del(), BUG happens
> as it tries to access already freed memory.
> 
> v2: 
> Greg suggested to make the kobject as a pointer. But it seems a little
> hard to make kobj(kobject) embedded in mkobj(module_kobject) a pointer,
> as that seems to cause getting the mkobj from the kobj impossible --
> to_module_kobject() is used in several places to derive mkobj from its
> member kobj. 
> 
> So in this version, I made the whole mkobj(module_kobject) as a pointer
> in mod(module).

Thanks so much for doing this, it's the correct fix.  I've added my
signed-off-by below, Rusty, will you be taking this in your tree for
3.12?

> The mkobj is then allocated in mod_sysfs_init(), and freed in its member
> kobj's release function -- it seems that there is no mkobj usage after
> its kobj is released? 
> 
> [ 1844.175287] kobject: 'holders' (ffff88007c1f1600): kobject_release, parent ffffffffa01600d0 (delayed)
> [ 1844.178991] kobject: 'notes' (ffff8800370b2a00): kobject_release, parent ffffffffa01600d0 (delayed)
> [ 1845.180118] kobject: 'holders' (ffff88007c1f1600): kobject_cleanup, parent ffffffffa01600d0
> [ 1845.182130] kobject: 'holders' (ffff88007c1f1600): auto cleanup kobject_del
> [ 1845.184120] BUG: unable to handle kernel paging request at ffffffffa01601d0
> [ 1845.185026] IP: [<ffffffff812cda81>] kobject_put+0x11/0x60
> [ 1845.185026] PGD 1a13067 PUD 1a14063 PMD 7bd30067 PTE 0
> [ 1845.185026] Oops: 0000 [#1] PREEMPT 
> [ 1845.185026] Modules linked in: xfs libcrc32c [last unloaded: kprobe_example]
> [ 1845.185026] CPU: 0 PID: 18 Comm: kworker/0:1 Tainted: G           O 3.11.0-rc6-next-20130819+ #1
> [ 1845.185026] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [ 1845.185026] Workqueue: events kobject_delayed_cleanup
> [ 1845.185026] task: ffff88007ca51f00 ti: ffff88007ca5c000 task.ti: ffff88007ca5c000
> [ 1845.185026] RIP: 0010:[<ffffffff812cda81>]  [<ffffffff812cda81>] kobject_put+0x11/0x60
> [ 1845.185026] RSP: 0018:ffff88007ca5dd08  EFLAGS: 00010282
> [ 1845.185026] RAX: 0000000000002000 RBX: ffffffffa01600d0 RCX: ffffffff8177d638
> [ 1845.185026] RDX: ffff88007ca5dc18 RSI: 0000000000000000 RDI: ffffffffa01600d0
> [ 1845.185026] RBP: ffff88007ca5dd18 R08: ffffffff824e9810 R09: ffffffffffffffff
> [ 1845.185026] R10: ffff8800ffffffff R11: dead4ead00000001 R12: ffffffff81a95040
> [ 1845.185026] R13: ffff88007b27a960 R14: ffff88007c1f1600 R15: 0000000000000000
> [ 1845.185026] FS:  0000000000000000(0000) GS:ffffffff81a23000(0000) knlGS:0000000000000000
> [ 1845.185026] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1845.185026] CR2: ffffffffa01601d0 CR3: 0000000037207000 CR4: 00000000000006b0
> [ 1845.185026] Stack:
> [ 1845.185026]  ffff88007c1f1600 ffff88007c1f1600 ffff88007ca5dd38 ffffffff812cdb7e
> [ 1845.185026]  0000000000000000 ffff88007c1f1640 ffff88007ca5dd68 ffffffff812cdbfe
> [ 1845.185026]  ffff88007c974800 ffff88007c1f1640 ffff88007ff61a00 0000000000000000
> [ 1845.185026] Call Trace:
> [ 1845.185026]  [<ffffffff812cdb7e>] kobject_del+0x2e/0x40
> [ 1845.185026]  [<ffffffff812cdbfe>] kobject_delayed_cleanup+0x6e/0x1d0
> [ 1845.185026]  [<ffffffff81063a45>] process_one_work+0x1e5/0x670
> [ 1845.185026]  [<ffffffff810639e3>] ? process_one_work+0x183/0x670
> [ 1845.185026]  [<ffffffff810642b3>] worker_thread+0x113/0x370
> [ 1845.185026]  [<ffffffff810641a0>] ? rescuer_thread+0x290/0x290
> [ 1845.185026]  [<ffffffff8106bfba>] kthread+0xda/0xe0
> [ 1845.185026]  [<ffffffff814ff0f0>] ? _raw_spin_unlock_irq+0x30/0x60
> [ 1845.185026]  [<ffffffff8106bee0>] ? kthread_create_on_node+0x130/0x130
> [ 1845.185026]  [<ffffffff8150751a>] ret_from_fork+0x7a/0xb0
> [ 1845.185026]  [<ffffffff8106bee0>] ? kthread_create_on_node+0x130/0x130
> [ 1845.185026] Code: 81 48 c7 c7 28 95 ad 81 31 c0 e8 9b da 01 00 e9 4f ff ff ff 66 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 1d <f6> 87 00 01 00 00 01 74 1e 48 8d 7b 38 83 6b 38 01 0f 94 c0 84 
> [ 1845.185026] RIP  [<ffffffff812cda81>] kobject_put+0x11/0x60
> [ 1845.185026]  RSP <ffff88007ca5dd08>
> [ 1845.185026] CR2: ffffffffa01601d0
> [ 1845.185026] ---[ end trace 49a70afd109f5653 ]---
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
