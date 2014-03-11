Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaCKSuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:50:16 -0400
Received: from smtpsalv.cc.upv.es ([158.42.249.11]:60014 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbaCKSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:50:14 -0400
X-Greylist: delayed 1087 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2014 14:50:14 EDT
From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, security@kernel.org,
        =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>
Subject: [PATCH] synclink: fix info leak in ioctl
Date: Tue, 11 Mar 2014 19:31:23 +0100
Message-Id: <1394562683-22498-1-git-send-email-speiro@ai2.upv.es>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hdlcdev_ioctl() code fails to initialize the two padding bytes of
struct sync_serial_settings after the ->loopback member. Add an explicit
memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
---
 drivers/tty/synclink.c   |    1 +
 drivers/tty/synclinkmp.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 5ae14b4..d48e040 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -7866,6 +7866,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 					      HDLC_FLAG_TXC_TXCPIN | HDLC_FLAG_TXC_DPLL |
 					      HDLC_FLAG_TXC_BRG    | HDLC_FLAG_TXC_RXCPIN);
 
+		memset(&new_line, 0, sizeof(new_line));
 		switch (flags){
 		case (HDLC_FLAG_RXC_RXCPIN | HDLC_FLAG_TXC_TXCPIN): new_line.clock_type = CLOCK_EXT; break;
 		case (HDLC_FLAG_RXC_BRG    | HDLC_FLAG_TXC_BRG):    new_line.clock_type = CLOCK_INT; break;
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 144202e..53ba853 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -1766,6 +1766,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 					      HDLC_FLAG_TXC_TXCPIN | HDLC_FLAG_TXC_DPLL |
 					      HDLC_FLAG_TXC_BRG    | HDLC_FLAG_TXC_RXCPIN);
 
+		memset(&new_line, 0, sizeof(new_line));
 		switch (flags){
 		case (HDLC_FLAG_RXC_RXCPIN | HDLC_FLAG_TXC_TXCPIN): new_line.clock_type = CLOCK_EXT; break;
 		case (HDLC_FLAG_RXC_BRG    | HDLC_FLAG_TXC_BRG):    new_line.clock_type = CLOCK_INT; break;
-- 
1.7.10.4

