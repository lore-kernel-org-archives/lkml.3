Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbbA2DEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:04:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965198AbbA2Che (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 026/139] usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()
Date: Wed, 28 Jan 2015 14:19:29 -0800
Message-Id: <1422483682-15393-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.13-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/renesas_usbhs/mod_gadget.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 3385aeb..c3bb467 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -600,6 +600,10 @@ static int usbhsg_ep_enable(struct usb_ep *ep,
 static int usbhsg_ep_disable(struct usb_ep *ep)
 {
 	struct usbhsg_uep *uep = usbhsg_ep_to_uep(ep);
+	struct usbhs_pipe *pipe = usbhsg_uep_to_pipe(uep);
+
+	if (!pipe)
+		return -EINVAL;
 
 	usbhsg_pipe_disable(uep);
 
-- 
1.9.1

