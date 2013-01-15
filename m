Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298Ab3AOW4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:56:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:48233 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933995Ab3AOW4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:56:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michael Tokarev <mjt@tls.msk.ru>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 35/71] ext4: do not try to write superblock on ro remount w/o journal
Date: Tue, 15 Jan 2013 14:54:32 -0800
Message-Id: <20130115225342.963666466@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4438,7 +4438,7 @@ static int ext4_remount(struct super_blo
 	}
 
 	ext4_setup_system_zone(sb);
-	if (sbi->s_journal == NULL)
+	if (sbi->s_journal == NULL && !(old_sb_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 
 #ifdef CONFIG_QUOTA


