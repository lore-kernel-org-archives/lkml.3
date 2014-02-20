Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaBUAs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:48:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaBTXvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH 3.10 24/66] tty: n_gsm: Fix for modems with brk in modem status control
Date: Thu, 20 Feb 2014 15:51:23 -0800
Message-Id: <20140220234910.186101474@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars Poeschel <poeschel@lemonage.de>

commit 3ac06b905655b3ef2fd2196bab36e4587e1e4e4f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_gsm.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1089,6 +1089,7 @@ static void gsm_control_modem(struct gsm
 {
 	unsigned int addr = 0;
 	unsigned int modem = 0;
+	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
 	u8 *dp = data;
@@ -1115,6 +1116,16 @@ static void gsm_control_modem(struct gsm
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


