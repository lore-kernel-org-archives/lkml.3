Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3DUUtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 16:49:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43294 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3DUUte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 16:49:34 -0400
Date: Sun, 21 Apr 2013 16:48:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jiri Slaby <jslaby@suse.cz>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-mm@kvack.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        mgorman@suse.de
Subject: [PATCH 3/3 -v2] ext4: mark metadata blocks using bh flags
Message-ID: <20130421204848.GB13543@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jiri Slaby <jslaby@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-mm@kvack.org,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	mgorman@suse.de
References: <20130421000522.GA5054@thunk.org>
 <1366502828-7793-1-git-send-email-tytso@mit.edu>
 <1366502828-7793-3-git-send-email-tytso@mit.edu>
 <5173828A.2030809@suse.cz>
 <20130421195534.GA13543@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421195534.GA13543@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, here's the right version of the patch.

>From 13fca323e9a8b63c08de7a4e05d3c702516b535d Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 21 Apr 2013 16:45:54 -0400
Subject: [PATCH 3/3] ext4: mark metadata blocks using bh flags

This allows metadata writebacks which are issued via block device
writeback to be sent with the current write request flags.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4_jbd2.c | 2 ++
 fs/ext4/inode.c     | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 0e1dc9e..451eb40 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -215,6 +215,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 
 	might_sleep();
 
+	set_buffer_meta(bh);
+	set_buffer_prio(bh);
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 62492e9..d7518e2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1080,10 +1080,14 @@ retry_journal:
 /* For write_end() in data=journal mode */
 static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
+	int ret;
 	if (!buffer_mapped(bh) || buffer_freed(bh))
 		return 0;
 	set_buffer_uptodate(bh);
-	return ext4_handle_dirty_metadata(handle, NULL, bh);
+	ret = ext4_handle_dirty_metadata(handle, NULL, bh);
+	clear_buffer_meta(bh);
+	clear_buffer_prio(bh);
+	return ret;
 }
 
 /*
-- 
1.7.12.rc0.22.gcdd159b

