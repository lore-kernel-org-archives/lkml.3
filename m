Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3BEOl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:41:26 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58798 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab3BEOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:41:01 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/2] tty: metag_da: avoid getting tty kref in dashtty_timer()
Date: Tue, 5 Feb 2013 14:40:50 +0000
Message-ID: <1360075250-21970-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360075250-21970-1-git-send-email-james.hogan@imgtec.com>
References: <1360075250-21970-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_05_14_41_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting the tty kref in dashtty_timer() is no longer necessary since it
isn't needed in fetch_data() any longer (due to changes which make the
tty flip functions refer to tty_ports instead of tty_structs), so just
pass around a channel number instead.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/metag_da.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/metag_da.c b/drivers/tty/metag_da.c
index fc2a36b..0e88862 100644
--- a/drivers/tty/metag_da.c
+++ b/drivers/tty/metag_da.c
@@ -147,9 +147,8 @@ static int chancall(int in_bios_function, int in_channel,
 /*
  * Attempts to fetch count bytes from channel and returns actual count.
  */
-static int fetch_data(struct tty_struct *tty)
+static int fetch_data(unsigned int channel)
 {
-	unsigned int channel = tty->index;
 	struct dashtty_port *dport = &dashtty_ports[channel];
 	int received = 0;
 
@@ -180,31 +179,31 @@ unlock:
 }
 
 /**
- * find_channel_to_poll() - Returns kref to the next channel tty to poll.
- * Returns:	The TTY of the next channel to poll, or NULL if no TTY needs
- *		polling. Release with tty_kref_put().
+ * find_channel_to_poll() - Returns number of the next channel to poll.
+ * Returns:	The number of the next channel to poll, or -1 if none need
+ *		polling.
  */
-static struct tty_struct *find_channel_to_poll(void)
+static int find_channel_to_poll(void)
 {
 	static int last_polled_channel;
 	int last = last_polled_channel;
 	int chan;
-	struct tty_struct *tty = NULL;
+	struct dashtty_port *dport;
 
 	for (chan = last + 1; ; ++chan) {
 		if (chan >= NUM_TTY_CHANNELS)
 			chan = 0;
 
-		tty = tty_port_tty_get(&dashtty_ports[chan].port);
-		if (tty) {
+		dport = &dashtty_ports[chan];
+		if (dport->rx_buf) {
 			last_polled_channel = chan;
-			return tty;
+			return chan;
 		}
 
 		if (chan == last)
 			break;
 	}
-	return tty;
+	return -1;
 }
 
 /**
@@ -302,19 +301,17 @@ static int put_data(void *arg)
  */
 static void dashtty_timer(unsigned long ignored)
 {
-	struct tty_struct *tty;
+	int channel;
 
 	/* If there are no ports open do nothing and don't poll again. */
 	if (!atomic_read(&num_channels_need_poll))
 		return;
 
-	tty = find_channel_to_poll();
+	channel = find_channel_to_poll();
 
 	/* Did we find a channel to poll? */
-	if (tty) {
-		fetch_data(tty);
-		tty_kref_put(tty);
-	}
+	if (channel >= 0)
+		fetch_data(channel);
 
 	mod_timer_pinned(&poll_timer, jiffies + DA_TTY_POLL);
 }
-- 
1.7.7.6


