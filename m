Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaECDsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 23:48:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:34013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaECDsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 23:48:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,976,1389772800"; 
   d="scan'208";a="532813741"
From: xiao jin <jin.xiao@intel.com>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yanmin.zhang@intel.com, juan.zou@intel.com, david.a.cohen@linux.intel.com,
        xiao jin <jin.xiao@intel.com>
Subject: [PATCH] USB: ehci-hub: wait for RESUME finished when hub try to clear SUSPEND
Date: Sat,  3 May 2014 11:52:25 +0800
Message-Id: <1399089145-21351-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use usb ehci to connect with modem and run stress test on ehci
remote wake. Sometimes usb disconnect. We add more debug ftrace
(Kernel version: 3.10) and list the key log to show how problem
happened.

<idle>-0     [000] d.h2 26879.385095: ehci_irq: irq status 1008c PPCE FLR PCD
<idle>-0     [000] d.h2 26879.385099: ehci_irq: rh_state[2] hcd->state[132] pstatus[0][238014c5] suspended_ports[1] reset_done[0]
<...>-12873 [000] d..1 26879.393536: ehci_hub_control: GetStatus port:1 status 238014c5 17  ERR POWER sig=k SUSPEND RESUME PE CONNECT
<...>-12873 [000] d..1 26879.393549: ehci_hub_control: typeReq [2301] wIndex[1] wValue[2]
<...>-12873 [000] d..1 26879.393553: ehci_hub_control: [ehci_hub_control]line[891]  port[0] hostpc_reg [44000202]->[44000202]
<idle>-0     [001] ..s. 26879.403122: ehci_hub_status_data: wgq[ehci_hub_status_data] ignore_oc[0] resuming_ports[1]
<...>-12873 [000] d..1 26879.413379: ehci_hub_control: [ehci_hub_control]line[907]  port[0] write portsc_reg[238014c5] reset_done[2105769]
<...>-12873 [000] d..1 26879.453173: ehci_hub_control: GetStatus port:1 status 23801885 17  ERR POWER sig=j SUSPEND PE CONNECT
<...>-12873 [000] .... 26879.473158: check_port_resume_type: port 1 status 0000.0507 after resume, -19
<...>-12873 [000] .... 26879.473160: usb_port_resume: status = -19 after check_port_resume_type
<...>-12873 [000] .... 26879.473161: usb_port_resume: can't resume, status -19
<...>-12873 [000] .... 26879.473162: hub_port_logical_disconnect: logical disconnect on port 1

There is a in-band remote wakeup and controller run in k-state. Then kernel
driver(ClearPortFeature/USB_PORT_FEAT_SUSPEND) write RESUME|LS(k-state) bit
into controller. It makes controller status weird. It's defined in EHCI
controller spec(Revision 1.0), "If it has enabled remote wake-up, a K-state
on the bus will turn the transceiver clock and generate an interrupt. The
software will then have to wait 20 ms for the resume to complete and the
port to go back to an active state." In this case Kernel should wait for
the wakeup finished, then judge what should do next step.

We have some thought and give a patch. This patch is to wait for controller
RESUME finished when hub try to clear port SUSPEND feature.

Signed-off-by: xiao jin <jin.xiao@intel.com>
Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/host/ehci-hub.c  |    7 +++++++
 include/linux/usb/ehci_def.h |    5 +++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 7ae0c4d..09a8b6b 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -935,6 +935,13 @@ static int ehci_hub_control (
 				break;
 			}
 #endif
+			if ((temp & PORT_RESUME)
+				&& ((temp & PORT_LS_MASK) == PORT_K_STATE)) {
+				ehci_handshake(ehci, status_reg,
+					PORT_RESUME, 0, 20000 /* 20msec */);
+				temp = ehci_readl(ehci, status_reg);
+				temp &= ~PORT_RWC_BITS;
+			}
 			if (!(temp & PORT_SUSPEND))
 				break;
 			if ((temp & PORT_PE) == 0)
diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index daec99a..0f0f919 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -149,6 +149,11 @@ struct ehci_regs {
 #define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
 #define PORT_USB11(x) (((x)&(3<<10)) == (1<<10))	/* USB 1.1 device */
 /* 11:10 for detecting lowspeed devices (reset vs release ownership) */
+#define PORT_LS_MASK	(0x3<<10)	/* line status */
+#define PORT_SE0_STATE	(0<<10)
+#define PORT_K_STATE	(1<<10)
+#define PORT_J_STATE	(2<<10)
+#define PORT_UNDEFINED_STATE	(3<<10)
 /* 9 reserved */
 #define PORT_LPM	(1<<9)		/* LPM transaction */
 #define PORT_RESET	(1<<8)		/* reset port */
-- 
1.7.9.5

