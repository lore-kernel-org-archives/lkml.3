Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaLCJL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:11:56 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:37240 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaLCJLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:11:51 -0500
MIME-Version: 1.0
Date: Wed, 3 Dec 2014 17:11:49 +0800
Message-ID: <CANVTcTaChssJEU48iS6a1WwFf59Tqz2T9VrnsSM9ZLwnRC+SWw@mail.gmail.com>
Subject: Bug: Fatal errors result in infinite stream of error messages
From: rui wang <ruiv.wang@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, bp@alien8.de, aris@redhat.com, rui.y.wang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When a machine check panics while the kdump service isn't loaded (e.g.
due to insufficient disk space), we see an infinite stream of error
messages on the console, repeatedly, like this (The machine can never
reboot):

[   82.733050] bad: scheduling from the idle thread!
[   82.738304] CPU: 85 PID: 0 Comm: swapper/85 Tainted: G   M        E
 3.18.0-rc4-7-default+ #33
[   82.747921] Hardware name: Intel Corporation BRICKLAND/BRICKLAND,
BIOS BRHSXSD1.86B.0056.R01.1409242327 09/24/2014
[   82.759480]  ffff88047f873280 ffff88047f869878 ffffffff81566db9
0000000000000000
[   82.767788]  ffff88047f873280 ffff88047f869898 ffffffff810871ff
ffffffff81dbbe02
[   82.776094]  ffff88047f873280 ffff88047f8698c8 ffffffff8107c1fa
0000000100000000
[   82.784399] Call Trace:
[   82.787129]  <#MC>  [<ffffffff81566db9>] dump_stack+0x46/0x58
[   82.793570]  [<ffffffff810871ff>] dequeue_task_idle+0x2f/0x40
[   82.799987]  [<ffffffff8107c1fa>] dequeue_task+0x5a/0x80
[   82.805921]  [<ffffffff810804f3>] deactivate_task+0x23/0x30
[   82.812145]  [<ffffffff81569050>] __schedule+0x580/0x7f0
[   82.818080]  [<ffffffff81569739>] schedule_preempt_disabled+0x29/0x70
[   82.825268]  [<ffffffff8156ac49>] __ww_mutex_lock_slowpath+0xeb/0x192
[   82.832464]  [<ffffffff8156ad43>] __ww_mutex_lock+0x53/0x85
[   82.838704]  [<ffffffffa00b6a5d>] drm_modeset_lock+0x3d/0x110 [drm]
[   82.845717]  [<ffffffffa00b6c2a>] __drm_modeset_lock_all+0x8a/0x120 [drm]
[   82.853311]  [<ffffffffa00b6cd0>] drm_modeset_lock_all+0x10/0x30 [drm]
[   82.860608]  [<ffffffffa01c68bf>]
drm_fb_helper_pan_display+0x2f/0xf0 [drm_kms_helper]
[   82.869453]  [<ffffffff8132bd21>] fb_pan_display+0xd1/0x1a0
[   82.875677]  [<ffffffff81326010>] bit_update_start+0x20/0x50
[   82.881997]  [<ffffffff813259f2>] fbcon_switch+0x3a2/0x550
[   82.888125]  [<ffffffff813a01c9>] redraw_screen+0x189/0x240
[   82.894343]  [<ffffffff81322f8a>] fbcon_blank+0x20a/0x2d0
[   82.900366]  [<ffffffff8137d359>] ? erst_writer+0x209/0x330
[   82.906591]  [<ffffffff810ba2f3>] ? internal_add_timer+0x63/0x80
[   82.913292]  [<ffffffff810bc137>] ? mod_timer+0x127/0x1e0
[   82.919323]  [<ffffffff813a0cd8>] do_unblank_screen+0xa8/0x1d0
[   82.925832]  [<ffffffff813a0e10>] unblank_screen+0x10/0x20
[   82.931951]  [<ffffffff812ca0d9>] bust_spinlocks+0x19/0x40
[   82.938070]  [<ffffffff81561ca7>] panic+0x106/0x1f5
[   82.943520]  [<ffffffff810232d0>] mce_panic+0x210/0x230
[   82.949357]  [<ffffffff812c796a>] ? delay_tsc+0x4a/0x80
[   82.955185]  [<ffffffff81024c55>] do_machine_check+0xa95/0xab0
[   82.961701]  [<ffffffff813365d7>] ? intel_idle+0xc7/0x150
[   82.967722]  [<ffffffff8156f13f>] machine_check+0x1f/0x30
[   82.973751]  [<ffffffff813365d7>] ? intel_idle+0xc7/0x150
[   82.979781]  <<EOE>>  [<ffffffff814283d5>] cpuidle_enter_state+0x55/0x170
[   82.987386]  [<ffffffff814285a7>] cpuidle_enter+0x17/0x20
[   82.993419]  [<ffffffff81097b08>] cpu_startup_entry+0x2d8/0x370
[   83.000031]  [<ffffffff8102fc39>] start_secondary+0x159/0x180

The problem is because kdump fails to load a new kernel, and we're
executing past crash_kexec() in panic(). And it calls
bust_spinlocks(0) which calls into the GPU driver trying to unblank
the screen, which eventually calls __schedule() while waiting for a
mutex to be released. But we're still in the machine check context.
The infinite stream of errors is because there's a for(;;) loop in
__mutex_lock_common(), so we enter __schedule() again and again.

Among them the offset 0x106 (panic+0x106) reveals that it's the second
bust_spinlocks() call inside panic(). It's after crash_kexec()
returns. Should be unreachable code if kdump works correctly.

So the bug is that bust_spinlocks(0) isn't safe to be called in
panic() (probably it used to be safe?). I changed it to
bust_spinlocks(1) and the problem is gone. Now when the machine check
panics, it says:

[  171.663161] Kernel panic - not syncing: Fatal Machine check
[  171.723760] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffff9fffffff)
[  171.735125] drm_kms_helper: panic occurred, switching back to text console
[  172.144582] Rebooting in 30 seconds..

And it reboots correctly after 30 seconds. But this may not be the
desired fix because we don't call the GPU driver to unblank the
screen. Here's the workaround:

diff --git a/kernel/panic.c b/kernel/panic.c
index d09dc5c..380d5c0 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -143,7 +143,7 @@ void panic(const char *fmt, ...)
         */
        crash_kexec(NULL);

-       bust_spinlocks(0);
+       bust_spinlocks(1);

        if (!panic_blink)
                panic_blink = no_blink;


There's probably no easy fix if we're to unblank the screen. Anyone
has any idea how this should be fixed?

Thanks
Rui
