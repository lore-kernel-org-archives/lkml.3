Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3IRTIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:08:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3IRTIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:08:00 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: [PATCH 1/8] audit: avoid soft lockup due to audit_log_start() incorrect loop termination
Date: Wed, 18 Sep 2013 15:06:46 -0400
Message-Id: <e172e2536b18223179fde70879a589e1ff9a74c5.1379530867.git.rgb@redhat.com>
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
In-Reply-To: <cover.1379530867.git.rgb@redhat.com>
References: <cover.1379530867.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 82919919 caused the wait for auditd timeout condition to loop endlessly
rather than fall through to the error recovery code.

 BUG: soft lockup - CPU#0 stuck for 22s! [preload:785]
 RIP: 0010:[<ffffffff810fb240>]  [<ffffffff810fb240>] audit_log_start+0xf0/0x460
 Call Trace:
  [<ffffffff810aca40>] ? try_to_wake_up+0x310/0x310
  [<ffffffff81100fd1>] audit_log_exit+0x51/0xcb0
  [<ffffffff811020b5>] __audit_syscall_exit+0x275/0x2d0
  [<ffffffff816ec540>] sysret_audit+0x17/0x21

If the timeout condition goes negative, the loop continues endlessly instead of
breaking out and going to the failure code and allow other processes to run
when auditd is unable to drain the queue fast enough.

This can easily be triggered by readahead-collector, in particular during
installations.  The readahead-collector (ab)uses the audit interface and
sometimes gets stuck in a 'stopped' state.

To trigger:
	readahead-collector -f &
	pkill -SIGSTOP readahead-collector
	top

See:
	https://lkml.org/lkml/2013/8/28/626
	https://lkml.org/lkml/2013/9/2/471
	https://lkml.org/lkml/2013/9/3/4

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Dan Duval <dan.duval@oracle.com>
Signed-off-by: Chuck Anderson <chuck.anderson@oracle.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..7b0e23a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1117,9 +1117,10 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 
 			sleep_time = timeout_start + audit_backlog_wait_time -
 					jiffies;
-			if ((long)sleep_time > 0)
+			if ((long)sleep_time > 0) {
 				wait_for_auditd(sleep_time);
-			continue;
+				continue;
+			}
 		}
 		if (audit_rate_check() && printk_ratelimit())
 			printk(KERN_WARNING
-- 
1.7.1

