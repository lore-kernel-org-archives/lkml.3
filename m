Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab3E1Dzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52627 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758908Ab3E1DyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        "Terry Barnaby" <terry@beam.ltd.uk>, "Chris Ball" <cjb@laptop.org>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.34123184@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [05/94] mmc: atmel-mci: pio hang on block errors
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Barnaby <terry@beam.ltd.uk>

commit bdbc5d0c60f3e9de3eeccf1c1a18bdc11dca62cc upstream.

The driver is doing, by default, multi-block reads. When a block error
occurs, card/block.c instigates a single block read: "mmcblk0: retrying
using single block read".  It leaves the sg chain intact and just changes
the length attribute for the first sg entry and the overall sg_len
parameter.  When atmci_read_data_pio is called to read the single block
of data it ignores the sg_len and expects to read more than 512 bytes as
it sees there are multiple items in the sg list. No more data comes as
the controller has only been commanded to get one block.

Signed-off-by: Terry Barnaby <terry@beam.ltd.uk>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/atmel-mci.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -163,6 +163,7 @@ struct atmel_mci {
 	void __iomem		*regs;
 
 	struct scatterlist	*sg;
+	unsigned int		sg_len;
 	unsigned int		pio_offset;
 
 	struct atmel_mci_slot	*cur_slot;
@@ -751,6 +752,7 @@ static u32 atmci_prepare_data(struct atm
 	data->error = -EINPROGRESS;
 
 	host->sg = data->sg;
+	host->sg_len = data->sg_len;
 	host->data = data;
 	host->data_chan = NULL;
 
@@ -1573,7 +1575,8 @@ static void atmci_read_data_pio(struct a
 			if (offset == sg->length) {
 				flush_dcache_page(sg_page(sg));
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1586,7 +1589,8 @@ static void atmci_read_data_pio(struct a
 
 			flush_dcache_page(sg_page(sg));
 			host->sg = sg = sg_next(sg);
-			if (!sg)
+			host->sg_len--;
+			if (!sg || !host->sg_len)
 				goto done;
 
 			offset = 4 - remaining;
@@ -1640,7 +1644,8 @@ static void atmci_write_data_pio(struct
 			nbytes += 4;
 			if (offset == sg->length) {
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1654,7 +1659,8 @@ static void atmci_write_data_pio(struct
 			nbytes += remaining;
 
 			host->sg = sg = sg_next(sg);
-			if (!sg) {
+			host->sg_len--;
+			if (!sg || !host->sg_len) {
 				atmci_writel(host, ATMCI_TDR, value);
 				goto done;
 			}

