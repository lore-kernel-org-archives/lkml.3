Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3HTTQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:16:14 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:57905 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3HTTQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:16:13 -0400
Date: Tue, 20 Aug 2013 21:16:11 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: Re: [PATCH 1/2] usb: fix cleanup after failure in hub_configure()
Message-ID: <20130820191611.GA32209@shrek.podlesie.net>
References: <20130820184236.GA782@shrek.podlesie.net>
 <Pine.LNX.4.44L0.1308201457380.892-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308201457380.892-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:59:18PM -0400, Alan Stern wrote:
> On Tue, 20 Aug 2013, Krzysztof Mazur wrote:
> 
> > > Why bother with a separate jump label?  Just set maxchild to 0 whenever 
> > > a failure occurs.
> > > 
> > 
> > Initially I had just straightforward "dev->maxchild = 0;" after fail,
> > but I changed that to simplify the second patch and be able to
> > use goto fail:
> > 
> > 	ret = usb_hub_create_port_device(hub, i + 1);
> > 	if (ret < 0) {
> > 		dev_err(hub->intfdev,
> > 			"couldn't create port%d device.\n", i + 1);
> > 		hdev->maxchild = i;
> > 		goto fail;
> > 	}
> > 
> > and avoid "return ret" here or something like
> > 
> > 	if (hdev->maxchild == hub->descriptor->bNbrPorts)
> > 		hdev->maxchild = 0;
> > 
> > in the fail path.
> 
> The second patch can either clean up the port devices by hand, or else 
> jump to a new label after the line that sets maxchild to 0.
> Alan Stern

I think that new label is better, it's equivalent to previous version
except for ugly rename of original fail label.

Thanks,
Krzysiek
-- >8 --
Subject: [PATCH 2/2 v2] usb: fail on usb_hub_create_port_device() errors

Ignoring usb_hub_create_port_device() errors cause later NULL pointer
deference when uninitialized hub->ports[i] entries are dereferenced
after port memory allocation error.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 drivers/usb/core/hub.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index affed11..292ffa8 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1557,10 +1557,15 @@ static int hub_configure(struct usb_hub *hub,
 	if (hub->has_indicators && blinkenlights)
 		hub->indicator [0] = INDICATOR_CYCLE;
 
-	for (i = 0; i < hdev->maxchild; i++)
-		if (usb_hub_create_port_device(hub, i + 1) < 0)
+	for (i = 0; i < hdev->maxchild; i++) {
+		ret = usb_hub_create_port_device(hub, i + 1);
+		if (ret < 0) {
 			dev_err(hub->intfdev,
 				"couldn't create port%d device.\n", i + 1);
+			hdev->maxchild = i;
+			goto fail_keep_maxchild;
+		}
+	}
 
 	usb_hub_adjust_deviceremovable(hdev, hub->descriptor);
 
@@ -1569,6 +1574,7 @@ static int hub_configure(struct usb_hub *hub,
 
 fail:
 	hdev->maxchild = 0;
+fail_keep_maxchild:
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
 	/* hub_disconnect() frees urb and descriptor */
-- 
1.8.4.rc1.409.gbd48715

