Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3FKXDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 19:03:13 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51942 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab3FKXDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 19:03:11 -0400
From: =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, olof@lixom.net,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>
Subject: [PATCH] drivers/tty: Don't hangup shared ttys
Date: Tue, 11 Jun 2013 16:03:07 -0700
Message-Id: <1370991787-24141-1-git-send-email-marcheu@chromium.org>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When quickly restarting X servers, we can run into a situation where
one X server quits while another one starts on the same tty. For a
while, two X servers share the tty, and when the old X server
eventually quits, the tty layer hangs up the tty, which among other
things stubs out the tty's ioctl functions. Later on, the new X
server (which shares the tty functions) tries to call some ioctls
on the tty and fails because they have been replaced with the hungup
versions. This in turn causes the new X server to abort.

This patch checks the tty->count to make sure we're the last
consumer before hanging up a tty.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
---
 drivers/tty/tty_io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 6464029..62a0f02 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -619,6 +619,9 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 	if (!tty)
 		return;
 
+	/* Don't hangup if there are other users */
+	if (tty->count > 1)
+		return;
 
 	spin_lock(&redirect_lock);
 	if (redirect && file_tty(redirect) == tty) {
-- 
1.8.3

