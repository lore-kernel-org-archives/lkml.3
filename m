Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161110AbaKLB4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:56:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161050AbaKLBz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:55:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.10 106/123] tty: Fix high cpu load if tty is unreleaseable
Date: Wed, 12 Nov 2014 10:17:52 +0900
Message-Id: <20141112011723.814379233@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/tty_io.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1698,6 +1698,7 @@ int tty_release(struct inode *inode, str
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
 	int	idx;
 	char	buf[64];
+	long	timeout = 0;
 
 	if (tty_paranoia_check(tty, inode, __func__))
 		return 0;
@@ -1782,7 +1783,11 @@ int tty_release(struct inode *inode, str
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


