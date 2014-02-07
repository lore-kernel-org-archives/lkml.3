Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaBGMi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:38:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbaBGLui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luiz Capitulino <lcapitulino@redhat.com>, Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 125/233] audit: reset audit backlog wait time after error recovery
Date: Fri,  7 Feb 2014 11:45:44 +0000
Message-Id: <1391773652-25214-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit e789e561a50de0aaa8c695662d97aaa5eac9d55f upstream.

When the audit queue overflows and times out (audit_backlog_wait_time), the
audit queue overflow timeout is set to zero.  Once the audit queue overflow
timeout condition recovers, the timeout should be reset to the original value.

See also:
	https://lkml.org/lkml/2013/9/2/473

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Dan Duval <dan.duval@oracle.com>
Signed-off-by: Chuck Anderson <chuck.anderson@oracle.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7ddfd8a..6def25f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -103,7 +103,8 @@ static int	audit_rate_limit;
 
 /* Number of outstanding audit_buffers allowed. */
 static int	audit_backlog_limit = 64;
-static int	audit_backlog_wait_time = 60 * HZ;
+#define AUDIT_BACKLOG_WAIT_TIME (60 * HZ)
+static int	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
 static int	audit_backlog_wait_overflow = 0;
 
 /* The identity of the user shutting down the audit system. */
@@ -1135,6 +1136,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 		return NULL;
 	}
 
+	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
+
 	ab = audit_buffer_alloc(ctx, gfp_mask, type);
 	if (!ab) {
 		audit_log_lost("out of memory in audit_log_start");
-- 
1.8.3.2

