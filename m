Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaLHWUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:20:55 -0500
Received: from mail.cybernetics.com ([173.71.130.66]:56631 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbaLHWUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:20:53 -0500
Message-ID: <54862444.3020901@cybernetics.com>
Date: Mon, 08 Dec 2014 17:20:52 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fix random memory corruption with scsi-mq + T10 PI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes random memory corruption triggered when all three of the
following are true:

* scsi-mq enabled
* T10 Protection Information (DIF) enabled
* SCSI host with sg_tablesize > SCSI_MAX_SG_SEGMENTS (128)

The symptoms of this bug are unpredictable memory corruption, BUG()s,
oopses, lockups, etc., any of which may appear to be completely
unrelated to the root cause.

Cc: <stable@vger.kernel.org> # 3.17.x, 3.18.x
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

---

I encountered this problem with a QLogic QLE2672 FC HBA using qla2xxx.
On my system, this would trigger BUG_ON(atomic_read(&bio->bi_remaining) <= 0)
in bio_endio(), or a general protection fault in __sg_free_table()
trying to free prot_sdb, or any number of other weird random problems.
All of this was caused by cmd->prot_sdb pointing to the wrong memory.
To see how the memory is allocated, refer to scsi_mq_setup_tags() in
scsi_lib.c.

For inclusion in 3.19, 3.18.x, and 3.17.x.

--- linux-3.18.0/drivers/scsi/scsi_lib.c.orig	2014-12-08 16:23:28.000000000 -0500
+++ linux-3.18.0/drivers/scsi/scsi_lib.c	2014-12-08 16:24:00.000000000 -0500
@@ -1829,7 +1829,9 @@ static int scsi_mq_prep_fn(struct reques
 
 	if (scsi_host_get_prot(shost)) {
 		cmd->prot_sdb = (void *)sg +
-			shost->sg_tablesize * sizeof(struct scatterlist);
+			min_t(unsigned int,
+			      shost->sg_tablesize, SCSI_MAX_SG_SEGMENTS) *
+			sizeof(struct scatterlist);
 		memset(cmd->prot_sdb, 0, sizeof(struct scsi_data_buffer));
 
 		cmd->prot_sdb->table.sgl =

