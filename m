Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaCCTAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:00:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbaCCTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:00:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 48/67] tty: n_gsm: Fix for modems with brk in modem status control
Date: Mon,  3 Mar 2014 10:55:36 -0800
Message-Id: <1393872955-28810-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/n_gsm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index bfd6771..72438dd 100644
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
1.8.3.2

