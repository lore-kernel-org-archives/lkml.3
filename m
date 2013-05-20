Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab3ETKwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3ETKwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Terry Barnaby <terry@beam.ltd.uk>, Chris Ball <cjb@laptop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 008/115] mmc: atmel-mci: pio hang on block errors
Date: Mon, 20 May 2013 11:50:08 +0100
Message-Id: <1369047116-9378-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/atmel-mci.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 77e998b..ac472be 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -175,6 +175,7 @@ struct atmel_mci {
 	void __iomem		*regs;
 
 	struct scatterlist	*sg;
+	unsigned int		sg_len;
 	unsigned int		pio_offset;
 	unsigned int		*buffer;
 	unsigned int		buf_size;
@@ -819,6 +820,7 @@ static u32 atmci_prepare_data(struct atmel_mci *host, struct mmc_data *data)
 	data->error = -EINPROGRESS;
 
 	host->sg = data->sg;
+	host->sg_len = data->sg_len;
 	host->data = data;
 	host->data_chan = NULL;
 
@@ -1751,7 +1753,8 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 			if (offset == sg->length) {
 				flush_dcache_page(sg_page(sg));
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1764,7 +1767,8 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 
 			flush_dcache_page(sg_page(sg));
 			host->sg = sg = sg_next(sg);
-			if (!sg)
+			host->sg_len--;
+			if (!sg || !host->sg_len)
 				goto done;
 
 			offset = 4 - remaining;
@@ -1815,7 +1819,8 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			nbytes += 4;
 			if (offset == sg->length) {
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1829,7 +1834,8 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			nbytes += remaining;
 
 			host->sg = sg = sg_next(sg);
-			if (!sg) {
+			host->sg_len--;
+			if (!sg || !host->sg_len) {
 				atmci_writel(host, ATMCI_TDR, value);
 				goto done;
 			}
-- 
1.8.1.2

