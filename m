Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3LBTki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:40:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3LBTSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.12 167/212] Input: cypress_ps2 - do not consider data bad if palm is detected
Date: Mon,  2 Dec 2013 11:15:58 -0800
Message-Id: <20131202191306.615483110@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/cypress_ps2.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -439,7 +439,7 @@ static int cypress_get_finger_count(unsi
 			case 2: return 5;
 			default:
 				/* Invalid contact (e.g. palm). Ignore it. */
-				return -1;
+				return 0;
 		}
 	}
 
@@ -452,17 +452,10 @@ static int cypress_parse_packet(struct p
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
@@ -535,11 +528,9 @@ static void cypress_process_packet(struc
 	int slots[CYTP_MAX_MT_SLOTS];
 	int n;
 
-	if (cypress_parse_packet(psmouse, cytp, &report_data))
-		return;
+	cypress_parse_packet(psmouse, cytp, &report_data);
 
 	n = report_data.contact_cnt;
-
 	if (n > CYTP_MAX_MT_SLOTS)
 		n = CYTP_MAX_MT_SLOTS;
 
@@ -605,10 +596,6 @@ static psmouse_ret_t cypress_validate_by
 		return PSMOUSE_BAD_DATA;
 
 	contact_cnt = cypress_get_finger_count(packet[0]);
-
-	if (contact_cnt < 0)
-		return PSMOUSE_BAD_DATA;
-
 	if (cytp->mode & CYTP_BIT_ABS_NO_PRESSURE)
 		cypress_set_packet_size(psmouse, contact_cnt == 2 ? 7 : 4);
 	else


