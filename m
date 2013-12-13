Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3LMFO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:14:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:44826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab3LMFNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:13:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,476,1384329600"; 
   d="scan'208";a="423990250"
From: David Cohen <david.a.cohen@linux.intel.com>
To: pavel@ucw.cz, rjw@rjwysocki.net, len.brown@intel.com,
        sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, santosh.shilimkar@ti.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH 2/3] usb/xhci: implement proper static inline stubs when !CONFIG_PM
Date: Thu, 12 Dec 2013 21:18:24 -0800
Message-Id: <1386911905-2366-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386911905-2366-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1386911905-2366-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current xhci_suspend() and xhci_resume() implementation in case of
CONFIG_PM not defined is buggy. If we try to use them we get the
following error:

drivers/usb/host/xhci-plat.c: In function ‘xhci_plat_suspend’:
drivers/usb/host/xhci-plat.c:205:21: error: called object ‘0u’ is not a function
drivers/usb/host/xhci-plat.c: In function ‘xhci_plat_resume’:
drivers/usb/host/xhci-plat.c:213:20: error: called object ‘0u’ is not a function

It happens because the function names are replaced by NULL but the
brackets stay: NULL()

This patch implements proper static inline stubs.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/host/xhci.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 941d5f59e4dc..6a5e7a98de7e 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1771,8 +1771,10 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
 int xhci_suspend(struct xhci_hcd *xhci);
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
 #else
-#define	xhci_suspend	NULL
-#define	xhci_resume	NULL
+static inline int
+xhci_suspend(struct xhci_hcd *xhci) { return 0; }
+static inline int
+xhci_resume(struct xhci_hcd *xhci, bool hibernated) { return 0; }
 #endif
 
 int xhci_get_frame(struct usb_hcd *hcd);
-- 
1.8.4.2

