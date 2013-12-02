Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab3LBT6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:58:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab3LBTSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.12 115/212] n_tty: Fix 4096-byte canonical reads
Date: Mon,  2 Dec 2013 11:15:06 -0800
Message-Id: <20131202191300.031914162@linuxfoundation.org>
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

commit c77569d2f3ef7844ee4ac7005a57da6898b302a8 upstream.

Although the maximum allowable canonical line is specified to
be 255 bytes (MAX_CANON), the practical limit has actually been
the size of the line discipline read buffer (N_TTY_BUF_SIZE == 4096).

Commit 32f13521ca68bc624ff6effc77f308a52b038bf0,
n_tty: Line copy to user buffer in canonical mode, limited the
line copy to 4095 bytes. With a completely full line discipline
read buffer and a userspace buffer > 4095, _no_ data was copied,
and the read() syscall returned 0, indicating EOF.

Fix the interval arithmetic to compute the correct number of bytes
to copy to userspace in the range [1..4096].

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2005,7 +2005,10 @@ static int canon_copy_from_read_buf(stru
 		found = 1;
 
 	size = N_TTY_BUF_SIZE - tail;
-	n = (found + eol + size) & (N_TTY_BUF_SIZE - 1);
+	n = eol - tail;
+	if (n > 4096)
+		n += 4096;
+	n += found;
 	c = n;
 
 	if (found && read_buf(ldata, eol) == __DISABLED_CHAR) {


