Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbbALTP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:15:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbALSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 016/216] usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()
Date: Mon, 12 Jan 2015 18:02:13 +0000
Message-Id: <1421085933-32536-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.16: replaced pipe by uep->pipe ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/renesas_usbhs/mod_gadget.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 458f3766bef1..e344d50f4697 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -601,6 +601,9 @@ static int usbhsg_ep_disable(struct usb_ep *ep)
 {
 	struct usbhsg_uep *uep = usbhsg_ep_to_uep(ep);
 
+	if (!uep->pipe)
+		return -EINVAL;
+
 	usbhsg_pipe_disable(uep);
 
 	uep->pipe->mod_private	= NULL;
-- 
2.1.4

