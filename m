Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaIBWMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:12:10 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47549 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754581AbaIBWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:12:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 21/26] tty: Convert tty_struct bitfield to bools
Date: Tue,  2 Sep 2014 17:39:30 -0400
Message-Id: <1409693975-1028-22-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stopped, hw_stopped, flow_stopped and packet bits are smp-unsafe
and interrupt-unsafe. For example,

CPU 0                         | CPU 1
                              |
tty->flow_stopped = 1         | tty->hw_stopped = 0

One of these updates will be corrupted, as the bitwise operation
on the bitfield is non-atomic.

Ensure each flag has a separate memory location, so concurrent
updates do not corrupt orthogonal states.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1c3316a..7cf61cb 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -261,7 +261,10 @@ struct tty_struct {
 	unsigned long flags;
 	int count;
 	struct winsize winsize;		/* winsize_mutex */
-	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
+	bool stopped;
+	bool hw_stopped;
+	bool flow_stopped;
+	bool packet;
 	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
 	int flow_change;
-- 
2.1.0

