Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbaHYQ6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:58:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59870 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbaHYQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:55:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 11/13] mnt: Change the default remount atime from relatime to the existing value
Date: Mon, 25 Aug 2014 09:54:57 -0700
Message-Id: <1408985699-31838-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408985699-31838-1-git-send-email-kamal@canonical.com>
References: <1408985699-31838-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit ffbc6f0ead47fa5a1dc9642b0331cb75c20a640e upstream.

Since March 2009 the kernel has treated the state that if no
MS_..ATIME flags are passed then the kernel defaults to relatime.

Defaulting to relatime instead of the existing atime state during a
remount is silly, and causes problems in practice for people who don't
specify any MS_...ATIME flags and to get the default filesystem atime
setting.  Those users may encounter a permission error because the
default atime setting does not work.

A default that does not work and causes permission problems is
ridiculous, so preserve the existing value to have a default
atime setting that is always guaranteed to work.

Using the default atime setting in this way is particularly
interesting for applications built to run in restricted userspace
environments without /proc mounted, as the existing atime mount
options of a filesystem can not be read from /proc/mounts.

In practice this fixes user space that uses the default atime
setting on remount that are broken by the permission checks
keeping less privileged users from changing more privileged users
atime settings.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namespace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1d8b3d8..4d63cfe 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2327,6 +2327,14 @@ long do_mount(const char *dev_name, const char *dir_name,
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
 
+	/* The default atime for remount is preservation */
+	if ((flags & MS_REMOUNT) &&
+	    ((flags & (MS_NOATIME | MS_NODIRATIME | MS_RELATIME |
+		       MS_STRICTATIME)) == 0)) {
+		mnt_flags &= ~MNT_ATIME_MASK;
+		mnt_flags |= path.mnt->mnt_flags & MNT_ATIME_MASK;
+	}
+
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
 		   MS_STRICTATIME);
-- 
1.9.1

