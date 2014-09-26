Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaIZKMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:12:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969AbaIZJq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/142] mnt: Change the default remount atime from relatime to the existing value
Date: Fri, 26 Sep 2014 11:45:00 +0200
Message-Id: <fafbc9412b8f2dae04bc3ca233ae7b49482c8df8.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/namespace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7c67de88f3f1..4ea2b7378d8c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2391,6 +2391,14 @@ long do_mount(const char *dev_name, const char *dir_name,
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
2.1.0

