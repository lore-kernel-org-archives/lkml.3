Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbaJ1Dvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:51:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbaJ1Dvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:51:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc MERLIN <marc@merlins.org>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.10 02/43] Btrfs: fix build_backref_tree issue with multiple shared blocks
Date: Tue, 28 Oct 2014 11:36:00 +0800
Message-Id: <20141028033523.503733500@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit bbe9051441effce51c9a533d2c56440df64db2d7 upstream.

Marc Merlin sent me a broken fs image months ago where it would blow up in the
upper->checked BUG_ON() in build_backref_tree.  This is because we had a
scenario like this

block a -- level 4 (not shared)
   |
block b -- level 3 (reloc block, shared)
   |
block c -- level 2 (not shared)
   |
block d -- level 1 (shared)
   |
block e -- level 0 (shared)

We go to build a backref tree for block e, we notice block d is shared and add
it to the list of blocks to lookup it's backrefs for.  Now when we loop around
we will check edges for the block, so we will see we looked up block c last
time.  So we lookup block d and then see that the block that points to it is
block c and we can just skip that edge since we've already been up this path.
The problem is because we clear need_check when we see block d (as it is shared)
we never add block b as needing to be checked.  And because block c is in our
path already we bail out before we walk up to block b and add it to the backref
check list.

To fix this we need to reset need_check if we trip over a block that doesn't
need to be checked.  This will make sure that any subsequent blocks in the path
as we're walking up afterwards are added to the list to be processed.  With this
patch I can now mount Marc's fs image and it'll complete the balance without
panicing.  Thanks,

Reported-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -967,8 +967,11 @@ again:
 					need_check = false;
 					list_add_tail(&edge->list[UPPER],
 						      &list);
-				} else
+				} else {
+					if (upper->checked)
+						need_check = true;
 					INIT_LIST_HEAD(&edge->list[UPPER]);
+				}
 			} else {
 				upper = rb_entry(rb_node, struct backref_node,
 						 rb_node);


