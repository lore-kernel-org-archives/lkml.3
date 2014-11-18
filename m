Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaKROVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:21:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbaKROKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 184/206] tty: Fix high cpu load if tty is unreleaseable
Date: Tue, 18 Nov 2014 15:08:59 +0100
Message-Id: <866f9fec24ee1dfa4a40e1d166b6ce3f4c3736de.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 37b164578826406a173ca7c20d9ba7430134d23e upstream.

Kernel oops can cause the tty to be unreleaseable (for example, if
n_tty_read() crashes while on the read_wait queue). This will cause
tty_release() to endlessly loop without sleeping.

Use a killable sleep timeout which grows by 2n+1 jiffies over the interval
[0, 120 secs.) and then jumps to forever (but still killable).

NB: killable just allows for the task to be rewoken manually, not
to be terminated.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index d3448a90f0f9..25d07412e08e 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1701,6 +1701,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
 	int	idx;
 	char	buf[64];
+	long	timeout = 0;
 
 	if (tty_paranoia_check(tty, inode, __func__))
 		return 0;
@@ -1785,7 +1786,11 @@ int tty_release(struct inode *inode, struct file *filp)
 				__func__, tty_name(tty, buf));
 		tty_unlock_pair(tty, o_tty);
 		mutex_unlock(&tty_mutex);
-		schedule();
+		schedule_timeout_killable(timeout);
+		if (timeout < 120 * HZ)
+			timeout = 2 * timeout + 1;
+		else
+			timeout = MAX_SCHEDULE_TIMEOUT;
 	}
 
 	/*
-- 
2.1.3

