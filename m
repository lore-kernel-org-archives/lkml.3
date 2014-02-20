Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaBUALx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:11:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbaBTXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:53:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.13 36/99] n_tty: Fix stale echo output
Date: Thu, 20 Feb 2014 15:52:31 -0800
Message-Id: <20140220235119.271296228@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit e2613be5093d04e6589924d36a1e363eef3c87c7 upstream.

When echoes cannot be flushed to output (usually because the tty
has no more write room) and L_ECHO is subsequently turned off, then
when L_ECHO is turned back on, stale echoes are output.

Output completed echoes regardless of the L_ECHO setting:
  1. before normal writes to that tty
  2. if the tty was stopped by soft flow control and is being
     restarted

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -813,8 +813,7 @@ static void process_echoes(struct tty_st
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t echoed;
 
-	if ((!L_ECHO(tty) && !L_ECHONL(tty)) ||
-	    ldata->echo_mark == ldata->echo_tail)
+	if (ldata->echo_mark == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
@@ -1238,7 +1237,8 @@ n_tty_receive_signal_char(struct tty_str
 	if (L_ECHO(tty)) {
 		echo_char(c, tty);
 		commit_echoes(tty);
-	}
+	} else
+		process_echoes(tty);
 	isig(signal, tty);
 	return;
 }
@@ -1269,7 +1269,7 @@ n_tty_receive_char_special(struct tty_st
 	if (I_IXON(tty)) {
 		if (c == START_CHAR(tty)) {
 			start_tty(tty);
-			commit_echoes(tty);
+			process_echoes(tty);
 			return 0;
 		}
 		if (c == STOP_CHAR(tty)) {
@@ -1821,8 +1821,10 @@ static void n_tty_set_termios(struct tty
 	 * Fix tty hang when I_IXON(tty) is cleared, but the tty
 	 * been stopped by STOP_CHAR(tty) before it.
 	 */
-	if (!I_IXON(tty) && old && (old->c_iflag & IXON) && !tty->flow_stopped)
+	if (!I_IXON(tty) && old && (old->c_iflag & IXON) && !tty->flow_stopped) {
 		start_tty(tty);
+		process_echoes(tty);
+	}
 
 	/* The termios change make the tty ready for I/O */
 	wake_up_interruptible(&tty->write_wait);


