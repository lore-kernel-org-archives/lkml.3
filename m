Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbaC0QIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:08:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43024 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaC0QIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:08:30 -0400
Message-ID: <53344CE4.4070609@oracle.com>
Date: Thu, 27 Mar 2014 12:08:04 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, jslaby@suse.cz
CC: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: tty: hang on ldisc_sem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next
kernel, I've encountered a lockup on ldisc_sem.

The issue was detected here:

[ 6009.895215] trinity-watchdo D ffff880038efb000  5976 22153  22152 0x10000000
[ 6009.895986]  ffff880034205c78 0000000000000002 ffff880034205c38 0000000000000082
[ 6009.896942]  ffff880034205fd8 00000000001d79c0 00000000001d79c0 00000000001d79c0
[ 6009.897849]  ffff8803ac620000 ffff880038efb000 ffff880034205c58 ffff8805abb00970
[ 6009.898745] Call Trace:
[ 6009.899015]  schedule (kernel/sched/core.c:2750)
[ 6009.899596]  schedule_timeout (kernel/timer.c:1475)
[ 6009.900674]  ? down_read_failed (drivers/tty/tty_ldsem.c:235)
[ 6009.901977]  ? _raw_spin_unlock_irq (arch/x86/include/asm/paravirt.h:819 include/linux/spinlock_api_smp.h:168 kernel/locking/spinlock.c:199)
[ 6009.902596]  ? get_parent_ip (kernel/sched/core.c:2472)
[ 6009.903143]  ? preempt_count_sub (kernel/sched/core.c:2527)
[ 6009.903732]  down_read_failed (drivers/tty/tty_ldsem.c:235)
[ 6009.904401]  ldsem_down_read (drivers/tty/tty_ldsem.c:331 drivers/tty/tty_ldsem.c:366)
[ 6009.905186]  ? tty_ldisc_ref_wait (drivers/tty/tty_ldisc.c:268)
[ 6009.906041]  tty_ldisc_ref_wait (drivers/tty/tty_ldisc.c:268)
[ 6009.906776]  tty_write (drivers/tty/tty_io.c:1213)
[ 6009.907371]  ? redirected_tty_write (drivers/tty/tty_io.c:1238)
[ 6009.908034]  ? get_parent_ip (kernel/sched/core.c:2472)
[ 6009.908648]  ? preempt_count_sub (kernel/sched/core.c:2527)
[ 6009.909256]  redirected_tty_write (drivers/tty/tty_io.c:1238)
[ 6009.909890]  vfs_write (fs/read_write.c:485)
[ 6009.910762]  SyS_write (fs/read_write.c:535 fs/read_write.c:527)
[ 6009.911347]  tracesys (arch/x86/kernel/entry_64.S:749)
[ 6009.911910] 1 lock held by trinity-watchdo/22153:
[ 6009.912394]  #0:  (&tty->ldisc_sem){++++++}, at: tty_ldisc_ref_wait (drivers/tty/tty_ldisc.c:268)

There are many processes trying to grab ldisc_sem, while the only
process that's holding ldisc_sem is:

[ 6019.904950] sh              S 0000000000000016  4584  8737   8665 0x10000000
[ 6019.905793]  ffff88012b43fca8 0000000000000002 0000000000000000 ffff8801acdd8500
[ 6019.906836]  ffff88012b43ffd8 00000000001d79c0 00000000001d79c0 00000000001d79c0
[ 6019.907704]  ffff8800c845b000 ffff88012be23000 ffff88012b43fc88 ffff8805abb00948
[ 6019.908551] Call Trace:
[ 6019.908832]  schedule (kernel/sched/core.c:2750)
[ 6019.909398]  schedule_timeout (kernel/timer.c:1475)
[ 6019.910025]  ? n_tty_read (drivers/tty/n_tty.c:2222)
[ 6019.910785]  ? preempt_count_sub (kernel/sched/core.c:2527)
[ 6019.911684]  ? put_lock_stats.isra.12 (arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[ 6019.912450]  ? n_tty_read (drivers/tty/n_tty.c:2222)
[ 6019.913222]  n_tty_read (drivers/tty/n_tty.c:2224)
[ 6019.913879]  ? get_parent_ip (kernel/sched/core.c:2472)
[ 6019.914616]  ? get_parent_ip (kernel/sched/core.c:2472)
[ 6019.915301]  ? try_to_wake_up (kernel/sched/core.c:2844)
[ 6019.916033]  tty_read (drivers/tty/tty_io.c:1039)
[ 6019.916640]  vfs_read (fs/read_write.c:408)
[ 6019.917202]  SyS_read (fs/read_write.c:519 fs/read_write.c:511)
[ 6019.917772]  tracesys (arch/x86/kernel/entry_64.S:749)


Thanks,
Sasha
