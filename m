Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3H2VLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:11:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45936 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3H2VLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:11:22 -0400
Date: Thu, 29 Aug 2013 16:11:14 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] Make sure to wake reaper
Message-ID: <20130829211114.GA20726@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since commit af4b8a83add95ef40716401395b44a1b579965f4 it's been
possible to get into a situation where a pidns reaper is
<defunct>, reparented to host pid 1, but never reaped.  How to
reproduce this is documented at

https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526
(and see
https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526/comments/13)
In short, run repeated starts of a container whose init is

Process.exit(0);

sysrq-t when such a task is playing zombie shows:

[  131.132978] init            x ffff88011fc14580     0  2084   2039 0x00000000
[  131.132978]  ffff880116e89ea8 0000000000000002 ffff880116e89fd8 0000000000014580
[  131.132978]  ffff880116e89fd8 0000000000014580 ffff8801172a0000 ffff8801172a0000
[  131.132978]  ffff8801172a0630 ffff88011729fff0 ffff880116e14650 ffff88011729fff0
[  131.132978] Call Trace:
[  131.132978]  [<ffffffff816f6159>] schedule+0x29/0x70
[  131.132978]  [<ffffffff81064591>] do_exit+0x6e1/0xa40
[  131.132978]  [<ffffffff81071eae>] ? signal_wake_up_state+0x1e/0x30
[  131.132978]  [<ffffffff8106496f>] do_group_exit+0x3f/0xa0
[  131.132978]  [<ffffffff810649e4>] SyS_exit_group+0x14/0x20
[  131.132978]  [<ffffffff8170102f>] tracesys+0xe1/0xe6

Further debugging showed that every time this happened, zap_pid_ns_processes()
started with nr_hashed being 3, while we were expecting it to drop to 2.
Any time it didn't happen, nr_hashed was 1 or 2.  So the reaper was
waiting for nr_hashed to become 2, but free_pid() only wakes the reaper
if nr_hashed hits 1.  This patch makes free_pid() wake the reaper any
time the reaper is PF_EXITING, to force it to re-test the
pidns->nr_hashed = init_pids test.  Note that this is more like what
__unhash_process() used to do before
af4b8a83add95ef40716401395b44a1b579965f4.

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/pid.c b/kernel/pid.c
index 0db3e79..6b312c4 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -274,6 +274,10 @@ void free_pid(struct pid *pid)
 		case 0:
 			schedule_work(&ns->proc_work);
 			break;
+		default:
+			if (ns->child_reaper->flags & PF_EXITING)
+				wake_up_process(ns->child_reaper);
+			break;
 		}
 	}
 	spin_unlock_irqrestore(&pidmap_lock, flags);
-- 
1.8.3.2

