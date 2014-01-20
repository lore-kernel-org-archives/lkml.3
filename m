Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaATX03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:26:29 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46826 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaATX01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:26:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 20 Jan 2014 15:26:15 -0800
Message-ID: <87lhya6xrc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Osrji4ZHonBnpNgujnlShwZDYZFY4los=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0012]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH] vfs: Is mounted should be testing mnt_ns for NULL or error.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A bug was introduced with the is_mounted helper function in
commit f7a99c5b7c8bd3d3f533c8b38274e33f3da9096e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Jun 9 00:59:08 2012 -0400

    get rid of ->mnt_longterm

    it's enough to set ->mnt_ns of internal vfsmounts to something
    distinct from all struct mnt_namespace out there; then we can
    just use the check for ->mnt_ns != NULL in the fast path of
    mntput_no_expire()

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

The intent was to test if the real_mount(vfsmount)->mnt_ns was
NULL_OR_ERR but the code is actually testing real_mount(vfsmount)
and always returning true.

The result is d_absolute_path returning paths it should be hiding.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/mount.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index d64c594be6c4..a17458ca6f29 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -74,7 +74,7 @@ static inline int mnt_has_parent(struct mount *mnt)
 static inline int is_mounted(struct vfsmount *mnt)
 {
 	/* neither detached nor internal? */
-	return !IS_ERR_OR_NULL(real_mount(mnt));
+	return !IS_ERR_OR_NULL(real_mount(mnt)->mnt_ns);
 }
 
 extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *);
-- 
1.7.5.4

