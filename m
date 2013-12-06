Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162268Ab3LFNpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:45:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44188 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab3LFNC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Eric Paris <eparis@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 133/272] audit: log the audit_names record type
Date: Fri,  6 Dec 2013 12:57:02 +0000
Message-Id: <1386334761-25517-134-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit d3aea84a4ace5ff9ce7fb7714cee07bebef681c2 upstream.

...to make it clear what the intent behind each record's operation was.

In many cases you can infer this, based on the context of the syscall
and the result. In other cases it's not so obvious. For instance, in
the case where you have a file being renamed over another, you'll have
two different records with the same filename but different inode info.
By logging this information we can clearly tell which one was created
and which was deleted.

This fixes what was broken in commit bfcec708.
Commit 79f6530c should also be backported to stable v3.7+.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 34eeb48..7ddfd8a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1537,6 +1537,26 @@ void audit_log_name(struct audit_context *context, struct audit_names *n,
 		}
 	}
 
+	/* log the audit_names record type */
+	audit_log_format(ab, " nametype=");
+	switch(n->type) {
+	case AUDIT_TYPE_NORMAL:
+		audit_log_format(ab, "NORMAL");
+		break;
+	case AUDIT_TYPE_PARENT:
+		audit_log_format(ab, "PARENT");
+		break;
+	case AUDIT_TYPE_CHILD_DELETE:
+		audit_log_format(ab, "DELETE");
+		break;
+	case AUDIT_TYPE_CHILD_CREATE:
+		audit_log_format(ab, "CREATE");
+		break;
+	default:
+		audit_log_format(ab, "UNKNOWN");
+		break;
+	}
+
 	audit_log_fcaps(ab, n);
 	audit_log_end(ab);
 }
-- 
1.8.3.2

