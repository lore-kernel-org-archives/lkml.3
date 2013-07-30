Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3G3JcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:32:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628Ab3G3JcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Disseldorp <ddiss@suse.de>, Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 007/106] [CIFS] use sensible file nlink values if unprovided
Date: Tue, 30 Jul 2013 10:30:26 +0100
Message-Id: <1375176725-5825-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit 6658b9f70ebca5fc0795b1d6d733996af1e2caa7 upstream.

Certain servers may not set the NumberOfLinks field in query file/path
info responses. In such a case, cifs_inode_needs_reval() assumes that
all regular files are hardlinks and triggers revalidation, leading to
excessive and unnecessary network traffic.

This change hardcodes cf_nlink (and subsequently i_nlink) when not
returned by the server, similar to what already occurs in cifs_mkdir().

Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Steve French <smfrench@gmail.com>
[ luis: backported to 3.5:
  - replaced cifs_dbg() by cFYI() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6fbfbdb..293226e 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -549,6 +549,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 			fattr->cf_mode &= ~(S_IWUGO);
 
 		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
+		if (fattr->cf_nlink < 1) {
+			cFYI(1, "replacing bogus file nlink value %u\n",
+				fattr->cf_nlink);
+			fattr->cf_nlink = 1;
+		}
 	}
 
 	fattr->cf_uid = cifs_sb->mnt_uid;
-- 
1.8.3.2

