Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3JUIAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:00:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab3JUIAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:00:32 -0400
X-IronPort-AV: E=Sophos;i="4.93,537,1378828800"; 
   d="scan'208";a="8814337"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] audit: don't create audit log when audit_backlog_limit is zero
Date: Mon, 21 Oct 2013 16:01:40 +0800
Message-Id: <1382342500-12693-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/21 15:58:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/21 15:58:04,
	Serialize complete at 2013/10/21 15:58:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the man page of auditctl said:
"
-b backlog
              Set max number of outstanding audit buffers allowed (Kernel Default=64)
	      If all buffers are full, the failure flag is consulted by the kernel
              for action.
"

So if audit_backlog_limit is zero, it means no audit buffer
should be allocated.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..bbb4000 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1104,14 +1104,16 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	if (unlikely(audit_filter_type(type)))
 		return NULL;
 
+	if (!audit_backlog_limit)
+		return NULL;
+
 	if (gfp_mask & __GFP_WAIT)
 		reserve = 0;
 	else
 		reserve = 5; /* Allow atomic callers to go up to five
 				entries over the normal backlog limit */
 
-	while (audit_backlog_limit
-	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
+	while (skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
 		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time) {
 			unsigned long sleep_time;
 
-- 
1.8.3.1

