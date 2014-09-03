Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbaICWGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:06:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933210AbaICWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:06:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.10 46/55] ARM: OMAP2+: hwmod: Rearm wake-up interrupts for DT when MUSB is idled
Date: Wed,  3 Sep 2014 15:05:36 -0700
Message-Id: <20140903220501.294960621@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit cc824534d4fef0e46e4486d5c1e10d3c6b1ebadc upstream.

Looks like MUSB cable removal can cause wake-up interrupts to
stop working for device tree based booting at least for UART3
even as nothing is dynamically remuxed. This can be fixed by
calling reconfigure_io_chain() for device tree based booting
in hwmod code. Note that we already do that for legacy booting
if the legacy mux is configured.

My guess is that this is related to UART3 and MUSB ULPI
hsusb0_data0 and hsusb0_data1 support for Carkit mode that
somehow affect the configured IO chain for UART3 and require
rearming the wake-up interrupts.

In general, for device tree based booting, pinctrl-single
calls the rearm hook that in turn calls reconfigure_io_chain
so calling reconfigure_io_chain should not be needed from the
hwmod code for other events.

So let's limit the hwmod rearming of iochain only to
HWMOD_FORCE_MSTANDBY where MUSB is currently the only user
of it. If we see other devices needing similar changes we can
add more checks for it.

Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_hwmod.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2177,6 +2177,8 @@ static int _enable(struct omap_hwmod *oh
 			 oh->mux->pads_dynamic))) {
 		omap_hwmod_mux(oh->mux, _HWMOD_STATE_ENABLED);
 		_reconfigure_io_chain();
+	} else if (oh->flags & HWMOD_FORCE_MSTANDBY) {
+		_reconfigure_io_chain();
 	}
 
 	_add_initiator_dep(oh, mpu_oh);
@@ -2283,6 +2285,8 @@ static int _idle(struct omap_hwmod *oh)
 	if (oh->mux && oh->mux->pads_dynamic) {
 		omap_hwmod_mux(oh->mux, _HWMOD_STATE_IDLE);
 		_reconfigure_io_chain();
+	} else if (oh->flags & HWMOD_FORCE_MSTANDBY) {
+		_reconfigure_io_chain();
 	}
 
 	oh->_state = _HWMOD_STATE_IDLE;


