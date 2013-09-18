Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3IRJsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:48:22 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:61847 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3IRJsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:48:20 -0400
Subject: [PATCH] audit: fix endless wait in audit_log_start()
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Dan Duval <dan.duval@oracle.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 18 Sep 2013 13:48:17 +0400
Message-ID: <20130918094817.18754.8847.stgit@zurg>
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 829199197a430dade2519d54f5545c4a094393b8 audit emiters will block
forever if userspace daemon cannot handle backlog. After the timeout waiting
loop turns into busy loop and runs until daemon dies or returns back to work.
This is minimal patch for that bug.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Chuck Anderson <chuck.anderson@oracle.com>
Cc: Dan Duval <dan.duval@oracle.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 kernel/audit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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

