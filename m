Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbbA2DTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:19:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46952 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001AbbA2CgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:06 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 069/139] mnt: Implicitly add MNT_NODEV on remount when it was implicitly added by mount
Date: Wed, 28 Jan 2015 14:20:12 -0800
Message-Id: <1422483682-15393-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 3e1866410f11356a9fd869beb3e95983dc79c067 upstream.

Now that remount is properly enforcing the rule that you can't remove
nodev at least sandstorm.io is breaking when performing a remount.

It turns out that there is an easy intuitive solution implicitly
add nodev on remount when nodev was implicitly added on mount.

Tested-by: Cedric Bosdonnat <cbosdonnat@suse.com>
Tested-by: Richard Weinberger <richard@nod.at>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namespace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index fe2b527..32f2b2d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1945,7 +1945,13 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	}
 	if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
 	    !(mnt_flags & MNT_NODEV)) {
-		return -EPERM;
+		/* Was the nodev implicitly added in mount? */
+		if ((mnt->mnt_ns->user_ns != &init_user_ns) &&
+		    !(sb->s_type->fs_flags & FS_USERNS_DEV_MOUNT)) {
+			mnt_flags |= MNT_NODEV;
+		} else {
+			return -EPERM;
+		}
 	}
 	if ((mnt->mnt.mnt_flags & MNT_LOCK_NOSUID) &&
 	    !(mnt_flags & MNT_NOSUID)) {
-- 
1.9.1

