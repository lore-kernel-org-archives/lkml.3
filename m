Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab3KTHvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:51:13 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:59773 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3KTHvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:51:10 -0500
Date: Wed, 20 Nov 2013 09:51:02 +0200
From: Johan Hedberg <johan.hedberg@intel.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: OOPS: Bluetooth: Store RFCOMM address information in its own
 socket structure
Message-ID: <20131120075102.GA13210@x220.p-661hnu-f1>
References: <528C2A68.1000304@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528C2A68.1000304@ubuntu.com>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

On Tue, Nov 19, 2013, Phillip Susi wrote:
> Bisected an OOPS to this commit:
> 
> commit 94a86df01082557e2de45865e538d7fb6c46231c
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Sun Oct 13 10:34:02 2013 -0700
> 
>     Bluetooth: Store RFCOMM address information in its own socket structure
> 
>     The address information of RFCOMM sockets should be stored in its
>     own socket structure. Trying to generalize them is not helpful since
>     different transports have different address types.
> 
>     Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
>     Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
> 
> OOPS looks like:
> 
> [   16.636145] BUG: unable to handle kernel paging request at 000000268333770b
> [   16.637771] IP: [<ffffffffa01d7c78>] rfcomm_sock_getsockopt+0xe8/0x220 [rfcomm]
> [   16.639350] PGD 0 
> [   16.640875] Oops: 0000 [#11] SMP 
> [   16.642394] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec joydev snd_hwdep snd_pcm snd_page_alloc snd_seq_midi radeon snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore ttm dm_multipath scsi_dh drm_kms_helper microcode(+) drm btusb i2c_algo_bit lpc_ich psmouse wmi serio_raw bnep rfcomm bluetooth binfmt_misc btrfs xor raid6_pq libcrc32c hid_generic hid_microsoft usbhid hid e1000e ahci libahci ptp pps_core
> [   16.645718] CPU: 1 PID: 968 Comm: bluetoothd Tainted: G      D      3.12.0+ #74
> [   16.647369] Hardware name: System manufacturer System Product Name/P8P67 PRO REV 3.1, BIOS 1904 08/15/2011
> [   16.649030] task: ffff8801262d8000 ti: ffff8800c772c000 task.ti: ffff8800c772c000
> [   16.650693] RIP: 0010:[<ffffffffa01d7c78>]  [<ffffffffa01d7c78>] rfcomm_sock_getsockopt+0xe8/0x220 [rfcomm]
> [   16.652372] RSP: 0018:ffff8800c772df08  EFLAGS: 00010246
> [   16.654118] RAX: 000000268333770b RBX: ffff8800c9156080 RCX: 00007fff67e9cd98
> [   16.655800] RDX: 0000000000000003 RSI: 0000000000000012 RDI: ffff8800c9156080
> [   16.657445] RBP: ffff8800c772df38 R08: 00007fff67e9cd9c R09: 00007fff67e9d018
> [   16.659055] R10: 00007fff67e9cd98 R11: 0000000000000202 R12: ffff880036dbd800
> [   16.660624] R13: 00007fff67e9cd98 R14: 0000000000000003 R15: 00007fff67e9cd9c
> [   16.662190] FS:  00007f1cfe1a1740(0000) GS:ffff88012f480000(0000) knlGS:0000000000000000
> [   16.663742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.665284] CR2: 000000268333770b CR3: 00000000c746b000 CR4: 00000000000407e0
> [   16.666823] Stack:
> [   16.668353]  00038800c772df30 ffff8800c9156080 0000000000000012 0000000000000003
> [   16.669906]  00007fff67e9cd98 00007fff67e9cd9c ffff8800c772df78 ffffffff8155ff38
> [   16.671460]  0000000000000000 0000000000000001 00007fff67e9d018 0000000000000001
> [   16.673016] Call Trace:
> [   16.674562]  [<ffffffff8155ff38>] SyS_getsockopt+0x68/0xd0
> [   16.676111]  [<ffffffff81672356>] system_call_fastpath+0x1a/0x1f
> [   16.677651] Code: 00 4c 89 e7 e8 1a bf 38 e1 45 89 f1 48 83 c4 08 44 89 c8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 49 8b 84 24 e8 02 00 00 <48> 8b 18 4c 89 c0 e8 dd 91 14 e1 85 c0 49 89 d7 41 b9 f2 ff ff 
> [   16.679393] RIP  [<ffffffffa01d7c78>] rfcomm_sock_getsockopt+0xe8/0x220 [rfcomm]
> [   16.681022]  RSP <ffff8800c772df08>
> [   16.682639] CR2: 000000268333770b
> [   16.684262] ---[ end trace a5f6978e71640635 ]---

I have a feeling this one was already fixed but just hasn't propagated
itself to the upstream trees. The fix should already available in
the wireless.git and bluetooth.git trees though.

Johan
