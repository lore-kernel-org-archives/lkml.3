Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaAGS2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:28:41 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61545 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaAGS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:28:33 -0500
Message-ID: <52CC474A.7090207@lwfinger.net>
Date: Tue, 07 Jan 2014 12:28:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Lockdep problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A locking dependency problem has been reported for b43 at 
https://bugzilla.kernel.org/show_bug.cgi?id=67561. I was able to duplicate with 
the following:

1. Set network under manual, not NetworkManager, control.
2. Start hostapd
3. Use 'rfkill block all' to disable the access point

As my skills in fixing locking dependencies are minimal, I am hoping that 
someone here can help me. The resulting splat is as follows:

  ======================================================
  [ INFO: possible circular locking dependency detected ]
  3.13.0-rc6-wl+ #34 Tainted: G           O
  -------------------------------------------------------
  rfkill/15379 is trying to acquire lock:
   (rtnl_mutex){+.+.+.}, at: [<ffffffff813d3232>] rtnl_lock+0x12/0x20

but task is already holding lock:
   (rfkill_global_mutex){+.+.+.}, at: [<ffffffff8145dd5a>] 
rfkill_fop_write+0x6a/0x180

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #4 (rfkill_global_mutex){+.+.+.}:
         [<ffffffff810994ea>] lock_acquire+0x9a/0x1d0
         [<ffffffff8146cd12>] mutex_lock_nested+0x62/0x3f0
         [<ffffffff8145e4e9>] rfkill_fop_open+0x89/0x200
         [<ffffffff812d9753>] misc_open+0xb3/0x170
         [<ffffffff8116827a>] chrdev_open+0x9a/0x1d0
         [<ffffffff81161e92>] do_dentry_open.isra.18+0x1a2/0x2a0
         [<ffffffff8116208b>] finish_open+0x2b/0x40
         [<ffffffff81172792>] do_last+0x572/0xdd0
         [<ffffffff811730a6>] path_openat+0xb6/0x6d0
         [<ffffffff81174785>] do_filp_open+0x35/0x80
         [<ffffffff811631b9>] do_sys_open+0x129/0x220
         [<ffffffff811632c9>] SyS_open+0x19/0x20
         [<ffffffff81471b34>] tracesys+0xdd/0xe2

-> #3 (misc_mtx){+.+.+.}:
         [<ffffffff810994ea>] lock_acquire+0x9a/0x1d0
         [<ffffffff8146cd12>] mutex_lock_nested+0x62/0x3f0
         [<ffffffff812d94a4>] misc_register+0x24/0x120
         [<ffffffffa000e139>] hwrng_register+0x109/0x1d0 [rng_core]
         [<ffffffffa0719990>] b43_wireless_core_init+0xdb0/0x1270 [b43]
         [<ffffffffa071a6c0>] b43_op_start+0x210/0x230 [b43]
         [<ffffffffa065c210>] ieee80211_do_open+0x350/0x17a0 [mac80211]
         [<ffffffffa065d6c1>] ieee80211_open+0x61/0x70 [mac80211]
         [<ffffffff813c6d0f>] __dev_open+0xbf/0x140
         [<ffffffff813c6ff8>] __dev_change_flags+0x98/0x170
         [<ffffffff813c70f4>] dev_change_flags+0x24/0x60
         [<ffffffff813d6251>] do_setlink+0x321/0x9a0
         [<ffffffff813d6d6f>] rtnl_newlink+0x37f/0x560
         [<ffffffff813d5cac>] rtnetlink_rcv_msg+0x8c/0x240
         [<ffffffff813eecf9>] netlink_rcv_skb+0xa9/0xc0
         [<ffffffff813d5c15>] rtnetlink_rcv+0x25/0x30
         [<ffffffff813ee5da>] netlink_unicast+0x13a/0x200
         [<ffffffff813eea7b>] netlink_sendmsg+0x33b/0x410
         [<ffffffff813a6a8a>] sock_sendmsg+0x6a/0x90
         [<ffffffff813a94d9>] ___sys_sendmsg+0x389/0x3a0
         [<ffffffff813aa26d>] __sys_sendmsg+0x3d/0x80
         [<ffffffff813aa2bd>] SyS_sendmsg+0xd/0x20
         [<ffffffff81471b34>] tracesys+0xdd/0xe2

