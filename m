Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaKYLkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:40:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaKYKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 084/254] fs: make cont_expand_zero interruptible
Date: Tue, 25 Nov 2014 10:37:14 +0000
Message-Id: <1416912004-5928-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 19a78d074e0d..4752094053f9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2328,6 +2328,11 @@ static int cont_expand_zero(struct file *file, struct address_space *mapping,
 		err = 0;
 
 		balance_dirty_pages_ratelimited(mapping);
+
+		if (unlikely(fatal_signal_pending(current))) {
+			err = -EINTR;
+			goto out;
+		}
 	}
 
 	/* page covers the boundary, find the boundary offset */
-- 
2.1.0

