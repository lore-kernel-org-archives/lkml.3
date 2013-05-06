Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683Ab3EFXPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:15:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3EFXOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Terry Barnaby <terry@beam.ltd.uk>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 102/104] mmc: atmel-mci: pio hang on block errors
Date: Mon,  6 May 2013 16:13:01 -0700
Message-Id: <20130506230054.099403296@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/atmel-mci.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -178,6 +178,7 @@ struct atmel_mci {
 	void __iomem		*regs;
 
 	struct scatterlist	*sg;
+	unsigned int		sg_len;
 	unsigned int		pio_offset;
 	unsigned int		*buffer;
 	unsigned int		buf_size;
@@ -892,6 +893,7 @@ static u32 atmci_prepare_data(struct atm
 	data->error = -EINPROGRESS;
 
 	host->sg = data->sg;
+	host->sg_len = data->sg_len;
 	host->data = data;
 	host->data_chan = NULL;
 
@@ -1826,7 +1828,8 @@ static void atmci_read_data_pio(struct a
 			if (offset == sg->length) {
 				flush_dcache_page(sg_page(sg));
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1839,7 +1842,8 @@ static void atmci_read_data_pio(struct a
 
 			flush_dcache_page(sg_page(sg));
 			host->sg = sg = sg_next(sg);
-			if (!sg)
+			host->sg_len--;
+			if (!sg || !host->sg_len)
 				goto done;
 
 			offset = 4 - remaining;
@@ -1890,7 +1894,8 @@ static void atmci_write_data_pio(struct
 			nbytes += 4;
 			if (offset == sg->length) {
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1904,7 +1909,8 @@ static void atmci_write_data_pio(struct
 			nbytes += remaining;
 
 			host->sg = sg = sg_next(sg);
-			if (!sg) {
+			host->sg_len--;
+			if (!sg || !host->sg_len) {
 				atmci_writel(host, ATMCI_TDR, value);
 				goto done;
 			}


