Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbaIOXJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:09:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbaIOWMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 137/187] CIFS: Fix async reading on reconnects
Date: Mon, 15 Sep 2014 15:09:07 -0700
Message-Id: <1410818997-9432-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 038bc961c31b070269ecd07349a7ee2e839d4fec upstream.

If we get into read_into_pages() from cifs_readv_receive() and then
loose a network, we issue cifs_reconnect that moves all mids to
a private list and issue their callbacks. The callback of the async
read request sets a mid to retry, frees it and wakes up a process
that waits on the rdata completion.

After the connection is established we return from read_into_pages()
with a short read, use the mid that was freed before and try to read
the remaining data from the a newly created socket. Both actions are
not what we want to do. In reconnect cases (-EAGAIN) we should not
mask off the error with a short read but should return the error
code instead.

Acked-by: Jeff Layton <jlayton@samba.org>
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4911dc8..dd4aaca 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2847,7 +2847,7 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 		total_read += result;
 	}
 
-	return total_read > 0 ? total_read : result;
+	return total_read > 0 && result != -EAGAIN ? total_read : result;
 }
 
 static ssize_t
@@ -3270,7 +3270,7 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 		total_read += result;
 	}
 
-	return total_read > 0 ? total_read : result;
+	return total_read > 0 && result != -EAGAIN ? total_read : result;
 }
 
 static int cifs_readpages(struct file *file, struct address_space *mapping,
-- 
1.9.1

