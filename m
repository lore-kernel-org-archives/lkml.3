Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaIZKMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:12:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbaIZJq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 108/142] CIFS: Fix async reading on reconnects
Date: Fri, 26 Sep 2014 11:45:19 +0200
Message-Id: <98bbdfdb93af137f5364dddff5286633644cc9d1.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <pshilovsky@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 643a18491bed..892a1e947b5a 100644
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
2.1.0

