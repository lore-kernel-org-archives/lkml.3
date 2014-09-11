Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaIKMlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:41:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51674 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.825648406@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 041/131] mnt: Change the default remount atime from
 relatime to the existing value
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: add definition of MNT_ATIME_MASK, as we don't
 need the fix that introduced that definition upstream]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2333,6 +2333,14 @@ long do_mount(char *dev_name, char *dir_
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
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -43,6 +43,7 @@ struct mnt_namespace;
  */
 #define MNT_SHARED_MASK	(MNT_UNBINDABLE)
 #define MNT_PROPAGATION_MASK	(MNT_SHARED | MNT_UNBINDABLE)
+#define MNT_ATIME_MASK (MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME )
 
 
 #define MNT_INTERNAL	0x4000

