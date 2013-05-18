Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3ERDGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:06:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3ERDA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:26 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=u38SSOtgOSgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0RSAhsw8cQwA:10 a=8QEJkOaBAAAA:8 a=jAfPOIUMAAAA:8 a=VwQbUJbxAAAA:8 a=Op-mwl0xAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=gE_ZUhsuebIA:10 a=d4CUUju0HPYA:10 a=jeBq3FmKZ4MA:10 a=BhhSwUBaWxIJ7XzD:21 a=WO4PIR8SM1AgA7uY:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021655.111534263@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Terry Barnaby <terry@beam.ltd.uk>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 083/136 ] mmc: atmel-mci: pio hang on block errors
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0083-mmc-atmel-mci-pio-hang-on-block-errors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Terry Barnaby <terry@beam.ltd.uk>

[ Upstream commit bdbc5d0c60f3e9de3eeccf1c1a18bdc11dca62cc ]

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
Cc: stable <stable@vger.kernel.org> # 3.2+
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/mmc/host/atmel-mci.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 79d0095..8e8afe4 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -175,6 +175,7 @@ struct atmel_mci {
 	void __iomem		*regs;
 
 	struct scatterlist	*sg;
+	unsigned int		sg_len;
 	unsigned int		pio_offset;
 	unsigned int		*buffer;
 	unsigned int		buf_size;
@@ -825,6 +826,7 @@ static u32 atmci_prepare_data(struct atmel_mci *host, struct mmc_data *data)
 	data->error = -EINPROGRESS;
 
 	host->sg = data->sg;
+	host->sg_len = data->sg_len;
 	host->data = data;
 	host->data_chan = NULL;
 
@@ -1757,7 +1759,8 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 			if (offset == sg->length) {
 				flush_dcache_page(sg_page(sg));
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1770,7 +1773,8 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 
 			flush_dcache_page(sg_page(sg));
 			host->sg = sg = sg_next(sg);
-			if (!sg)
+			host->sg_len--;
+			if (!sg || !host->sg_len)
 				goto done;
 
 			offset = 4 - remaining;
@@ -1821,7 +1825,8 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			nbytes += 4;
 			if (offset == sg->length) {
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1835,7 +1840,8 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			nbytes += remaining;
 
 			host->sg = sg = sg_next(sg);
-			if (!sg) {
+			host->sg_len--;
+			if (!sg || !host->sg_len) {
 				atmci_writel(host, ATMCI_TDR, value);
 				goto done;
 			}
-- 
1.7.10.4


