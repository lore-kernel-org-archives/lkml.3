Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaFETFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:05:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:18618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaFETFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,982,1392192000"; 
   d="scan'208";a="552253967"
Message-ID: <1401995156.30026.2.camel@dwillia2-mobl2.amr.corp.intel.com>
Subject: Re: linux-next crash in xhci_add_ep_to_interval
From: Dan Williams <dan.j.williams@intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Thu, 05 Jun 2014 12:05:56 -0700
In-Reply-To: <33745.1401989394@turing-police.cc.vt.edu>
References: <18529.1401981749@turing-police.cc.vt.edu>
	 <CAA9_cmfje+8qAh7NqjHi1zcRAPZgJ0xdOK2nM7TKN9NRgqcRfw@mail.gmail.com>
	 <23223.1401985468@turing-police.cc.vt.edu>
	 <CAPcyv4gYnvF4Nt5itkDsD=DzL8sfETZUBmQqZwiHE1SOZvtsbw@mail.gmail.com>
	 <33745.1401989394@turing-police.cc.vt.edu>
Content-Type: multipart/mixed; boundary="=-Txm6ECokJT0Mv0AakQe0"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Txm6ECokJT0Mv0AakQe0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2014-06-05 at 13:29 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 05 Jun 2014 09:35:48 -0700, Dan Williams said:
> 
> > Actually, on second look I bet xhci_alloc_tt_info() is being called
> > while hdev->maxchild is not set.  Let me throw together a debug
> > patch...
> 
> Sure, no problem - just let me know what variant of linux-next you
> want it applied against. :)

This should apply to -next.  Use "git am -c", but I have attached it for
convenience as well.  Boots for me, but more importantly does it boot
for you :-).

8<------
Subject: usb: fix ->update_hub_device() vs hdev->maxchild

From: Dan Williams <dan.j.williams@intel.com>

Commit d8521afe3586 "usb: assign default peer ports for root hubs"
delayed marking a hub valid (set hdev->maxchild) until it had been fully
configured and to enable the publishing of valid hubs to be serialized
by usb_port_peer_mutex.

However, xhci_update_hub_device() in some cases depends on
hdev->maxchild already being set.  Do the minimal fix and move it after
the setting of hdev->maxchild.

Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/usb/core/hub.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index db6287025c06..971d95745e2a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1526,18 +1526,6 @@ static int hub_configure(struct usb_hub *hub,
 		dev_dbg(hub_dev, "%umA bus power budget for each child\n",
 				hub->mA_per_port);
 
-	/* Update the HCD's internal representation of this hub before khubd
-	 * starts getting port status changes for devices under the hub.
-	 */
-	if (hcd->driver->update_hub_device) {
-		ret = hcd->driver->update_hub_device(hcd, hdev,
-				&hub->tt, GFP_KERNEL);
-		if (ret < 0) {
-			message = "can't update HCD hub info";
-			goto fail;
-		}
-	}
-
 	ret = hub_hub_status(hub, &hubstatus, &hubchange);
 	if (ret < 0) {
 		message = "can't get hub status";
@@ -1593,6 +1581,18 @@ static int hub_configure(struct usb_hub *hub,
 	if (ret < 0)
 		goto fail;
 
+	/* Update the HCD's internal representation of this hub before khubd
+	 * starts getting port status changes for devices under the hub.
+	 */
+	if (hcd->driver->update_hub_device) {
+		ret = hcd->driver->update_hub_device(hcd, hdev,
+				&hub->tt, GFP_KERNEL);
+		if (ret < 0) {
+			message = "can't update HCD hub info";
+			goto fail;
+		}
+	}
+
 	usb_hub_adjust_deviceremovable(hdev, hub->descriptor);
 
 	hub_activate(hub, HUB_INIT);


--=-Txm6ECokJT0Mv0AakQe0
Content-Disposition: attachment; filename="valdis-crash-fix.patch"
Content-Type: text/x-patch; name="valdis-crash-fix.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

usb: fix ->update_hub_device() vs hdev->maxchild

From: Dan Williams <dan.j.williams@intel.com>

Commit d8521afe3586 "usb: assign default peer ports for root hubs"
delayed marking a hub valid (set hdev->maxchild) until it had been fully
configured and to enable the publishing of valid hubs to be serialized
by usb_port_peer_mutex.

However, xhci_update_hub_device() in some cases depends on
hdev->maxchild already being set.  Do the minimal fix and move it after
the setting of hdev->maxchild.

Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/usb/core/hub.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index db6287025c06..971d95745e2a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1526,18 +1526,6 @@ static int hub_configure(struct usb_hub *hub,
 		dev_dbg(hub_dev, "%umA bus power budget for each child\n",
 				hub->mA_per_port);
 
-	/* Update the HCD's internal representation of this hub before khubd
-	 * starts getting port status changes for devices under the hub.
-	 */
-	if (hcd->driver->update_hub_device) {
-		ret = hcd->driver->update_hub_device(hcd, hdev,
-				&hub->tt, GFP_KERNEL);
-		if (ret < 0) {
-			message = "can't update HCD hub info";
-			goto fail;
-		}
-	}
-
 	ret = hub_hub_status(hub, &hubstatus, &hubchange);
 	if (ret < 0) {
 		message = "can't get hub status";
@@ -1593,6 +1581,18 @@ static int hub_configure(struct usb_hub *hub,
 	if (ret < 0)
 		goto fail;
 
+	/* Update the HCD's internal representation of this hub before khubd
+	 * starts getting port status changes for devices under the hub.
+	 */
+	if (hcd->driver->update_hub_device) {
+		ret = hcd->driver->update_hub_device(hcd, hdev,
+				&hub->tt, GFP_KERNEL);
+		if (ret < 0) {
+			message = "can't update HCD hub info";
+			goto fail;
+		}
+	}
+
 	usb_hub_adjust_deviceremovable(hdev, hub->descriptor);
 
 	hub_activate(hub, HUB_INIT);

--=-Txm6ECokJT0Mv0AakQe0--

