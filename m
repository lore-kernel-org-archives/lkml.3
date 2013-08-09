Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968001Ab3HIQDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:03:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:36859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab3HIQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:03:40 -0400
Date: Fri, 9 Aug 2013 18:03:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Bin Liu <binmlist@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: [PATCH] usb: musb: am335x: Do not remove the session bin HOST-only
 mode
Message-ID: <20130809160339.GA14829@linutronix.de>
References: <51F2BE6F.3010008@linutronix.de>
 <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
 <51F2D427.7050106@linutronix.de>
 <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
 <51F2DD90.2030405@linutronix.de>
 <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com>
 <20130729165329.GA5773@linutronix.de>
 <CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com>
 <51F6ABA2.7060102@linutronix.de>
 <CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I observe:
On the first connect, the musb starts with DEVCTL.Session set. On
disconnect, musb_core calls try_idle. That functions removes the Session
bit signalize that the session is over (something that only in OTG is
required). A new device, that is plugged, is no longer recognized.
I've setup a timer and checked the DEVCTL register and I haven't seen a
change in VBus and I saw the B-Device bit set. After setting the IDDIG
into A mode and forcing the device to behave like I didn't see a change.
Neither VBUS goes to 0b11 nor does a session start request come.
The TI-v3.2 kernel they skip to call musb_platform_try_idle() in the
OTG_STATE_A_WAIT_BCON state while not in OTG mode.
Since the second port hast a standard A plug the patch changes the port
to run in host mode only, force the id-pin to host only and skip the
timer which would remove DEVCTL.Session.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/am335x-evm.dts |  3 +++
 drivers/usb/musb/musb_dsps.c     | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index c26c16c..38a821a 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -192,6 +192,9 @@
 
 			usb@47401800 {
 				status = "okay";
+				musb1: usb@47401c00 {
+					port-mode = <1>;
+				};
 			};
 
 			dma@07402000  {
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 4ffbaac..b0752fa 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -65,6 +65,9 @@ static inline void dsps_writeb(void __iomem *addr, unsigned offset, u8 data)
 static inline void dsps_writel(void __iomem *addr, unsigned offset, u32 data)
 	{ __raw_writel(data, addr + offset); }
 
+#define USBMODE_IDDIG_A		(0 << 8)
+#define USBMODE_ID_MUX_REG	(1 << 7)
+#define USBMODE_ID_MUX_PHY	(0 << 7)
 /**
  * DSPS musb wrapper register offset.
  * FIXME: This should be expanded to have all the wrapper registers from TI DSPS
@@ -230,6 +233,8 @@ static void dsps_musb_try_idle(struct musb *musb, unsigned long timeout)
 		glue->last_timer = jiffies;
 		return;
 	}
+	if (musb->port_mode == MUSB_PORT_MODE_HOST)
+		return;
 
 	if (time_after(glue->last_timer, timeout) &&
 				timer_pending(&glue->timer)) {
@@ -388,6 +393,14 @@ static int dsps_musb_init(struct musb *musb)
 	val &= ~(1 << wrp->otg_disable);
 	dsps_writel(musb->ctrl_base, wrp->phy_utmi, val);
 
+	if (musb->port_mode == MUSB_PORT_MODE_HOST) {
+		val = USBMODE_IDDIG_A;
+		val |= USBMODE_ID_MUX_REG;
+	} else {
+		val = USBMODE_ID_MUX_PHY;
+	}
+	dsps_writel(musb->ctrl_base, wrp->mode, val);
+
 	return 0;
 }
 
-- 
1.8.3.2

