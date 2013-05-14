Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab3ENQiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab3ENQiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:38:15 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com
Subject: [PATCH v4 14/20] ext4: truncate_inode_pages() in orphan cleanup path
Date: Tue, 14 May 2013 18:37:28 +0200
Message-Id: <1368549454-8930-15-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we do not tell mm to zero out tail of the page before truncate
in orphan_cleanup(). This is ok, because the page should not be
uptodate, however this may eventually change and I might cause problems.

Call truncate_inode_pages() as precautionary measure. Thanks Jan Kara
for pointing this out.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dbc7c09..b971066 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2173,6 +2173,7 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
 			mutex_lock(&inode->i_mutex);
+			truncate_inode_pages(inode->i_mapping, inode->i_size);
 			ext4_truncate(inode);
 			mutex_unlock(&inode->i_mutex);
 			nr_truncates++;
-- 
1.7.7.6

