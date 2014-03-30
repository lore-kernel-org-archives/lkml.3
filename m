Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaCaABs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:01:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbaC3XnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lars Poeschel" <poeschel@lemonage.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.529022179@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 094/200] tty: n_gsm: Fix for modems with brk in modem
 status control
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_gsm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1090,6 +1090,7 @@ static void gsm_control_modem(struct gsm
 {
 	unsigned int addr = 0;
 	unsigned int modem = 0;
+	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
 	u8 *dp = data;
@@ -1116,6 +1117,16 @@ static void gsm_control_modem(struct gsm
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

