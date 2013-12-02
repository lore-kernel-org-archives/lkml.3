Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab3LBTxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:53:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3LBTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.12 119/212] n_tty: Ensure reader restarts worker for next reader
Date: Mon,  2 Dec 2013 11:15:10 -0800
Message-Id: <20131202191300.431715789@linuxfoundation.org>
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

commit 42458f41d08f0873299e830464c1232a6839297d upstream.

A departing reader must restart a flush_to_ldisc() worker _before_
the next reader enters the read loop; this is to avoid the new reader
concluding no more i/o is available and prematurely exiting, when the
old reader simply hasn't re-started the worker yet.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2253,6 +2253,9 @@ static ssize_t n_tty_read(struct tty_str
 		if (time)
 			timeout = time;
 	}
+	n_tty_set_room(tty);
+	up_read(&tty->termios_rwsem);
+
 	mutex_unlock(&ldata->atomic_read_lock);
 	remove_wait_queue(&tty->read_wait, &wait);
 
@@ -2263,8 +2266,6 @@ static ssize_t n_tty_read(struct tty_str
 	if (b - buf)
 		retval = b - buf;
 
-	n_tty_set_room(tty);
-	up_read(&tty->termios_rwsem);
 	return retval;
 }
 


