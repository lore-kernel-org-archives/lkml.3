Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaC3Mal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 08:30:41 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:61164 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaC3Mak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:30:40 -0400
Date: Sun, 30 Mar 2014 08:30:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandre Demers <alexandre.f.demers@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH driver-core-next] sysfs: restore in-kernel mount of sysfs
Message-ID: <20140330123036.GA8942@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long ago, sysfs used to depend on vfs data structures for internal
representation and thus needed to make a hidden mount to make them
available.  sysfs stopped depending on vfs for internal representation
long ago and 9e30cc959530 ("sysfs, kernfs: no need to kern_mount()
sysfs from sysfs_init()") removed the internal mount.

This doesn't seem to cause wide-spread failure but there is one
failure reported.  During boot, userland somehow falls into infinite
loop, fills up one of the filesystems used during boot (possibly a
tmpfs) and then hangs.  It isn't yet clear what's going on or why
userland would depend on internal kernel mount of sysfs.

This needs further digging but let's restore the internal mount in the
simplest way.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Alexandre Demers <alexandre.f.demers@gmail.com>
---
 fs/sysfs/mount.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index a66ad61..dd6d455 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -75,5 +75,14 @@ int __init sysfs_init(void)
 		return err;
 	}
 
+	/*
+	 * XXX: Create an in-kernel mount of sysfs.  It isn't clear yet why
+	 * this makes any difference; however, there is one report of
+	 * userland falling into an infinite loop during boot without it.
+	 *
+	 * http://lkml.kernel.org/g/CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com
+	 */
+	WARN_ON(IS_ERR(kern_mount(&sysfs_fs_type)));
+
 	return 0;
 }
