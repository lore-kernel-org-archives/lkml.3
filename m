Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028AbaDJDWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934653AbaDJDVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Jiri Kosina <jkosina@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 021/134] HID: hidraw: fix list->buffer memleak
Date: Wed,  9 Apr 2014 20:22:17 -0700
Message-Id: <20140410032302.629577313@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu CASTET <matthieu.castet@parrot.com>

commit 4c7b417ecb756e85dfc955b0e7a04fd45585533e upstream.

If we don't read fast enough hidraw device, hidraw_report_event
will cycle and we will leak list->buffer.
Also list->buffer are not free on release.
After this patch, kmemleak report nothing.

Signed-off-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hidraw.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -96,6 +96,7 @@ static ssize_t hidraw_read(struct file *
 		}
 
 		kfree(list->buffer[list->tail].value);
+		list->buffer[list->tail].value = NULL;
 		list->tail = (list->tail + 1) & (HIDRAW_BUFFER_SIZE - 1);
 	}
 out:
@@ -300,6 +301,7 @@ static int hidraw_release(struct inode *
 	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
 	int ret;
+	int i;
 
 	mutex_lock(&minors_lock);
 	if (!hidraw_table[minor]) {
@@ -317,6 +319,9 @@ static int hidraw_release(struct inode *
 			kfree(list->hidraw);
 		}
 	}
+
+	for (i = 0; i < HIDRAW_BUFFER_SIZE; ++i)
+		kfree(list->buffer[i].value);
 	kfree(list);
 	ret = 0;
 unlock:
@@ -446,12 +451,17 @@ int hidraw_report_event(struct hid_devic
 	int ret = 0;
 
 	list_for_each_entry(list, &dev->list, node) {
+		int new_head = (list->head + 1) & (HIDRAW_BUFFER_SIZE - 1);
+
+		if (new_head == list->tail)
+			continue;
+
 		if (!(list->buffer[list->head].value = kmemdup(data, len, GFP_ATOMIC))) {
 			ret = -ENOMEM;
 			break;
 		}
 		list->buffer[list->head].len = len;
-		list->head = (list->head + 1) & (HIDRAW_BUFFER_SIZE - 1);
+		list->head = new_head;
 		kill_fasync(&list->fasync, SIGIO, POLL_IN);
 	}
 


