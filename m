Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaKYL54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:57:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaKYKko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 039/254] tty: Fix high cpu load if tty is unreleaseable
Date: Tue, 25 Nov 2014 10:36:29 +0000
Message-Id: <1416912004-5928-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 37b164578826406a173ca7c20d9ba7430134d23e upstream.

Kernel oops can cause the tty to be unreleaseable (for example, if
n_tty_read() crashes while on the read_wait queue). This will cause
tty_release() to endlessly loop without sleeping.

Use a killable sleep timeout which grows by 2n+1 jiffies over the interval
[0, 120 secs.) and then jumps to forever (but still killable).

NB: killable just allows for the task to be rewoken manually, not
to be terminated.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/tty_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 34110719fe03..fd682252bbac 100644
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
2.1.0

