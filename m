Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3LBTxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:53:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3LBTSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.12 117/212] n_tty: Fix echo overrun tail computation
Date: Mon,  2 Dec 2013 11:15:08 -0800
Message-Id: <20131202191300.248356199@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 6f2225363c205e186c1465c2c7c84f17c1635504 upstream.

Commit cbfd0340ae1993378fd47179db949e050e16e697,
'n_tty: Process echoes in blocks', introduced an error when
consuming the echo buffer tail to prevent buffer overrun, where
the incorrect operation code byte is checked to determine how
far to advance the tail to the next echo byte.

Check the correct byte for the echo operation code byte.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -768,7 +768,7 @@ static size_t __process_echoes(struct tt
 	 * data at the tail to prevent a subsequent overrun */
 	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
 		if (echo_buf(ldata, tail) == ECHO_OP_START) {
-			if (echo_buf(ldata, tail) == ECHO_OP_ERASE_TAB)
+			if (echo_buf(ldata, tail + 1) == ECHO_OP_ERASE_TAB)
 				tail += 3;
 			else
 				tail += 2;


