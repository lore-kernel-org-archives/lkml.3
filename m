Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3IRTJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:09:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab3IRTIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:08:01 -0400
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
Subject: [PATCH 2/8] audit: reset audit backlog wait time after error recovery
Date: Wed, 18 Sep 2013 15:06:47 -0400
Message-Id: <762b08414d480568379cf566c95d81ee66767063.1379530867.git.rgb@redhat.com>
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
In-Reply-To: <cover.1379530867.git.rgb@redhat.com>
References: <cover.1379530867.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the audit queue overflows and times out (audit_backlog_wait_time), the
audit queue overflow timeout is set to zero.  Once the audit queue overflow
timeout condition recovers, the timeout should be reset to the original value.

See also:
	https://lkml.org/lkml/2013/9/2/473

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Dan Duval <dan.duval@oracle.com>
Signed-off-by: Chuck Anderson <chuck.anderson@oracle.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..772725e 100644
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
@@ -1134,6 +1135,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 		return NULL;
 	}
 
+	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
+
 	ab = audit_buffer_alloc(ctx, gfp_mask, type);
 	if (!ab) {
 		audit_log_lost("out of memory in audit_log_start");
-- 
1.7.1

