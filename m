Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab3APQIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab3APQIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Tokarev <mjt@tls.msk.ru>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 171/222] ext4: do not try to write superblock on ro remount w/o journal
Date: Wed, 16 Jan 2013 13:56:11 -0200
Message-Id: <1358351822-7675-172-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Tokarev <mjt@tls.msk.ru>

commit d096ad0f79a782935d2e06ae8fb235e8c5397775 upstream.

When a journal-less ext4 filesystem is mounted on a read-only block
device (blockdev --setro will do), each remount (for other, unrelated,
flags, like suid=>nosuid etc) results in a series of scary messages
from kernel telling about I/O errors on the device.

This is becauese of the following code ext4_remount():

       if (sbi->s_journal == NULL)
                ext4_commit_super(sb, 1);

at the end of remount procedure, which forces writing (flushing) of
a superblock regardless whenever it is dirty or not, if the filesystem
is readonly or not, and whenever the device itself is readonly or not.

We only need call ext4_commit_super when the file system had been
previously mounted read/write.

Thanks to Eric Sandeen for help in diagnosing this issue.

Signed-off-By: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b045207..5be2105 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4686,7 +4686,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	ext4_setup_system_zone(sb);
-	if (sbi->s_journal == NULL)
+	if (sbi->s_journal == NULL && !(old_sb_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 
 #ifdef CONFIG_QUOTA
-- 
1.7.9.5

