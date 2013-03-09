Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab3CICRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 21:17:50 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34850 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947Ab3CICRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 21:17:49 -0500
Message-ID: <513A9BCA.9020402@lwfinger.net>
Date: Fri, 08 Mar 2013 20:17:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [3.9-rc1] Locking dependency problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel 3.9-rc1, I get the following lockdep warning. This kernel is from the 
wireless-testing tree, but I have seen the same message from the mainline kernel.

[ 4199.401157]
[ 4199.401159] ======================================================
[ 4199.401160] [ INFO: possible circular locking dependency detected ]
[ 4199.401163] 3.9.0-rc1-wl+ #124 Tainted: G        W
[ 4199.401164] -------------------------------------------------------
[ 4199.401167] kworker/0:3/2382 is trying to acquire lock:
[ 4199.401177]  (&fb_info->lock){+.+.+.}, at: [<ffffffff8124c371>] 
lock_fb_info+0x21/0x60
[ 4199.401177]
[ 4199.401177] but task is already holding lock:
[ 4199.401183]  (console_lock){+.+.+.}, at: [<ffffffff812c487e>] 
console_callback+0xe/0x130
[ 4199.401184]
[ 4199.401184] which lock already depends on the new lock.
[ 4199.401184]
[ 4199.401185]
[ 4199.401185] the existing dependency chain (in reverse order) is:
[ 4199.401187]
[ 4199.401187] -> #1 (console_lock){+.+.+.}:
[ 4199.401193]        [<ffffffff810a49c8>] lock_acquire+0xa8/0x1f0
[ 4199.401197]        [<ffffffff81041a87>] console_lock+0x77/0x80
[ 4199.401200]        [<ffffffff8124e0a2>] register_framebuffer+0x1b2/0x300
[ 4199.401205]        [<ffffffff818c0d9d>] vesafb_probe+0x6ec/0x76c
[ 4199.401208]        [<ffffffff812e429e>] platform_drv_probe+0x3e/0x70
[ 4199.401211]        [<ffffffff812e2215>] driver_probe_device+0x75/0x230
[ 4199.401213]        [<ffffffff812e2473>] __driver_attach+0xa3/0xb0
[ 4199.401216]        [<ffffffff812e0485>] bus_for_each_dev+0x55/0x90
[ 4199.401218]        [<ffffffff812e1d69>] driver_attach+0x19/0x20
[ 4199.401220]        [<ffffffff812e1899>] bus_add_driver+0x109/0x270
[ 4199.401223]        [<ffffffff812e2b22>] driver_register+0x72/0x170
[ 4199.401226]        [<ffffffff812e3b11>] platform_driver_register+0x41/0x50
[ 4199.401228]        [<ffffffff812e3b36>] platform_driver_probe+0x16/0xa0
[ 4199.401231]        [<ffffffff818c066e>] vesafb_init+0x215/0x258
[ 4199.401235]        [<ffffffff81000302>] do_one_initcall+0x122/0x180
[ 4199.401239]        [<ffffffff8189af4e>] kernel_init_freeable+0x103/0x192
[ 4199.401242]        [<ffffffff814544e9>] kernel_init+0x9/0xf0
[ 4199.401247]        [<ffffffff8146cfbc>] ret_from_fork+0x7c/0xb0
[ 4199.401250]
[ 4199.401250] -> #0 (&fb_info->lock){+.+.+.}:
[ 4199.401252]        [<ffffffff810a3b89>] __lock_acquire+0x1479/0x1c70
[ 4199.401255]        [<ffffffff810a49c8>] lock_acquire+0xa8/0x1f0
[ 4199.401257]        [<ffffffff81469189>] mutex_lock_nested+0x69/0x370
[ 4199.401259]        [<ffffffff8124c371>] lock_fb_info+0x21/0x60
[ 4199.401263]        [<ffffffff812598db>] fbcon_blank+0x29b/0x2e0
[ 4199.401266]        [<ffffffff812c1706>] do_blank_screen+0x1d6/0x280
[ 4199.401269]        [<ffffffff812c48cf>] console_callback+0x5f/0x130
[ 4199.401273]        [<ffffffff81064761>] process_one_work+0x1f1/0x660
[ 4199.401275]        [<ffffffff81064f70>] worker_thread+0x110/0x380
[ 4199.401279]        [<ffffffff8106a756>] kthread+0xd6/0xe0
[ 4199.401282]        [<ffffffff8146cfbc>] ret_from_fork+0x7c/0xb0
[ 4199.401282]
[ 4199.401282] other info that might help us debug this:
[ 4199.401282]
[ 4199.401283]  Possible unsafe locking scenario:
[ 4199.401283]
[ 4199.401284]        CPU0                    CPU1
[ 4199.401284]        ----                    ----
[ 4199.401286]   lock(console_lock);
[ 4199.401287]                                lock(&fb_info->lock);
[ 4199.401288]                                lock(console_lock);
[ 4199.401290]   lock(&fb_info->lock);
[ 4199.401290]
[ 4199.401290]  *** DEADLOCK ***
[ 4199.401290]
[ 4199.401292] 3 locks held by kworker/0:3/2382:
[ 4199.401297]  #0:  (events){.+.+.+}, at: [<ffffffff810646f5>] 
process_one_work+0x185/0x660
[ 4199.401301]  #1:  (console_work){+.+...}, at: [<ffffffff810646f5>] 
process_one_work+0x185/0x660
[ 4199.401305]  #2:  (console_lock){+.+.+.}, at: [<ffffffff812c487e>] 
console_callback+0xe/0x130
[ 4199.401306]
[ 4199.401306] stack backtrace:
[ 4199.401308] Pid: 2382, comm: kworker/0:3 Tainted: G        W    3.9.0-rc1-wl+ 
#124
[ 4199.401309] Call Trace:
[ 4199.401312]  [<ffffffff81464497>] print_circular_bug+0x28e/0x29f
[ 4199.401315]  [<ffffffff8146c7f3>] ? retint_restore_args+0x13/0x13
[ 4199.401318]  [<ffffffff810a3b89>] __lock_acquire+0x1479/0x1c70
[ 4199.401322]  [<ffffffff812628db>] ? bitfill_aligned+0x8b/0x140
[ 4199.401324]  [<ffffffff810a49c8>] lock_acquire+0xa8/0x1f0
[ 4199.401326]  [<ffffffff8124c371>] ? lock_fb_info+0x21/0x60
[ 4199.401329]  [<ffffffff81469189>] mutex_lock_nested+0x69/0x370
[ 4199.401331]  [<ffffffff8124c371>] ? lock_fb_info+0x21/0x60
[ 4199.401333]  [<ffffffff8125ca3c>] ? bit_clear+0xcc/0x100
[ 4199.401336]  [<ffffffff8125620e>] ? fbcon_clear+0x1be/0x1f0
[ 4199.401338]  [<ffffffff8124c371>] lock_fb_info+0x21/0x60
[ 4199.401341]  [<ffffffff812598db>] fbcon_blank+0x29b/0x2e0
[ 4199.401343]  [<ffffffff8146c17a>] ? _raw_spin_unlock_irqrestore+0x3a/0x80
[ 4199.401346]  [<ffffffff810a54ed>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[ 4199.401349]  [<ffffffff810a558d>] ? trace_hardirqs_on+0xd/0x10
[ 4199.401354]  [<ffffffff8105303a>] ? try_to_del_timer_sync+0x4a/0x60
[ 4199.401356]  [<ffffffff8105310a>] ? del_timer_sync+0xba/0xf0
[ 4199.401359]  [<ffffffff81053050>] ? try_to_del_timer_sync+0x60/0x60
[ 4199.401362]  [<ffffffff812c1706>] do_blank_screen+0x1d6/0x280
[ 4199.401364]  [<ffffffff812c48cf>] console_callback+0x5f/0x130
[ 4199.401367]  [<ffffffff81064761>] process_one_work+0x1f1/0x660
[ 4199.401370]  [<ffffffff810646f5>] ? process_one_work+0x185/0x660
[ 4199.401372]  [<ffffffff81064f70>] worker_thread+0x110/0x380
[ 4199.401375]  [<ffffffff810a558d>] ? trace_hardirqs_on+0xd/0x10
[ 4199.401377]  [<ffffffff81064e60>] ? rescuer_thread+0x250/0x250
[ 4199.401379]  [<ffffffff8106a756>] kthread+0xd6/0xe0
[ 4199.401382]  [<ffffffff8146c1eb>] ? _raw_spin_unlock_irq+0x2b/0x50
[ 4199.401385]  [<ffffffff8106a680>] ? __init_kthread_worker+0x70/0x70
[ 4199.401388]  [<ffffffff8146cfbc>] ret_from_fork+0x7c/0xb0
[ 4199.401390]  [<ffffffff8106a680>] ? __init_kthread_worker+0x70/0x70

This problem seems to be related to 
http://www.mentby.com/russell-king-2/bug-circular-locking-dependency-detected.html. 
Losing lockdep when the screen blanks is certainly a hindrance when trying to 
debug new drivers.

Thanks,

Larry
