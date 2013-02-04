Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab3BDNFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:05:24 -0500
Received: from ozlabs.org ([203.10.76.45]:48966 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab3BDNFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:05:23 -0500
Message-ID: <1359983119.20724.10.camel@concordia>
Subject: Re: 3.8: possible circular locking dependency detected
From: Michael Ellerman <michael@ellerman.id.au>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 05 Feb 2013 00:05:19 +1100
In-Reply-To: <alpine.DEB.2.01.1302031843450.13050@trent.utfs.org>
References: <alpine.DEB.2.01.1302031843450.13050@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-03 at 21:09 -0800, Christian Kujau wrote:
> Hi,
> 
> similar to what I reported earlier [0] for 3.8.0-rc1, this happens during 
> "ifup wlan0" (which in effect starts wpa_supplicant to bring up a Broadcom 
> b43 wifi network interface). The interface is working though and continues 
> to work over several ifup/ifdown iterations.
> 
> The backtrace looks awfully similar to the earlier[0] report, but this 
> time it had b43* stuff in it so I thought I should report it. Full dmesg 
> and .config here: http://nerdbynature.de/bits/3.8.0-rc6/

>[0] https://lkml.org/lkml/2013/1/3/543

Actually the backtrace looks very different, that was fb vs
console_lock.

This one should probably go to linux-wireless@vger.kernel.org (CC-ed).

IIUI it's actually the work handling that is the problem. In
b43_wireless_core_stop() it calls cancel_work_sync() with the RTNL held,
but the work function (b43_request_firmware()) also takes the RTNL via
ieee80211_register_hw() and wiphy_register(). eg:

> [  807.767412]        CPU0                    CPU1
> [  807.768561]        ----                    ----
> [  807.769690]   lock(rtnl_mutex);
> [  807.770822]                                process_one_work(..., &wl->firmware_load);
> [  807.771970]                                lock(rtnl_mutex);
> [  807.773115]   cancel_work_sync(&wl->firmware_load);

cheers

> [  807.693791] 
> [  807.695519] ======================================================
> [  807.697198] [ INFO: possible circular locking dependency detected ]
> [  807.698890] 3.8.0-rc6-00008-g8b31849 #1 Not tainted
> [  807.700573] -------------------------------------------------------
> [  807.702255] wpa_supplicant/4129 is trying to acquire lock:
> [  807.703925]  ((&wl->firmware_load)){+.+.+.}, at: [<c0049d1c>] flush_work+0x0/0x2b0
> [  807.705696] 
> [  807.705696] but task is already holding lock:
> [  807.709023]  (rtnl_mutex){+.+.+.}, at: [<c04362d4>] rtnl_lock+0x1c/0x2c
> [  807.710743] 
> [  807.710743] which lock already depends on the new lock.
> [  807.710743] 
> [  807.715541] 
> [  807.715541] the existing dependency chain (in reverse order) is:
> [  807.718691] 
> [  807.718691] -> #1 (rtnl_mutex){+.+.+.}:
> [  807.721903]        [<c04f69ac>] mutex_lock_nested+0x6c/0x2bc
> [  807.723533]        [<c04362d4>] rtnl_lock+0x1c/0x2c
> [  807.725138]        [<f20be0d8>] wiphy_register+0x510/0x53c [cfg80211]
> [  807.726798]        [<f64815ec>] ieee80211_register_hw+0x3f8/0x82c [mac80211]
> [  807.728431]        [<f64c6890>] b43_request_firmware+0x8c/0x198 [b43]
> [  807.730025]        [<c004b1f4>] process_one_work+0x1a4/0x498
> [  807.731549]        [<c004b8b4>] worker_thread+0x17c/0x428
> [  807.733025]        [<c0051280>] kthread+0xa8/0xac
> [  807.734439]        [<c0010990>] ret_from_kernel_thread+0x64/0x6c
> [  807.735810] 
> [  807.735810] -> #0 ((&wl->firmware_load)){+.+.+.}:
> [  807.738389]        [<c0071b38>] lock_acquire+0x50/0x6c
> [  807.739694]        [<c0049d58>] flush_work+0x3c/0x2b0
> [  807.740980]        [<c004c30c>] __cancel_work_timer+0x94/0xec
> [  807.742271]        [<f64c748c>] b43_wireless_core_stop+0x5c/0x234 [b43]
> [  807.743574]        [<f64c76b0>] b43_op_stop+0x4c/0x88 [b43]
> [  807.744888]        [<f64a4c08>] ieee80211_stop_device+0x4c/0x8c [mac80211]
> [  807.746240]        [<f64913a8>] ieee80211_do_stop+0x2c0/0x5dc [mac80211]
> [  807.747582]        [<f64916dc>] ieee80211_stop+0x18/0x2c [mac80211]
> [  807.748925]        [<c0423d94>] __dev_close_many+0xb0/0x100
> [  807.750257]        [<c0423e10>] __dev_close+0x2c/0x4c
> [  807.751560]        [<c0427514>] __dev_change_flags+0x124/0x178
> [  807.752868]        [<c042761c>] dev_change_flags+0x1c/0x64
> [  807.754177]        [<c047db9c>] devinet_ioctl+0x69c/0x74c
> [  807.755459]        [<c047ecf8>] inet_ioctl+0xcc/0xf8
> [  807.756709]        [<c040eab0>] sock_ioctl+0x70/0x2e8
> [  807.757948]        [<c00d9f70>] do_vfs_ioctl+0xa4/0x7c0
> [  807.759182]        [<c00da6d0>] sys_ioctl+0x44/0x70
> [  807.760407]        [<c001084c>] ret_from_syscall+0x0/0x38
> [  807.761622] 
> [  807.761622] other info that might help us debug this:
> [  807.761622] 
> [  807.765107]  Possible unsafe locking scenario:
> [  807.765107] 
> [  807.767412]        CPU0                    CPU1
> [  807.768561]        ----                    ----
> [  807.769690]   lock(rtnl_mutex);
> [  807.770822]                                lock((&wl->firmware_load));
> [  807.771970]                                lock(rtnl_mutex);
> [  807.773115]   lock((&wl->firmware_load));
> [  807.774244] 
> [  807.774244]  *** DEADLOCK ***
> [  807.774244] 
> [  807.777405] 1 lock held by wpa_supplicant/4129:
> [  807.778475]  #0:  (rtnl_mutex){+.+.+.}, at: [<c04362d4>] rtnl_lock+0x1c/0x2c
> [  807.779628] 
> [  807.779628] stack backtrace:
> [  807.781720] Call Trace:
> [  807.782765] [eea2db20] [c0009160] show_stack+0x48/0x15c (unreliable)
> [  807.784087] [eea2db60] [c04fae24] print_circular_bug+0x2b0/0x2c8
> [  807.785169] [eea2db90] [c0071300] __lock_acquire+0x14f4/0x18c8
> [  807.786254] [eea2dc30] [c0071b38] lock_acquire+0x50/0x6c
> [  807.787335] [eea2dc50] [c0049d58] flush_work+0x3c/0x2b0
> [  807.788418] [eea2dcc0] [c004c30c] __cancel_work_timer+0x94/0xec
> [  807.789516] [eea2dcf0] [f64c748c] b43_wireless_core_stop+0x5c/0x234 [b43]
> [  807.790629] [eea2dd20] [f64c76b0] b43_op_stop+0x4c/0x88 [b43]
> [  807.791754] [eea2dd40] [f64a4c08] ieee80211_stop_device+0x4c/0x8c [mac80211]
> [  807.792888] [eea2dd50] [f64913a8] ieee80211_do_stop+0x2c0/0x5dc [mac80211]
> [  807.794016] [eea2dd80] [f64916dc] ieee80211_stop+0x18/0x2c [mac80211]
> [  807.795124] [eea2dd90] [c0423d94] __dev_close_many+0xb0/0x100
> [  807.796237] [eea2ddb0] [c0423e10] __dev_close+0x2c/0x4c
> [  807.797345] [eea2ddd0] [c0427514] __dev_change_flags+0x124/0x178
> [  807.798451] [eea2ddf0] [c042761c] dev_change_flags+0x1c/0x64
> [  807.799564] [eea2de10] [c047db9c] devinet_ioctl+0x69c/0x74c
> [  807.800680] [eea2de70] [c047ecf8] inet_ioctl+0xcc/0xf8
> [  807.801792] [eea2de80] [c040eab0] sock_ioctl+0x70/0x2e8
> [  807.802905] [eea2dea0] [c00d9f70] do_vfs_ioctl+0xa4/0x7c0
> [  807.804025] [eea2df10] [c00da6d0] sys_ioctl+0x44/0x70
> [  807.805145] [eea2df40] [c001084c] ret_from_syscall+0x0/0x38
> [  807.806270] --- Exception: c01 at 0xfbf2758
> [  807.806270]     LR = 0xfbf26bc
> 
> [  850.445766] b43-phy1: Broadcom 4306 WLAN found (core revision 5)
> [  850.469062] b43-phy1: Found PHY: Analog 2, Type 2 (G), Revision 2
> [  850.493199] Broadcom 43xx driver loaded [ Features: P ]
> [  850.497448] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
> [  860.820792] b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
> 
> 




