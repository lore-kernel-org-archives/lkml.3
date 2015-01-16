Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbbAPUHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:07:37 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:56213 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbbAPUFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:05:53 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Christian Riesch <christian.riesch@omicron.at>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Denis Du <dudenis2000@yahoo.ca>,
        =?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 2/6] n_tty: Fix throttle for canon lines > 3967 chars
Date: Fri, 16 Jan 2015 15:05:35 -0500
Message-Id: <1421438739-29672-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421438739-29672-1-git-send-email-peter@hurleysoftware.com>
References: <1421113668-20468-1-git-send-email-peter@hurleysoftware.com>
 <1421438739-29672-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty driver will be mistakenly throttled if a line termination
has not been received, and the line exceeds 3967 chars. Thus, it is
possible for the driver to stop sending when it has not yet sent
the newline. This does not apply to the pty driver.

Don't throttle until at least one line termination has been
received.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index b60b043..d4b14c3 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -247,6 +247,8 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
 
 static void n_tty_check_throttle(struct tty_struct *tty)
 {
+	struct n_tty_data *ldata = tty->disc_data;
+
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY)
 		return;
 	/*
@@ -254,6 +256,9 @@ static void n_tty_check_throttle(struct tty_struct *tty)
 	 * mode.  We don't want to throttle the driver if we're in
 	 * canonical mode and don't have a newline yet!
 	 */
+	if (ldata->icanon && ldata->canon_head == ldata->read_tail)
+		return;
+
 	while (1) {
 		int throttled;
 		tty_set_flow_change(tty, TTY_THROTTLE_SAFE);
-- 
2.2.2

