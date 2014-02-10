Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaBJW5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:57:15 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:62335 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaBJW5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:57:14 -0500
Date: Mon, 10 Feb 2014 17:57:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH driver-core-next] kernfs: fix hash calculation in
 kernfs_rename_ns()
Message-ID: <20140210225709.GH25350@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3eef34ad7dc3 ("kernfs: implement kernfs_get_parent(),
kernfs_name/path() and friends") restructured kernfs_rename_ns() such
that new name assignment happens under kernfs_rename_lock;
unfortunately, it mistakenly passed NULL to kernfs_name_hash() to
calculate the new hash if the name hasn't changed, which can lead to
oops.

Fix it by using kn->name and kn->ns when calculating the new hash.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dan Carpenter dan.carpenter@oracle.com
---
 fs/kernfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 939684e..ba8c858 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1296,7 +1296,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 
 	spin_unlock_irq(&kernfs_rename_lock);
 
-	kn->hash = kernfs_name_hash(new_name, new_ns);
+	kn->hash = kernfs_name_hash(kn->name, kn->ns);
 	kernfs_link_sibling(kn);
 
 	kernfs_put(old_parent);
