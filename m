Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab3ICEtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 00:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3ICEtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 00:49:04 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, dan.duval@oracle.com,
        akpm@linux-foundation.org, rgb@redhat.com, oleg@redhat.com,
        chuck.anderson@oracle.com
Subject: [PATCH 2/2] audit: kaudit_send_skb(): make non-blocking call to netlink_unicast()
Date: Tue,  3 Sep 2013 00:48:55 -0400
Message-Id: <1378183735-19338-3-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1378183735-19338-1-git-send-email-lcapitulino@redhat.com>
References: <1378183735-19338-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luiz capitulino <lcapitulino@redhat.com>

Try this:

 1. Download the readahead-collector program and build it
 2. Run it with:
   # readahead-collector -f
 3. From another terminal do:
   # pkill -SIGSTOP readahead-collector
 4. Keep using the system, run top -d1, vmstat -S 1, etc
 5. Eventually, you'll get something like this:

[  124.046016] BUG: soft lockup - CPU#0 stuck for 22s! [login:2196]
[  124.046016] Modules linked in:
[  124.046016] CPU: 0 PID: 2196 Comm: login Not tainted 3.11.0-rc7-00030-g41615e8 #13
[  124.046016] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  124.046016] task: ffff88003d92c970 ti: ffff88003cd50000 task.ti: ffff88003cd50000
[  124.046016] RIP: 0010:[<ffffffff8108a36c>]  [<ffffffff8108a36c>] audit_log_start+0x99/0x349
[  124.046016] RSP: 0018:ffff88003cd51db0  EFLAGS: 00000202
[  124.046016] RAX: 0000000000000100 RBX: ffffffff8107115e RCX: 000000000000ea60
[  124.046016] RDX: ffffffffffff95f3 RSI: 0000000000000101 RDI: 000000000000ea60
[  124.046016] RBP: ffff88003cd51e30 R08: 0000000000000100 R09: 0000000000000000
[  124.046016] R10: ffffffff000399b3 R11: ffff88003fc0d4a0 R12: 0000000000000046
[  124.046016] R13: ffff88003cd51d28 R14: 0000000000000046 R15: ffffffff810501ac
[  124.046016] FS:  00007f80d3efa800(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[  124.046016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  124.046016] CR2: 00007f3f04f8c000 CR3: 000000003cd41000 CR4: 00000000000006b0
[  124.046016] Stack:
[  124.046016]  ffffffffffff95f3 ffff88003d747800 00000000fffbfc40 0000051600000010
[  124.046016]  ffff88003cd51e30 0000000000000000 0000000000000000 ffff88003d92c970
[  124.046016]  ffffffff8105b3a6 dead000000100100 dead000000200200 ffff88003d747860
[  124.046016] Call Trace:
[  124.046016]  [<ffffffff8105b3a6>] ? wake_up_state+0x12/0x12
[  124.046016]  [<ffffffff8108b6cb>] audit_log_name+0x34/0x1a2
[  124.046016]  [<ffffffff8136f52b>] ? _raw_spin_unlock_irqrestore+0x34/0x48
[  124.046016]  [<ffffffff8108ebe8>] audit_log_exit+0xa44/0xa8f
[  124.046016]  [<ffffffff8108e07e>] ? rcu_read_unlock+0x1c/0x2d
[  124.046016]  [<ffffffff8108efe8>] ? audit_filter_inodes+0xf5/0x10e
[  124.046016]  [<ffffffff8108e17d>] ? audit_filter_syscall+0xb2/0xd9
[  124.046016]  [<ffffffff8108f374>] __audit_syscall_exit+0x4d/0x108
[  124.046016]  [<ffffffff813709c5>] sysret_audit+0x17/0x21
[  124.046016] Code: e7 8b 05 1c ed 59 00 8b 0d 12 ed 59 00 8b 35 1c 24 e1 00 46 8d 04 30 48 63 f9 85 c0 0f 84 29 01 00 00 44 39 c6 0f 86 20 01 00 00 <83> 7c 24 18 00 0f 84 a4 00 00 00 85 c9 0f 84 9c 00 00 00 48 8b

This is what happens:

 1. The readahead-collector daemon got stuck and stops reading
    from the netlink socket
 2. The kernel keeps logging stuff to the audit subsystem at
    a high rate
 3. Because kauditd's call to netlink_unicast() is blocking and
    as the netlink socket got a backlog, the kaudit thread will
    eventually get blocked when trying to send an SKB to user-space
 4. As the kaudit thread is blocked, SKBs start to accumulate.
    This will cause a thread calling audit_log_start() to
    be put to sleep when a threshold of queued SBKs is reached
 5. The kaudit thread never wakes up, but the kernel thread
    put to sleep in step 4 does. Soon or later sleep_time will be
    negative, causing it to busy-wait in the while() loop

This commit fixes that problem by making the call to netlink_unicast()
non-blocking in kaudit_send_skb(). This way the kaudit thread
never gets blocked, completely avoiding the scenario described above.

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 kernel/audit.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 475c1d1..2b34bd6 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -385,8 +385,12 @@ static int kauditd_send_skb(struct sk_buff *skb)
 	int err;
 	/* take a reference in case we can't send it and we want to hold it */
 	skb_get(skb);
-	err = netlink_unicast(audit_sock, skb, audit_nlk_portid, 0);
-	if (err < 0) {
+	err = netlink_unicast(audit_sock, skb, audit_nlk_portid, 1);
+	if (err == -EAGAIN) {
+		pr_warn_ratelimited("auditd (pid=%d) is not responding\n", audit_pid);
+		audit_hold_skb(skb);
+		return err;
+	} else if (err < 0) {
 		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
 		printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
 		audit_log_lost("auditd disappeared\n");
-- 
1.8.1.4

