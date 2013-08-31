Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3HaKMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 06:12:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40048 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3HaKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 06:12:03 -0400
Date: Sat, 31 Aug 2013 12:12:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: 3.10: unpriviledged user crashes kernel using bluetooth
Message-ID: <20130831101201.GB7029@amd.pavel.ucw.cz>
References: <20130831100127.GA6711@amd.pavel.ucw.cz>
 <20130831100933.GA7029@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831100933.GA7029@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-08-31 12:09:33, Pavel Machek wrote:
> Hi!
> 
> > . Python sources for client/server are at 
> > 
> > http://tui.cvs.sourceforge.net/viewvc/tui/tui/liveview/
> > 
> > . My kernels like to warn about
> > 
> > Aug 31 11:46:37 duo kernel: WARNING: CPU: 1 PID: 1 at
> > net/wireless/reg.c:423 regulatory_init+0x92/0xff()
> > Aug 31 11:46:37 duo kernel: db.txt is empty, you should update it...
> > 
> > . 3.10 does not seem to be affected.
> 
> When I said 3.10 was not affected, I was wrong. 3.10 survived the
> test, but when I attempted to reboot the box, I got 
> 
> WARNING: at lib/list_debug.c:59 __list_del_entry+0xac/0xe0()
> list_del_corruption. prev->next should be f44fffd4, but was f44c402c
> ...
> ...Comm: bluetoothd....
> Call trace:
> ...
> __list_del_entry
> cd_forget
> evict
> iput

Aha, I have even better dump in the logs:

<6>cfg80211: Calling CRDA to update world regulatory domain
<6>wlan0: authenticate with 00:11:95:05:30:d7
<6>wlan0: send auth to 00:11:95:05:30:d7 (try 1/3)
<6>iwl3945 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not
supported by the AP
<6>iwl3945 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not
supported by the AP
<6>wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x401 status=0
aid=2)
<6>wlan0: associated
<4>the code is fine but needs lockdep annotation.
<4>turning off the locking correctness validator.
<4> edd4cc30 f3187db0 c095a48c f3187df0 c027c43e c0b27dcc f5f71670
00000000
<4> 00000000 f3187df4 00000246 edd4cc30 c10253b0 00000000 00000000
c10253b0
<4> [<c095a48c>] dump_stack+0x16/0x18
<4> [<c027c43e>] __lock_acquire+0x71e/0xcf0
<4> [<c027ca74>] lock_acquire+0x64/0x80
<4> [<c04e59ec>] ? tty_buffer_flush+0x1c/0xd0
<4> [<c095d52b>] _raw_spin_lock_irqsave+0x3b/0x50
<4> [<c04e59ec>] ? tty_buffer_flush+0x1c/0xd0
<4> [<c04e59ec>] tty_buffer_flush+0x1c/0xd0
<4> [<c04df38f>] tty_ioctl+0x5bf/0xa80
<4> [<c027c0a6>] ? __lock_acquire+0x386/0xcf0
<4> [<c02e4899>] do_vfs_ioctl+0x89/0x5b0
<4> [<c0455873>] ? debug_check_no_obj_freed+0xe3/0x190
<4> [<c02e2ac8>] ? final_putname+0x18/0x40
<4> [<c095e4b8>] sysenter_do_call+0x12/0x31
<6>wlan0: deauthenticated from 00:11:95:05:30:d7 (Reason: 3)
<6>cfg80211: Calling CRDA to update world regulatory domain
<6>wlan0: authenticate with 00:11:95:05:30:d7
<6>wlan0: send auth to 00:11:95:05:30:d7 (try 1/3)
<6>wlan0: authenticated
<6>iwl3945 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not
supported by the AP
<6>iwl3945 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not
supported by the AP
<6>wlan0: associate with 00:11:95:05:30:d7 (try 1/3)
<6>wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x401 status=0
aid=2)
<6>wlan0: associated
<6>wlan0: deauthenticated from 00:11:95:05:30:d7 (Reason: 3)
<6>cfg80211: Calling CRDA to update world regulatory domain
<6>wlan0: authenticated
<6>iwl3945 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not
supported by the AP
<6>iwl3945 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not
supported by the AP

Broadcast message from root@duo (console) (Sat Aug 31 12:05:57 2013):

