Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3LBVFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:05:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3LBTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rodolfo Giometti <giometti@enneenne.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 3.10 068/173] mmc: atmel-mci: fix oops in atmci_tasklet_func
Date: Mon,  2 Dec 2013 11:10:51 -0800
Message-Id: <20131202191150.615942788@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodolfo Giometti <giometti@enneenne.com>

commit fbd986cd420d1deeabf1039ec4e74075a5639db5 upstream.

In some cases, a NULL pointer dereference happens because data is NULL when
STATE_END_REQUEST case is reached in atmci_tasklet_func.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/atmel-mci.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1794,12 +1794,14 @@ static void atmci_tasklet_func(unsigned
 			if (unlikely(status)) {
 				host->stop_transfer(host);
 				host->data = NULL;
-				if (status & ATMCI_DTOE) {
-					data->error = -ETIMEDOUT;
-				} else if (status & ATMCI_DCRCE) {
-					data->error = -EILSEQ;
-				} else {
-					data->error = -EIO;
+				if (data) {
+					if (status & ATMCI_DTOE) {
+						data->error = -ETIMEDOUT;
+					} else if (status & ATMCI_DCRCE) {
+						data->error = -EILSEQ;
+					} else {
+						data->error = -EIO;
+					}
 				}
 			}
 


