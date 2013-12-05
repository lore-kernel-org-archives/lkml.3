Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3LEHQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:16:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32885 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3LEHQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:16:20 -0500
Date: Thu, 5 Dec 2013 16:15:23 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
CC: <linux-audit@redhat.com>, <linux-kernel@vger.kernel.org>,
        <toshi.okajima@jp.fujitsu.com>, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [RESEND][BUG][PATCH V3] audit: audit_log_start running on auditd
 should not stop
Message-ID: <20131205161523.4f0952f11664d1bbce416579@jp.fujitsu.com>
In-Reply-To: <cover.1386206544.git.rgb@redhat.com>
References: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
	<cover.1386206544.git.rgb@redhat.com>
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

Please apply this patch because the problem that audit_receive called by auditd 
process is hung up by other process (systemd) which has already called it is fixed.

This patch fixes the problem that auditd hangs up by itself.

Thanks.

---
The backlog cannot be consumed when audit_log_start is running on auditd
even if audit_log_start calls wait_for_auditd to consume it.
The situation is the deadlock because only auditd can consume the backlog.
If the other process needs to send the backlog, it can be also stopped 
by the deadlock.

So, audit_log_start running on auditd should not stop.

You can see the deadlock with the following reproducer:
 # auditctl -a exit,always -S all
 # reboot

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Reviewed-by: gaofeng@cn.fujitsu.com
---
 kernel/audit.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..29cfc94 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1095,7 +1095,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	struct audit_buffer	*ab	= NULL;
 	struct timespec		t;
 	unsigned int		uninitialized_var(serial);
-	int reserve;
+	int reserve = 5; /* Allow atomic callers to go up to five
+			    entries over the normal backlog limit */
 	unsigned long timeout_start = jiffies;
 
 	if (audit_initialized != AUDIT_INITIALIZED)
@@ -1104,11 +1105,12 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	if (unlikely(audit_filter_type(type)))
 		return NULL;
 
-	if (gfp_mask & __GFP_WAIT)
-		reserve = 0;
-	else
-		reserve = 5; /* Allow atomic callers to go up to five
-				entries over the normal backlog limit */
+	if (gfp_mask & __GFP_WAIT) {
+		if (audit_pid && audit_pid == current->pid)
+			gfp_mask &= ~__GFP_WAIT;
+		else
+			reserve = 0;
+	}
 
 	while (audit_backlog_limit
 	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
-- 
1.5.5.6
