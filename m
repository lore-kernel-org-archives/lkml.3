Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaBKU6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:58:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaBKTFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 3.13 009/120] audit: reset audit backlog wait time after error recovery
Date: Tue, 11 Feb 2014 11:04:10 -0800
Message-Id: <20140211184823.780685449@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -102,7 +102,8 @@ static int	audit_rate_limit;
 
 /* Number of outstanding audit_buffers allowed. */
 static int	audit_backlog_limit = 64;
-static int	audit_backlog_wait_time = 60 * HZ;
+#define AUDIT_BACKLOG_WAIT_TIME (60 * HZ)
+static int	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
 static int	audit_backlog_wait_overflow = 0;
 
 /* The identity of the user shutting down the audit system. */
@@ -1239,6 +1240,8 @@ struct audit_buffer *audit_log_start(str
 		return NULL;
 	}
 
+	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
+
 	ab = audit_buffer_alloc(ctx, gfp_mask, type);
 	if (!ab) {
 		audit_log_lost("out of memory in audit_log_start");


