Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161841Ab3LFNl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:41:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44240 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161604Ab3LFNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 145/272] Input: cypress_ps2 - do not consider data bad if palm is detected
Date: Fri,  6 Dec 2013 12:57:14 +0000
Message-Id: <1386334761-25517-146-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Salisbury <joseph.salisbury@canonical.com>

commit 5df682b297f6b23ec35615ed7bb50cbb25d25869 upstream.

If hardware (or firmware) detects palm on the surface of the device it does
not mean that the data packet is bad from the protocol standpoint. Instead
of reporting PSMOUSE_BAD_DATA in this case simply threat it as if nothing
touches the surface.

BugLink: http://bugs.launchpad.net/bugs/1229361

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Tested-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/cypress_ps2.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index f51765f..888a81a 100644
--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -439,7 +439,7 @@ static int cypress_get_finger_count(unsigned char header_byte)
 			case 2: return 5;
 			default:
 				/* Invalid contact (e.g. palm). Ignore it. */
-				return -1;
+				return 0;
 		}
 	}
 
@@ -452,17 +452,10 @@ static int cypress_parse_packet(struct psmouse *psmouse,
 {
 	unsigned char *packet = psmouse->packet;
 	unsigned char header_byte = packet[0];
-	int contact_cnt;
 
 	memset(report_data, 0, sizeof(struct cytp_report_data));
 
-	contact_cnt = cypress_get_finger_count(header_byte);
-
-	if (contact_cnt < 0) /* e.g. palm detect */
-		return -EINVAL;
-
-	report_data->contact_cnt = contact_cnt;
-
+	report_data->contact_cnt = cypress_get_finger_count(header_byte);
 	report_data->tap = (header_byte & ABS_MULTIFINGER_TAP) ? 1 : 0;
 
 	if (report_data->contact_cnt == 1) {
@@ -535,11 +528,9 @@ static void cypress_process_packet(struct psmouse *psmouse, bool zero_pkt)
 	int slots[CYTP_MAX_MT_SLOTS];
 	int n;
 
-	if (cypress_parse_packet(psmouse, cytp, &report_data))
-		return;
+	cypress_parse_packet(psmouse, cytp, &report_data);
 
 	n = report_data.contact_cnt;
-
 	if (n > CYTP_MAX_MT_SLOTS)
 		n = CYTP_MAX_MT_SLOTS;
 
@@ -605,10 +596,6 @@ static psmouse_ret_t cypress_validate_byte(struct psmouse *psmouse)
 		return PSMOUSE_BAD_DATA;
 
 	contact_cnt = cypress_get_finger_count(packet[0]);
-
-	if (contact_cnt < 0)
-		return PSMOUSE_BAD_DATA;
-
 	if (cytp->mode & CYTP_BIT_ABS_NO_PRESSURE)
 		cypress_set_packet_size(psmouse, contact_cnt == 2 ? 7 : 4);
 	else
-- 
1.8.3.2

