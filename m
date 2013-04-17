Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966157Ab3DQRo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:44:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965225Ab3DQRo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:44:27 -0400
Date: Wed, 17 Apr 2013 10:44:25 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] HID: debugfs rework
In-Reply-To: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1304171041070.31201@pobox.suse.cz>
References: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Benjamin Tissoires wrote:

> Hi Jiri,
> 
> This is a small rework of the HID debugfs.
> I encountered a problem with multitouch devices: they have too much usages to
> fit into the fixed size output buffer of 512.
> So I digg a little, and end up with those 4 patches.

Hi Benjamin,

thanks, I will look into it and see whether I would be able to apply it 
still for 3.10 merge window.

I also have a locking fix for HID-debugfs which I am going to apply 
shortly, but I am travelling this week, so I am in a bit degraded mode.

For reference, locking fix below.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: protect hid_debug_list

Accesses to hid_device->hid_debug_list are not serialized properly, which
could result in SMP concurrency issues when HID debugfs events are accessesed
by multiple userspace processess.

Serialize all the list operations by a mutex.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-core.c  | 1 +
 drivers/hid/hid-debug.c | 6 ++++++
 include/linux/hid.h     | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1129f49..e3b7123 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2347,6 +2347,7 @@ struct hid_device *hid_allocate_device(void)
 
 	init_waitqueue_head(&hdev->debug_wait);
 	INIT_LIST_HEAD(&hdev->debug_list);
+	mutex_init(&hdev->debug_list_lock);
 	sema_init(&hdev->driver_lock, 1);
 	sema_init(&hdev->driver_input_lock, 1);
 
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 933fff0..3337261 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -580,12 +580,14 @@ void hid_debug_event(struct hid_device *hdev, char *buf)
 	int i;
 	struct hid_debug_list *list;
 
+	mutex_lock(&hdev->debug_list_lock);
 	list_for_each_entry(list, &hdev->debug_list, node) {
 		for (i = 0; i < strlen(buf); i++)
 			list->hid_debug_buf[(list->tail + i) % HID_DEBUG_BUFSIZE] =
 				buf[i];
 		list->tail = (list->tail + i) % HID_DEBUG_BUFSIZE;
         }
+	mutex_unlock(&hdev->debug_list_lock);
 
 	wake_up_interruptible(&hdev->debug_wait);
 }
@@ -960,7 +962,9 @@ static int hid_debug_events_open(struct inode *inode, struct file *file)
 	file->private_data = list;
 	mutex_init(&list->read_mutex);
 
+	mutex_lock(&list->hdev->debug_list_lock);
 	list_add_tail(&list->node, &list->hdev->debug_list);
+	mutex_unlock(&list->hdev->debug_list_lock);
 
 out:
 	return err;
@@ -1055,7 +1059,9 @@ static int hid_debug_events_release(struct inode *inode, struct file *file)
 {
 	struct hid_debug_list *list = file->private_data;
 
+	mutex_lock(&list->hdev->debug_list_lock);
 	list_del(&list->node);
+	mutex_unlock(&list->hdev->debug_list_lock);
 	kfree(list->hid_debug_buf);
 	kfree(list);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index b7b5ff2..af1b86d 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -515,6 +515,7 @@ struct hid_device {							/* device report descriptor */
 	struct dentry *debug_rdesc;
 	struct dentry *debug_events;
 	struct list_head debug_list;
+	struct mutex debug_list_lock;
 	wait_queue_head_t debug_wait;
 };
 

-- 
Jiri Kosina
SUSE Labs
