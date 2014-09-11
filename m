Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaIKNAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51549 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Steven Vittitoe" <scvitti@google.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.614617707@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 089/131] HID: magicmouse: sanity check report size in
 raw_event() callback
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit c54def7bd64d7c0b6993336abcffb8444795bf38 upstream.

The report passed to us from transport driver could potentially be
arbitrarily large, therefore we better sanity-check it so that
magicmouse_emit_touch() gets only valid values of raw_id.

Reported-by: Steven Vittitoe <scvitti@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-magicmouse.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -308,6 +308,11 @@ static int magicmouse_raw_event(struct h
 		if (size < 4 || ((size - 4) % 9) != 0)
 			return 0;
 		npoints = (size - 4) / 9;
+		if (npoints > 15) {
+			hid_warn(hdev, "invalid size value (%d) for TRACKPAD_REPORT_ID\n",
+					size);
+			return 0;
+		}
 		msc->ntouches = 0;
 		for (ii = 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 9 + 4);
@@ -331,6 +336,11 @@ static int magicmouse_raw_event(struct h
 		if (size < 6 || ((size - 6) % 8) != 0)
 			return 0;
 		npoints = (size - 6) / 8;
+		if (npoints > 15) {
+			hid_warn(hdev, "invalid size value (%d) for MOUSE_REPORT_ID\n",
+					size);
+			return 0;
+		}
 		msc->ntouches = 0;
 		for (ii = 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);