-> #2 (rng_mutex){+.+.+.}:
         [<ffffffff810994ea>] lock_acquire+0x9a/0x1d0
         [<ffffffff8146cd12>] mutex_lock_nested+0x62/0x3f0
         [<ffffffffa000e05f>] hwrng_register+0x2f/0x1d0 [rng_core]
         [<ffffffffa0719990>] b43_wireless_core_init+0xdb0/0x1270 [b43]
         [<ffffffffa071a6c0>] b43_op_start+0x210/0x230 [b43]
         [<ffffffffa065c210>] ieee80211_do_open+0x350/0x17a0 [mac80211]
         [<ffffffffa065d6c1>] ieee80211_open+0x61/0x70 [mac80211]
         [<ffffffff813c6d0f>] __dev_open+0xbf/0x140
         [<ffffffff813c6ff8>] __dev_change_flags+0x98/0x170
         [<ffffffff813c70f4>] dev_change_flags+0x24/0x60
         [<ffffffff813d6251>] do_setlink+0x321/0x9a0
         [<ffffffff813d6d6f>] rtnl_newlink+0x37f/0x560
         [<ffffffff813d5cac>] rtnetlink_rcv_msg+0x8c/0x240
         [<ffffffff813eecf9>] netlink_rcv_skb+0xa9/0xc0
         [<ffffffff813d5c15>] rtnetlink_rcv+0x25/0x30
         [<ffffffff813ee5da>] netlink_unicast+0x13a/0x200
         [<ffffffff813eea7b>] netlink_sendmsg+0x33b/0x410
         [<ffffffff813a6a8a>] sock_sendmsg+0x6a/0x90
         [<ffffffff813a94d9>] ___sys_sendmsg+0x389/0x3a0
         [<ffffffff813aa26d>] __sys_sendmsg+0x3d/0x80
         [<ffffffff813aa2bd>] SyS_sendmsg+0xd/0x20
         [<ffffffff81471b34>] tracesys+0xdd/0xe2

-> #1 (&wl->mutex){+.+.+.}:
         [<ffffffff810994ea>] lock_acquire+0x9a/0x1d0
         [<ffffffff8146cd12>] mutex_lock_nested+0x62/0x3f0
         [<ffffffffa071a5a8>] b43_op_start+0xf8/0x230 [b43]
         [<ffffffffa065c210>] ieee80211_do_open+0x350/0x17a0 [mac80211]
         [<ffffffffa065d6c1>] ieee80211_open+0x61/0x70 [mac80211]
         [<ffffffff813c6d0f>] __dev_open+0xbf/0x140
         [<ffffffff813c6ff8>] __dev_change_flags+0x98/0x170
         [<ffffffff813c70f4>] dev_change_flags+0x24/0x60
         [<ffffffff813d6251>] do_setlink+0x321/0x9a0
         [<ffffffff813d6d6f>] rtnl_newlink+0x37f/0x560
         [<ffffffff813d5cac>] rtnetlink_rcv_msg+0x8c/0x240
         [<ffffffff813eecf9>] netlink_rcv_skb+0xa9/0xc0
         [<ffffffff813d5c15>] rtnetlink_rcv+0x25/0x30
         [<ffffffff813ee5da>] netlink_unicast+0x13a/0x200
         [<ffffffff813eea7b>] netlink_sendmsg+0x33b/0x410
         [<ffffffff813a6a8a>] sock_sendmsg+0x6a/0x90
         [<ffffffff813a94d9>] ___sys_sendmsg+0x389/0x3a0
         [<ffffffff813aa26d>] __sys_sendmsg+0x3d/0x80
         [<ffffffff813aa2bd>] SyS_sendmsg+0xd/0x20
         [<ffffffff81471b34>] tracesys+0xdd/0xe2

