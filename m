Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3JWDC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 23:02:56 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35973 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3JWDCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 23:02:55 -0400
Message-ID: <52673C57.1050607@linux.vnet.ibm.com>
Date: Wed, 23 Oct 2013 11:02:47 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: remove extra put_online_cpus() inside sched_setaffinity()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102303-3864-0000-0000-00000AB2C295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6acce3ef84520537f8a09a12c9ddbe814a584dd2
        sched: Remove get_online_cpus() usage

has left one extra put_online_cpus() inside sched_setaffinity(), remove it
to fix the WARN:

[3165] Watchdog is alive
[3159] Started watchdog thread 3165
[   58.695502] ------------[ cut here ]------------
[   58.697835] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus+0x43/0x70()
[   58.702423] Modules linked in:
[   58.704404] CPU: 0 PID: 3166 Comm: trinity-child0 Not tainted 3.12.0-rc5-01882-gf3db366 #1172
[   58.708530] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   58.710992]  0000000000000000 ffff88000acfbe50 ffffffff81a24643 0000000000000000
[   58.715410]  ffff88000acfbe88 ffffffff810c3e6b ffffffff810c3fef 0000000000000000
[   58.719826]  0000000000000000 0000000000006ee0 0000000000000ffc ffff88000acfbe98
[   58.724348] Call Trace:
[   58.726190]  [<ffffffff81a24643>] dump_stack+0x4d/0x66
[   58.728531]  [<ffffffff810c3e6b>] warn_slowpath_common+0x7f/0x98
[   58.731069]  [<ffffffff810c3fef>] ? put_online_cpus+0x43/0x70
[   58.733664]  [<ffffffff810c3f32>] warn_slowpath_null+0x1a/0x1c
[   58.736258]  [<ffffffff810c3fef>] put_online_cpus+0x43/0x70
[   58.738686]  [<ffffffff810efd59>] sched_setaffinity+0x7d/0x1f9
[   58.741210]  [<ffffffff810efce1>] ? sched_setaffinity+0x5/0x1f9
[   58.743775]  [<ffffffff81a2f724>] ? _raw_spin_unlock_irq+0x2c/0x3e
[   58.746417]  [<ffffffff810c7012>] ? do_setitimer+0x194/0x1f5
[   58.748899]  [<ffffffff810eff37>] SyS_sched_setaffinity+0x62/0x71
[   58.751481]  [<ffffffff81a373a9>] system_call_fastpath+0x16/0x1b
[   58.754070] ---[ end trace 034818a1f6f06868 ]---
[   58.757521] ------------[ cut here ]------------

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c06b8d3..7c61f31 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3716,7 +3716,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
        p = find_process_by_pid(pid);
        if (!p) {
                rcu_read_unlock();
-               put_online_cpus();
                return -ESRCH;
        }

-- 
1.7.9.5

