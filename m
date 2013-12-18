Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3LRVOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:14:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3LRVOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 107/118] Btrfs: reset intwrite on transaction abort
Date: Wed, 18 Dec 2013 13:12:24 -0800
Message-Id: <20131218211222.485388776@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit e0228285a8cad70e4b7b4833cc650e36ecd8de89 upstream.

If we abort a transaction in the middle of a commit we weren't undoing the
intwrite locking.  This patch fixes that problem.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/transaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1552,6 +1552,8 @@ static void cleanup_transaction(struct b
 		root->fs_info->running_transaction = NULL;
 	spin_unlock(&root->fs_info->trans_lock);
 
+	if (trans->type & __TRANS_FREEZABLE)
+		sb_end_intwrite(root->fs_info->sb);
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 


