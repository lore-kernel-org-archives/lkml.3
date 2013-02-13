Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965401Ab3BMSKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:10:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34188 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965171Ab3BMSCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:46 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:10 -0800
Message-Id: <1360777934-5663-81-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/1nPP/eNgyijWmWqhGuaTqdlkH//m3hT4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0012]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 81/85] cifs: Convert struct cifsFileInfo to use a kuid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/file.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 98312fd..04aa74e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -930,7 +930,7 @@ struct cifsFileInfo {
 	struct list_head tlist;	/* pointer to next fid owned by tcon */
 	struct list_head flist;	/* next fid (file instance) for this inode */
 	struct cifs_fid_locks *llist;	/* brlocks held by this fid */
-	unsigned int uid;	/* allows finding which FileInfo structure */
+	kuid_t uid;		/* allows finding which FileInfo structure */
 	__u32 pid;		/* process id who opened file */
 	struct cifs_fid fid;	/* file id from remote */
 	/* BB add lock scope info here if needed */ ;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b9baf5f..c23fbd8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1649,7 +1649,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 	   are always at the end of the list but since the first entry might
 	   have a close pending, we go through the whole list */
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
-		if (fsuid_only && open_file->uid != current_fsuid())
+		if (fsuid_only && !uid_eq(open_file->uid, current_fsuid()))
 			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_READ) {
 			if (!open_file->invalidHandle) {
@@ -1702,7 +1702,7 @@ refind_writable:
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (!any_available && open_file->pid != current->tgid)
 			continue;
-		if (fsuid_only && open_file->uid != current_fsuid())
+		if (fsuid_only && !uid_eq(open_file->uid, current_fsuid()))
 			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
-- 
1.7.5.4

