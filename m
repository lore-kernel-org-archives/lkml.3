Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaERQDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:03:44 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63096 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaERQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:03:42 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390: net: qeth_core_main.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:04:27 +0200
Message-Id: <1400429068-10607-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/s390/net/qeth_core_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 22470a3..5562665 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1012,7 +1012,7 @@ static long __qeth_check_irb_error(struct ccw_device *cdev,
 
 	card = CARD_FROM_CDEV(cdev);
 
-	if (!IS_ERR(irb))
+	if (!card || !IS_ERR(irb))
 		return 0;
 
 	switch (PTR_ERR(irb)) {
@@ -1028,7 +1028,7 @@ static long __qeth_check_irb_error(struct ccw_device *cdev,
 		QETH_CARD_TEXT(card, 2, "ckirberr");
 		QETH_CARD_TEXT_(card, 2, "  rc%d", -ETIMEDOUT);
 		if (intparm == QETH_RCD_PARM) {
-			if (card && (card->data.ccwdev == cdev)) {
+			if (card->data.ccwdev == cdev) {
 				card->data.state = CH_STATE_DOWN;
 				wake_up(&card->wait_q);
 			}
-- 
1.7.10.4

