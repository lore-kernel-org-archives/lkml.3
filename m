Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaJAP7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbaJAP7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:59:53 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: David Herrmann <dh.herrmann@googlemail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: uHID: fix excepted report type
Date: Wed,  1 Oct 2014 11:59:47 -0400
Message-Id: <1412179187-15107-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When uhid_get_report() or uhid_set_report() are called, they emit on the
char device a UHID_GET_REPORT or UHID_SET_REPORT message. Then, the
protocol says that the user space asnwers with UHID_GET_REPORT_REPLY
or UHID_SET_REPORT_REPLY.

Unfortunatelly, the current code waits for an event of type UHID_GET_REPORT
or UHID_SET_REPORT instead of the reply one.
Add 1 to UHID_GET_REPORT or UHID_SET_REPORT to actually wait for the
reply, and validate the reply.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi David,

while playing with a Bluetooth LE mouse, I noticed that uhid did not validate
properly the get_report feature. With this patch and some work on bluez, this
part now works almost (at least I manage to get reports from the device, there
is still a 0x0b header I can not rely to anything, so there will be some work
to do in Bordeaux :) )

Cheers,
Benjamin

 drivers/hid/uhid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index f6ec5ea..e094c57 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -154,7 +154,7 @@ static int __uhid_report_queue_and_wait(struct uhid_device *uhid,
 
 	spin_lock_irqsave(&uhid->qlock, flags);
 	*report_id = ++uhid->report_id;
-	uhid->report_type = ev->type;
+	uhid->report_type = ev->type + 1;
 	uhid->report_running = true;
 	uhid_queue(uhid, ev);
 	spin_unlock_irqrestore(&uhid->qlock, flags);
-- 
1.9.3

