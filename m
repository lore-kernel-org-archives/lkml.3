Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936542Ab3DKVIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:08:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935677Ab3DKUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:11 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0fkYAOX6RlYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4Tb8Cmw1AOEA:10 a=PtDNVHqPAAAA:8 a=VwQbUJbxAAAA:8 a=DfNHnWVPAAAA:8 a=5B7ymKCk4aPVd3eQcpIA:9 a=wYE_KDyynt4A:10 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202604.512616100@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 111/171 ] ipc: Restrict mounting the mqueue filesystem
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0111-ipc-Restrict-mounting-the-mqueue-filesystem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit a636b702ed1805e988ad3d8ff8b52c060f8b341c ]

Only allow mounting the mqueue filesystem if the caller has CAP_SYS_ADMIN
rights over the ipc namespace.   The principle here is if you create
or have capabilities over it you can mount it, otherwise you get to live
with what other people have mounted.

This information is not particularly sensitive and mqueue essentially
only reports which posix messages queues exist.  Still when creating a
restricted environment for an application to live any extra
information may be of use to someone with sufficient creativity.  The
historical if imperfect way this information has been restricted has
been not to allow mounts and restricting this to ipc namespace
creators maintains the spirit of the historical restriction.

Cc: stable@vger.kernel.org
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 ipc/mqueue.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 9e4cf7f..f1df4bc 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -331,8 +331,16 @@ static struct dentry *mqueue_mount(struct file_system_type *fs_type,
 			 int flags, const char *dev_name,
 			 void *data)
 {
-	if (!(flags & MS_KERNMOUNT))
-		data = current->nsproxy->ipc_ns;
+	if (!(flags & MS_KERNMOUNT)) {
+		struct ipc_namespace *ns = current->nsproxy->ipc_ns;
+		/* Don't allow mounting unless the caller has CAP_SYS_ADMIN
+		 * over the ipc namespace.
+		 */
+		if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+			return ERR_PTR(-EPERM);
+
+		data = ns;
+	}
 	return mount_ns(fs_type, flags, data, mqueue_fill_super);
 }
 
-- 
1.7.10.4


