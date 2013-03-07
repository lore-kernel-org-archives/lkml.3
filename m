Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab3CGT7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:59:39 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:61371 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3CGT7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:59:33 -0500
MIME-Version: 1.0
Date: Thu, 7 Mar 2013 21:59:32 +0200
Message-ID: <CA+ydwtpxXb2SSpyG9vn7mvvRU6Z+1BhOe5qi+QXf-6+E_iZ3kg@mail.gmail.com>
Subject: snd_seq_timer_open() NULL pointer dereference
From: Tommi Rantala <tt.rantala@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm hitting this while fuzzing the kernel with Trinity:

[  239.006244] BUG: unable to handle kernel NULL pointer dereference
at 00000000000002ae
[  239.007011] IP: [<ffffffff819b3477>] snd_seq_timer_open+0xe7/0x130
[  239.007011] PGD 785cd067 PUD 76964067 PMD 0
[  239.007011] Oops: 0002 [#4] SMP
[  239.007011] CPU 0
[  239.007011] Pid: 4288, comm: trinity-child7 Tainted: G      D W
3.9.0-rc1+ #100 Bochs Bochs
[  239.007011] RIP: 0010:[<ffffffff819b3477>]  [<ffffffff819b3477>]
snd_seq_timer_open+0xe7/0x130
[  239.007011] RSP: 0018:ffff88006ece7d38  EFLAGS: 00010246
[  239.007011] RAX: 0000000000000286 RBX: ffff88007851b400 RCX: 0000000000000000
[  239.007011] RDX: 000000000000ffff RSI: ffff88006ece7d58 RDI: ffff88006ece7d38
[  239.007011] RBP: ffff88006ece7d98 R08: 000000000000000a R09: 000000000000fffe
[  239.007011] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  239.007011] R13: ffff8800792c5400 R14: 0000000000e8f000 R15: 0000000000000007
[  239.007011] FS:  00007f7aaa650700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[  239.007011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  239.007011] CR2: 00000000000002ae CR3: 000000006efec000 CR4: 00000000000006f0
[  239.007011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  239.007011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  239.007011] Process trinity-child7 (pid: 4288, threadinfo
ffff88006ece6000, task ffff880076a8a290)
[  239.007011] Stack:
[  239.007011]  0000000000000286 ffffffff828f2be0 ffff88006ece7d58
ffffffff810f354d
[  239.007011]  65636e6575716573 2065756575712072 ffff8800792c0030
0000000000000000
[  239.007011]  ffff88006ece7d98 ffff8800792c5400 ffff88007851b400
ffff8800792c5520
[  239.007011] Call Trace:
[  239.007011]  [<ffffffff810f354d>] ? trace_hardirqs_on+0xd/0x10
[  239.007011]  [<ffffffff819b17e9>] snd_seq_queue_timer_open+0x29/0x70
[  239.007011]  [<ffffffff819ae01a>] snd_seq_ioctl_set_queue_timer+0xda/0x120
[  239.007011]  [<ffffffff819acb9b>] snd_seq_do_ioctl+0x9b/0xd0
[  239.007011]  [<ffffffff819acbe0>] snd_seq_ioctl+0x10/0x20
[  239.007011]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
[  239.007011]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
[  239.007011]  [<ffffffff810f354d>] ? trace_hardirqs_on+0xd/0x10
[  239.007011]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[  239.007011]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  239.007011]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
[  239.007011] Code: e8 ef b4 fd ff 85 c0 41 89 c4 79 18 44 89 e6 48
c7 c7 e0 f0 5f 82 31 c0 e8 e7 34 5e 00 eb 35 0f 1f 44 00 00 48 8b 45
a0 45 31 e4 <48> c7 40 28 e0 2e 9b 81 4c 89 68 38 83 48 10 08 48 89 43
50 eb
[  239.007011] RIP  [<ffffffff819b3477>] snd_seq_timer_open+0xe7/0x130
[  239.007011]  RSP <ffff88006ece7d38>
[  239.007011] CR2: 00000000000002ae
[  239.055294] ---[ end trace bfb5b965ff1d73a3 ]---

Tommi
