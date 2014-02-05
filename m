Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaBEUTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:19:06 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48568 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaBEUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Chris Mason <chris.mason@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 185/213] Btrfs: call the ordered free operation without any locks held
Date: Wed, 5 Feb 2014 15:02:20 -0500
Message-ID: <1391630568-49251-186-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <chris.mason@fusionio.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e9fbcb42201c862fd6ab45c48ead4f47bb2dea9d upstream.

Each ordered operation has a free callback, and this was called with the
worker spinlock held.  Josef made the free callback also call iput,
which we can't do with the spinlock.

This drops the spinlock for the free operation and grabs it again before
moving through the rest of the list.  We'll circle back around to this
and find a cleaner way that doesn't bounce the lock around so much.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/btrfs/async-thread.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 462859a30141..474d1b82e38c 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -212,10 +212,17 @@ static noinline int run_ordered_completions(struct btrfs_workers *workers,
 
 		work->ordered_func(work);
 
-		/* now take the lock again and call the freeing code */
+		/* now take the lock again and drop our item from the list */
 		spin_lock(&workers->order_lock);
 		list_del(&work->order_list);
+		spin_unlock(&workers->order_lock);
+
+		/*
+		 * we don't want to call the ordered free functions
+		 * with the lock held though
+		 */
 		work->ordered_free(work);
+		spin_lock(&workers->order_lock);
 	}
 
 	spin_unlock(&workers->order_lock);
-- 
1.8.5.2

