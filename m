Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbbA2KkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:40:23 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755041AbbA2JAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 172/176] md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.
Date: Wed, 28 Jan 2015 15:30:02 +0100
Message-Id: <852e783e104c8730e6c6b6fd6520480dca1e6eb9.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 108cef3aa41669610e1836fe638812dd067d72de upstream.

It is critical that fetch_block() and handle_stripe_dirtying()
are consistent in their analysis of what needs to be loaded.
Otherwise raid5 can wait forever for a block that won't be loaded.

Currently when writing to a RAID5 that is resyncing, to a location
beyond the resync offset, handle_stripe_dirtying chooses a
reconstruct-write cycle, but fetch_block() assumes a
read-modify-write, and a lockup can happen.

So treat that case just like RAID6, just as we do in
handle_stripe_dirtying.  RAID6 always does reconstruct-write.

This bug was introduced when the behaviour of handle_stripe_dirtying
was changed in 3.7, so the patch is suitable for any kernel since,
though it will need careful merging for some versions.

Cc: stable@vger.kernel.org (v3.7+)
Fixes: a7854487cd7128a30a7f4f5259de9f67d5efb95f
Reported-by: Henry Cai <henryplusplus@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 582bc3f69a43..7b54c3bf9f8f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2789,7 +2789,8 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 	     (s->failed >= 2 && fdev[1]->toread) ||
 	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
-	     (sh->raid_conf->level == 6 && s->failed && s->to_write))) {
+	     ((sh->raid_conf->level == 6 || sh->sector >= sh->raid_conf->mddev->recovery_cp)
+	      && s->failed && s->to_write))) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
 		 */
-- 
2.2.2

