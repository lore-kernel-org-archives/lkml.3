Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3JKBgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:36:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42740 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3JKBgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:36:19 -0400
Date: Fri, 11 Oct 2013 10:36:45 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: <viro@zeniv.linux.org.uk>, <eparis@redhat.com>
CC: <linux-audit@redhat.com>, <linux-kernel@vger.kernel.org>,
        <toshi.okajima@jp.fujitsu.com>
Subject: [BUG][PATCH][RFC] audit: hang up in audit_log_start executed on
 auditd
Message-ID: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.11; i686-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. 

The following reproducer causes auditd daemon hang up.
(But the hang up is released after the audit_backlog_wait_time passes.)
 # auditctl -a exit,always -S all
 # reboot


I reproduced the hangup on KVM, and then got a crash dump.
After I analyzed the dump, I found auditd daemon hung up in audit_log_start. 
(I have confirmed it on linux-3.12-rc4.)

Like this:
crash> bt 1426
PID: 1426   TASK: ffff88007b63e040  CPU: 1   COMMAND: "auditd"
 #0 [ffff88007cb93918] __schedule at ffffffff8155d980
 #1 [ffff88007cb939b0] schedule at ffffffff8155de99
 #2 [ffff88007cb939c0] schedule_timeout at ffffffff8155b840
 #3 [ffff88007cb93a60] audit_log_start at ffffffff810d3ce5
 #4 [ffff88007cb93b20] audit_log_config_change at ffffffff810d3ece
 #5 [ffff88007cb93b60] audit_receive_msg at ffffffff810d4fd6
 #6 [ffff88007cb93c00] audit_receive at ffffffff810d5173
 #7 [ffff88007cb93c30] netlink_unicast at ffffffff814c5269
 #8 [ffff88007cb93c90] netlink_sendmsg at ffffffff814c6386
 #9 [ffff88007cb93d20] sock_sendmsg at ffffffff814813c0
#10 [ffff88007cb93e30] SYSC_sendto at ffffffff81481524
#11 [ffff88007cb93f70] sys_sendto at ffffffff8148157e
#12 [ffff88007cb93f80] system_call_fastpath at ffffffff81568052
    RIP: 00007f5c47f7fba3  RSP: 00007fffcf21a118  RFLAGS: 00010202
    RAX: 000000000000002c  RBX: ffffffff81568052  RCX: 0000000000000000
    RDX: 0000000000000030  RSI: 00007fffcf21e7d0  RDI: 0000000000000003
    RBP: 00007fffcf21e7d0   R8: 00007fffcf21a130   R9: 000000000000000c
    R10: 0000000000000000  R11: 0000000000000293  R12: ffffffff8148157e
    R13: ffff88007cb93f78  R14: 0000000000000020  R15: 0000000000000030
    ORIG_RAX: 000000000000002c  CS: 0033  SS: 002b


The reason is that auditd daemon itself cannot consume its backlog 
while audit_log_start is calling schedule_timeout on auditd daemon.  
So, that is a deadlock!

Therefore, I think audit_log_start shouldn't handle auditd's backlog
when auditd daemon executes audit_log_start.

For example, I made the following fix patch.
--------------------------------------------------------------
auditd daemon can execute the audit_log_start, and then it can cause 
a hang up because only auditd daemon can consume the backlog.
So, audit_log_start executed by auditd daemon should not handle the backlog 
in case auditd daemon hangs up (while wait_for_auditd is calling).

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 kernel/audit.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..86c389e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1098,6 +1098,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	int reserve;
 	unsigned long timeout_start = jiffies;
 
+	if (audit_pid && (audit_pid == current->pid))
+		return NULL;
+
 	if (audit_initialized != AUDIT_INITIALIZED)
 		return NULL;
 
-- 
1.5.5.6
