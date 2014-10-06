Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaJFFNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:13:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbaJFFJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:17 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com, arozansk@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com
Subject: [PATCH V5 02/13] namespaces: expose namespace instance serial number in proc_ns_operations
Date: Mon,  6 Oct 2014 01:08:27 -0400
Message-Id: <ebec33a351a8af7822a24d9bed81178c786a0b1a.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the namespace instance serial number for each namespace type in the proc
namespace operations structure to make it available for the proc filesystem.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/namespace.c           |    7 +++++++
 include/linux/proc_ns.h  |    1 +
 ipc/namespace.c          |    8 ++++++++
 kernel/pid_namespace.c   |    7 +++++++
 kernel/user_namespace.c  |    7 +++++++
 kernel/utsname.c         |    8 ++++++++
 net/core/net_namespace.c |    7 +++++++
 7 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9af49ff..f433f21 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3028,6 +3028,12 @@ static unsigned int mntns_inum(void *ns)
 	return mnt_ns->proc_inum;
 }
 
+static long long mntns_snum(void *ns)
+{
+	struct mnt_namespace *mnt_ns = ns;
+	return mnt_ns->serial_num;
+}
+
 const struct proc_ns_operations mntns_operations = {
 	.name		= "mnt",
 	.type		= CLONE_NEWNS,
@@ -3035,4 +3041,5 @@ const struct proc_ns_operations mntns_operations = {
 	.put		= mntns_put,
 	.install	= mntns_install,
 	.inum		= mntns_inum,
+	.snum		= mntns_snum,
 };
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 34a1e10..aaafe3e 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -14,6 +14,7 @@ struct proc_ns_operations {
 	void (*put)(void *ns);
 	int (*install)(struct nsproxy *nsproxy, void *ns);
 	unsigned int (*inum)(void *ns);
+	long long (*snum)(void *ns);
 };
 
 struct proc_ns {
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 76dac5c..36ce7ff 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -191,6 +191,13 @@ static unsigned int ipcns_inum(void *vp)
 	return ns->proc_inum;
 }
 
+static long long ipcns_snum(void *vp)
+{
+	struct ipc_namespace *ns = vp;
+
+	return ns->serial_num;
+}
+
 const struct proc_ns_operations ipcns_operations = {
 	.name		= "ipc",
 	.type		= CLONE_NEWIPC,
@@ -198,4 +205,5 @@ const struct proc_ns_operations ipcns_operations = {
 	.put		= ipcns_put,
 	.install	= ipcns_install,
 	.inum		= ipcns_inum,
+	.snum		= ipcns_snum,
 };
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 40a8b36..059b330 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -370,6 +370,12 @@ static unsigned int pidns_inum(void *ns)
 	return pid_ns->proc_inum;
 }
 
+static long long pidns_snum(void *ns)
+{
+	struct pid_namespace *pid_ns = ns;
+	return pid_ns->serial_num;
+}
+
 const struct proc_ns_operations pidns_operations = {
 	.name		= "pid",
 	.type		= CLONE_NEWPID,
@@ -377,6 +383,7 @@ const struct proc_ns_operations pidns_operations = {
 	.put		= pidns_put,
 	.install	= pidns_install,
 	.inum		= pidns_inum,
+	.snum		= pidns_snum,
 };
 
 static __init int pid_namespaces_init(void)
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 5c5c399..3f04df5 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -896,6 +896,12 @@ static unsigned int userns_inum(void *ns)
 	return user_ns->proc_inum;
 }
 
+static long long userns_snum(void *ns)
+{
+	struct user_namespace *user_ns = ns;
+	return user_ns->serial_num;
+}
+
 const struct proc_ns_operations userns_operations = {
 	.name		= "user",
 	.type		= CLONE_NEWUSER,
@@ -903,6 +909,7 @@ const struct proc_ns_operations userns_operations = {
 	.put		= userns_put,
 	.install	= userns_install,
 	.inum		= userns_inum,
+	.snum		= userns_snum,
 };
 
 static __init int user_namespaces_init(void)
diff --git a/kernel/utsname.c b/kernel/utsname.c
index d0cf7b5..ffeac1b 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -132,6 +132,13 @@ static unsigned int utsns_inum(void *vp)
 	return ns->proc_inum;
 }
 
+static long long utsns_snum(void *vp)
+{
+	struct uts_namespace *ns = vp;
+
+	return ns->serial_num;
+}
+
 const struct proc_ns_operations utsns_operations = {
 	.name		= "uts",
 	.type		= CLONE_NEWUTS,
@@ -139,4 +146,5 @@ const struct proc_ns_operations utsns_operations = {
 	.put		= utsns_put,
 	.install	= utsns_install,
 	.inum		= utsns_inum,
+	.snum		= utsns_snum,
 };
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3b5cfdb..c402eea 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -671,6 +671,12 @@ static unsigned int netns_inum(void *ns)
 	return net->proc_inum;
 }
 
+static long long netns_snum(void *ns)
+{
+	struct net *net = ns;
+	return net->serial_num;
+}
+
 const struct proc_ns_operations netns_operations = {
 	.name		= "net",
 	.type		= CLONE_NEWNET,
@@ -678,5 +684,6 @@ const struct proc_ns_operations netns_operations = {
 	.put		= netns_put,
 	.install	= netns_install,
 	.inum		= netns_inum,
+	.snum		= netns_snum,
 };
 #endif
-- 
1.7.1

