Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbbAUGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:16:27 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42621 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbbAUGQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:16:24 -0500
Message-ID: <1421820981.16275.1.camel@marge.simpson.net>
Subject: [patch] cpuset: fix crash when adding CPUs to an empty set
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Date: Wed, 21 Jan 2015 07:16:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While creating a set of shielded CPUs, we passed cpuset_cpumask_can_shrink()
an empty cpumask (cur), and dl_bw_of(cpumask_any(cur)) made boom with it.

[  514.513841] CPU: 0 PID: 6942 Comm: shield.sh Not tainted 3.19.0-master #19
[  514.513841] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[  514.513841] task: ffff880224552450 ti: ffff8800caab8000 task.ti: ffff8800caab8000
[  514.513841] RIP: 0010:[<ffffffff81073846>]  [<ffffffff81073846>] cpuset_cpumask_can_shrink+0x56/0xb0
[  514.513841] RSP: 0018:ffff8800caabbda8  EFLAGS: 00010202
[  514.513841] RAX: 0000ffff00000000 RBX: ffff880037ae2ab8 RCX: 0000000000000000
[  514.513841] RDX: 0000000000012900 RSI: 0000000000000000 RDI: 000000000000000c
[  514.513841] RBP: ffff8800caabbdc8 R08: ffff880037ae2ab8 R09: 0000000000000034
[  514.513841] R10: 00000077e6fd3d1a R11: ffff88022e9b301c R12: ffff880223c98ab8
[  514.513841] R13: ffff880037ae2a00 R14: 0000000000000004 R15: ffff8802254b3c60
[  514.513841] FS:  00007fdbab533700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
[  514.513841] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  514.513841] CR2: 00007ffff8ab8000 CR3: 00000000bef11000 CR4: 00000000000007f0
[  514.513841] Stack:
[  514.513841]  ffff880223c98ab8 ffffffff81a46c20 ffff880223c98a00 ffff880037ae2a00
[  514.513841]  ffff8800caabbdf8 ffffffff810cb82a ffff8800caabbdf8 ffff880037ae2a00
[  514.513841]  ffff8800ca9e5240 0000000000000000 ffff8800caabbe48 ffffffff810cc877
[  514.513841] Call Trace:
[  514.513841]  [<ffffffff810cb82a>] validate_change+0x18a/0x200
[  514.513841]  [<ffffffff810cc877>] cpuset_write_resmask+0x3b7/0x720
[  514.513841]  [<ffffffff810c4d58>] cgroup_file_write+0x38/0x100
[  514.513841]  [<ffffffff811d953a>] kernfs_fop_write+0x12a/0x180
[  514.513841]  [<ffffffff8116e1a3>] vfs_write+0xb3/0x1d0
[  514.513841]  [<ffffffff8116ed06>] SyS_write+0x46/0xb0
[  514.513841]  [<ffffffff8159ced6>] system_call_fastpath+0x16/0x1b

Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>

---
 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -511,7 +511,7 @@ static int validate_change(struct cpuset
 	 * tasks.
 	 */
 	ret = -EBUSY;
-	if (is_cpu_exclusive(cur) &&
+	if (is_cpu_exclusive(cur) && !cpumask_empty(cur->cpus_allowed) &&
 	    !cpuset_cpumask_can_shrink(cur->cpus_allowed,
 				       trial->cpus_allowed))
 		goto out;


