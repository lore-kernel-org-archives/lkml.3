Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3LBT77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:59:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab3LBTSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>,
        Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com
Subject: [PATCH 3.12 105/212] audit: printk USER_AVC messages when audit isnt enabled
Date: Mon,  2 Dec 2013 11:14:56 -0800
Message-Id: <20131202191259.020425420@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -613,7 +613,7 @@ static int audit_log_common_recv_msg(str
 	int rc = 0;
 	uid_t uid = from_kuid(&init_user_ns, current_uid());
 
-	if (!audit_enabled) {
+	if (!audit_enabled && msg_type != AUDIT_USER_AVC) {
 		*ab = NULL;
 		return rc;
 	}


