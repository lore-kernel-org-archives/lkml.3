Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbaICWS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:18:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813AbaICWSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.16 086/125] Btrfs: read lock extent buffer while walking backrefs
Date: Wed,  3 Sep 2014 15:07:23 -0700
Message-Id: <20140903220626.255378126@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 6f7ff6d7832c6be13e8c95598884dbc40ad69fb7 upstream.

Before processing the extent buffer, acquire a read lock on it, so
that we're safe against concurrent updates on the extent buffer.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/backref.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1000,8 +1000,11 @@ again:
 					ret = -EIO;
 					goto out;
 				}
+				btrfs_tree_read_lock(eb);
+				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie);
+				btrfs_tree_read_unlock_blocking(eb);
 				free_extent_buffer(eb);
 				if (ret < 0)
 					goto out;


