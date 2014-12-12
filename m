Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbaLLGeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:34:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51946 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759329AbaLLGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Hurley" <peter@hurleysoftware.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.971957013@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 117/164] tty: Fix high cpu load if tty is unreleaseable
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/tty_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1594,6 +1594,7 @@ int tty_release(struct inode *inode, str
 	int	devpts;
 	int	idx;
 	char	buf[64];
+	long	timeout = 0;
 
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
 		return 0;
@@ -1721,7 +1722,11 @@ int tty_release(struct inode *inode, str
 				    "active!\n", tty_name(tty, buf));
 		tty_unlock();
 		mutex_unlock(&tty_mutex);
-		schedule();
+		schedule_timeout_killable(timeout);
+		if (timeout < 120 * HZ)
+			timeout = 2 * timeout + 1;
+		else
+			timeout = MAX_SCHEDULE_TIMEOUT;
 	}
 
 	/*

