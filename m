Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaIOT4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:56:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbaIOTrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@samba.org>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.10 60/71] CIFS: Fix async reading on reconnects
Date: Mon, 15 Sep 2014 12:26:58 -0700
Message-Id: <20140915192640.699454270@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2809,7 +2809,7 @@ cifs_uncached_read_into_pages(struct TCP
 		total_read += result;
 	}
 
-	return total_read > 0 ? total_read : result;
+	return total_read > 0 && result != -EAGAIN ? total_read : result;
 }
 
 static ssize_t
@@ -3232,7 +3232,7 @@ cifs_readpages_read_into_pages(struct TC
 		total_read += result;
 	}
 
-	return total_read > 0 ? total_read : result;
+	return total_read > 0 && result != -EAGAIN ? total_read : result;
 }
 
 static int cifs_readpages(struct file *file, struct address_space *mapping,


