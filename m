Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKESSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:18:07 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:51760 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKESSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:18:04 -0500
Date: Wed, 5 Nov 2014 19:14:54 +0100
From: Johan Hovold <johan@kernel.org>
To: Nix <nix@esperi.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Paul Martin <pm@debian.org>,
        Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141105181454.GW31358@localhost>
References: <20141012185845.GB2786@localhost>
 <878uklynq9.fsf@spindle.srvr.nix>
 <20141014083432.GB7958@localhost>
 <871tq04fiy.fsf@spindle.srvr.nix>
 <20141022101458.GK2113@localhost>
 <87y4s8yv38.fsf@spindle.srvr.nix>
 <20141024111442.GA19377@localhost>
 <87d298i3y9.fsf@spindle.srvr.nix>
 <20141105115643.GR31358@localhost>
 <87vbmtbrx2.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbmtbrx2.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 03:14:49PM +0000, Nix wrote:
> On 5 Nov 2014, Johan Hovold stated:
> 
> > On Fri, Oct 31, 2014 at 04:44:46PM +0000, Nix wrote:
> >> Sorry for the delay: illness and work-related release time flurries.
> >> 
> >> On 24 Oct 2014, Johan Hovold told this:
> >> 

> > The log appears incomplete again, this time it seems the last part is
> > completely missing (the device is never closed for example). The device
> > still seems to be responding.
> 
> Nope -- by the time I clipped the log, the device was definitely
> nonresponsive.
>
> I've appended the remaining log, just in case. This is the same as the
> snapshot I added to the email itself last time: a close-and-open as I
> tried restarting the daemon, and another close as part of system
> shutdown.

Ok, yeah, there's the crash.

> >> >                                                      What if you
> >> > physically disconnect and reconnect the device instead, or simply
> >> 
> >> That fixes it, in fact it's the only way to fix it once it's broken by
> >> this bug.
> >
> > I didn't mean whether it would get the device working again, but rather
> > whether you could kill it this way.
> 
> Never seen it fail after a physical disconnection.

Ok.

And it has to include an enumeration, since just opening and closing it
(restarting the daemon) repeatedly seems to work?

> >> ... no, that doesn't help. Additional log from that shows a lot of what
> >> looks like error returns:
> >> 
> >> Oct 31 16:38:03 fold kern debug: : [  168.135213] cdc_acm 2-1:1.0: acm_tty_close
> >> Oct 31 16:38:08 fold kern debug: : [  173.130531] cdc_acm 2-1:1.0: acm_ctrl_msg - rq 0x22, val 0x0, len 0x0, result -110
> >
> > Yeah, it seems your device firmware has crashed. It stops responding to
> > control requests.
> 
> Not surprising: I was fairly sure we were provoking a key firmware crash
> or something like that. This is a device with no support for flow
> control at all, after all, so I'm not terribly surprised that trying to
> do flow control confuses it.

Only weird thing is that it has been coping with those calls for a long
time. Only the slightly changed timings seems to have triggered this
issue.

> > The above is all normal, but
> >
> >> Oct 31 16:38:08 fold kern debug: : [  173.161489] cdc_acm 2-1:1.0: acm_ctrl_msg - rq 0x22, val 0x3, len 0x0, result -62
> >
> > here's another timeout. It's dead.
> 
> Again, not surprising.
> 
> > Did you get anywhere with trying to look at the device firmware?
> 
> Look at it? Only Daniel Silverstone (Cc:ed) can do that. The only copy
> of the firmware I have is baked into the sealed key. :)

Ah, ok. I guess we need a new quirk then. There's already a quirk in the
driver to suppress error from when trying to set the control lines.

But that doesn't help this device, which happily accepts the requests
and then dies at random times.

Could you try two more things (too make sure line control is really the
culprit):

1. If you clear HUPCL in ekeyd so that the lines are never lowered, does
that fix the stability issue?

2. Can you verify that the patch below works? Did I use the correct
VID/PID? Could you provide "lsusb -v" output (for the capability flags)
as well?

Note that the patch is against the usb-linus branch of the usb tree,
which also contains another fix which could affect this device
(set_termios will now be called an extra time on every open). You also
need this one, which have not yet been applied:

	http://marc.info/?l=linux-usb&m=141520959813505&w=2

Thanks,
Johan


>From 76abc8a7eda9ea1978ee3527c773210c28332317 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 5 Nov 2014 18:51:54 +0100
Subject: [PATCH] USB: cdc-acm: add quirk for control-line state requests

Add new quirk for devices that cannot handle control-line state
requests.

Note that we currently send these requests to all devices, regardless of
whether they claim to support it, but that errors are only logged if
support is claimed.

Since commit 0943d8ead30e ("USB: cdc-acm: use tty-port dtr_rts"), which
only changed the timings for these requests slightly, this has been
reported to cause occasional firmware crashes on Simtec Electronics
Entropy Key devices after re-enumeration. Enable the quirk for this
device.

Reported-by: Nix <nix@esperi.org.uk>
Cc: stable <stable@vger.kernel.org>	# v3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 14 ++++++++++++--
 drivers/usb/class/cdc-acm.h |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 9d6495424b06..077d58ac3dcb 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -148,8 +148,15 @@ static int acm_ctrl_msg(struct acm *acm, int request, int value,
 /* devices aren't required to support these requests.
  * the cdc acm descriptor tells whether they do...
  */
-#define acm_set_control(acm, control) \
-	acm_ctrl_msg(acm, USB_CDC_REQ_SET_CONTROL_LINE_STATE, control, NULL, 0)
+static inline int acm_set_control(struct acm *acm, int control)
+{
+	if (acm->quirks & QUIRK_CONTROL_LINE_STATE)
+		return -EOPNOTSUPP;
+
+	return acm_ctrl_msg(acm, USB_CDC_REQ_SET_CONTROL_LINE_STATE,
+			control, NULL, 0);
+}
+
 #define acm_set_line(acm, line) \
 	acm_ctrl_msg(acm, USB_CDC_REQ_SET_LINE_CODING, 0, line, sizeof *(line))
 #define acm_send_break(acm, ms) \
@@ -1320,6 +1327,7 @@ made_compressed_probe:
 	tty_port_init(&acm->port);
 	acm->port.ops = &acm_port_ops;
 	init_usb_anchor(&acm->delayed);
+	acm->quirks = quirks;
 
 	buf = usb_alloc_coherent(usb_dev, ctrlsize, GFP_KERNEL, &acm->ctrl_dma);
 	if (!buf) {
@@ -1687,6 +1695,8 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x20df, 0x0001), /* Simtec Electronics Entropy Key */
+	.driver_info = QUIRK_CONTROL_LINE_STATE, },
 	{ USB_DEVICE(0x2184, 0x001c) },	/* GW Instek AFG-2225 */
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index fc75651afe1c..d3251ebd09e2 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -121,6 +121,7 @@ struct acm {
 	unsigned int throttle_req:1;			/* throttle requested */
 	u8 bInterval;
 	struct usb_anchor delayed;			/* writes queued for a device about to be woken */
+	unsigned long quirks;
 };
 
 #define CDC_DATA_INTERFACE_TYPE	0x0a
@@ -132,3 +133,4 @@ struct acm {
 #define NOT_A_MODEM			BIT(3)
 #define NO_DATA_INTERFACE		BIT(4)
 #define IGNORE_DEVICE			BIT(5)
+#define QUIRK_CONTROL_LINE_STATE	BIT(6)
-- 
2.0.4

