Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685AbaKRPNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:13:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbaKROJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 059/206] fs: make cont_expand_zero interruptible
Date: Tue, 18 Nov 2014 15:06:54 +0100
Message-Id: <b99b3db3dd136f694fced42552c4b927b5364f2f.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index fe2182ec812d..dc1107fec557 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2325,6 +2325,11 @@ static int cont_expand_zero(struct file *file, struct address_space *mapping,
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
2.1.3

