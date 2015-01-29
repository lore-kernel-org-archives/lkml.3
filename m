Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbbA2GEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:04:53 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60830 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbbA2GEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:04:52 -0500
Message-ID: <54C9CD7C.3030402@hitachi.com>
Date: Thu, 29 Jan 2015 15:04:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH 0/3] kprobes/ftrace/x86: Function graph trace jprobes
References: <20150128043036.429390502@goodmis.org>
In-Reply-To: <20150128043036.429390502@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/28 13:30), Steven Rostedt wrote:
> I had these patches sitting in my repo for a while, thinking I already
> posted them. I never did, so here I go  (a little late :-/)

Oops, I might miss that.

> Basically, what I had before was fixes for jprobes and function graph
> tracing that were stepping on each other. When enabling both jprobes
> and graph tracer, it could crash the system. The fix was just to ignore
> function graph tracing while handling a jprobe. This was fine for stable
> and fixing a bug that would usually crash, but it still messes with
> function graph trace. It is still required if fentry is not used, but
> when fentry is (which is now the majority of cases - gcc > 4.6 and x86_64),
> we can trace jprobes with a little trickery.
> 
> The way this solves the issue is that on the return from the jprobe,
> we can detect if function graph tracing happened because the stack
> frame would have changed. When this is detected
>  (saved_sp == return_to_handler), the ip is changed once again to
> go preform a "fixup". The real ip is saved in r10 (callee clobber)
> and will be put back by the fixup trampoline.

Hmm, could you make this more generic? Maybe we can directly call
ftrace_return_to_handler() from longjmp_break_handler().
Actually, current implementation seems just skipping one return
address, however, there may be possible to call jprobe_return() in
the nested functions, like below;

void test_exit(int flag)
{
	if (!flag)
		jprobe_return();
}
int jdo_fork(...)
{
	...
	test_exit(something_to_test);
	...
	jprobe_return();
	return 0;
}

I've tested similar code on this series and it crashed kernel.
(I also checked that the above example can work safely without graph tracer)

[58149.913578] Planted jprobe at ffffffff8109a2a0, handler addr ffffffffa007e030
[58152.642572] jprobe: clone_flags = 0x1200011, stack_start = 0x0 stack_size = 0x0
[58152.642923] 	never_ret: 18874385,           (null)
[58152.664210] jprobe at ffffffff8109a2a0 unregistered
[58152.667840] kernel tried to execute NX-protected page - exploit attempt? (uid: 1000)
[58152.668796] BUG: unable to handle kernel paging request at 00007fffae3c30a0
[58152.668796] IP: [<00007fffae3c30a0>] 0x7fffae3c30a0
[58152.668796] PGD 42cb66067 PUD 42b708067 PMD 42a464067 PTE 8000000413146065
[58152.668796] Oops: 0011 [#1] SMP
[58152.668796] Modules linked in: jprobe_example(E) nls_utf8 isofs cirrus drm_kms_helper ttm drm ppdev crct10dif_pclmul crc32_pclmul parport_pc virtio_net i2c_piix4 parport crc32c_intel virtio_balloon
serio_raw ghash_clmulni_intel virtio_blk virtio_pci virtio_ring ata_generic virtio pata_acpi [last unloaded: jprobe_example]
[58152.668796] CPU: 0 PID: 12992 Comm: bash Tainted: G            E  3.19.0-rc3+ #1
[58152.668796] Hardware name: Fedora Project OpenStack Nova, BIOS 1.7.5-20140709_153950- 04/01/2014
[58152.668796] task: ffff88042c4fb8a0 ti: ffff88042b638000 task.ti: ffff88042b638000
[58152.668796] RIP: 0010:[<00007fffae3c30a0>]  [<00007fffae3c30a0>] 0x7fffae3c30a0
[58152.668796] RSP: 0018:ffff88042b63bf48  EFLAGS: 00010282
[58152.668796] RAX: 0000000000000027 RBX: 0000000000000000 RCX: ffff8800bbae0100
[58152.668796] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa007e089
[58152.668796] RBP: ffff88042b63bf40 R08: 0000000000000cc8 R09: ffff88042bfffcd8
[58152.668796] R10: 000000000000000c R11: 0000000000000cc8 R12: 00007fffae3c3060
[58152.668796] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000001d63470
[58152.668796] FS:  00007fdfbb57a700(0000) GS:ffff88043fc00000(0000) knlGS:0000000000000000
[58152.668796] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[58152.668796] CR2: 00007fffae3c30a0 CR3: 000000042b58b000 CR4: 00000000000406f0
[58152.668796] Stack:
[58152.668796]  ffffffff8176a9c8 ffffffff817682e9 0000000001d63470 0000000000000000
[58152.668796]  0000000000000000 00007fffae3c3060 00007fffae3c30a0 0000000000000000
[58152.668796]  0000000000000246 00007fdfbb57a9d0 0000000000000000 0000000000000000
[58152.668796] Call Trace:
[58152.668796]  [<ffffffff8176a9c8>] ftrace_graph_caller+0xa8/0xa8
[58152.668796]  [<ffffffff8106370d>] __bad_area_nosemaphore+0x8d/0x220
[58152.668796]  [<ffffffff817682e9>] ? system_call_fastpath+0x12/0x17
[58152.668796] Code:  Bad RIP value.
[58152.668796] RIP  [<00007fffae3c30a0>] 0x7fffae3c30a0
[58152.668796]  RSP <ffff88042b63bf48>
[58152.668796] CR2: 00007fffae3c30a0
[58152.668796] ------------[ cut here ]------------

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


