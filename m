Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab3KOKSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:18:49 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:48311 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3KOKSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:18:39 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: recursive locking (coredump/vfs_write)
Date: Fri, 15 Nov 2013 11:18:35 +0100
Message-ID: <1531328.VGTlsG5iNH@al>
User-Agent: KMail/4.11.3 (Linux/3.12.0-1-custom; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20131113211147.GA30263@redhat.com>
References: <20131113211147.GA30263@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 13 November 2013 16:11:47 Dave Jones wrote:
> Hey Al,
> 
> here's another one..
> 
> [..]

I also saw this warning with a slightly different path.
Kernel is v3.12-7033-g42a2d92, the out-of-tree module below is unrelated
(bbswitch).

This was triggered when trying trying to get a coredump by running
/lib/libGL.so after manually changing kernel.core_pattern back to
"core" as systemd hijacked this setting.

libGL.so[23053]: segfault at 1 ip 0000000000000001 sp 00007fffc8829418 error 14 in mesa-libGL.so.1.2.0[7f7d9fa9c000+5a000]

=============================================
[ INFO: possible recursive locking detected ]
3.12.0-1-custom #1 Tainted: G           O
---------------------------------------------
libGL.so/23053 is trying to acquire lock:
 (sb_writers#3){.+.+.+}, at: [<ffffffff81175203>] vfs_write+0x173/0x1f0

but task is already holding lock:
 (sb_writers#3){.+.+.+}, at: [<ffffffff811d5c15>] do_coredump+0xdd5/0xf20

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sb_writers#3);
  lock(sb_writers#3);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by libGL.so/23053:
 #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811d5c15>] do_coredump+0xdd5/0xf20

stack backtrace:
CPU: 2 PID: 23053 Comm: libGL.so Tainted: G           O 3.12.0-1-custom #1
Hardware name: CLEVO CO.                        B7130                           /B7130                           , BIOS 6.00 08/27/2010
 ffffffff8207ac50 ffff8800ae1a1828 ffffffff815be016 ffffffff8207ac50
 ffff8800ae1a18f0 ffffffff810af393 000202d200000000 0000000000000246
 ffff88023bff4740 0000000000000001 0000000000000000 00000000003aa1d5
Call Trace:
 [<ffffffff815be016>] dump_stack+0x4d/0x66
 [<ffffffff810af393>] __lock_acquire+0x16c3/0x1a60
 [<ffffffff810adf8d>] ? __lock_acquire+0x2bd/0x1a60
 [<ffffffff810afec3>] lock_acquire+0x93/0x120
 [<ffffffff81175203>] ? vfs_write+0x173/0x1f0
 [<ffffffff811777e1>] __sb_start_write+0xc1/0x190
 [<ffffffff81175203>] ? vfs_write+0x173/0x1f0
 [<ffffffff81175203>] ? vfs_write+0x173/0x1f0
 [<ffffffff812a8ad3>] ? security_file_permission+0x23/0xa0
 [<ffffffff81175203>] vfs_write+0x173/0x1f0
 [<ffffffff811d4d07>] dump_emit+0x87/0xc0
 [<ffffffff811cd848>] elf_core_dump+0xcd8/0x14b0
 [<ffffffff811cd37e>] ? elf_core_dump+0x80e/0x14b0
 [<ffffffff810ad790>] ? mark_held_locks+0xb0/0x130
 [<ffffffff811d5a1a>] do_coredump+0xbda/0xf20
 [<ffffffff81056363>] ? __sigqueue_free.part.15+0x33/0x40
 [<ffffffff810ab1ed>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff81059cea>] get_signal_to_deliver+0x2aa/0x6a0
 [<ffffffff810023c8>] do_signal+0x48/0x960
 [<ffffffff81165fc5>] ? kmem_cache_free+0x95/0x1d0
 [<ffffffff81180a72>] ? final_putname+0x22/0x50
 [<ffffffff8116609e>] ? kmem_cache_free+0x16e/0x1d0
 [<ffffffff815c608d>] ? retint_signal+0x11/0x84
 [<ffffffff81002d45>] do_notify_resume+0x65/0x80
 [<ffffffff815c60c2>] retint_signal+0x46/0x84
