Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227AbaCUAu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:50:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965592AbaCUAEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.13 137/149] Btrfs: return immediately if tree log mod is not necessary
Date: Thu, 20 Mar 2014 17:05:00 -0700
Message-Id: <20140321000441.706715123@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe David Borba Manana <fdmanana@gmail.com>

commit 783577663507411e36e459390ef056556e93ef29 upstream.

In ctree.c:tree_mod_log_set_node_key() we were calling
__tree_mod_log_insert_key() even when the modification doesn't need
to be logged. This would allocate a tree_mod_elem structure, fill it
and pass it to  __tree_mod_log_insert(), which would just acquire
the tree mod log write lock and then free the tree_mod_elem structure
and return (that is, a no-op).

Therefore call tree_mod_log_insert() instead of __tree_mod_log_insert()
which just returns immediately if the modification doesn't need to be
logged (without allocating the structure, fill it, acquire write lock,
free structure).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -772,7 +772,7 @@ tree_mod_log_set_node_key(struct btrfs_f
 {
 	int ret;
 
-	ret = __tree_mod_log_insert_key(fs_info, eb, slot,
+	ret = tree_mod_log_insert_key(fs_info, eb, slot,
 					MOD_LOG_KEY_REPLACE,
 					atomic ? GFP_ATOMIC : GFP_NOFS);
 	BUG_ON(ret < 0);


