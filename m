Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860Ab3DBXLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:11:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079Ab3DBWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 052/124] ipc: Restrict mounting the mqueue filesystem
Date: Tue,  2 Apr 2013 15:10:34 -0700
Message-Id: <20130402221110.244125698@linuxfoundation.org>
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

commit a636b702ed1805e988ad3d8ff8b52c060f8b341c upstream.

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

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/mqueue.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -330,8 +330,16 @@ static struct dentry *mqueue_mount(struc
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
 


