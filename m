Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3EITHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:07:00 -0400
Received: from mout.gmx.net ([212.227.17.22]:58953 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3EITG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:06:58 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+UOgJ870mUIrCJoxQwTGzJcn0Px6SLGLMuFhipfw
	O/iQbx4WZytDeJ
Message-ID: <518BF3CF.10405@gmx.de>
Date: Thu, 09 May 2013 21:06:55 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: BUG: spinlock recursion on CPU#0, rngd/899
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following issue occurred at a user mode linux (32bit stable Gentoo),
forced by a trinity run :



2013-05-09T20:51:24.296+02:00 trinity kernel: BUG: spinlock recursion on CPU#0, rngd/899
2013-05-09T20:51:24.296+02:00 trinity kernel: lock: 0x843946c, .magic: dead4ead, .owner: rngd/899, .owner_cpu: 0
2013-05-09T20:51:24.296+02:00 trinity kernel: CPU: 0 PID: 899 Comm: rngd Not tainted 3.9.0-11791-geaf38eb #24
2013-05-09T20:51:24.296+02:00 trinity kernel: 40117990 401179c0 0835eeba 083f3d78 0843946c dead4ead 41e1c7b0 00000383 
2013-05-09T20:51:24.296+02:00 trinity kernel: 00000000 40110000 0843946c 083f3c56 401179d0 0835eedc 0843946c 00000008 
2013-05-09T20:51:24.296+02:00 trinity kernel: 401179f0 082825ce 080a2095 08441880 40110000 00000000 00000008 00000000 40117964:  [<08060d2f>] show_stack+0xcf/0x100
2013-05-09T20:51:24.296+02:00 trinity kernel: 40117988:  [<0835eda9>] dump_stack+0x26/0x28
2013-05-09T20:51:24.296+02:00 trinity kernel: 40117998:  [<0835eeba>] spin_dump+0xa5/0xac
2013-05-09T20:51:24.296+02:00 trinity kernel: 401179c4:  [<0835eedc>] spin_bug+0x1b/0x1f
2013-05-09T20:51:24.296+02:00 trinity kernel: 401179d4:  [<082825ce>] do_raw_spin_lock+0x4e/0x100
2013-05-09T20:51:24.301+02:00 trinity kernel: 401179f4:  [<08361431>] _raw_spin_lock+0x11/0x20
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117a00:  [<08060852>] sigio_lock+0x12/0x20
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117a0c:  [<080714d4>] add_sigio_fd+0x14/0x100
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117a34:  [<0805ed7a>] reactivate_fd+0x6a/0x80
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117a50:  [<080607c7>] sigio_interrupt+0x37/0x40
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117a68:  [<080c6ddf>] handle_irq_event_percpu+0x2f/0x150
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117a98:  [<080c6f3a>] handle_irq_event+0x3a/0x60
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117ab4:  [<080c9350>] handle_edge_irq+0xe0/0x110
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117ac8:  [<080c678b>] generic_handle_irq+0x2b/0x30
2013-05-09T20:51:24.301+02:00 trinity kernel: 40117ad8:  [<0805ee75>] do_IRQ+0x25/0x40
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117ae8:  [<0805eef5>] sigio_handler+0x65/0x80
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117b00:  [<08071d58>] sig_handler_common+0xb8/0xe0
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117d84:  [<08071c7b>] unblock_signals+0x4b/0x70
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117d90:  [<08071dfe>] set_signals+0x1e/0x40
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117d9c:  [<080713ad>] update_thread+0x13d/0x150
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117dc0:  [<08071599>] add_sigio_fd+0xd9/0x100
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117de8:  [<0805ed7a>] reactivate_fd+0x6a/0x80
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117e04:  [<0806e41b>] rng_dev_read+0x17b/0x270
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117e44:  [<081016be>] vfs_read+0x9e/0x170
2013-05-09T20:51:24.307+02:00 trinity kernel: 40117e78:  [<08101bbe>] SyS_read+0x5e/0x90
2013-05-09T20:51:24.311+02:00 trinity kernel: 40117eac:  [<08062ac2>] handle_syscall+0x82/0xb0
2013-05-09T20:51:24.311+02:00 trinity kernel: 40117ef4:  [<0807519d>] userspace+0x46d/0x590
2013-05-09T20:51:24.311+02:00 trinity kernel: 40117fec:  [<0805f82c>] fork_handler+0x6c/0x70
2013-05-09T20:51:24.311+02:00 trinity kernel: 40117ffc:  [<00000000>] 0x0
2013-05-09T20:51:24.311+02:00 trinity kernel: 
2013-05-09T20:51:24.311+02:00 trinity kernel: BUG: spinlock lockup suspected on CPU#0, rngd/899
2013-05-09T20:51:24.311+02:00 trinity kernel: lock: 0x843946c, .magic: dead4ead, .owner: rngd/899, .owner_cpu: 0
2013-05-09T20:51:24.311+02:00 trinity kernel: CPU: 0 PID: 899 Comm: rngd Not tainted 3.9.0-11791-geaf38eb #24
2013-05-09T20:51:24.311+02:00 trinity kernel: 401179a0 401179d0 0835eeba 083f3d78 0843946c dead4ead 41e1c7b0 00000383 
2013-05-09T20:51:24.311+02:00 trinity kernel: 00000000 40110000 0843946c 1d2cc000 401179f0 08282649 00000001 1d2cc000 
2013-05-09T20:51:24.315+02:00 trinity kernel: 40110000 00000000 00000008 00000000 401179fc 08361431 0843946c 40117a08 40117974:  [<08060d2f>] show_stack+0xcf/0x100
2013-05-09T20:51:24.315+02:00 trinity kernel: 40117998:  [<0835eda9>] dump_stack+0x26/0x28
2013-05-09T20:51:24.315+02:00 trinity kernel: 401179a8:  [<0835eeba>] spin_dump+0xa5/0xac
2013-05-09T20:51:24.315+02:00 trinity kernel: 401179d4:  [<08282649>] do_raw_spin_lock+0xc9/0x100
2013-05-09T20:51:24.315+02:00 trinity kernel: 401179f4:  [<08361431>] _raw_spin_lock+0x11/0x20
2013-05-09T20:51:24.315+02:00 trinity kernel: 40117a00:  [<08060852>] sigio_lock+0x12/0x20
2013-05-09T20:51:24.315+02:00 trinity kernel: 40117a0c:  [<080714d4>] add_sigio_fd+0x14/0x100
2013-05-09T20:51:24.315+02:00 trinity kernel: 40117a34:  [<0805ed7a>] reactivate_fd+0x6a/0x80
2013-05-09T20:51:24.315+02:00 trinity kernel: 40117a50:  [<080607c7>] sigio_interrupt+0x37/0x40
2013-05-09T20:51:24.315+02:00 trinity kernel: 40117a68:  [<080c6ddf>] handle_irq_event_percpu+0x2f/0x150
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117a98:  [<080c6f3a>] handle_irq_event+0x3a/0x60
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117ab4:  [<080c9350>] handle_edge_irq+0xe0/0x110
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117ac8:  [<080c678b>] generic_handle_irq+0x2b/0x30
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117ad8:  [<0805ee75>] do_IRQ+0x25/0x40
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117ae8:  [<0805eef5>] sigio_handler+0x65/0x80
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117b00:  [<08071d58>] sig_handler_common+0xb8/0xe0
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117d84:  [<08071c7b>] unblock_signals+0x4b/0x70
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117d90:  [<08071dfe>] set_signals+0x1e/0x40
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117d9c:  [<080713ad>] update_thread+0x13d/0x150
2013-05-09T20:51:24.371+02:00 trinity kernel: 40117dc0:  [<08071599>] add_sigio_fd+0xd9/0x100
2013-05-09T20:51:24.388+02:00 trinity kernel: 40117de8:  [<0805ed7a>] reactivate_fd+0x6a/0x80
2013-05-09T20:51:24.388+02:00 trinity kernel: 40117e04:  [<0806e41b>] rng_dev_read+0x17b/0x270
2013-05-09T20:51:24.388+02:00 trinity kernel: 40117e44:  [<081016be>] vfs_read+0x9e/0x170
2013-05-09T20:51:24.388+02:00 trinity kernel: 40117e78:  [<08101bbe>] SyS_read+0x5e/0x90
2013-05-09T20:51:24.388+02:00 trinity kernel: 40117eac:  [<08062ac2>] handle_syscall+0x82/0xb0
2013-05-09T20:51:24.388+02:00 trinity kernel: 40117ef4:  [<0807519d>] userspace+0x46d/0x590
2013-05-09T20:51:24.388+02:00 trinity kernel: 40117fec:  [<0805f82c>] fork_handler+0x6c/0x70
2013-05-09T20:51:24.388+02:00 trinity kernel: 40117ffc:  [<00000000>] 0x0
2013-05-09T20:51:24.388+02:00 trinity kernel: 
2013-05-09T20:51:24.388+02:00 trinity kernel: BUG: spinlock lockup suspected on CPU#0, rngd/899
2013-05-09T20:51:24.398+02:00 trinity kernel: lock: 0x843946c, .magic: dead4ead, .owner: rngd/899, .owner_cpu: 0
2013-05-09T20:51:24.398+02:00 trinity kernel: CPU: 0 PID: 899 Comm: rngd Not tainted 3.9.0-11791-geaf38eb #24
2013-05-09T20:51:24.398+02:00 trinity kernel: 401179bc 401179ec 0835eeba 083f3d78 0843946c dead4ead 41e1c7b0 00000383
2013-05-09T20:51:24.398+02:00 trinity kernel: 00000000 40110000 0843946c 1d2cc000 40117a0c 08282649 00000001 1d2cc000
2013-05-09T20:51:24.398+02:00 trinity kernel: 40110000 00000000 00000008 00000000 40117a18 08361431 0843946c 40117a24 40117990:  [<08060d2f>] show_stack+0xcf/0x100
2013-05-09T20:51:24.398+02:00 trinity kernel: 401179b4:  [<0835eda9>] dump_stack+0x26/0x28
2013-05-09T20:51:24.398+02:00 trinity kernel: 401179c4:  [<0835eeba>] spin_dump+0xa5/0xac
2013-05-09T20:51:24.398+02:00 trinity kernel: 401179f0:  [<08282649>] do_raw_spin_lock+0xc9/0x100
2013-05-09T20:51:24.398+02:00 trinity kernel: 40117a10:  [<08361431>] _raw_spin_lock+0x11/0x20
2013-05-09T20:51:24.398+02:00 trinity kernel: 40117a1c:  [<08060852>] sigio_lock+0x12/0x20
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117a28:  [<080714d4>] add_sigio_fd+0x14/0x100
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117a50:  [<0805ed7a>] reactivate_fd+0x6a/0x80
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117a6c:  [<080607c7>] sigio_interrupt+0x37/0x40
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117a84:  [<080c6ddf>] handle_irq_event_percpu+0x2f/0x150
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117ab4:  [<080c6f3a>] handle_irq_event+0x3a/0x60
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117ad0:  [<080c9350>] handle_edge_irq+0xe0/0x110
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117ae4:  [<080c678b>] generic_handle_irq+0x2b/0x30
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117af4:  [<0805ee75>] do_IRQ+0x25/0x40
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117b04:  [<0805eef5>] sigio_handler+0x65/0x80
2013-05-09T20:51:24.408+02:00 trinity kernel: 40117b1c:  [<08071d58>] sig_handler_common+0xb8/0xe0
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117da0:  [<08071c7b>] unblock_signals+0x4b/0x70
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117dac:  [<08071dfe>] set_signals+0x1e/0x40
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117db8:  [<080713ad>] update_thread+0x13d/0x150
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117ddc:  [<08071599>] add_sigio_fd+0xd9/0x100
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117e04:  [<0806e428>] rng_dev_read+0x188/0x270
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117e44:  [<081016be>] vfs_read+0x9e/0x170
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117e78:  [<08101bbe>] SyS_read+0x5e/0x90
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117eac:  [<08062ac2>] handle_syscall+0x82/0xb0
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117ef4:  [<0807519d>] userspace+0x46d/0x590
2013-05-09T20:51:24.416+02:00 trinity kernel: 40117fec:  [<0805f82c>] fork_handler+0x6c/0x70
2013-05-09T20:51:24.418+02:00 trinity kernel: 40117ffc:  [<00000000>] 0x0
2013-05-09T20:51:24.418+02:00 trinity kernel:

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
