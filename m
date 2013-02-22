Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab3BVSTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:19:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759015Ab3BVSTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:19:03 -0500
Date: Fri, 22 Feb 2013 13:18:57 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: eparis@redhat.com, Christian Kujau <lists@nerdbynature.de>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, the addition of dmesg_restrict covered both the syslog
method of accessing dmesg, as well as /dev/kmsg itself.  This was done
indirectly by security_syslog calling cap_syslog before doing any LSM
checks.

However, commit 12b3052c3ee (capabilities/syslog: open code cap_syslog
logic to fix build failure) moved the code around and pushed the checks
into the caller itself.  That seems to have inadvertently dropped the
checks for dmesg_restrict on /dev/kmsg.  Most people haven't noticed
because util-linux dmesg(1) defaults to using the syslog method for
access in older versions.  With util-linux 2.22 and a kernel newer than
3.5, dmesg(1) defaults to reading directly from /dev/kmsg.

Fix this by making an explicit check in the devkmsg_open function.

This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192

Reported-by: Christian Kujau <lists@nerdbynature.de>
CC: stable@vger.kernel.org
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 kernel/printk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/printk.c b/kernel/printk.c
index f24633a..398ef9a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -615,6 +615,9 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	struct devkmsg_user *user;
 	int err;
 
+	if (dmesg_restrict && !capable(CAP_SYSLOG))
+		return -EACCES;
+
 	/* write-only does not need any file context */
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
-- 
1.8.1.2

