Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3LBT5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:57:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3LBTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, Eric Paris <eparis@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.12 109/212] audit: log the audit_names record type
Date: Mon,  2 Dec 2013 11:15:00 -0800
Message-Id: <20131202191259.431099150@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1537,6 +1537,26 @@ void audit_log_name(struct audit_context
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


