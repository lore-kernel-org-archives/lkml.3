Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaEEPt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:49:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32958 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaEEPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:49:23 -0400
Message-ID: <5367B2F8.7020905@oracle.com>
Date: Mon, 05 May 2014 11:49:12 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: m.chehab@samsung.com, hans.verkuil@cisco.com
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        linux-media@vger.kernel.org
Subject: v4l2: circular locking between mmap_sem and device mutex
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next
kernel I've stumbled on the following:


[ 2179.111265] ======================================================
[ 2179.112228] [ INFO: possible circular locking dependency detected ]
[ 2179.113144] 3.15.0-rc3-next-20140502-sasha-00020-g3183c20 #432 Tainted: G        W
[ 2179.114325] -------------------------------------------------------
[ 2179.115286] trinity-c15/27050 is trying to acquire lock:
[ 2179.116071] (&dev->mutex#3){+.+.+.}, at: vb2_fop_mmap (drivers/media/v4l2-core/videobuf2-core.c:3029 (discriminator 1))
[ 2179.117347]
[ 2179.117347] but task is already holding lock:
[ 2179.118185] (&mm->mmap_sem){++++++}, at: vm_mmap_pgoff (mm/util.c:398)
[ 2179.120023]
[ 2179.120023] which lock already depends on the new lock.
[ 2179.120023]
[ 2179.120036]
[ 2179.120036] the existing dependency chain (in reverse order) is:
[ 2179.120036]
-> #1 (&mm->mmap_sem){++++++}:
[ 2179.120036] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2179.120036] might_fault (mm/memory.c:4368)
[ 2179.120036] video_usercopy (arch/x86/include/asm/uaccess.h:713 drivers/media/v4l2-core/v4l2-ioctl.c:2369)
[ 2179.120036] video_ioctl2 (drivers/media/v4l2-core/v4l2-ioctl.c:2445)
[ 2179.120036] v4l2_ioctl (drivers/media/v4l2-core/v4l2-dev.c:355)
[ 2179.120036] do_vfs_ioctl (fs/ioctl.c:44 fs/ioctl.c:598)
[ 2179.120036] SyS_ioctl (include/linux/file.h:38 fs/ioctl.c:614 fs/ioctl.c:604)
[ 2179.120036] tracesys (arch/x86/kernel/entry_64.S:746)
[ 2179.120036]
-> #0 (&dev->mutex#3){+.+.+.}:
[ 2179.120036] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2179.120036] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2179.120036] mutex_lock_interruptible_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:616)
[ 2179.120036] vb2_fop_mmap (drivers/media/v4l2-core/videobuf2-core.c:3029 (discriminator 1))
[ 2179.120036] v4l2_mmap (drivers/media/v4l2-core/v4l2-dev.c:427)
[ 2179.120036] mmap_region (mm/mmap.c:1577)
[ 2179.120036] do_mmap_pgoff (mm/mmap.c:1369)
[ 2179.120036] vm_mmap_pgoff (mm/util.c:400)
[ 2179.120036] SyS_mmap_pgoff (mm/mmap.c:1418 mm/mmap.c:1378)
[ 2179.120036] SyS_mmap (arch/x86/kernel/sys_x86_64.c:72)
[ 2179.120036] tracesys (arch/x86/kernel/entry_64.S:746)
[ 2179.120036]
[ 2179.120036] other info that might help us debug this:
[ 2179.120036]
[ 2179.120036]  Possible unsafe locking scenario:
[ 2179.120036]
[ 2179.120036]        CPU0                    CPU1
[ 2179.120036]        ----                    ----
[ 2179.120036]   lock(&mm->mmap_sem);
[ 2179.120036]                                lock(&dev->mutex#3);
[ 2179.120036]                                lock(&mm->mmap_sem);
[ 2179.120036]   lock(&dev->mutex#3);
[ 2179.120036]
[ 2179.120036]  *** DEADLOCK ***
[ 2179.120036]
[ 2179.120036] 1 lock held by trinity-c15/27050:
[ 2179.120036] #0: (&mm->mmap_sem){++++++}, at: vm_mmap_pgoff (mm/util.c:398)
[ 2179.120036]
[ 2179.120036] stack backtrace:
[ 2179.120036] CPU: 1 PID: 27050 Comm: trinity-c15 Tainted: G        W     3.15.0-rc3-next-20140502-sasha-00020-g3183c20 #432
[ 2179.120036]  ffffffffbaa718e0 ffff88065df9dab8 ffffffffb75326bb 0000000000000002
[ 2179.120036]  ffffffffbaa718e0 ffff88065df9db08 ffffffffb7525488 0000000000000001
[ 2179.120036]  ffff88065df9db98 ffff88065df9db08 ffff88065dd63cf0 ffff88065dd63d28
[ 2179.120036] Call Trace:
[ 2179.120036] dump_stack (lib/dump_stack.c:52)
[ 2179.120036] print_circular_bug (kernel/locking/lockdep.c:1216)
[ 2179.120036] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 2179.120036] ? mmap_region (mm/mmap.c:1556)
[ 2179.120036] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 2179.120036] ? vb2_fop_mmap (drivers/media/v4l2-core/videobuf2-core.c:3029 (discriminator 1))
[ 2179.120036] mutex_lock_interruptible_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:616)
[ 2179.120036] ? vb2_fop_mmap (drivers/media/v4l2-core/videobuf2-core.c:3029 (discriminator 1))
[ 2179.120036] ? vb2_fop_mmap (drivers/media/v4l2-core/videobuf2-core.c:3029 (discriminator 1))
[ 2179.120036] ? get_parent_ip (kernel/sched/core.c:2485)
[ 2179.120036] vb2_fop_mmap (drivers/media/v4l2-core/videobuf2-core.c:3029 (discriminator 1))
[ 2179.120036] ? mmap_region (mm/mmap.c:1556)
[ 2179.120036] ? mmap_region (mm/mmap.c:1556)
[ 2179.120036] v4l2_mmap (drivers/media/v4l2-core/v4l2-dev.c:427)
[ 2179.120036] mmap_region (mm/mmap.c:1577)
[ 2179.120036] do_mmap_pgoff (mm/mmap.c:1369)
[ 2179.120036] ? vm_mmap_pgoff (mm/util.c:398)
[ 2179.120036] vm_mmap_pgoff (mm/util.c:400)
[ 2179.120036] ? __rcu_read_unlock (kernel/rcu/update.c:97)
[ 2179.120036] ? __fget (fs/file.c:633)
[ 2179.120036] SyS_mmap_pgoff (mm/mmap.c:1418 mm/mmap.c:1378)
[ 2179.120036] SyS_mmap (arch/x86/kernel/sys_x86_64.c:72)
[ 2179.120036] tracesys (arch/x86/kernel/entry_64.S:746)


Thanks,
Sasha
