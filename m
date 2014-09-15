Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbaIOT6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:58:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbaIOTrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.10 41/71] mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into do_remount
Date: Mon, 15 Sep 2014 12:26:39 -0700
Message-Id: <20140915192640.063256868@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 07b645589dcda8b7a5249e096fece2a67556f0f4 upstream.

There are no races as locked mount flags are guaranteed to never change.

Moving the test into do_remount makes it more visible, and ensures all
filesystem remounts pass the MNT_LOCK_READONLY permission check.  This
second case is not an issue today as filesystem remounts are guarded
by capable(CAP_DAC_ADMIN) and thus will always fail in less privileged
mount namespaces, but it could become an issue in the future.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1764,9 +1764,6 @@ static int change_mount_flags(struct vfs
 	if (readonly_request == __mnt_is_readonly(mnt))
 		return 0;
 
-	if (mnt->mnt_flags & MNT_LOCK_READONLY)
-		return -EPERM;
-
 	if (readonly_request)
 		error = mnt_make_readonly(real_mount(mnt));
 	else
@@ -1792,6 +1789,16 @@ static int do_remount(struct path *path,
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Don't allow changing of locked mnt flags.
+	 *
+	 * No locks need to be held here while testing the various
+	 * MNT_LOCK flags because those flags can never be cleared
+	 * once they are set.
+	 */
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_READONLY) &&
+	    !(mnt_flags & MNT_READONLY)) {
+		return -EPERM;
+	}
 	err = security_sb_remount(sb, data);
 	if (err)
 		return err;