The system is going down for reboot NOW!
<7>uhci_hcd 0000:00:1d.3: release dev 2 ep81-INT, period 1, phase 0,
23 us
<4>WARNING: at lib/list_debug.c:59 __list_del_entry+0xac/0xe0()
<4>list_del corruption. prev->next should be f44fffd4, but was
f44c402c
<4>Modules linked in:
<4>CPU: 0 PID: 2801 Comm: bluetoothd Tainted: G        W    3.10.0+
#293
<4>Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )
03/31/2011
<4> 0000003b f0933e14 c095a48c f0933e3c c022c96f c0b47bcc f0933e68
0000003b
<4> c0454ddc c0454ddc f44c402c f44fffd4 f44c4000 f0933e54 c022ca0e
00000009
<4> f0933e4c c0b47bcc f0933e68 f0933e74 c0454ddc c0b474dd 0000003b
c0b47bcc
<4>Call Trace:
<4> [<c095a48c>] dump_stack+0x16/0x18
<4> [<c022c96f>] warn_slowpath_common+0x5f/0x80
<4> [<c0454ddc>] ? __list_del_entry+0xac/0xe0
<4> [<c0454ddc>] ? __list_del_entry+0xac/0xe0
<4> [<c0454ddc>] __list_del_entry+0xac/0xe0
<4> [<c02d9276>] cd_forget+0x26/0x60
<4> [<c02ebc69>] evict+0x119/0x170
<4> [<c02ebda6>] iput+0xe6/0x170
<4> [<c02e950f>] d_kill+0xaf/0x100
<4> [<c02e9bf6>] dput+0xc6/0x170
<4> [<c02d6d84>] __fput+0x154/0x200
<4> [<c02d6e98>] ____fput+0x8/0x10
<4> [<c0247a61>] task_work_run+0x81/0xb0
<1>BUG: unable to handle kernel paging request at fffffffc
<1>IP: [<c02d3943>] filp_close+0x13/0x80
<4>*pde = 00d14067 *pte = 00000000 
<4>Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
<4>Modules linked in:
<0>CPU: 1 PID: 3735 Comm: python Tainted: G      D W    3.10.0+ #293
<0>Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )
03/31/2011
<0>task: f29c6670 ti: edf28000 task.ti: edf28000
<4>EIP: 0060:[<c02d3943>] EFLAGS: 00210282 CPU: 1
<4>EIP is at filp_close+0x13/0x80
<4>EAX: ffffffc0 EBX: ffffffc0 ECX: 00000000 EDX: ee297f00
<4>ESI: ee297f00 EDI: f4779be0 EBP: edf29de0 ESP: edf29dd0
<4> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<4>CR0: 8005003b CR2: fffffffc CR3: 00d13000 CR4: 00000710
<4>DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
<4>DR6: ffff0ff0 DR7: 00000400
<0>Stack:
<4> 00200246 00000000 0000001f f4779be0 edf29e0c c02ee2a5 00000002
00000001
<4> 00000000 c02ee21a 00000000 ee297f00 f29c6670 ee297f00 f29c6a54
edf29e20
<4> c02ee372 edfdadc0 f29c6670 f29c6a54 edf29e74 c0231e25 c02eff30
00000000
<0>Call Trace:
<4> [<c02ee2a5>] put_files_struct+0xa5/0x130
<4> [<c02ee21a>] ? put_files_struct+0x1a/0x130
<4> [<c02ee372>] exit_files+0x42/0x60
<4> [<c0231e25>] do_exit+0x205/0x850
<4> [<c02eff30>] ? mntput_no_expire+0x30/0xf0
<4> [<c023d454>] ? get_signal_to_deliver+0xa4/0x570
<4> [<c02324a9>] do_group_exit+0x39/0xa0
<4> [<c023d540>] get_signal_to_deliver+0x190/0x570
<4> [<c095db2d>] ? _raw_spin_unlock+0x1d/0x20
<4> [<c0201237>] do_signal+0x37/0x930
<4> [<c07eccc6>] ? sys_recv+0x36/0x40
<4> [<c07ecd7c>] ? SyS_socketcall+0xac/0x290
<4> [<c0201b68>] do_notify_resume+0x38/0x50
<4> [<c095dee2>] work_notifysig+0x24/0x2a
<0>Code: 09 3d fc fd ff ff 74 02 5d c3 b8 fc ff ff ff 5d c3 8d b4 26
00 00 00 00 55 89 e5 83 ec 10 89 5d f4 89 c3 89 75 f8 89 d6 89 7d fc
<8b> 40 3c 85 c0 74 4a 8b 43 14 85 c0 74 3f 8b 48 30 85 c9 74 38
<0>EIP: [<c02d3943>] filp_close+0x13/0x80 SS:ESP 0068:edf29dd0
<4>CR2: 00000000fffffffc
<4>---[ end trace 6a53890e7df0f3dc ]---
<1>Fixing recursive fault but reboot is needed!
<6>wlan0: deauthenticating from 00:11:95:05:30:d7 by local choice
(reason=3)
<6>cfg80211: Calling CRDA to update world regulatory domain

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
