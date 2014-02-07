Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaBGTeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:34:04 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:48689 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBGTeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:34:02 -0500
Message-ID: <1391801805.1155.30.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 0/4] minor blk-mq updates
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date: Fri, 07 Feb 2014 11:36:45 -0800
In-Reply-To: <20140207182235.659185141@bombadil.infradead.org>
References: <20140207182235.659185141@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 10:22 -0800, Christoph Hellwig wrote:
> Hi Jens,
> 
> these small blk-mq core updates fell out of the scsi multiqueue work.

That reminds me, the following blk-mq patch was required to get DIF
working with scsi-mq.

Jens, care to pick this up as well..?

--nab

>From 1428a390cc16025f93905852777d4afd8aeba05d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sun, 22 Dec 2013 11:58:49 +0000
Subject: blk-mq: Add bio_integrity setup to blk_mq_make_request

This patch adds the missing bio_integrity_enabled() +
bio_integrity_prep() setup into blk_mq_make_request()
in order to use DIF protection with scsi-mq.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c79126e..a520c39 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -916,6 +916,11 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
 	blk_queue_bounce(q, &bio);
 
+	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
+		bio_endio(bio, -EIO);
+		return;
+	}
+
 	if (use_plug && blk_attempt_plug_merge(q, bio, &request_count))
 		return;
 

