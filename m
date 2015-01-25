Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbbAYSrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:47:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbbAYSKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Battersby <tonyb@cybernetics.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.18 084/183] scsi: fix random memory corruption with scsi-mq + T10 PI
Date: Sun, 25 Jan 2015 10:06:46 -0800
Message-Id: <20150125180813.837432695@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

commit 120bb3e1e36da9c1ae6b978c825a28b944a5d7c5 upstream.

This fixes random memory corruption triggered when all three of the
following are true:

* scsi-mq enabled
* T10 Protection Information (DIF) enabled
* SCSI host with sg_tablesize > SCSI_MAX_SG_SEGMENTS (128)

The symptoms of this bug are unpredictable memory corruption, BUG()s,
oopses, lockups, etc., any of which may appear to be completely
unrelated to the root cause.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_lib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1829,7 +1829,9 @@ static int scsi_mq_prep_fn(struct reques
 
 	if (scsi_host_get_prot(shost)) {
 		cmd->prot_sdb = (void *)sg +
-			shost->sg_tablesize * sizeof(struct scatterlist);
+			min_t(unsigned int,
+			      shost->sg_tablesize, SCSI_MAX_SG_SEGMENTS) *
+			sizeof(struct scatterlist);
 		memset(cmd->prot_sdb, 0, sizeof(struct scsi_data_buffer));
 
 		cmd->prot_sdb->table.sgl =


