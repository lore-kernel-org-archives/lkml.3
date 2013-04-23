Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3DWUee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab3DWUed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:34:33 -0400
Message-ID: <5176F051.4030902@redhat.com>
Date: Tue, 23 Apr 2013 17:34:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kevin Baradon <kevin.baradon@gmail.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Revert "media/rc/imon.c: make send_packet() delay
 larger for 15c2:0036"
References: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com> <1366661386-6720-2-git-send-email-kevin.baradon@gmail.com>
In-Reply-To: <1366661386-6720-2-git-send-email-kevin.baradon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Em 22-04-2013 17:09, Kevin Baradon escreveu:
> This reverts commit d92f150f9cb80b4df56331d1f42442da78e351f0.
> It seems send_packet() is used during initialization, before send_packet_delay is set.
>
> This will be fixed by another patch.

Reverting patches is a resource that we generally use only when
there's something deadly wrong, as it makes the git history
dirtier, hides the reasons why a change is needed, and might be bad
for git bisecting.

In this specific case, by applying both the revert patch and your newer
one, it is clear that your intent is to move the logic that changes
the send packet delay, because it needs to happen earlier.

So, instead of applying both patches, I'll fold them into one,
as enclosed.

-

From: Kevin Baradon <kevin.baradon@gmail.com>

[media] imon: Use large delays earlier

send_packet() is used during initialization, before send_packet_delay
is set. So, move ictx->send_packet_delay to happen earlier.

[mchehab@redhat.com: fold two patches into one to make git history clearer]
Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index b8f9f85..624fd33 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2093,7 +2093,8 @@ static bool imon_find_endpoints(struct imon_context *ictx,
  
  }
  
-static struct imon_context *imon_init_intf0(struct usb_interface *intf)
+static struct imon_context *imon_init_intf0(struct usb_interface *intf,
+					    const struct usb_device_id *id)
  {
  	struct imon_context *ictx;
  	struct urb *rx_urb;
@@ -2133,6 +2134,10 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
  	ictx->vendor  = le16_to_cpu(ictx->usbdev_intf0->descriptor.idVendor);
  	ictx->product = le16_to_cpu(ictx->usbdev_intf0->descriptor.idProduct);
  
+	/* default send_packet delay is 5ms but some devices need more */
+	ictx->send_packet_delay = id->driver_info & IMON_NEED_20MS_PKT_DELAY ?
+				  20 : 5;
+
  	ret = -ENODEV;
  	iface_desc = intf->cur_altsetting;
  	if (!imon_find_endpoints(ictx, iface_desc)) {
@@ -2311,7 +2316,7 @@ static int imon_probe(struct usb_interface *interface,
  	first_if_ctx = usb_get_intfdata(first_if);
  
  	if (ifnum == 0) {
-		ictx = imon_init_intf0(interface);
+		ictx = imon_init_intf0(interface, id);
  		if (!ictx) {
  			pr_err("failed to initialize context!\n");
  			ret = -ENODEV;
@@ -2329,10 +2334,6 @@ static int imon_probe(struct usb_interface *interface,
  
  	}
  
-	/* default send_packet delay is 5ms but some devices need more */
-	ictx->send_packet_delay = id->driver_info & IMON_NEED_20MS_PKT_DELAY ?
-				  20 : 5;
-
  	usb_set_intfdata(interface, ictx);
  
  	if (ifnum == 0) {


