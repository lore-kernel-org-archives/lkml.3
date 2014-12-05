Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbaLEB5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:57:47 -0500
Received: from mail-pa0-f74.google.com ([209.85.220.74]:60161 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513AbaLEB4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:56:37 -0500
From: Aditya Kali <adityakali@google.com>
To: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, ebiederm@xmission.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com
Cc: containers@lists.linux-foundation.org, jnagal@google.com,
        vgoyal@redhat.com, richard.weinberger@gmail.com,
        Aditya Kali <adityakali@google.com>
Subject: [PATCHv3 6/8] cgroup: cgroup namespace setns support
Date: Thu,  4 Dec 2014 17:55:48 -0800
Message-Id: <1417744550-6461-7-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1417744550-6461-1-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1417744550-6461-1-git-send-email-adityakali@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setns on a cgroup namespace is allowed only if
task has CAP_SYS_ADMIN in its current user-namespace and
over the user-namespace associated with target cgroupns.
No implicit cgroup changes happen with attaching to another
cgroupns. It is expected that the somone moves the attaching
process under the target cgroupns-root.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 kernel/cgroup_namespace.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
index 0e0ef3a..ee0cc51 100644
--- a/kernel/cgroup_namespace.c
+++ b/kernel/cgroup_namespace.c
@@ -79,8 +79,21 @@ err_out:
 
 static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
 {
-	pr_info("setns not supported for cgroup namespace");
-	return -EINVAL;
+	struct cgroup_namespace *cgroup_ns = ns;
+
+	if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
+	    !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Don't need to do anything if we are attaching to our own cgroupns. */
+	if (cgroup_ns == nsproxy->cgroup_ns)
+		return 0;
+
+	get_cgroup_ns(cgroup_ns);
+	put_cgroup_ns(nsproxy->cgroup_ns);
+	nsproxy->cgroup_ns = cgroup_ns;
+
+	return 0;
 }
 
 static void *cgroupns_get(struct task_struct *task)
-- 
2.2.0.rc0.207.ga3a616c

