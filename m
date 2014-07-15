Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbaGOXaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:30:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131AbaGOXOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Chadwick <brianchad@westnet.com.au>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3.15 73/84] f2fs: check bdi->dirty_exceeded when trying to skip data writes
Date: Tue, 15 Jul 2014 16:18:10 -0700
Message-Id: <20140715231715.366917437@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 2743f865543c0c4a5e12fc13edb2bf89a6e9687c upstream.

If we don't check the current backing device status, balance_dirty_pages can
fall into infinite pausing routine.

This can be occurred when a lot of directories make a small number of dirty
dentry pages including files.

Reported-by: Brian Chadwick <brianchad@westnet.com.au>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/node.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -42,6 +42,8 @@ bool available_free_memory(struct f2fs_s
 		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >> 12;
 		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
 	} else if (type == DIRTY_DENTS) {
+		if (sbi->sb->s_bdi->dirty_exceeded)
+			return false;
 		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
 		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 1);
 	}


