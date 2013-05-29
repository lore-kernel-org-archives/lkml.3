Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206Ab3E2Ip3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:45:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965080Ab3E2Ip0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:45:26 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: multitouch: prevent memleak with the allocated name
Date: Wed, 29 May 2013 10:45:09 +0200
Message-Id: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mt_free_input_name() was never called during .remove():
hid_hw_stop() removes the hid_input items in hdev->inputs, and so the
list is therefore empty after the call. In the end, we never free the
special names that has been allocated during .probe().

Restore the original name before freeing it to avoid acessing already
freed pointer.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

I just spotted this one yesterday... My guess is that this way is safe (without
a locking mechanism to prevent accessing hi->input->name), but I'm not 100% sure.

Cheers,
Benjamin

 drivers/hid/hid-multitouch.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d99b959..cb0e361 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -264,9 +264,12 @@ static struct mt_class mt_classes[] = {
 static void mt_free_input_name(struct hid_input *hi)
 {
 	struct hid_device *hdev = hi->report->device;
+	const char *name = hi->input->name;
 
-	if (hi->input->name != hdev->name)
-		kfree(hi->input->name);
+	if (name != hdev->name) {
+		hi->input->name = hdev->name;
+		kfree(name);
+	}
 }
 
 static ssize_t mt_show_quirks(struct device *dev,
@@ -1040,11 +1043,11 @@ static void mt_remove(struct hid_device *hdev)
 	struct hid_input *hi;
 
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
-	hid_hw_stop(hdev);
-
 	list_for_each_entry(hi, &hdev->inputs, list)
 		mt_free_input_name(hi);
 
+	hid_hw_stop(hdev);
+
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
-- 
1.8.2.1

