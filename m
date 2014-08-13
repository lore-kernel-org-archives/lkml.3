Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaHMLtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:49:39 -0400
Received: from mailp.voltaire.com ([193.47.165.129]:51669 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751648AbaHMLth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:49:37 -0400
From: Sagi Grimberg <sagig@mellanox.com>
To: axboe@kernel.dk, martin.petersen@oracle.com
Cc: kmo@daterainc.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] block: Fix BUG_ON when pi errors occur
Date: Wed, 13 Aug 2014 14:49:31 +0300
Message-Id: <1407930571-26532-1-git-send-email-sagig@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When getting a pi error we get to bio_integrity_end_io with
bi_remaining already decremented to 0 where we will eventually
need to call bio_endio with restored original bio completion handler.
Calling bio_endio invokes a BUG_ON(). We should call bio_endio_nodec
instead, like what is done in bio_integrity_verify_fn.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 block/bio-integrity.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 9e24106..90d40f9 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -526,7 +526,7 @@ void bio_integrity_endio(struct bio *bio, int error)
 	 */
 	if (error) {
 		bio->bi_end_io = bip->bip_end_io;
-		bio_endio(bio, error);
+		bio_endio_nodec(bio, error);
 
 		return;
 	}
-- 
1.7.1

