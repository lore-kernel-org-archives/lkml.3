Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3CFNVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:21:39 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:48797 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab3CFNVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:21:25 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Vincent Pillet <vincentx.pillet@intel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/3] n_tty: Fix stuck throttled driver
Date: Wed,  6 Mar 2013 08:20:53 -0500
Message-Id: <1362576053-1295-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362576053-1295-1-git-send-email-peter@hurleysoftware.com>
References: <1362576053-1295-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noted in the following comment:

  /* FIXME: there is a tiny race here if the receive room check runs
     before the other work executes and empties the buffer (upping
     the receiving room and unthrottling. We then throttle and get
     stuck. This has been observed and traced down by Vincent Pillet/
     We need to address this when we sort out out the rx path locking */

Use new safe throttle/unthrottle functions to re-evaluate conditions
if interrupted by the complement flow control function.

Reported-by: Vincent Pillet <vincentx.pillet@intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 8f9f665..96d11ec 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1474,14 +1474,14 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	 * mode.  We don't want to throttle the driver if we're in
 	 * canonical mode and don't have a newline yet!
 	 */
-	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
-		tty_throttle(tty);
-
-        /* FIXME: there is a tiny race here if the receive room check runs
-           before the other work executes and empties the buffer (upping
-           the receiving room and unthrottling. We then throttle and get
-           stuck. This has been observed and traced down by Vincent Pillet/
-           We need to address this when we sort out out the rx path locking */
+	while (1) {
+		tty_set_flow_change(tty, TTY_THROTTLE_SAFE);
+		if (tty->receive_room >= TTY_THRESHOLD_THROTTLE)
+			break;
+		if (!tty_throttle_safe(tty))
+			break;
+	}
+	__tty_set_flow_change(tty, 0);
 }
 
 int is_ignored(int sig)
@@ -1954,11 +1954,17 @@ do_it_again:
 		 * longer than TTY_THRESHOLD_UNTHROTTLE in canonical mode,
 		 * we won't get any more characters.
 		 */
-		if (n_tty_chars_in_buffer(tty) <= TTY_THRESHOLD_UNTHROTTLE) {
+		while (1) {
+			tty_set_flow_change(tty, TTY_UNTHROTTLE_SAFE);
+			if (n_tty_chars_in_buffer(tty) > TTY_THRESHOLD_UNTHROTTLE)
+				break;
+			if (!tty->count)
+				break;
 			n_tty_set_room(tty);
-			if (tty->count)
-				tty_unthrottle(tty);
+			if (!tty_unthrottle_safe(tty))
+				break;
 		}
+		__tty_set_flow_change(tty, 0);
 
 		if (b - buf >= minimum)
 			break;
-- 
1.8.1.2

