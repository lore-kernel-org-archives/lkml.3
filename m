Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbbAGCHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:07:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044AbbAGCHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cedric Bosdonnat <cbosdonnat@suse.com>,
        Richard Weinberger <richard@nod.at>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.14 31/52] mnt: Implicitly add MNT_NODEV on remount when it was implicitly added by mount
Date: Tue,  6 Jan 2015 18:06:59 -0800
Message-Id: <20150107020600.179833672@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1966,7 +1966,13 @@ static int do_remount(struct path *path,
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


