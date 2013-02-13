Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041Ab3BMR57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:57:59 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49097 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964965Ab3BMR5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:51 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:27 -0800
Message-Id: <1360777934-5663-38-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX184GWqW6hYq5620gYAxlBlenBkpNdWNTFQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0828]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 38/85] gfs2: Convert uids and gids between dinodes and vfs inodes.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When reading dinodes from the disk convert uids and gids
into kuids and kgids to store in vfs data structures.

When writing to dinodes to the disk convert kuids and kgids
in the in memory structures into plain uids and gids.

For now all on disk data structures are assumed to be
stored in the initial user namespace.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/glops.c |    4 ++--
 fs/gfs2/inode.c |    4 ++--
 fs/gfs2/super.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 78d4184..444b650 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -322,8 +322,8 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 		break;
 	};
 
-	ip->i_inode.i_uid = be32_to_cpu(str->di_uid);
-	ip->i_inode.i_gid = be32_to_cpu(str->di_gid);
+	i_uid_write(&ip->i_inode, be32_to_cpu(str->di_uid));
+	i_gid_write(&ip->i_inode, be32_to_cpu(str->di_gid));
 	gfs2_set_nlink(&ip->i_inode, be32_to_cpu(str->di_nlink));
 	i_size_write(&ip->i_inode, be64_to_cpu(str->di_size));
 	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index bb7c754..b862d11 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -456,8 +456,8 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	di->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
 	di->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
 	di->di_mode = cpu_to_be32(ip->i_inode.i_mode);
-	di->di_uid = cpu_to_be32(ip->i_inode.i_uid);
-	di->di_gid = cpu_to_be32(ip->i_inode.i_gid);
+	di->di_uid = cpu_to_be32(i_uid_read(&ip->i_inode));
+	di->di_gid = cpu_to_be32(i_gid_read(&ip->i_inode));
 	di->di_nlink = 0;
 	di->di_size = cpu_to_be64(ip->i_inode.i_size);
 	di->di_blocks = cpu_to_be64(1);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 7cc5a60..a034253 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -721,8 +721,8 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
 	str->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
 	str->di_mode = cpu_to_be32(ip->i_inode.i_mode);
-	str->di_uid = cpu_to_be32(ip->i_inode.i_uid);
-	str->di_gid = cpu_to_be32(ip->i_inode.i_gid);
+	str->di_uid = cpu_to_be32(i_uid_read(&ip->i_inode));
+	str->di_gid = cpu_to_be32(i_gid_read(&ip->i_inode));
 	str->di_nlink = cpu_to_be32(ip->i_inode.i_nlink);
 	str->di_size = cpu_to_be64(i_size_read(&ip->i_inode));
 	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
-- 
1.7.5.4

