Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156Ab3BTAZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:25:55 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:34444 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934991Ab3BTAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:23:12 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 20/27] pktcdvd: Use bio_reset() in disabled code to kill bi_idx usage
Date: Tue, 19 Feb 2013 16:22:34 -0800
Message-Id: <1361319761-23873-21-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the short term this'll help with code auditing, and if this code ever
gets used now it's converted :)

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/pktcdvd.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 783c96c..1119042 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1156,16 +1156,15 @@ static int pkt_start_recovery(struct packet_data *pkt)
 	new_sector = new_block * (CD_FRAMESIZE >> 9);
 	pkt->sector = new_sector;
 
+	bio_reset(pkt->bio);
+	pkt->bio->bi_bdev = pd->bdev;
+	pkt->bio->bi_rw = REQ_WRITE;
 	pkt->bio->bi_sector = new_sector;
-	pkt->bio->bi_next = NULL;
-	pkt->bio->bi_flags = 1 << BIO_UPTODATE;
-	pkt->bio->bi_idx = 0;
-
-	BUG_ON(pkt->bio->bi_rw != REQ_WRITE);
-	BUG_ON(pkt->bio->bi_vcnt != pkt->frames);
-	BUG_ON(pkt->bio->bi_size != pkt->frames * CD_FRAMESIZE);
-	BUG_ON(pkt->bio->bi_end_io != pkt_end_io_packet_write);
-	BUG_ON(pkt->bio->bi_private != pkt);
+	pkt->bio->bi_size = pkt->frames * CD_FRAMESIZE;
+	pkt->bio->bi_vcnt = pkt->frames;
+
+	pkt->bio->bi_end_io = pkt_end_io_packet_write;
+	pkt->bio->bi_private = pkt;
 
 	drop_super(sb);
 	return 1;
-- 
1.7.12

