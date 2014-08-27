Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946AbaH0VCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:02:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935499AbaH0VCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:02:12 -0400
Date: Wed, 27 Aug 2014 14:02:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: stern@rowland.harvard.edu, balbi@ti.com, ming.lei@canonical.com,
        mwelling@emacinc.com, stefan@herbrechtsmeier.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "[3.8+]" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: hub: Prevent hub autosuspend if
 usbcore.autosuspend is -1
Message-ID: <20140827210212.GA25562@kroah.com>
References: <1407145486-14013-1-git-send-email-rogerq@ti.com>
 <53FDCADE.3040601@ti.com>
 <20140827192339.GA9620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827192339.GA9620@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 12:23:39PM -0700, Greg KH wrote:
> On Wed, Aug 27, 2014 at 03:11:10PM +0300, Roger Quadros wrote:
> > If user specifies that USB autosuspend must be disabled by module
> > parameter "usbcore.autosuspend=-1" then we must prevent
> > autosuspend of USB hub devices as well.
> > 
> > commit 596d789a211d introduced in v3.8 changed the original behaivour
> > and stopped respecting the usbcore.autosuspend parameter for hubs.
> > 
> > Fixes: 596d789a211d "USB: set hub's default autosuspend delay as 0"
> > 
> > Cc: [3.8+] <stable@vger.kernel.org>
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > ---
> >  drivers/usb/core/hub.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > index 8a4dcbc..59b599d 100644
> > --- a/drivers/usb/core/hub.c
> > +++ b/drivers/usb/core/hub.c
> > @@ -1728,8 +1728,14 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
> >  	 * - Change autosuspend delay of hub can avoid unnecessary auto
> >  	 *   suspend timer for hub, also may decrease power consumption
> >  	 *   of USB bus.
> > +	 *
> > +	 * - If user has indicated to prevent autosuspend by passing
> > +	 *   usbcore.autosuspend = -1 then keep autosuspend disabled.
> >  	 */
> > -	pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
> > +#ifdef CONFIG_PM_RUNTIME
> > +	if (hdev->dev.power.autosuspend_delay >= 0)
> > +		pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
> > +#endif
> >  
> >  	/*
> >  	 * Hubs have proper suspend/resume support, except for root hubs
> 
> Sorry, but can I have a patch that just adds the #ifdef as I already
> have your original one in my tree.

This should be all that is needed, right?

---------


diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 003cb6b1a6bf..46f5161c7891 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1732,8 +1732,10 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 * - If user has indicated to prevent autosuspend by passing
 	 *   usbcore.autosuspend = -1 then keep autosuspend disabled.
 	 */
+#ifdef CONFIG_PM_RUNTIME
 	if (hdev->dev.power.autosuspend_delay >= 0)
 		pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
+#endif
 
 	/*
 	 * Hubs have proper suspend/resume support, except for root hubs
