Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab3KVMRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:17:43 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:60575 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab3KVMRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:17:41 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] n_tty: Fix 4096-byte canonical reads
Date: Fri, 22 Nov 2013 07:16:25 -0500
Message-Id: <1385122585-8535-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: <stable@vger.kernel.org> # 3.12.x
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 053ead2..0f74945 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1998,7 +1998,10 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 		found = 1;
 
 	size = N_TTY_BUF_SIZE - tail;
-	n = (found + eol + size) & (N_TTY_BUF_SIZE - 1);
+	n = eol - tail;
+	if (n > 4096)
+		n += 4096;
+	n += found;
 	c = n;
 
 	if (found && read_buf(ldata, eol) == __DISABLED_CHAR) {
-- 
1.8.1.2

