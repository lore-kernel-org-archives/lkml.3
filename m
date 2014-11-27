Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaK0Ira (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:47:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:41653 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbaK0Ir0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:26 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Lawrence <joe.lawrence@stratus.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 33/91] usb: hub: take hub->hdev reference when processing from eventlist
Date: Thu, 27 Nov 2014 16:42:16 +0800
Message-Id: <1417077794-9299-33-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Lawrence <joe.lawrence@stratus.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit c605f3cdff53a743f6d875b76956b239deca1272 upstream.

During surprise device hotplug removal tests, it was observed that
hub_events may try to call usb_lock_device on a device that has already
been freed. Protect the usb_device by taking out a reference (under the
hub_event_lock) when hub_events pulls it off the list, returning the
reference after hub_events is finished using it.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Suggested-by: David Bulkow <david.bulkow@stratus.com> for using kref
Suggested-by: Alan Stern <stern@rowland.harvard.edu> for placement
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/core/hub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index e0d4d90..62a9e44 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3729,9 +3729,10 @@ static void hub_events(void)
 
 		hub = list_entry(tmp, struct usb_hub, event_list);
 		kref_get(&hub->kref);
+		hdev = hub->hdev;
+		usb_get_dev(hdev);
 		spin_unlock_irq(&hub_event_lock);
 
-		hdev = hub->hdev;
 		hub_dev = hub->intfdev;
 		intf = to_usb_interface(hub_dev);
 		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
@@ -3946,6 +3947,7 @@ static void hub_events(void)
 		usb_autopm_put_interface(intf);
  loop_disconnected:
 		usb_unlock_device(hdev);
+		usb_put_dev(hdev);
 		kref_put(&hub->kref, hub_release);
 
         } /* end while (1) */
-- 
1.9.1

