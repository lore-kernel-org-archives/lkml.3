Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbaAKXX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 18:23:28 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:49535 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaAKXX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 18:23:26 -0500
Date: Sat, 11 Jan 2014 18:23:23 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH driver-core-next] kernfs: remove unnecessary NULL check in
 __kernfs_remove()
Message-ID: <20140111232323.GA7584@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

895a068a524e ("kernfs: make kernfs_get_active() block if the node is
deactivated but not removed") added "struct kernfs_root *root =
kernfs_root(kn);" at the head of the function; however, the parameter
@kn is checked for later implying that the function may be called with
NULL.  This means that we may end up invoking kernfs_root() with NULL
which will oops.  None of the existing users invokes removal with NULL
@kn, so this bug doesn't actually trigger.

We can relocate kernfs_root() invocation after NULL check; however,
allowing NULL param tends to cause more confusion than actually
helping anything.  As there's no existing user, let's remove the
spurious NULL check.

This bug was detected by smatch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/kernfs/dir.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -920,9 +920,6 @@ static void __kernfs_remove(struct kernf
 
 	lockdep_assert_held(&kernfs_mutex);
 
-	if (!kn)
-		return;
-
 	pr_debug("kernfs %s: removing\n", kn->name);
 
 	__kernfs_deactivate(kn);

