Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaKAXdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:33:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46316 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaKAXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:33:42 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v3 1/4] input: alps: Do not try to parse data as 3 bytes packet when driver is out of sync
Date: Sun,  2 Nov 2014 00:25:07 +0100
Message-Id: <1414884310-19842-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414884310-19842-1-git-send-email-pali.rohar@gmail.com>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
 <1414884310-19842-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5th and 6th byte of ALPS trackstick V3 protocol match condition for first byte
of PS/2 3 bytes packet. When driver enters out of sync state and ALPS trackstick
is sending data then driver match 5th, 6th and next 1st bytes as PS/2.

It basically means if user is using trackstick when driver is in out of sync
state driver will never resync. Processing these bytes as 3 bytes PS/2 data
cause total mess (random cursor movements, random clicks) and make trackstick
unusable until psmouse driver decide to do full device reset.

Lot of users reported problems with ALPS devices on Dell Latitude E6440, E6540
and E7440 laptops. ALPS device or Dell EC for unknown reason send some invalid
ALPS PS/2 bytes which cause driver out of sync. It looks like that i8042 and
psmouse/alps driver always receive group of 6 bytes packets so there are no
missing bytes and no bytes were inserted between valid once.

This patch does not fix root of problem with ALPS devices found in Dell Latitude
laptops but it does not allow to process some (invalid) subsequence of 6 bytes
ALPS packets as 3 bytes PS/2 when driver is out of sync.

So with this patch trackstick input device does not report bogus data when
also driver is out of sync, so trackstick should be usable on those machines.

Unknown is also information which ALPS devices send 3 bytes packets and why
ALPS driver needs to handle also bare PS/2 packets. According to git (and plus
historic tree from bitkeeper) code for processing 3 bytes bare PS/2 packets
is there since first version of alps.c existence (since 2.6.9-rc2).

We do not want to break some older ALPS devices. And disabling processing bare
PS/2 packets when driver is out of sync should not break it.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/input/mouse/alps.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 2b0ae8c..a772745 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -1156,7 +1156,9 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 {
 	struct alps_data *priv = psmouse->private;
 
-	if ((psmouse->packet[0] & 0xc8) == 0x08) { /* PS/2 packet */
+	/* FIXME: Could we receive bare PS/2 packets from DualPoint devices?? */
+	if (!psmouse->out_of_sync_cnt &&
+	    (psmouse->packet[0] & 0xc8) == 0x08) { /* PS/2 packet */
 		if (psmouse->pktcnt == 3) {
 			alps_report_bare_ps2_packet(psmouse, psmouse->packet,
 						    true);
-- 
1.7.9.5

