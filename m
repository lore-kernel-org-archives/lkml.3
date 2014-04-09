Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbaDIP4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:56:25 -0400
Received: from col0-omc1-s4.col0.hotmail.com ([65.55.34.14]:42175 "EHLO
	col0-omc1-s4.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932786AbaDIP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:56:23 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 11:56:23 EDT
X-TMN: [ZZR1DBfHVMdDug3ztCypBnVH6UGO8N3WoSWNWr8Gje4=]
X-Originating-Email: [yuchaochina@hotmail.com]
Message-ID: <COL402-EAS13359D6EB23C18DA0BBE9DAAB6A0@phx.gbl>
From: Chao Yu <yuchaochina@hotmail.com>
To: "'Sasha Levin'" <sasha.levin@oracle.com>, <jaegeuk.kim@samsung.com>
CC: "'Dave Jones'" <davej@redhat.com>, "'LKML'" <linux-kernel@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
References: <53401D4A.1020203@oracle.com>
In-Reply-To: <53401D4A.1020203@oracle.com>
Subject: RE: [f2fs-dev] f2fs: kernel BUG at fs/f2fs/segment.h:543
Date: Wed, 9 Apr 2014 23:51:09 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQABAgME/2WmIdA0hbuM60HuEiw12Z6mDcDA
Content-Language: zh-cn
X-OriginalArrivalTime: 09 Apr 2014 15:51:15.0012 (UTC) FILETIME=[89C9F040:01CF540B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Levin,

Could you share dump code info like following one which can be generated
by 'objdump -Dl f2fs.ko > obj'.
It may help us to get a clue for this problem.

verify_block_addr()
segment.h:543 (discriminator 3)
    2f35:       39 55 ec                cmp    %edx,-0x14(%ebp)
segment.h:542 (discriminator 3)
    2f38:       8d 44 02 ff             lea    -0x1(%edx,%eax,1),%eax
segment.h:543 (discriminator 3)
    2f3c:       0f 82 dc 01 00 00       jb     311e <f2fs_submit_page_mbio+0x22e>
segment.h:544
    2f42:       39 45 ec                cmp    %eax,-0x14(%ebp)
    2f45:       0f 87 d1 01 00 00       ja     311c <f2fs_submit_page_mbio+0x22c>

Thank you

> -----Original Message-----
> From: Sasha Levin [mailto:sasha.levin@oracle.com]
> Sent: Saturday, April 05, 2014 11:12 PM
> To: jaegeuk.kim@samsung.com; jaegeuk.kim@samsung.com
> Cc: Dave Jones; LKML; linux-f2fs-devel@lists.sourceforge.net; Dave Jones; LKML;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] f2fs: kernel BUG at fs/f2fs/segment.h:543
> 
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest
> -next kernel I've stumbled on the following:
> 
> [ 1789.220942] kernel BUG at fs/f2fs/segment.h:543!
> [ 1789.220942] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 1789.220942] Dumping ftrace buffer:
> [ 1789.220942]    (ftrace buffer empty)
> [ 1789.220942] Modules linked in:
> [ 1789.220942] CPU: 0 PID: 28161 Comm: trinity-c0 Not tainted
> 3.14.0-next-20140403-sasha-00019-g7474aa9-dirty #376
> [ 1789.220942] task: ffff88032a598000 ti: ffff880329c3e000 task.ti: ffff880329c3e000
> [ 1789.220942] RIP: f2fs_submit_page_mbio (fs/f2fs/segment.h:543 fs/f2fs/data.c:181)
> [ 1789.220942] RSP: 0018:ffff880329c3fc08  EFLAGS: 00010287
> [ 1789.220942] RAX: 000000000000ffff RBX: ffff88012ac66a00 RCX: 0000000000000009
> [ 1789.220942] RDX: 0000000000000200 RSI: ffffea0001dd92c0 RDI: ffff88012ac667b0
> [ 1789.220942] RBP: ffff880329c3fc58 R08: 00000000000ba28e R09: ffff88032a598d98
> [ 1789.220942] R10: 0000000000000000 R11: 0000000000000000 R12: ffffea0001dd92c0
> [ 1789.220942] R13: ffff88012ac667b0 R14: 0000000000000000 R15: ffff880329c3fc70
> [ 1789.220942] FS:  00007f3599003700(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
> [ 1789.220942] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1789.220942] CR2: 00007faf4246a018 CR3: 0000000329b6f000 CR4: 00000000000006b0
> [ 1789.220942] DR0: 0000000000696000 DR1: 0000000000696000 DR2: 0000000000000000
> [ 1789.261947] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 1789.261947] Stack:
> [ 1789.261947]  ffff88032a598000 ffff880d2a478278 0000000000000006 0000000000000082
> [ 1789.261947]  ffffffffaa289475 ffffea0001dd92c0 ffff88012ac667b0 ffff880329c3fd30
> [ 1789.261947]  0000000000000000 ffffea0001dd92c0 ffff880329c3fc88 ffffffffaa9da033
> [ 1789.278327] Call Trace:
> [ 1789.278327] ? clear_page_dirty_for_io (arch/x86/include/asm/paravirt.h:809
> include/linux/backing-dev.h:176 mm/page-writeback.c:2355)
> [ 1789.278327] write_meta_page (fs/f2fs/segment.c:922)
> [ 1789.278327] f2fs_write_meta_page (arch/x86/include/asm/atomic.h:103 fs/f2fs/f2fs.h:692
> fs/f2fs/checkpoint.c:172)
> [ 1789.288220] trinity-c32: vm86 mode not supported on 64 bit kernel
> [ 1789.278327] sync_meta_pages (fs/f2fs/checkpoint.c:247)
> [ 1789.278327] ? get_parent_ip (kernel/sched/core.c:2472)
> [ 1789.278327] ? preempt_count_sub (kernel/sched/core.c:2527)
> [ 1789.278327] ? _raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:98
> include/linux/spinlock_api_smp.h:161 kernel/locking/spinlock.c:191)
> [ 1789.278327] write_checkpoint (fs/f2fs/checkpoint.c:875 fs/f2fs/checkpoint.c:913)
> [ 1789.310911] waiting module removal not supported: please upgrade
> [ 1789.278327] ? SyS_tee (fs/sync.c:77)
> [ 1789.278327] ? mutex_lock_nested (arch/x86/include/asm/paravirt.h:809 kernel/locking/mutex.c:569
> kernel/locking/mutex.c:587)
> [ 1789.278327] ? get_parent_ip (kernel/sched/core.c:2472)
> [ 1789.278327] ? bit_waitqueue (kernel/sched/wait.c:291)
> [ 1789.278327] ? SyS_tee (fs/sync.c:77)
> [ 1789.278327] f2fs_sync_fs (fs/f2fs/super.c:456)
> [ 1789.278327] sync_fs_one_sb (fs/sync.c:80)
> [ 1789.278327] iterate_supers (fs/super.c:512)
> [ 1789.278327] sys_sync (fs/sync.c:110)
> [ 1789.278327] tracesys (arch/x86/kernel/entry_64.S:749)
> [ 1789.278327] Code: 48 c1 e0 04 48 8d 9c 07 f0 00 00 00 49 8b 45 38 41 8b 8d d0 06 00 00 8b 50 78 8b 80
> 84 00 00 00 d3 e0 41 39 d6 8d 44 02 ff 73 09 <0f> 0b 0f 1f 80 00 00 00 00 41 39 c6 76 03 0f 0b 90 48 8d
> 43 20
> [ 1789.278327] RIP f2fs_submit_page_mbio (fs/f2fs/segment.h:543 fs/f2fs/data.c:181)
> [ 1789.278327]  RSP <ffff880329c3fc08>
> 
> 
> Thanks,
> Sasha
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
