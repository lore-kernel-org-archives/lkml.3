Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273Ab3BMSDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:03:34 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60443 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965253Ab3BMSDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:03:04 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:02 -0800
Message-Id: <1360777934-5663-73-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1++X3JIK9fO1MMRshz1I/MTIFYXWHjSJVE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0547]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 73/85] cifs: Override unmappable incoming uids and gids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

The cifs protocol has a 64bit space for uids and gids, while linux
only supports a 32bit space today.  Instead of silently truncating
64bit cifs ids, replace cifs ids that do not fit in the 32bit linux
id space with the default uid and gids for the cifs mount.

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/inode.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ed6208f..d7ea2a6 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -244,15 +244,19 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 		break;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
-		fattr->cf_uid = cifs_sb->mnt_uid;
-	else
-		fattr->cf_uid = le64_to_cpu(info->Uid);
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
-		fattr->cf_gid = cifs_sb->mnt_gid;
-	else
-		fattr->cf_gid = le64_to_cpu(info->Gid);
+	fattr->cf_uid = cifs_sb->mnt_uid;
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)) {
+		u64 id = le64_to_cpu(info->Uid);
+		if (id < ((uid_t)-1))
+			fattr->cf_uid = id;
+	}
+	
+	fattr->cf_gid = cifs_sb->mnt_gid;
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)) {
+		u64 id = le64_to_cpu(info->Gid);
+		if (id < ((gid_t)-1))
+			fattr->cf_gid = id;
+	}
 
 	fattr->cf_nlink = le64_to_cpu(info->Nlinks);
 }
-- 
1.7.5.4

