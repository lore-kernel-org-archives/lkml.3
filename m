Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaCQViP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:38:15 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62510 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaCQViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:38:14 -0400
MIME-Version: 1.0
Date: Mon, 17 Mar 2014 22:38:13 +0100
Message-ID: <CAAfyv37OPxJkcyYi0ZZe9MSQZ3TMeCuxa8rmWh8ahNF6Bs01Mg@mail.gmail.com>
Subject: w1: 3.14-rc7 - possible recursive locking detected
From: Belisko Marek <marek.belisko@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, zbr@ioremap.net
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

booting latest 3.14-rc7 on gta04 board gives following warning:

[    3.101409] Driver for 1-wire Dallas network protocol.
[    3.109649] omap_hdq omap_hdq: OMAP HDQ Hardware Rev 0.5. Driver in
Interrupt mode
[    3.330810]
[    3.332397] =============================================
[    3.338073] [ INFO: possible recursive locking detected ]
[    3.343749] 3.14.0-rc7-gta04 #520 Not tainted
[    3.348327] ---------------------------------------------
[    3.353973] w1_bus_master1/805 is trying to acquire lock:
[    3.359649]  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at:
[<c005977c>] __blocking_notifier_call_chain+0x28/0x58
[    3.370300]
[    3.370300] but task is already holding lock:
[    3.376434]  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at:
[<c005977c>] __blocking_notifier_call_chain+0x28/0x58
[    3.387084]
[    3.387084] other info that might help us debug this:
[    3.393920]  Possible unsafe locking scenario:
[    3.393920]
[    3.400146]        CPU0
[    3.402709]        ----
[    3.405273]   lock(&(&priv->bus_notifier)->rwsem);
[    3.410308]   lock(&(&priv->bus_notifier)->rwsem);
[    3.415374]
[    3.415374]  *** DEADLOCK ***
[    3.415374]
[    3.421569]  May be due to missing lock nesting notation
[    3.421569]
[    3.428710] 2 locks held by w1_bus_master1/805:
[    3.433471]  #0:  (&dev->mutex#2){+.+.+.}, at: [<c03bc5d4>]
w1_attach_slave_device+0xb8/0x1c4
[    3.442504]  #1:  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at:
[<c005977c>] __blocking_notifier_call_chain+0x28/0x58
[    3.453582]
[    3.453582] stack backtrace:
[    3.458190] CPU: 0 PID: 805 Comm: w1_bus_master1 Not tainted
3.14.0-rc7-gta04 #520
[    3.466156] [<c0014418>] (unwind_backtrace) from [<c0011788>]
(show_stack+0x10/0x14)
[    3.474304] [<c0011788>] (show_stack) from [<c04ee204>]
(dump_stack+0x68/0x84)
[    3.481933] [<c04ee204>] (dump_stack) from [<c007616c>]
(print_deadlock_bug+0xc0/0xf0)
[    3.490264] [<c007616c>] (print_deadlock_bug) from [<c0077a34>]
(validate_chain.isra.27+0x4e0/0x538)
[    3.499847] [<c0077a34>] (validate_chain.isra.27) from [<c0078864>]
(__lock_acquire+0x72c/0x838)
[    3.509094] [<c0078864>] (__lock_acquire) from [<c0078f84>]
(lock_acquire+0xf4/0x118)
[    3.517333] [<c0078f84>] (lock_acquire) from [<c04f69b0>]
(down_read+0x28/0x38)
[    3.525024] [<c04f69b0>] (down_read) from [<c005977c>]
(__blocking_notifier_call_chain+0x28/0x58)
[    3.534362] [<c005977c>] (__blocking_notifier_call_chain) from
[<c00597c0>] (blocking_notifier_call_chain+0x14/0x18)
[    3.545440] [<c00597c0>] (blocking_notifier_call_chain) from
[<c0306940>] (device_add+0x1f4/0x368)
[    3.554870] [<c0306940>] (device_add) from [<c030a158>]
(platform_device_add+0x138/0x1c8)
[    3.563476] [<c030a158>] (platform_device_add) from [<c03bf31c>]
(w1_bq27000_add_slave+0x44/0x74)
[    3.572784] [<c03bf31c>] (w1_bq27000_add_slave) from [<c03bca78>]
(w1_bus_notify.part.0+0x48/0xc8)
[    3.582214] [<c03bca78>] (w1_bus_notify.part.0) from [<c04f996c>]
(notifier_call_chain+0x38/0x68)
[    3.591522] [<c04f996c>] (notifier_call_chain) from [<c0059798>]
(__blocking_notifier_call_chain+0x44/0x58)
[    3.601776] [<c0059798>] (__blocking_notifier_call_chain) from
[<c00597c0>] (blocking_notifier_call_chain+0x14/0x18)
[    3.612823] [<c00597c0>] (blocking_notifier_call_chain) from
[<c0306940>] (device_add+0x1f4/0x368)
[    3.622253] [<c0306940>] (device_add) from [<c03bc4a0>]
(__w1_attach_slave_device+0x9c/0x118)
[    3.631225] [<c03bc4a0>] (__w1_attach_slave_device) from
[<c03bc644>] (w1_attach_slave_device+0x128/0x1c4)
[    3.641357] [<c03bc644>] (w1_attach_slave_device) from [<c03bc75c>]
(w1_slave_found+0x7c/0x98)
[    3.650421] [<c03bc75c>] (w1_slave_found) from [<c03bea10>]
(omap_w1_search_bus+0x54/0x5c)
[    3.659118] [<c03bea10>] (omap_w1_search_bus) from [<c03be950>]
(w1_search_devices+0x3c/0x48)
[    3.668090] [<c03be950>] (w1_search_devices) from [<c03bd210>]
(w1_search_process_cb+0x4c/0xc4)
[    3.677215] [<c03bd210>] (w1_search_process_cb) from [<c03bd2e0>]
(w1_process+0x58/0x10c)
[    3.685821] [<c03bd2e0>] (w1_process) from [<c0055850>] (kthread+0xc8/0xdc)
[    3.693145] [<c0055850>] (kthread) from [<c000dc68>]
(ret_from_fork+0x14/0x2c)
[    3.751068] omap_wdt: OMAP Watchdog Timer Rev 0x31: initial timeout 60 sec

AFAIK we didn't see that on (at least 3/14-rc2).

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
