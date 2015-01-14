Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbbANIOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:14:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbbANHbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.18 085/150] usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()
Date: Tue, 13 Jan 2015 23:22:36 -0800
Message-Id: <20150114072059.711428224@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>

commit 11432050f070810ba139d0226344eef120c3a559 upstream.

This patch fixes an issue that the NULL pointer dereference happens
when we uses g_audio driver. Since the g_audio driver will call
usb_ep_disable() in afunc_set_alt() before it calls usb_ep_enable(),
the uep->pipe of renesas usbhs driver will be NULL. So, this patch
adds a condition to avoid the oops.

Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Fixes: 2f98382dc (usb: renesas_usbhs: Add Renesas USBHS Gadget)
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/renesas_usbhs/mod_gadget.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -602,6 +602,9 @@ static int usbhsg_ep_disable(struct usb_
 	struct usbhsg_uep *uep = usbhsg_ep_to_uep(ep);
 	struct usbhs_pipe *pipe = usbhsg_uep_to_pipe(uep);
 
+	if (!pipe)
+		return -EINVAL;
+
 	usbhsg_pipe_disable(uep);
 	usbhs_pipe_free(pipe);
 


