Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaIJTo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:44:57 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47642 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbaIJToz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:44:55 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 14/14] tty: Workaround Alpha non-atomic byte storage in tty_struct
Date: Wed, 10 Sep 2014 15:06:36 -0400
Message-Id: <1410375996-4693-15-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Alpha EV4/EV5 cpus can corrupt adjacent byte and short data because
those cpus use RMW to store byte and short data. Thus, concurrent adjacent
byte stores could become corrupted, if serialized by a different lock.
tty_struct uses different locks to protect certain fields within the
structure, and thus is vulnerable to byte stores which are not atomic.

Merge the ->ctrl_status byte and packet mode bit, both protected by the
->ctrl_lock, into an unsigned long.

The padding bits are necessary to force the compiler to allocate the
type specified; otherwise, gcc will ignore the type specifier and
allocate the minimum number of bytes required to store the bitfield.
In turn, this would allow Alpha EV4/EV5 cpus to corrupt adjacent byte
or short storage (because those cpus use RMW to store byte and short data).

gcc versions < 4.7.2 will also corrupt storage adjacent to bitfields
smaller than unsigned long on ia64, ppc64, hppa64, and sparc64, thus
requiring more than unsigned int storage (which would otherwise be
sufficient to fix the Alpha non-atomic storage problem).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 3c1276b..7a0a796 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -266,8 +266,9 @@ struct tty_struct {
 		      flow_stopped:1,
 		      unused:62;
 	int hw_stopped;
-	int packet;
-	unsigned char ctrl_status;	/* ctrl_lock */
+	unsigned long ctrl_status:8,	/* ctrl_lock */
+		      packet:1,
+		      unused_ctrl:55;
 	unsigned int receive_room;	/* Bytes free for queue */
 	int flow_change;
 
-- 
2.1.0

