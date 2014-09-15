Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaIOTzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:55:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbaIOTrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.10 43/71] mnt: Change the default remount atime from relatime to the existing value
Date: Mon, 15 Sep 2014 12:26:41 -0700
Message-Id: <20140915192640.124464785@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2346,6 +2346,14 @@ long do_mount(const char *dev_name, cons
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


