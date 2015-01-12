Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbbALSjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:39:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58387 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbbALSar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 190/216] audit: don't attempt to lookup PIDs when changing PID filtering audit rules
Date: Mon, 12 Jan 2015 18:29:28 +0000
Message-Id: <1421087394-2712-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/auditfilter.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 8e9bc9c3dbb7..b2e63ba5f815 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -433,19 +433,6 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
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
-- 
2.1.4

