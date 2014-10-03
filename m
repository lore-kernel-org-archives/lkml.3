Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaJCVnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:43:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaJCVmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.16 133/357] usb: hub: take hub->hdev reference when processing from eventlist
Date: Fri,  3 Oct 2014 14:28:39 -0700
Message-Id: <20141003212937.466500110@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/hub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5008,9 +5008,10 @@ static void hub_events(void)
 
 		hub = list_entry(tmp, struct usb_hub, event_list);
 		kref_get(&hub->kref);
+		hdev = hub->hdev;
+		usb_get_dev(hdev);
 		spin_unlock_irq(&hub_event_lock);
 
-		hdev = hub->hdev;
 		hub_dev = hub->intfdev;
 		intf = to_usb_interface(hub_dev);
 		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
@@ -5123,6 +5124,7 @@ static void hub_events(void)
 		usb_autopm_put_interface(intf);
  loop_disconnected:
 		usb_unlock_device(hdev);
+		usb_put_dev(hdev);
 		kref_put(&hub->kref, hub_release);
 
 	} /* end while (1) */


