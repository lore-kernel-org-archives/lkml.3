Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaIDHCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:02:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaIDHCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:02:13 -0400
Date: Thu, 4 Sep 2014 09:02:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dylan Alex Simon <dylan-kernel@dylex.net>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: thingm: fix workqueue race on remove
In-Reply-To: <20140904010519.GA13189@datura.dylex.net>
Message-ID: <alpine.LNX.2.00.1409040901050.12309@pobox.suse.cz>
References: <54062150.2010800@gmail.com> <alpine.LNX.2.00.1409022328470.12309@pobox.suse.cz> <20140903023531.GA1128@datura.dylex.net> <alpine.LNX.2.00.1409030928200.12309@pobox.suse.cz> <20140903081723.GA1153@datura.dylex.net> <alpine.LNX.2.00.1409031021230.12309@pobox.suse.cz>
 <20140903130348.GA1161@datura.dylex.net> <alpine.LNX.2.00.1409031509070.12309@pobox.suse.cz> <20140903141601.GA1866@datura.dylex.net> <alpine.LNX.2.00.1409031636170.12309@pobox.suse.cz> <20140904010519.GA13189@datura.dylex.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thingm_remove_rgb() needs to flush the workqueue after all the LED classes 
have been unregistered, otherwise the removal might race with another LED 
event coming, causing thingm_led_set() to schedule additional work after 
thingm_remove_rgb() has flushed it. This obviously causes oops later, as 
the scheduled work has been freed in the meantime.

In addition to that, move the hid_hw_stop() to an earlier place, so that 
dmesg is not polluted by failure messages about not being able to write 
the LED while the device is being shut down.

Reported-and-tested-by: Dylan Alex Simon <dylan-kernel@dylex.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

Queued in hid.git#for-3.18/upstream

 drivers/hid/hid-thingm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-thingm.c b/drivers/hid/hid-thingm.c
index 134be89..f206398 100644
--- a/drivers/hid/hid-thingm.c
+++ b/drivers/hid/hid-thingm.c
@@ -208,10 +208,10 @@ unregister_red:
 
 static void thingm_remove_rgb(struct thingm_rgb *rgb)
 {
-	flush_work(&rgb->work);
 	led_classdev_unregister(&rgb->red.ldev);
 	led_classdev_unregister(&rgb->green.ldev);
 	led_classdev_unregister(&rgb->blue.ldev);
+	flush_work(&rgb->work);
 }
 
 static int thingm_probe(struct hid_device *hdev, const struct hid_device_id *id)
@@ -286,10 +286,10 @@ static void thingm_remove(struct hid_device *hdev)
 	struct thingm_device *tdev = hid_get_drvdata(hdev);
 	int i;
 
+	hid_hw_stop(hdev);
+
 	for (i = 0; i < tdev->fwinfo->numrgb; ++i)
 		thingm_remove_rgb(tdev->rgb + i);
-
-	hid_hw_stop(hdev);
 }
 
 static const struct hid_device_id thingm_table[] = {

-- 
Jiri Kosina
SUSE Labs
