Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbaJIVW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:22:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59533 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742AbaJIVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Lawrence <joe.lawrence@stratus.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 049/163] usb: hub: take hub->hdev reference when processing from eventlist
Date: Thu,  9 Oct 2014 14:01:14 -0700
Message-Id: <1412888588-26755-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@stratus.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/core/hub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a80e195..9f179ea 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4729,9 +4729,10 @@ static void hub_events(void)
 
 		hub = list_entry(tmp, struct usb_hub, event_list);
 		kref_get(&hub->kref);
+		hdev = hub->hdev;
+		usb_get_dev(hdev);
 		spin_unlock_irq(&hub_event_lock);
 
-		hdev = hub->hdev;
 		hub_dev = hub->intfdev;
 		intf = to_usb_interface(hub_dev);
 		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
@@ -4944,6 +4945,7 @@ static void hub_events(void)
 		usb_autopm_put_interface(intf);
  loop_disconnected:
 		usb_unlock_device(hdev);
+		usb_put_dev(hdev);
 		kref_put(&hub->kref, hub_release);
 
 	} /* end while (1) */
-- 
1.9.1

