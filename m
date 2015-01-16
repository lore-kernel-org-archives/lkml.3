Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbbAPUF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:05:58 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:46959 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbbAPUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:05:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Christian Riesch <christian.riesch@omicron.at>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Denis Du <dudenis2000@yahoo.ca>,
        =?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 5/6] n_tty: Fix PARMRK over-throttling
Date: Fri, 16 Jan 2015 15:05:38 -0500
Message-Id: <1421438739-29672-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421438739-29672-1-git-send-email-peter@hurleysoftware.com>
References: <1421113668-20468-1-git-send-email-peter@hurleysoftware.com>
 <1421438739-29672-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PARMRK is enabled, the available read buffer space computation is
overly-pessimistic, which results in severely throttled i/o, even
in the absence of parity errors. For example, if the 4k read buffer
contains 1k processed data, the input worker will compute available
space of 333 bytes, despite 3k being available. At 1365 chars of
processed data, 0 space available is computed.

*Divide remaining space* by 3, truncating down (if left == 2, left = 0).

Reported-by: Christian Riesch <christian.riesch@omicron.at>

Conflicts:
	drivers/tty/n_tty.c

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f63b25b..7aeabb7 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1669,9 +1669,8 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 
 	while (1) {
 		/*
-		 * When PARMRK is set, multiply read_cnt by 3, since each byte
-		 * might take up to three times as many spaces (depending on
-		 * its flags, e.g. parity error). [This calculation is wrong.]
+		 * When PARMRK is set, each input char may take up to 3 chars
+		 * in the read buf; reduce the buffer space avail by 3x
 		 *
 		 * If we are doing input canonicalization, and there are no
 		 * pending newlines, let characters through without limit, so
@@ -1683,13 +1682,10 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 		 * read_tail (so this producer will not overwrite unread data)
 		 */
 		size_t tail = smp_load_acquire(&ldata->read_tail);
-		size_t head = ldata->read_head;
 
+		room = N_TTY_BUF_SIZE - (ldata->read_head - tail) - 1;
 		if (I_PARMRK(tty))
-			room = N_TTY_BUF_SIZE - (head - tail) * 3 - 1;
-		else
-			room = N_TTY_BUF_SIZE - (head - tail) - 1;
-
+			room /= 3;
 		if (room <= 0)
 			room = ldata->icanon && ldata->canon_head == tail;
 
-- 
2.2.2

