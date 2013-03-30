Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3C3IFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 04:05:37 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:56416 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3C3IFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 04:05:32 -0400
From: Frankie Lin <frankiefrankie.lin@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: open <linux-kernel@vger.kernel.org>,
        Frankie Lin <frankiefrankie.lin@gmail.com>
Subject: [PATCH 1/1] TTY Fix NULL pointer error in tty_wakeup
Date: Sat, 30 Mar 2013 15:58:43 +0800
Message-Id: <1364630323-3078-1-git-send-email-frankiefrankie.lin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling tty_wakeup and the parameter is NULL,the oops will happen.
The virtual address &tty->flags can not be handled in the kernel space,
while PC goto test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags).

Tested on ARM Machine msm8625.

Signed-off-by: Frankie Lin <frankiefrankie.lin@gmail.com>
---
 drivers/tty/tty_io.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 05400ac..9c4fb2e 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -519,6 +519,11 @@ void tty_wakeup(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld;
 
+	if (!tty) {
+		pr_err("tty is null in function: %s.\n", __func__);
+		return;
+	}
+
 	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags)) {
 		ld = tty_ldisc_ref(tty);
 		if (ld) {
-- 
1.7.9.5

