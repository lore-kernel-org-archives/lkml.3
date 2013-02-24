Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3BXSPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 13:15:31 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:39366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3BXSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 13:15:30 -0500
Message-ID: <1361729697.8129.19.camel@jlt4.sipsolutions.net>
Subject: Re: Lockdep splat when unloading b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 24 Feb 2013 19:14:57 +0100
In-Reply-To: <512A4E83.5090901@lwfinger.net> (sfid-20130224_183218_530192_A4B69F12)
References: <512A4E83.5090901@lwfinger.net>
	 (sfid-20130224_183218_530192_A4B69F12)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-24 at 11:31 -0600, Larry Finger wrote:
> With the current wireless-testing tree, unloading b43 produces the lockdep log 
> splat copied below. My understanding of locking is deficient, and I would like 
> to learn. Any help on understanding this problem is appreciated.

> [ 3093.900880] modprobe/5557 is trying to acquire lock:
> [ 3093.900883]  ((&wl->firmware_load)){+.+.+.}, at: [<ffffffff81062160>] 
> flush_work+0x0/0x2a0

This is a work "lock", it's a fake lock I (originally anyway) added to
work structs (and workqueues) to detect issues like the one it just
detected for you. The lockdep tracking "acquires" the lock whenever the
work runs (around the work) and whenever you flush the work (like here)

It's a bit tricky to wrap your head around this though because it's not
a typical lock.

> [ 3093.900895] but task is already holding lock:
> [ 3093.900897]  (rtnl_mutex){+.+.+.}, at: [<ffffffff813bd7d2>] rtnl_lock+0x12/0x20

So you're also holding the RTNL. This creates a RTNL->firmware_load
dependency.

> [ 3093.900905] which lock already depends on the new lock.

But it's telling you that you already have the reverse dependency
(firmware_load->RTNL), it tells you why below:

> [ 3093.900908] the existing dependency chain (in reverse order) is:

> [ 3093.900911] -> #1 (rtnl_mutex){+.+.+.}:
> [ 3093.900915]        [<ffffffff810a4bf6>] lock_acquire+0xa6/0x1e0
> [ 3093.900922]        [<ffffffff81458769>] mutex_lock_nested+0x69/0x370
> [ 3093.900927]        [<ffffffff813bd7d2>] rtnl_lock+0x12/0x20
> [ 3093.900931]        [<ffffffffa03e613c>] wiphy_register+0x59c/0x6c0 [cfg80211]
> [ 3093.900965]        [<ffffffffa050556b>] ieee80211_register_hw+0x37b/0x820 
> [mac80211]
> [ 3093.901000]        [<ffffffffa047a0bc>] b43_request_firmware+0x8c/0x180 [b43]

Here request_firmware calls wiphy_register which locks the RTNL, and
it's running from the work struct. This was newly introduced by commit
ecb4433550f0620f3d1471ae7099037ede30a91e
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Aug 12 14:00:59 2011 +0200

    mac80211: fix suspend/resume races with unregister hw


> [ 3093.901033] -> #0 ((&wl->firmware_load)){+.+.+.}:
> [ 3093.901037]        [<ffffffff810a3d3e>] __lock_acquire+0x14ee/0x1d60
> [ 3093.901041]        [<ffffffff810a4bf6>] lock_acquire+0xa6/0x1e0
> [ 3093.901045]        [<ffffffff81062198>] flush_work+0x38/0x2a0
> [ 3093.901049]        [<ffffffff8106337b>] __cancel_work_timer+0x7b/0xd0
> [ 3093.901053]        [<ffffffff810633eb>] cancel_work_sync+0xb/0x10
> [ 3093.901057]        [<ffffffffa047acd5>] b43_wireless_core_stop+0x75/0x250 [b43]
> [ 3093.901065]        [<ffffffffa047aefc>] b43_op_stop+0x4c/0x90 [b43]
> [ 3093.901072]        [<ffffffffa053f067>] ieee80211_stop_device+0x67/0x290 
> [mac80211]
> [ 3093.901095]        [<ffffffffa0521499>] ieee80211_do_stop+0x4e9/0x9e0 [mac80211]
> [ 3093.901112]        [<ffffffffa05219a5>] ieee80211_stop+0x15/0x20 [mac80211]
> [ 3093.901129]        [<ffffffff813aa8ad>] __dev_close_many+0x8d/0xd0
> [ 3093.901134]        [<ffffffff813aa9b3>] dev_close_many+0x83/0xf0
> [ 3093.901137]        [<ffffffff813aaadf>] rollback_registered_many+0xbf/0x2c0
> [ 3093.901140]        [<ffffffff813aacf6>] unregister_netdevice_many+0x16/0x70

This I'm confused about... That's the same it's doing right now (see
below)??

> [ 3093.901235]  Possible unsafe locking scenario:

Here's where it tells you how it might deadlock.

> [ 3093.901238]        CPU0                    CPU1
> [ 3093.901239]        ----                    ----
> [ 3093.901241]   lock(rtnl_mutex);

You have rtnl locked on one CPU, while the firmware load work is pending

> [ 3093.901244]                                lock((&wl->firmware_load));

the firmware load work starts to run

> [ 3093.901247]                                lock(rtnl_mutex);

and tries to acquire the RTNL -- but has to wait since CPU0 is holding
it

> [ 3093.901250]   lock((&wl->firmware_load));

and you might cancel_work_sync() on CPU0, thus causing the deadlock.

> [ 3093.901315]  [<ffffffff81062198>] flush_work+0x38/0x2a0
> [ 3093.901319]  [<ffffffff81062160>] ? work_cpu+0x20/0x20
> [ 3093.901323]  [<ffffffff810a557c>] ? mark_held_locks+0x8c/0x110
> [ 3093.901329]  [<ffffffff81052d27>] ? del_timer+0x57/0x70
> [ 3093.901334]  [<ffffffff81063368>] ? __cancel_work_timer+0x68/0xd0
> [ 3093.901338]  [<ffffffff810a5705>] ? trace_hardirqs_on_caller+0x105/0x190
> [ 3093.901343]  [<ffffffff8106337b>] __cancel_work_timer+0x7b/0xd0
> [ 3093.901347]  [<ffffffff810633eb>] cancel_work_sync+0xb/0x10
> [ 3093.901355]  [<ffffffffa047acd5>] b43_wireless_core_stop+0x75/0x250 [b43]
> [ 3093.901364]  [<ffffffffa047aefc>] b43_op_stop+0x4c/0x90 [b43]
> [ 3093.901384]  [<ffffffffa053f067>] ieee80211_stop_device+0x67/0x290 [mac80211]
> [ 3093.901402]  [<ffffffffa0521499>] ieee80211_do_stop+0x4e9/0x9e0 [mac80211]
> [ 3093.901407]  [<ffffffff813cb0b1>] ? dev_deactivate_many+0x231/0x2f0
> [ 3093.901425]  [<ffffffffa05219a5>] ieee80211_stop+0x15/0x20 [mac80211]
> [ 3093.901429]  [<ffffffff813aa8ad>] __dev_close_many+0x8d/0xd0
> [ 3093.901433]  [<ffffffff813aa9b3>] dev_close_many+0x83/0xf0
> [ 3093.901437]  [<ffffffff813aaadf>] rollback_registered_many+0xbf/0x2c0
> [ 3093.901441]  [<ffffffff813aacf6>] unregister_netdevice_many+0x16/0x70

Anyway, the solution probably is to move the cancel_work_sync into
something like the ssb deregister.

johannes

