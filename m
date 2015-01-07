Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbbAGCON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:14:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063AbbAGCHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.14 33/52] umount: Disallow unprivileged mount force
Date: Tue,  6 Jan 2015 18:07:01 -0800
Message-Id: <20150107020600.521579094@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit b2f5d4dc38e034eecb7987e513255265ff9aa1cf upstream.

Forced unmount affects not just the mount namespace but the underlying
superblock as well.  Restrict forced unmount to the global root user
for now.  Otherwise it becomes possible a user in a less privileged
mount namespace to force the shutdown of a superblock of a filesystem
in a more privileged mount namespace, allowing a DOS attack on root.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1441,6 +1441,9 @@ SYSCALL_DEFINE2(umount, char __user *, n
 		goto dput_and_out;
 	if (mnt->mnt.mnt_flags & MNT_LOCKED)
 		goto dput_and_out;
+	retval = -EPERM;
+	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
+		goto dput_and_out;
 
 	retval = do_umount(mnt, flags);
 dput_and_out:


