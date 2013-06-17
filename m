Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3FQReO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:34:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50535 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3FQReL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:34:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 35/84] cifs: fix off-by-one bug in build_unc_path_to_root
Date: Mon, 17 Jun 2013 10:30:39 -0700
Message-Id: <1371490288-23167-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 1fc29bacedeabb278080e31bb9c1ecb49f143c3b upstream.

commit 839db3d10a (cifs: fix up handling of prefixpath= option) changed
the code such that the vol->prepath no longer contained a leading
delimiter and then fixed up the places that accessed that field to
account for that change.

One spot in build_unc_path_to_root was missed however. When doing the
pointer addition on pos, that patch failed to account for the fact that
we had already incremented "pos" by one when adding the length of the
prepath. This caused a buffer overrun by one byte.

This patch fixes the problem by correcting the handling of "pos".

Reported-by: Marcus Moeller <marcus.moeller@gmx.ch>
Reported-by: Ken Fallon <ken.fallon@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/connect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f7199b9..c70d31a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3316,8 +3316,8 @@ build_unc_path_to_root(const struct smb_vol *vol,
 	pos = full_path + unc_len;
 
 	if (pplen) {
-		*pos++ = CIFS_DIR_SEP(cifs_sb);
-		strncpy(pos, vol->prepath, pplen);
+		*pos = CIFS_DIR_SEP(cifs_sb);
+		strncpy(pos + 1, vol->prepath, pplen);
 		pos += pplen;
 	}
 
-- 
1.8.1.2

