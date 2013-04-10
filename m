Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937188Ab3DJXPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:15:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937029Ab3DJWrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marco Munderloh <munderl@tnt.uni-hannover.de>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Airlie <airlied@redhat.com>
Subject: [ 18/64] drm: correctly restore mappings if drm_open fails
Date: Wed, 10 Apr 2013 15:46:15 -0700
Message-Id: <20130410224337.257177171@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit a8ec3a662921220fc058ed6f7f3674697876d218 upstream.

If first drm_open fails, the error-handling path will
incorrectly restore inode's mapping to NULL. This can
cause the crash later on. Fix by separately storing
away mapping pointers that drm_open can touch and
restore each from its own respective variable if the
call fails.

Fixes: https://bugzilla.novell.com/show_bug.cgi?id=807850
(thanks to Michal Hocko for investigating investigating and
finding the root cause of the bug)

Reference:
http://lists.freedesktop.org/archives/dri-devel/2013-March/036564.html

v2: Use one variable to store file and inode mapping
    since they are the same at the function entry.
    Fix spelling mistakes in commit message.

v3: Add reference to the original bug report.

Reported-by: Marco Munderloh <munderl@tnt.uni-hannover.de>
Tested-by: Marco Munderloh <munderl@tnt.uni-hannover.de>
Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_fops.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -123,6 +123,7 @@ int drm_open(struct inode *inode, struct
 	int retcode = 0;
 	int need_setup = 0;
 	struct address_space *old_mapping;
+	struct address_space *old_imapping;
 
 	minor = idr_find(&drm_minors_idr, minor_id);
 	if (!minor)
@@ -137,6 +138,7 @@ int drm_open(struct inode *inode, struct
 	if (!dev->open_count++)
 		need_setup = 1;
 	mutex_lock(&dev->struct_mutex);
+	old_imapping = inode->i_mapping;
 	old_mapping = dev->dev_mapping;
 	if (old_mapping == NULL)
 		dev->dev_mapping = &inode->i_data;
@@ -159,8 +161,8 @@ int drm_open(struct inode *inode, struct
 
 err_undo:
 	mutex_lock(&dev->struct_mutex);
-	filp->f_mapping = old_mapping;
-	inode->i_mapping = old_mapping;
+	filp->f_mapping = old_imapping;
+	inode->i_mapping = old_imapping;
 	iput(container_of(dev->dev_mapping, struct inode, i_data));
 	dev->dev_mapping = old_mapping;
 	mutex_unlock(&dev->struct_mutex);


