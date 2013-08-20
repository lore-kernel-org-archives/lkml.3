Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3HTSmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:42:42 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:49941 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HTSml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:42:41 -0400
Date: Tue, 20 Aug 2013 20:42:36 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: Re: [PATCH 1/2] usb: fix cleanup after failure in hub_configure()
Message-ID: <20130820184236.GA782@shrek.podlesie.net>
References: <1377019476-7701-2-git-send-email-krzysiek@podlesie.net>
 <Pine.LNX.4.44L0.1308201412220.1591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308201412220.1591-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:14:42PM -0400, Alan Stern wrote:
> On Tue, 20 Aug 2013, Krzysztof Mazur wrote:
> 
> > If the hub_configure() fails after setting the hdev->maxchild
> > the hub->ports might be NULL or point to uninitialized kzallocated
> > memory causing NULL pointer dereference in hub_quiesce() during cleanup.
> > 
> > Now after such error the hdev->maxchild is set to 0 to avoid cleanup
> > of uninitialized ports.
> 
> The idea is good, but the implementation is a little silly...
> 
> > Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> > ---
> >  drivers/usb/core/hub.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > index 558313d..588c3a3 100644
> > --- a/drivers/usb/core/hub.c
> > +++ b/drivers/usb/core/hub.c
> > @@ -1339,7 +1339,7 @@ static int hub_configure(struct usb_hub *hub,
> >  			     GFP_KERNEL);
> >  	if (!hub->ports) {
> >  		ret = -ENOMEM;
> > -		goto fail;
> > +		goto fail_maxchild;
> >  	}
> >  
> >  	wHubCharacteristics = le16_to_cpu(hub->descriptor->wHubCharacteristics);
> 
> > @@ -1567,6 +1567,8 @@ static int hub_configure(struct usb_hub *hub,
> >  	hub_activate(hub, HUB_INIT);
> >  	return 0;
> >  
> > +fail_maxchild:
> > +	hdev->maxchild = 0;
> >  fail:
> >  	dev_err (hub_dev, "config failed, %s (err %d)\n",
> >  			message, ret);
> 
> Why bother with a separate jump label?  Just set maxchild to 0 whenever 
> a failure occurs.
> 

Initially I had just straightforward "dev->maxchild = 0;" after fail,
but I changed that to simplify the second patch and be able to
use goto fail:

	ret = usb_hub_create_port_device(hub, i + 1);
	if (ret < 0) {
		dev_err(hub->intfdev,
			"couldn't create port%d device.\n", i + 1);
		hdev->maxchild = i;
		goto fail;
	}

and avoid "return ret" here or something like

	if (hdev->maxchild == hub->descriptor->bNbrPorts)
		hdev->maxchild = 0;

in the fail path.

Thanks,
Krzysiek

-- >8 --
Subject: [PATCH 1/2 v2] usb: fix cleanup after failure in hub_configure()

If the hub_configure() fails after setting the hdev->maxchild
the hub->ports might be NULL or point to uninitialized kzallocated
memory causing NULL pointer dereference in hub_quiesce() during cleanup.

Now after such error the hdev->maxchild is set to 0 to avoid cleanup
of uninitialized ports.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 drivers/usb/core/hub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 558313d..affed11 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1568,6 +1568,7 @@ static int hub_configure(struct usb_hub *hub,
 	return 0;
 
 fail:
+	hdev->maxchild = 0;
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
 	/* hub_disconnect() frees urb and descriptor */
-- 
1.8.4.rc1.409.gbd48715

