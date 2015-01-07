Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbbAGC1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:27:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbbAGCSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH 3.17 57/73] audit: dont attempt to lookup PIDs when changing PID filtering audit rules
Date: Tue,  6 Jan 2015 18:16:18 -0800
Message-Id: <20150107021559.265256072@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 3640dcfa4fd00cd91d88bb86250bdb496f7070c0 upstream.

Commit f1dc4867 ("audit: anchor all pid references in the initial pid
namespace") introduced a find_vpid() call when adding/removing audit
rules with PID/PPID filters; unfortunately this is problematic as
find_vpid() only works if there is a task with the associated PID
alive on the system.  The following commands demonstrate a simple
reproducer.

	# auditctl -D
	# auditctl -l
	# autrace /bin/true
	# auditctl -l

This patch resolves the problem by simply using the PID provided by
the user without any additional validation, e.g. no calls to check to
see if the task/PID exists.

Cc: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/auditfilter.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -433,19 +433,6 @@ static struct audit_entry *audit_data_to
 			f->val = 0;
 		}
 
-		if ((f->type == AUDIT_PID) || (f->type == AUDIT_PPID)) {
-			struct pid *pid;
-			rcu_read_lock();
-			pid = find_vpid(f->val);
-			if (!pid) {
-				rcu_read_unlock();
-				err = -ESRCH;
-				goto exit_free;
-			}
-			f->val = pid_nr(pid);
-			rcu_read_unlock();
-		}
-
 		err = audit_field_valid(entry, f);
 		if (err)
 			goto exit_free;


