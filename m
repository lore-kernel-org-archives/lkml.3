Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3ITULs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:11:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3ITULq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:11:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 83/93] CIFS: Fix a memory leak when a lease break comes
Date: Fri, 20 Sep 2013 13:09:18 -0700
Message-Id: <1379707768-1804-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 1a05096de82f3cd672c76389f63964952678506f upstream.

This happens when we receive a lease break from a server, then
find an appropriate lease key in opened files and schedule the
oplock_break slow work. lw pointer isn't freed in this case.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/smb2misc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7b1c5e3..a27f337 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -469,6 +469,7 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 
 				queue_work(cifsiod_wq, &cfile->oplock_break);
 
+				kfree(lw);
 				spin_unlock(&cifs_file_list_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
 				return true;
-- 
1.8.1.2

