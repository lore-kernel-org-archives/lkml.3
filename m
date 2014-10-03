Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbaJCXDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:03:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbaJCWXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:23:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Vittitoe <scvitti@google.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 027/143] HID: magicmouse: sanity check report size in raw_event() callback
Date: Fri,  3 Oct 2014 14:33:42 -0700
Message-Id: <20141003213315.310358271@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit c54def7bd64d7c0b6993336abcffb8444795bf38 upstream.

The report passed to us from transport driver could potentially be
arbitrarily large, therefore we better sanity-check it so that
magicmouse_emit_touch() gets only valid values of raw_id.

Reported-by: Steven Vittitoe <scvitti@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-magicmouse.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -290,6 +290,11 @@ static int magicmouse_raw_event(struct h
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
@@ -307,6 +312,11 @@ static int magicmouse_raw_event(struct h
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


