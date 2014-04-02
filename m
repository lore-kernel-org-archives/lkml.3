Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbaDBRG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbaDBRGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:06:53 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, sgrubb@redhat.com
Subject: [PATCH] integrity: get comm using lock to avoid race in string printing
Date: Wed,  2 Apr 2014 12:19:51 -0400
Message-Id: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When task->comm is passed directly to audit_log_untrustedstring() without
getting a copy or using the task_lock, there is a race that could happen that
would output a NULL (\0) in the output string that would effectively truncate
the rest of the report text after the comm= field in the audit, losing fields.

Use get_task_comm() to get a copy while acquiring the task_lock to prevent
this and to prevent the result from being a mixture of old and new values of
comm.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 security/integrity/integrity_audit.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 85253b5..11706a2 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -33,6 +33,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 			 const char *cause, int result, int audit_info)
 {
 	struct audit_buffer *ab;
+	char comm[sizeof(current->comm)];
 
 	if (!integrity_audit_info && audit_info == 1)	/* Skip info messages */
 		return;
@@ -49,7 +50,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 	audit_log_format(ab, " cause=");
 	audit_log_string(ab, cause);
 	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, current->comm);
+	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	if (fname) {
 		audit_log_format(ab, " name=");
 		audit_log_untrustedstring(ab, fname);
-- 
1.7.1

