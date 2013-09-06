Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab3IFB2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:28:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7121 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3IFB2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:28:36 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BbXNHQx3NekA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fxhqf5xVK60A:10 a=20KFwNOVAAAA:8 a=h9ey2EYbBthl3LKSNv4A:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 5 Sep 2013 21:28:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130905212834.605408a4@gandalf.local.home>
In-Reply-To: <20130906011924.GA7970@redhat.com>
References: <20130906011924.GA7970@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013 21:19:24 -0400
Dave Jones <davej@redhat.com> wrote:

> For whatever dumb reason, when running 'make install' on a Fedora system,
> os-prober tries to figure out what filesystems are needed by loading filesystems,
> and seeing what sticks..  Today it blew up spectacularly when it got to
> loading reiserfs..  System wedged entirely afterwards.

Could it be that the reiserfs module was compiled differently than the
running kernel?

> 
> 	Dave
> 
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 30566 at kernel/trace/ftrace.c:1694 ftrace_bug+0x25d/0x270()
> Modules linked in: reiserfs(+) snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc xfs snd_timer libcrc32c snd e1000e ptp usb_debug pps_core pcspkr soundcore
> CPU: 2 PID: 30566 Comm: modprobe Not tainted 3.11.0+ #57 
>  ffffffff81a2809d ffff88008de19c30 ffffffff817171e9 0000000000000000
>  ffff88008de19c68 ffffffff81053dad 0000000000000010 ffffffffa02738b0
>  ffff8802419e3518 0000000000000000 ffff8801ab16e100 ffff88008de19c78
> Call Trace:
>  [<ffffffff817171e9>] dump_stack+0x54/0x74
>  [<ffffffff81053dad>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff81053e8a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8111924d>] ftrace_bug+0x25d/0x270
>  [<ffffffff81119568>] ftrace_process_locs+0x308/0x630
>  [<ffffffff811198cc>] ftrace_module_notify_enter+0x3c/0x40
>  [<ffffffff817257c6>] notifier_call_chain+0x66/0x150
>  [<ffffffff81088d97>] __blocking_notifier_call_chain+0x67/0xc0
>  [<ffffffff81088e06>] blocking_notifier_call_chain+0x16/0x20
>  [<ffffffff810d23cd>] load_module+0x1f7d/0x2680
>  [<ffffffff810cd6f0>] ? store_uevent+0x40/0x40
>  [<ffffffffa0240000>] ? reiserfs_xattr_register_handlers+0xf9f/0xf9f [reiserfs]
>  [<ffffffffa0240000>] ? reiserfs_xattr_register_handlers+0xf9f/0xf9f [reiserfs]
>  [<ffffffff810d2c66>] SyS_finit_module+0x86/0xb0
>  [<ffffffff8172aa14>] tracesys+0xdd/0xe2
> ---[ end trace 956db59f53237fe4 ]---
> ftrace failed to modify [<ffffffffa02738b0>] reiserfs_init_bitmap_cache+0x0/0xffffffffffff5750 [reiserfs]
>  actual: 14:00:00:00:00

Hmm, where it expected to see a call to mcount, instead is sees the
instruction:

 0x14 00 00 00 00


Can you do an objdump of that same binary, and show me what's located
at: reiserfs_init_bitmap_cache+0x0

-- Steve

> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 30566 at arch/x86/mm/pageattr.c:677 __cpa_process_fault+0x91/0xa0()
> CPA: called for zero pte. vaddr = ffffffffa0249000 cpa->vaddr = ffffffffa0249000
> Modules linked in: reiserfs(+) snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc xfs snd_timer libcrc32c snd e1000e ptp usb_debug pps_core pcspkr soundcore
> CPU: 2 PID: 30566 Comm: modprobe Tainted: G        W    3.11.0+ #57 
>  ffffffff81a0ba44 ffff88008de19b40 ffffffff817171e9 ffff88008de19b88
>  ffff88008de19b78 ffffffff81053dad ffff88008de19d08 00000000fffffff2
>  ffffffffa0249000 ffff880238646248 ffff88008de19d08 ffff88008de19bd8
> Call Trace:
>  [<ffffffff817171e9>] dump_stack+0x54/0x74
>  [<ffffffff81053dad>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffffa0249000>] ? reiserfs_xattr_register_handlers+0x9f9f/0x29f9f [reiserfs]
>  [<ffffffff81053e1c>] warn_slowpath_fmt+0x4c/0x50
>  [<ffffffffa0248000>] ? reiserfs_xattr_register_handlers+0x8f9f/0xf9f [reiserfs]
>  [<ffffffffa0249000>] ? reiserfs_xattr_register_handlers+0x9f9f/0x29f9f [reiserfs]
>  [<ffffffffa0249000>] ? reiserfs_xattr_register_handlers+0x9f9f/0x29f9f [reiserfs]
>  [<ffffffff8103b421>] __cpa_process_fault+0x91/0xa0
>  [<ffffffff8103b852>] __change_page_attr_set_clr+0x392/0xab0
>  [<ffffffffa023f000>] ? 0xffffffffa023efff
>  [<ffffffff8103c093>] change_page_attr_set_clr+0x123/0x460
>  [<ffffffffa023f000>] ? 0xffffffffa023efff
>  [<ffffffff8103c86f>] set_memory_ro+0x2f/0x40
>  [<ffffffffa0249000>] ? reiserfs_xattr_register_handlers+0x9f9f/0x29f9f [reiserfs]
>  [<ffffffff81713e0d>] set_section_ro_nx+0x3a/0x71
>  [<ffffffff810d23ee>] load_module+0x1f9e/0x2680
>  [<ffffffff810cd6f0>] ? store_uevent+0x40/0x40
>  [<ffffffffa0240000>] ? reiserfs_xattr_register_handlers+0xf9f/0xf9f [reiserfs]
>  [<ffffffffa0240000>] ? reiserfs_xattr_register_handlers+0xf9f/0xf9f [reiserfs]
>  [<ffffffff810d2c66>] SyS_finit_module+0x86/0xb0
>  [<ffffffff8172aa14>] tracesys+0xdd/0xe2
> ---[ end trace 956db59f53237fe5 ]---
> Oops: 0003 [#1] SMP 
> Modules linked in: reiserfs snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc xfs snd_timer libcrc32c snd e1000e ptp usb_debug pps_core pcspkr soundcore
> CPU: 1 PID: 30571 Comm: modprobe Tainted: G        W    3.11.0+ #57 
> task: ffff8801238a0000 ti: ffff8801ab314000 task.ti: ffff8801ab314000
> RIP: 0010:[<ffffffff810d1a6b>]  [<ffffffff810d1a6b>] load_module+0x161b/0x2680
> RSP: 0018:ffff8801ab315dc0  EFLAGS: 00010202
> RAX: ffffffffa009c000 RBX: ffff8801ab315ef8 RCX: ffffffffa00c2000
> RDX: ffffffffa00c2000 RSI: 0000005500000000 RDI: ffffffffa00c3f98
> RBP: ffff8801ab315ee8 R08: ffffffffa009fa68 R09: ffffffffa009c000
> R10: ffffffffa00c3f98 R11: 0000000000000002 R12: ffffffffa02d2838
> R13: 0000000000000001 R14: 0000000000000000 R15: ffffffffa02d2820
> FS:  00007f6f48b51740(0000) GS:ffff880245800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa00c2000 CR3: 00000002211e9000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Stack:
>  00000000003fa26b ffff8801238a0000 ffff8801ab315e48 ffff8801238a0000
>  ffffffffa009c000 ffffffffa02d2a58 ffffffffa02d2838 0000000000003a80
>  ffffffffa009c000 ffffffffa00c2000 0000003a94a10969 ffffffffa00c3f98
> Call Trace:
>  [<ffffffffa00c2000>] ? xfs_setattr_nonsize+0x240/0x5d0 [xfs]
>  [<ffffffffa00c3f98>] ? xfs_inumbers+0x248/0x420 [xfs]
>  [<ffffffff810cdeba>] ? copy_module_from_fd.isra.48+0x12a/0x190
>  [<ffffffff810d2c66>] SyS_finit_module+0x86/0xb0
>  [<ffffffff8172aa14>] tracesys+0xdd/0xe2
> Code: 48 83 7a 38 00 78 6a 48 8b 30 44 89 ea 4c 89 d7 48 8d 14 52 4c 89 4c 24 40 41 83 c5 01 48 8d 14 d1 48 89 4c 24 48 4c 89 54 24 58 <48> 89 32 48 8b 70 08 48 89 72 08 48 8b 70 10 48 89 72 10 4c 89 
> RIP  [<ffffffff810d1a6b>] load_module+0x161b/0x2680
>  RSP <ffff8801ab315dc0>
> CR2: ffffffffa00c2000
> ---[ end trace 956db59f53237fe6 ]---
> Oops: 0003 [#2] SMP 
> Modules linked in: reiserfs snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc xfs snd_timer libcrc32c snd e1000e ptp usb_debug pps_core pcspkr soundcore
> CPU: 3 PID: 30573 Comm: modprobe Tainted: G      D W    3.11.0+ #57 
> task: ffff8801238a2a60 ti: ffff8800939ec000 task.ti: ffff8800939ec000
> RIP: 0010:[<ffffffff810d1a6b>]  [<ffffffff810d1a6b>] load_module+0x161b/0x2680
> RSP: 0018:ffff8800939eddc0  EFLAGS: 00010202
> RAX: ffffffffa01d9000 RBX: ffff8800939edef8 RCX: ffffffffa01e6035
> RDX: ffffffffa01e6035 RSI: 0000005500000000 RDI: ffffffffa01e71ed
> RBP: ffff8800939edee8 R08: ffffffffa01db250 R09: ffffffffa01d9000
> R10: ffffffffa01e71ed R11: 0000000000000002 R12: ffffffffa0257138
> R13: 0000000000000001 R14: 0000000000000000 R15: ffffffffa0257120
> FS:  00007f8207d62740(0000) GS:ffff880245c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa01e6035 CR3: 000000009f46b000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Stack:
>  000000000016abca ffff8801238a2a60 ffff8800939ede48 ffff8801238a2a60
>  ffffffffa01d9000 ffffffffa0257358 ffffffffa0257138 0000000000002268
>  ffffffffa01d9000 ffffffffa01e6035 0000003a94a10969 ffffffffa01e71ed
> Call Trace:
>  [<ffffffffa0257358>] ? 0xffffffffa0257357
>  [<ffffffffa0257138>] ? 0xffffffffa0257137
>  [<ffffffffa01e6035>] ? snd_pcm_xrun_debug_write+0x5/0x70 [snd_pcm]
>  [<ffffffffa01e71ed>] ? snd_pcm_control_ioctl+0xad/0x260 [snd_pcm]
>  [<ffffffff810cdeba>] ? copy_module_from_fd.isra.48+0x12a/0x190
>  [<ffffffff810d2c66>] SyS_finit_module+0x86/0xb0
>  [<ffffffff8172aa14>] tracesys+0xdd/0xe2
> Code: 48 83 7a 38 00 78 6a 48 8b 30 44 89 ea 4c 89 d7 48 8d 14 52 4c 89 4c 24 40 41 83 c5 01 48 8d 14 d1 48 89 4c 24 48 4c 89 54 24 58 <48> 89 32 48 8b 70 08 48 89 72 08 48 8b 70 10 48 89 72 10 4c 89 
> RIP  [<ffffffff810d1a6b>] load_module+0x161b/0x2680
>  RSP <ffff8800939eddc0>
> CR2: ffffffffa01e6035
> ---[ end trace 956db59f53237fe7 ]---

