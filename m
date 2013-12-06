Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab3LFNCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:02:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44132 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab3LFNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rodolfo Giometti <giometti@enneenne.com>, Chris Ball <cjb@laptop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 121/272] mmc: atmel-mci: fix oops in atmci_tasklet_func
Date: Fri,  6 Dec 2013 12:56:50 +0000
Message-Id: <1386334761-25517-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodolfo Giometti <giometti@enneenne.com>

commit fbd986cd420d1deeabf1039ec4e74075a5639db5 upstream.

In some cases, a NULL pointer dereference happens because data is NULL when
STATE_END_REQUEST case is reached in atmci_tasklet_func.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/atmel-mci.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e9ea2fc..78d7e47 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1792,12 +1792,14 @@ static void atmci_tasklet_func(unsigned long priv)
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
 
-- 
1.8.3.2

