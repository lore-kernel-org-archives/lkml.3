Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbbALSTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:19:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbbALSGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 070/216] mnt: Implicitly add MNT_NODEV on remount when it was implicitly added by mount
Date: Mon, 12 Jan 2015 18:03:07 +0000
Message-Id: <1421085933-32536-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/namespace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f24161a45b06..e718c7a0437a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1973,7 +1973,13 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
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
2.1.4

