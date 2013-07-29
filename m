Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab3G2SDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:03:17 -0400
Received: from etezian.org ([198.101.225.253]:33056 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab3G2SDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:03:16 -0400
From: Andi Shyti <andi@etezian.org>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikko.rapeli@iki.fi, jlayton@redhat.com, pshilovsky@samba.org
Subject: [PATCH v2] cifs: file: initialize oparms.reconnect before using it
Date: Mon, 29 Jul 2013 20:04:35 +0200
Message-Id: <1375121075-11239-1-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130729093241.437315e1@corrin.poochiereds.net>
References: <20130729093241.437315e1@corrin.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the cifs_reopen_file function, if the following statement is
asserted:

(tcon->unix_ext && cap_unix(tcon->ses) &&
            (CIFS_UNIX_POSIX_PATH_OPS_CAP &
            (tcon->fsUnixInfo.Capability)))

and we succeed to open with cifs_posix_open, the function jumps
to the label reopen_success and checks for oparms.reconnect
which is not initialized.

This issue has been reported by scan.coverity.com

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 fs/cifs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1e57f36..7e36ae3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -647,6 +647,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 				     oflags, &oplock, &cfile->fid.netfid, xid);
 		if (rc == 0) {
 			cifs_dbg(FYI, "posix reopen succeeded\n");
+			oparms.reconnect = true;
 			goto reopen_success;
 		}
 		/*
-- 
1.8.3.2

