Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab3DBWbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:31:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631Ab3DBWOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [ 10/68] sysfs: handle failure path correctly for readdir()
Date: Tue,  2 Apr 2013 15:12:59 -0700
Message-Id: <20130402221331.128188706@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/sysfs/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1002,6 +1002,8 @@ static int sysfs_readdir(struct file * f
 		ino = parent_sd->s_ino;
 		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	if (filp->f_pos == 1) {
 		if (parent_sd->s_parent)
@@ -1010,6 +1012,8 @@ static int sysfs_readdir(struct file * f
 			ino = parent_sd->s_ino;
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);


