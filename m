Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbbA1CTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:19:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbbA1B2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Henry Cai <henryplusplus@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.10 32/32] md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.
Date: Tue, 27 Jan 2015 17:27:02 -0800
Message-Id: <20150128012631.529758868@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2678,7 +2678,8 @@ static int fetch_block(struct stripe_hea
 	     (s->failed >= 2 && fdev[1]->toread) ||
 	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
-	     (sh->raid_conf->level == 6 && s->failed && s->to_write))) {
+	     ((sh->raid_conf->level == 6 || sh->sector >= sh->raid_conf->mddev->recovery_cp)
+	      && s->failed && s->to_write))) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
 		 */


