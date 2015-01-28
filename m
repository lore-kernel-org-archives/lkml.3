Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbbA1EeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:34:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:41156 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965229AbbA1EZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:35 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 154/177] Input: alps - ignore potential bare packets when device is out of sync
Date: Wed, 28 Jan 2015 12:10:12 +0800
Message-Id: <1422418236-12852-245-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/input/mouse/alps.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 4c6a72d..e03a0ae 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -787,7 +787,13 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 	struct alps_data *priv = psmouse->private;
 	const struct alps_model_info *model = priv->i;
 
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
1.9.1

