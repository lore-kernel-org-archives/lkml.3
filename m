Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3IYA7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:59:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3IYAQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 083/110] Btrfs: dont allow the replace procedure on read only filesystems
Date: Tue, 24 Sep 2013 17:15:21 -0700
Message-Id: <20130925001332.397696395@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Behrens <sbehrens@giantdisaster.de>

commit bbb651e469d99f0088e286fdeb54acca7bb4ad4e upstream.

If you start the replace procedure on a read only filesystem, at
the end the procedure fails to write the updated dev_items to the
chunk tree. The problem is that this error is not indicated except
for a WARN_ON(). If the user now thinks that everything was done
as expected and destroys the source device (with mkfs or with a
hammer). The next mount fails with "failed to read chunk root" and
the filesystem is gone.

This commit adds code to fail the attempt to start the replace
procedure if the filesystem is mounted read-only.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3299,6 +3299,9 @@ static long btrfs_ioctl_dev_replace(stru
 
 	switch (p->cmd) {
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
+		if (root->fs_info->sb->s_flags & MS_RDONLY)
+			return -EROFS;
+
 		if (atomic_xchg(
 			&root->fs_info->mutually_exclusive_operation_running,
 			1)) {


