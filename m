Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3GRAlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab3GRAlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:41:17 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] kaudit: prevent an older auditd shutdown from orphaning a newer auditd startup
Date: Wed, 17 Jul 2013 20:40:44 -0400
Message-Id: <1374108044-28026-1-git-send-email-rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been reports of auditd restarts resulting in kaudit not being able
to find a newly registered auditd.  It results in reports such as:
	kernel: [ 2077.233573] audit: *NO* daemon at audit_pid=1614
	kernel: [ 2077.234712] audit: audit_lost=97 audit_rate_limit=0 audit_backlog_limit=320
	kernel: [ 2077.234718] audit: auditd disappeared
		(previously mis-spelled "dissapeared")

One possible cause is a race between the shutdown of an older auditd and a
newer one.  If the newer one sets the daemon pid to itself in kauditd before
the older one has cleared the daemon pid, the newer daemon pid will be erased.
This could be caused by an automated system, or by manual intervention, but in
either case, there is no use in having the older daemon clear the daemon pid
reference since its old pid is no longer being referenced.  This patch will
prevent that specific case, returning an error of EACCES.

The case for preventing a newer auditd from registering itself if there is an
existing auditd is a more difficult case that is beyond the scope of this
patch.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..7cb7486 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -686,6 +686,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (status_get->mask & AUDIT_STATUS_PID) {
 			int new_pid = status_get->pid;
 
+			if ((!new_pid) && (task_tgid_vnr(current) != audit_pid))
+				return -EACCES;
 			if (audit_enabled != AUDIT_OFF)
 				audit_log_config_change("audit_pid", new_pid, audit_pid, 1);
 			audit_pid = new_pid;
-- 
1.7.1

