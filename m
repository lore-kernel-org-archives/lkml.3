Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaAGMld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:41:33 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:42436 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbaAGMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:41:28 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 07:41:28 EST
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty: n_gsm: Fix for modems with brk in modem status control
Date: Tue,  7 Jan 2014 13:34:37 +0100
Message-Id: <1389098077-21692-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

3GPP TS 07.10 states in section 5.4.6.3.7:
"The length byte contains the value 2 or 3 ... depending on the break
signal." The break byte is optional and if it is sent, the length is
3. In fact the driver was not able to work with modems that send this
break byte in their modem status control message. If the modem just
sends the break byte if it is really set, then weird things might
happen.
The code for deconding the modem status to the internal linux
presentation in gsm_process_modem has already a big comment about
this 2 or 3 byte length thing and it is already able to decode the
brk, but the code calling the gsm_process_modem function in
gsm_control_modem does not encode it and hand it over the right way.
This patch fixes this.
Without this fix if the modem sends the brk byte in it's modem status
control message the driver will hang when opening a muxed channel.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/tty/n_gsm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c0f76da..5056090 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1089,6 +1089,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, u8 *data, int clen)
 {
 	unsigned int addr = 0;
 	unsigned int modem = 0;
+	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
 	u8 *dp = data;
@@ -1115,6 +1116,16 @@ static void gsm_control_modem(struct gsm_mux *gsm, u8 *data, int clen)
 		if (len == 0)
 			return;
 	}
+	len--;
+	if (len > 0) {
+		while (gsm_read_ea(&brk, *dp++) == 0) {
+			len--;
+			if (len == 0)
+				return;
+		}
+		modem <<= 7;
+		modem |= (brk & 0x7f);
+	}
 	tty = tty_port_tty_get(&dlci->port);
 	gsm_process_modem(tty, dlci, modem, clen);
 	if (tty) {
-- 
1.8.5.2

