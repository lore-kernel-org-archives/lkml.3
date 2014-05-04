Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaEDQdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:33:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbaEDPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Quinn Tran <quinn.tran@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 092/158] target/rd: T10-Dif: RAM disk is allocating more space than required.
Date: Sun,  4 May 2014 11:40:01 -0400
Message-Id: <20140504154042.444286204@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <quinn.tran@qlogic.com>

commit 9d2e59f2a778328a41771fe9a0098dadbc4314ba upstream.

Ram disk is allocating 8x more space than required for diff data.
For large RAM disk test, there is small potential for memory
starvation.

(Use block_size when calculating total_sg_needed - sagi + nab)

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_rd.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -242,7 +242,7 @@ static void rd_release_prot_space(struct
 	rd_dev->sg_prot_count = 0;
 }
 
-static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length)
+static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block_size)
 {
 	struct rd_dev_sg_table *sg_table;
 	u32 total_sg_needed, sg_tables;
@@ -252,8 +252,13 @@ static int rd_build_prot_space(struct rd
 
 	if (rd_dev->rd_flags & RDF_NULLIO)
 		return 0;
-
-	total_sg_needed = rd_dev->rd_page_count / prot_length;
+	/*
+	 * prot_length=8byte dif data
+	 * tot sg needed = rd_page_count * (PGSZ/block_size) *
+	 * 		   (prot_length/block_size) + pad
+	 * PGSZ canceled each other.
+	 */
+	total_sg_needed = (rd_dev->rd_page_count * prot_length / block_size) + 1;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
 
@@ -606,7 +611,8 @@ static int rd_init_prot(struct se_device
         if (!dev->dev_attrib.pi_prot_type)
 		return 0;
 
-	return rd_build_prot_space(rd_dev, dev->prot_length);
+	return rd_build_prot_space(rd_dev, dev->prot_length,
+				   dev->dev_attrib.block_size);
 }
 
 static void rd_free_prot(struct se_device *dev)