-> #0 (rtnl_mutex){+.+.+.}:
         [<ffffffff8109883a>] __lock_acquire+0x1a3a/0x1e60
         [<ffffffff810994ea>] lock_acquire+0x9a/0x1d0
         [<ffffffff8146cd12>] mutex_lock_nested+0x62/0x3f0
         [<ffffffff813d3232>] rtnl_lock+0x12/0x20
         [<ffffffffa056bb88>] cfg80211_rfkill_set_block.part.11+0x18/0x80 [cfg80211]
         [<ffffffffa056bc09>] cfg80211_rfkill_set_block+0x19/0x20 [cfg80211]
         [<ffffffff8145d84b>] rfkill_set_block+0x8b/0x140
         [<ffffffff8145ddc7>] rfkill_fop_write+0xd7/0x180
         [<ffffffff81163cdb>] vfs_write+0xab/0x1c0
         [<ffffffff81164634>] SyS_write+0x44/0xa0
         [<ffffffff81471b34>] tracesys+0xdd/0xe2

other info that might help us debug this:

  Chain exists of:
   rtnl_mutex --> misc_mtx --> rfkill_global_mutex

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(rfkill_global_mutex);
                                 lock(misc_mtx);
                                 lock(rfkill_global_mutex);
    lock(rtnl_mutex);

  *** DEADLOCK ***

  1 lock held by rfkill/15379:
   #0:  (rfkill_global_mutex){+.+.+.}, at: [<ffffffff8145dd5a>] 
rfkill_fop_write+0x6a/0x180

stack backtrace:
  CPU: 0 PID: 15379 Comm: rfkill Tainted: G           O 3.13.0-rc6-wl+ #34
  Hardware name: Hewlett-Packard HP Pavilion dv2700 Notebook PC/30D6, BIOS F.27 
11/27/2008
   ffffffff81f857a0 ffff88005df3bc88 ffffffff8146a1a4 ffffffff81f7dac0
   ffff88005df3bcc8 ffffffff814672e4 ffff88005df3bd20 ffff8800b560d340
   0000000000000000 ffff8800b560d318 ffff8800b560d340 ffff8800b560cce0
  Call Trace:
   [<ffffffff8146a1a4>] dump_stack+0x4e/0x7a
   [<ffffffff814672e4>] print_circular_bug+0x2b0/0x2bf
   [<ffffffff8109883a>] __lock_acquire+0x1a3a/0x1e60
   [<ffffffff810994ea>] lock_acquire+0x9a/0x1d0
   [<ffffffff813d3232>] ? rtnl_lock+0x12/0x20
   [<ffffffff813d3232>] ? rtnl_lock+0x12/0x20
   [<ffffffff8146cd12>] mutex_lock_nested+0x62/0x3f0
   [<ffffffff813d3232>] ? rtnl_lock+0x12/0x20
   [<ffffffff810968ba>] ? mark_held_locks+0x8a/0x130
   [<ffffffff813d3232>] rtnl_lock+0x12/0x20
   [<ffffffffa056bb88>] cfg80211_rfkill_set_block.part.11+0x18/0x80 [cfg80211]
   [<ffffffffa056bc09>] cfg80211_rfkill_set_block+0x19/0x20 [cfg80211]
   [<ffffffff8145d84b>] rfkill_set_block+0x8b/0x140
   [<ffffffff8145ddc7>] rfkill_fop_write+0xd7/0x180
   [<ffffffff81163cdb>] vfs_write+0xab/0x1c0
   [<ffffffff81183220>] ? fget_light+0x320/0x4b0
   [<ffffffff81164634>] SyS_write+0x44/0xa0
   [<ffffffff81471b34>] tracesys+0xdd/0xe2

Thanks,

Larry
