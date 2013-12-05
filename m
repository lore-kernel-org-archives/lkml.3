Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab3LERuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:50:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403Ab3LERhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hicks <tyhicks@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 51/90] audit: printk USER_AVC messages when audit isn't enabled
Date: Thu,  5 Dec 2013 17:35:33 +0000
Message-Id: <1386264972-5399-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 0868a5e150bc4c47e7a003367cd755811eb41e0b upstream.

When the audit=1 kernel parameter is absent and auditd is not running,
AUDIT_USER_AVC messages are being silently discarded.

AUDIT_USER_AVC messages should be sent to userspace using printk(), as
mentioned in the commit message of 4a4cd633 ("AUDIT: Optimise the
audit-disabled case for discarding user messages").

When audit_enabled is 0, audit_receive_msg() discards all user messages
except for AUDIT_USER_AVC messages. However, audit_log_common_recv_msg()
refuses to allocate an audit_buffer if audit_enabled is 0. The fix is to
special case AUDIT_USER_AVC messages in both functions.

It looks like commit 50397bd1 ("[AUDIT] clean up audit_receive_msg()")
introduced this bug.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 5917dfe..f02d3fc 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -625,7 +625,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 	char *ctx = NULL;
 	u32 len;
 
-	if (!audit_enabled) {
+	if (!audit_enabled && msg_type != AUDIT_USER_AVC) {
 		*ab = NULL;
 		return rc;
 	}
-- 
1.8.3.2

