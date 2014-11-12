Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965701AbaKLBt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:49:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965684AbaKLBtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:49:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.10 011/123] fs: make cont_expand_zero interruptible
Date: Wed, 12 Nov 2014 10:16:17 +0900
Message-Id: <20141112011719.494631391@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c2ca0fcd202863b14bd041a7fece2e789926c225 upstream.

This patch makes it possible to kill a process looping in
cont_expand_zero. A process may spend a lot of time in this function, so
it is desirable to be able to kill it.

It happened to me that I wanted to copy a piece data from the disk to a
file. By mistake, I used the "seek" parameter to dd instead of "skip". Due
to the "seek" parameter, dd attempted to extend the file and became stuck
doing so - the only possibility was to reset the machine or wait many
hours until the filesystem runs out of space and cont_expand_zero fails.
We need this patch to be able to terminate the process.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/buffer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2254,6 +2254,11 @@ static int cont_expand_zero(struct file
 		err = 0;
 
 		balance_dirty_pages_ratelimited(mapping);
+
+		if (unlikely(fatal_signal_pending(current))) {
+			err = -EINTR;
+			goto out;
+		}
 	}
 
 	/* page covers the boundary, find the boundary offset */


