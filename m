Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaLCL6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:58:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbaLCL1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/101] Input: alps - ignore potential bare packets when device is out of sync
Date: Wed,  3 Dec 2014 12:26:11 +0100
Message-Id: <92e2e274732d93eb7b1f5a7f916ba12d742afeee.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4ab8f7f320f91f279c3f06a9795cfea5c972888a upstream.

5th and 6th byte of ALPS trackstick V3 protocol match condition for first
byte of PS/2 3 bytes packet. When driver enters out of sync state and ALPS
trackstick is sending data then driver match 5th, 6th and next 1st bytes as
PS/2.

It basically means if user is using trackstick when driver is in out of
sync state driver will never resync. Processing these bytes as 3 bytes PS/2
data cause total mess (random cursor movements, random clicks) and make
trackstick unusable until psmouse driver decide to do full device reset.

Lot of users reported problems with ALPS devices on Dell Latitude E6440,
E6540 and E7440 laptops. ALPS device or Dell EC for unknown reason send
some invalid ALPS PS/2 bytes which cause driver out of sync. It looks like
that i8042 and psmouse/alps driver always receive group of 6 bytes packets
so there are no missing bytes and no bytes were inserted between valid
ones.

This patch does not fix root of problem with ALPS devices found in Dell
Latitude laptops but it does not allow to process some (invalid)
subsequence of 6 bytes ALPS packets as 3 bytes PS/2 when driver is out of
sync.

So with this patch trackstick input device does not report bogus data when
also driver is out of sync, so trackstick should be usable on those
machines.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/alps.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 7c5d72a6a26a..071bd835594c 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -873,7 +873,13 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 {
 	struct alps_data *priv = psmouse->private;
 
-	if ((psmouse->packet[0] & 0xc8) == 0x08) { /* PS/2 packet */
+	/*
+	 * Check if we are dealing with a bare PS/2 packet, presumably from
+	 * a device connected to the external PS/2 port. Because bare PS/2
+	 * protocol does not have enough constant bits to self-synchronize
+	 * properly we only do this if the device is fully synchronized.
+	 */
+	if (!psmouse->out_of_sync_cnt && (psmouse->packet[0] & 0xc8) == 0x08) {
 		if (psmouse->pktcnt == 3) {
 			alps_report_bare_ps2_packet(psmouse, psmouse->packet,
 						    true);
-- 
2.1.3

