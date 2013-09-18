Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3IRTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:09:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab3IRTHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:07:54 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6/8] audit: add boot option to override default backlog limit
Date: Wed, 18 Sep 2013 15:06:51 -0400
Message-Id: <9a485bfce587352442d32ffa6ea775b8f60583e5.1379530867.git.rgb@redhat.com>
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
In-Reply-To: <cover.1379530867.git.rgb@redhat.com>
References: <cover.1379530867.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default audit_backlog_limit is 64.  This was a reasonable limit at one time.

systemd causes so much audit queue activity on startup that auditd doesn't
start before the backlog queue has already overflowed by more than a factor of
2.  On a system with audit= not set on the kernel command line, this isn't an
issue since that history isn't kept for auditd when it is available.  On a
system with audit=1 set on the kernel command line, kaudit tries to keep that
history until auditd is able to drain the queue.

This default can be changed by the "-b" option in audit.rules once the system
has booted, but won't help with lost messages on boot.

One way to solve this would be to increase the default backlog queue size to
avoid losing any messages before auditd is able to consume them.  This would
be overkill to the embedded community and insufficient for some servers.

Another way to solve it might be to add a kconfig option to set the default
based on the system type.  An embedded system would get the current (or
smaller) default, while Workstations might get more than now and servers might
get more.

None of these solutions helps if a system's compiled default is too small to
see the lost messages without compiling a new kernel.

This patch adds a boot option (audit already has one to enable/disable it)
"audit_backlog_limit=<n>" that overrides the default to allow the system
administrator to set the backlog limit.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 990d02f..acfa7a9 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -944,9 +944,21 @@ static int __init audit_enable(char *str)
 
 	return 1;
 }
-
 __setup("audit=", audit_enable);
 
+/* Process kernel command-line parameter at boot time.  audit_backlog_limit=<n> */
+static int __init audit_backlog_limit_set(char *str)
+{
+	int audit_backlog_limit_arg = simple_strtol(str, NULL, 0);
+	if ((audit_backlog_limit_arg >= 0) && (audit_backlog_limit_arg < 8192))
+		audit_backlog_limit = audit_backlog_limit_arg;
+
+	printk(KERN_INFO "audit_backlog_limit: %d\n", audit_backlog_limit);
+
+	return 1;
+}
+__setup("audit_backlog_limit=", audit_backlog_limit_set);
+
 static void audit_buffer_free(struct audit_buffer *ab)
 {
 	unsigned long flags;
-- 
1.7.1

