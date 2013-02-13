Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965129Ab3BMSBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:01:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59390 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964965Ab3BMR57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:59 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Date: Wed, 13 Feb 2013 09:51:11 -0800
Message-Id: <1360777934-5663-22-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/XnfUtk8Lfcqs6xFtKigpphHvw6HG0jKo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 22/85] ocfs2: convert between kuids and kgids and DLM locks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Convert between uid and gids stored in the on the wire format of dlm
locks aka struct ocfs2_meta_lvb and kuids and kgids stored in
inode->i_uid and inode->i_gid.

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ocfs2/dlmglue.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4f7795f..f99af1c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2045,8 +2045,8 @@ static void __ocfs2_stuff_meta_lvb(struct inode *inode)
 	lvb->lvb_version   = OCFS2_LVB_VERSION;
 	lvb->lvb_isize	   = cpu_to_be64(i_size_read(inode));
 	lvb->lvb_iclusters = cpu_to_be32(oi->ip_clusters);
-	lvb->lvb_iuid      = cpu_to_be32(inode->i_uid);
-	lvb->lvb_igid      = cpu_to_be32(inode->i_gid);
+	lvb->lvb_iuid      = cpu_to_be32(i_uid_read(inode));
+	lvb->lvb_igid      = cpu_to_be32(i_gid_read(inode));
 	lvb->lvb_imode     = cpu_to_be16(inode->i_mode);
 	lvb->lvb_inlink    = cpu_to_be16(inode->i_nlink);
 	lvb->lvb_iatime_packed  =
@@ -2095,8 +2095,8 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	else
 		inode->i_blocks = ocfs2_inode_sector_count(inode);
 
-	inode->i_uid     = be32_to_cpu(lvb->lvb_iuid);
-	inode->i_gid     = be32_to_cpu(lvb->lvb_igid);
+	i_uid_write(inode, be32_to_cpu(lvb->lvb_iuid));
+	i_gid_write(inode, be32_to_cpu(lvb->lvb_igid));
 	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
 	set_nlink(inode, be16_to_cpu(lvb->lvb_inlink));
 	ocfs2_unpack_timespec(&inode->i_atime,
-- 
1.7.5.4

