Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab3JOEnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 00:43:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58835 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3JOEnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 00:43:18 -0400
Date: Tue, 15 Oct 2013 13:43:45 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: Gao feng <gaofeng@cn.fujitsu.com>, <viro@zeniv.linux.org.uk>,
        <eparis@redhat.com>
CC: <toshi.okajima@jp.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: [BUG][PATCH] audit: audit_log_start running on auditd should not
 stop
Message-ID: <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com>
In-Reply-To: <5257EF15.6080209@jp.fujitsu.com>
References: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com>
	<5257C5D7.80308@cn.fujitsu.com>
	<5257EF15.6080209@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.11; i686-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backlog cannot be consumed when audit_log_start is running on auditd
even if audit_log_start calls wait_for_auditd to consume it.
The situation is a deadlock because only auditd can consume the backlog.
If the other process needs to send the backlog, it can be also stopped 
by the deadlock.

So, audit_log_start running on auditd should not stop.

You can see the deadlock with the following reproducer:
 # auditctl -a exit,always -S all
 # reboot

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: gaofeng@cn.fujitsu.com
---
 kernel/audit.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..ce1fb38 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1098,6 +1098,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	int reserve;
 	unsigned long timeout_start = jiffies;
 
+	if (audit_pid && audit_pid == current->pid)
+		gfp_mask &= ~__GFP_WAIT;
+
 	if (audit_initialized != AUDIT_INITIALIZED)
 		return NULL;
 
-- 
1.5.5.6
