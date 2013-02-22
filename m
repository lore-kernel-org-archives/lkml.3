Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3BVO32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:29:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28940 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab3BVO3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:29:22 -0500
Message-ID: <512780B0.9040508@oracle.com>
Date: Fri, 22 Feb 2013 09:29:04 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: dougthompson@xmission.com
CC: linux-edac@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: edac: NULL deref when handling sysfs write
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel
I've stumbled on the following spew:


[ 2060.023557] Invalid bank value!
[ 2060.029076] [Hardware Error]: MC0 Error:
[ 2060.030515] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 2060.032038] IP: [<          (null)>]           (null)
[ 2060.034697] PGD 5e08b067 PUD b46cc067 PMD 650d3067 PTE 63b1225
[ 2060.036896] Oops: 0003 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[ 2060.037985] Modules linked in:
[ 2060.039759] CPU 1
[ 2060.040113] Pid: 3347, comm: trinity Tainted: G      D W    3.8.0-next-20130221-sasha-00038-g655a782-dirty #9
[ 2060.040311] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[ 2060.040311] RSP: 0018:ffff88005ed57af0  EFLAGS: 00010287
[ 2060.040311] RAX: 0000000000000000 RBX: ffffffff87141d20 RCX: 000000002c052c04
[ 2060.040311] RDX: ffff880061d78000 RSI: 0000000000000000 RDI: 0000000000000000
[ 2060.040311] RBP: ffff88005ed57b78 R08: 0000000000000002 R09: 0000000000000000
[ 2060.040311] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000001d6680
[ 2060.040311] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800bb600000
[ 2060.040311] FS:  00007f42a4a20700(0000) GS:ffff8800bb800000(0000) knlGS:0000000000000000
[ 2060.040311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2060.040311] CR2: 0000000000000000 CR3: 00000000920f2000 CR4: 00000000000406e0
[ 2060.040311] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2060.040311] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2060.040311] Process trinity (pid: 3347, threadinfo ffff88005ed56000, task ffff880061d78000)
[ 2060.079801] can: request_module (can-proto-3) failed.
[ 2060.040311] Stack:
[ 2060.040311]  ffffffff83394f95 0000000000000002 0000000000000000 ffff88005ed57b88
[ 2060.040311]  0000000000000286 ffff880065031000 ffff88005ed57b90 ffff88005ed57c70
[ 2060.040311]  ffff88005ed57b68 ffffffff81a3568c 0000000a00000286 0000000022222222
[ 2060.040311] Call Trace:
[ 2060.040311]  [<ffffffff83394f95>] ? amd_decode_mce+0xf5/0x880
[ 2060.040311]  [<ffffffff81a3568c>] ? _kstrtoull+0x2c/0x90
[ 2060.040311]  [<ffffffff833942b7>] edac_inject_bank_store+0x87/0xa0
[ 2060.040311]  [<ffffffff8130e21b>] ? sysfs_write_file+0xeb/0x150
[ 2060.040311]  [<ffffffff81a238cf>] kobj_attr_store+0xf/0x20
[ 2060.040311]  [<ffffffff8130e233>] sysfs_write_file+0x103/0x150
[ 2060.040311]  [<ffffffff81296e6e>] ? alloc_pipe_info+0x3e/0xa0
[ 2060.040311]  [<ffffffff8128d970>] vfs_write+0xb0/0x180
[ 2060.040311]  [<ffffffff812c012f>] write_pipe_buf+0x6f/0xb0
[ 2060.040311]  [<ffffffff812c00c0>] ? do_splice_to+0xb0/0xb0
[ 2060.040311]  [<ffffffff812bfa5c>] splice_from_pipe_feed+0x7c/0x120
[ 2060.040311]  [<ffffffff812c00c0>] ? do_splice_to+0xb0/0xb0
[ 2060.040311]  [<ffffffff812bff05>] __splice_from_pipe+0x45/0x80
[ 2060.040311]  [<ffffffff812c00c0>] ? do_splice_to+0xb0/0xb0
[ 2060.040311]  [<ffffffff812c19dc>] splice_from_pipe+0x4c/0x70
[ 2060.040311]  [<ffffffff812c1a18>] default_file_splice_write+0x18/0x30
[ 2060.040311]  [<ffffffff812bffc3>] do_splice_from+0x83/0xb0
[ 2060.040311]  [<ffffffff812c000e>] direct_splice_actor+0x1e/0x20
[ 2060.040311]  [<ffffffff812c0747>] splice_direct_to_actor+0xe7/0x200
[ 2060.040311]  [<ffffffff812bfff0>] ? do_splice_from+0xb0/0xb0
[ 2060.040311]  [<ffffffff812c1a9c>] do_splice_direct+0x4c/0x70
[ 2060.040311]  [<ffffffff8128e829>] do_sendfile+0x179/0x310
[ 2060.040311]  [<ffffffff8128ead4>] sys_sendfile64+0x64/0xb0
[ 2060.040311]  [<ffffffff83db10d8>] tracesys+0xe1/0xe6
[ 2060.040311] Code:  Bad RIP value.
[ 2060.040311] RIP  [<          (null)>]           (null)
[ 2060.040311]  RSP <ffff88005ed57af0>
[ 2060.040311] CR2: 0000000000000000
[ 2060.176086] ---[ end trace d40d4e0b7f844b95 ]---


Thanks,
Sasha
