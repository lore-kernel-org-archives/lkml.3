Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935079Ab3DGXeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:34:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46882 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935069Ab3DGXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:33:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <levinsasha928@gmail.com>,
        "Dave Jones" <davej@redhat.com>, "Ming Lei" <ming.lei@canonical.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.796935683@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [22/74] sysfs: handle failure path correctly for readdir()
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit e5110f411d2ee35bf8d202ccca2e89c633060dca upstream.

In case of 'if (filp->f_pos ==  0 or 1)' of sysfs_readdir(),
the failure from filldir() isn't handled, and the reference counter
of the sysfs_dirent object pointed by filp->private_data will be
released without clearing filp->private_data, so use after free
bug will be triggered later.

This patch returns immeadiately under the situation for fixing the bug,
and it is reasonable to return from readdir() when filldir() fails.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/sysfs/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -985,6 +985,8 @@ static int sysfs_readdir(struct file * f
 		ino = parent_sd->s_ino;
 		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	if (filp->f_pos == 1) {
 		if (parent_sd->s_parent)
@@ -993,6 +995,8 @@ static int sysfs_readdir(struct file * f
 			ino = parent_sd->s_ino;
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);

