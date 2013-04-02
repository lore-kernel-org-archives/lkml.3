Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab3DBWMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:12:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079Ab3DBWMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 047/124] scm: Require CAP_SYS_ADMIN over the current pidns to spoof pids.
Date: Tue,  2 Apr 2013 15:10:29 -0700
Message-Id: <20130402221109.647773164@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 92f28d973cce45ef5823209aab3138eb45d8b349 upstream.

Don't allow spoofing pids over unix domain sockets in the corner
cases where a user has created a user namespace but has not yet
created a pid namespace.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/scm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
 #include <linux/security.h>
+#include <linux/pid_namespace.h>
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
@@ -52,7 +53,8 @@ static __inline__ int scm_check_creds(st
 	if (!uid_valid(uid) || !gid_valid(gid))
 		return -EINVAL;
 
-	if ((creds->pid == task_tgid_vnr(current) || nsown_capable(CAP_SYS_ADMIN)) &&
+	if ((creds->pid == task_tgid_vnr(current) ||
+	     ns_capable(current->nsproxy->pid_ns->user_ns, CAP_SYS_ADMIN)) &&
 	    ((uid_eq(uid, cred->uid)   || uid_eq(uid, cred->euid) ||
 	      uid_eq(uid, cred->suid)) || nsown_capable(CAP_SETUID)) &&
 	    ((gid_eq(gid, cred->gid)   || gid_eq(gid, cred->egid) ||


