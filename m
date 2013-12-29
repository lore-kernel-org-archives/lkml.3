Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3L2COJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:14:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55850 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616Ab3L2COG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:14:06 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Richard Guy Briggs" <rgb@redhat.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>, linux-audit@redhat.com,
        "Eric Paris" <eparis@redhat.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.70640511@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 027/185] audit: printk USER_AVC messages when audit
 isn't enabled
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -625,7 +625,7 @@ static int audit_log_common_recv_msg(str
 	char *ctx = NULL;
 	u32 len;
 
-	if (!audit_enabled) {
+	if (!audit_enabled && msg_type != AUDIT_USER_AVC) {
 		*ab = NULL;
 		return rc;
 	}

