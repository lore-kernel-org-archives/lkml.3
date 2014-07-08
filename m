Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaGHOEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:04:36 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:52313 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGHOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:04:34 -0400
Date: Tue, 8 Jul 2014 10:04:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [workqueue] WARNING: CPU: 0 PID: 76 at
 drivers/block/floppy.c:968 schedule_bh()
Message-ID: <20140708140430.GE4979@htj.dyndns.org>
References: <20140708021149.GA12956@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708021149.GA12956@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jiri)

On Tue, Jul 08, 2014 at 10:11:49AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit b22ce2785d97423846206cceec4efee0c4afd980
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Wed Aug 28 17:33:37 2013 -0400
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Thu Aug 29 09:19:28 2013 -0400
> 
>     workqueue: cond_resched() after processing each work item
...
> [   45.121121] PCI: setting IRQ 11 as level-triggered
> [   45.407538] e1000 0000:00:03.0: setting latency timer to 64
> [   45.686040] ------------[ cut here ]------------
> [   45.975060] WARNING: CPU: 0 PID: 76 at drivers/block/floppy.c:968 schedule_bh+0x47/0x80()
> [   47.312537] CPU: 0 PID: 76 Comm: kworker/u2:1 Not tainted 3.11.0-rc7-00025-gb22ce27 #8
> [   47.848171] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [   48.433222] Workqueue: events_unbound async_run_entry_fn
> [   48.725491]  00000000 d25d7e0c c2745b10 d25d7e3c c105472d c2ff0b10 00000000 0000004c
> [   49.494639]  c30df57c 000003c8 c1a2fb57 c1a2fb57 00000001 c1a33aa0 c39a0ca0 d25d7e4c
> [   51.548252]  c1054812 00000009 00000000 d25d7e5c c1a2fb57 00000000 00000000 d25d7e84
> [   56.319716] Call Trace:
> [   58.164457]  [<c2745b10>] dump_stack+0x16/0x18
> [   61.355641]  [<c105472d>] warn_slowpath_common+0x8d/0xb0
> [   62.920432]  [<c1054812>] warn_slowpath_null+0x22/0x30
> [   63.411821]  [<c1a2fb57>] schedule_bh+0x47/0x80
> [   66.271423]  [<c1a33ed5>] wait_til_done+0x15/0x230
> [   75.990887]  [<c1a348d7>] user_reset_fdc+0xa7/0x110
> [   78.921153]  [<c384c939>] floppy_async_init+0x9ee/0x1263
> [   83.512228]  [<c108a0e4>] async_run_entry_fn+0x44/0x1e0
> [   89.499077]  [<c1075f5b>] process_one_work+0x33b/0x840
> [   91.634105]  [<c1076874>] worker_thread+0x414/0x890
> [   92.265965]  [<c1080ba6>] kthread+0xa6/0xb0
> [   92.658144]  [<c2763f57>] ret_from_kernel_thread+0x1b/0x28
> [   93.254541] ---[ end trace 857f8343e4eb716b ]---
> [   93.508601] floppy0: no floppy controllers found

Hmmm... this is schedule_bh() in floppy.c complaining that the work
item is already pending.  The cond_resched() addition by b22ce2785d97
doesn't change the semantics around work item execution although it
could have exposed an existing problem in the floppy driver.  I'll
look into how this could happen.

Thanks.

-- 
tejun
