Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3D0GGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 02:06:04 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55360 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3D0GGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 02:06:01 -0400
MIME-Version: 1.0
Date: Sat, 27 Apr 2013 14:06:00 +0800
Message-ID: <CAPgLHd-WbX7Lbb0EWimxU=BF5wYHNYQtbEcEQN-9idJ_DDhy=w@mail.gmail.com>
Subject: [PATCH RESEND] spi-topcliff-pch: fix to use list_for_each_entry_safe()
 when delete list items
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca, broonie@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Since we will remove items off the list using list_del_init() we need
to use a safe version of the list_for_each_entry() macro aptly named
list_for_each_entry_safe().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-topcliff-pch.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index f756481..7635803 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -615,7 +615,7 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 	int size;
 	u32 n_writes;
 	int j;
-	struct spi_message *pmsg;
+	struct spi_message *pmsg, *tmp;
 	const u8 *tx_buf;
 	const u16 *tx_sbuf;
 
@@ -656,7 +656,7 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 	if (!data->pkt_rx_buff) {
 		/* flush queue and set status of all transfers to -ENOMEM */
 		dev_err(&data->master->dev, "%s :kzalloc failed\n", __func__);
-		list_for_each_entry(pmsg, data->queue.next, queue) {
+		list_for_each_entry_safe(pmsg, tmp, data->queue.next, queue) {
 			pmsg->status = -ENOMEM;
 
 			if (pmsg->complete != 0)
@@ -703,7 +703,7 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 
 static void pch_spi_nomore_transfer(struct pch_spi_data *data)
 {
-	struct spi_message *pmsg;
+	struct spi_message *pmsg, *tmp;
 	dev_dbg(&data->master->dev, "%s called\n", __func__);
 	/* Invoke complete callback
 	 * [To the spi core..indicating end of transfer] */
@@ -740,7 +740,7 @@ static void pch_spi_nomore_transfer(struct pch_spi_data *data)
 		dev_dbg(&data->master->dev,
 			"%s suspend/remove initiated, flushing queue\n",
 			__func__);
-		list_for_each_entry(pmsg, data->queue.next, queue) {
+		list_for_each_entry_safe(pmsg, tmp, data->queue.next, queue) {
 			pmsg->status = -EIO;
 
 			if (pmsg->complete)
@@ -1187,7 +1187,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 
 static void pch_spi_process_messages(struct work_struct *pwork)
 {
-	struct spi_message *pmsg;
+	struct spi_message *pmsg, *tmp;
 	struct pch_spi_data *data;
 	int bpw;
 
@@ -1199,7 +1199,7 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 	if (data->board_dat->suspend_sts || (data->status == STATUS_EXITING)) {
 		dev_dbg(&data->master->dev, "%s suspend/remove initiated,"
 			"flushing queue\n", __func__);
-		list_for_each_entry(pmsg, data->queue.next, queue) {
+		list_for_each_entry_safe(pmsg, tmp, data->queue.next, queue) {
 			pmsg->status = -EIO;
 
 			if (pmsg->complete != 0) {

