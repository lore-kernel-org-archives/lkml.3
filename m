Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbbAWWxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:53:38 -0500
Received: from mail.ispras.ru ([83.149.199.45]:60429 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbbAWWxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:53:36 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Rodolfo Giometti <giometti@linux.it>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] usb: host: oxu210hp-hcd: Fix deadlock in oxu_qh_alloc()
Date: Sat, 24 Jan 2015 01:53:21 +0300
Message-Id: <1422053601-29473-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oxu_qh_alloc() acquires oxu->mem_lock spinlock, finds free qh slot
and calls ehci_qtd_alloc() to initialize qh->dummy, but
ehci_qtd_alloc() acquires oxu->mem_lock as well.
That means an unavoidable deadlock in oxu_qh_alloc().

The patch fixes the issue by introduction of unlocked version
of ehci_qtd_alloc().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/host/oxu210hp-hcd.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 036924e640f5..15d4cf2c35cd 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -573,13 +573,11 @@ static inline void oxu_qtd_free(struct oxu_hcd *oxu, struct ehci_qtd *qtd)
 	spin_unlock(&oxu->mem_lock);
 }
 
-static struct ehci_qtd *ehci_qtd_alloc(struct oxu_hcd *oxu)
+static struct ehci_qtd *ehci_qtd_alloc_unlocked(struct oxu_hcd *oxu)
 {
 	int i;
 	struct ehci_qtd *qtd = NULL;
 
-	spin_lock(&oxu->mem_lock);
-
 	for (i = 0; i < QTD_NUM; i++)
 		if (!oxu->qtd_used[i])
 			break;
@@ -598,6 +596,17 @@ static struct ehci_qtd *ehci_qtd_alloc(struct oxu_hcd *oxu)
 		oxu->qtd_used[i] = 1;
 	}
 
+	return qtd;
+}
+
+static struct ehci_qtd *ehci_qtd_alloc(struct oxu_hcd *oxu)
+{
+	struct ehci_qtd *qtd;
+
+	spin_lock(&oxu->mem_lock);
+
+	qtd = ehci_qtd_alloc_unlocked(oxu);
+
 	spin_unlock(&oxu->mem_lock);
 
 	return qtd;
@@ -651,7 +660,7 @@ static struct ehci_qh *oxu_qh_alloc(struct oxu_hcd *oxu)
 		INIT_LIST_HEAD(&qh->qtd_list);
 
 		/* dummy td enables safe urb queuing */
-		qh->dummy = ehci_qtd_alloc(oxu);
+		qh->dummy = ehci_qtd_alloc_unlocked(oxu);
 		if (qh->dummy == NULL) {
 			oxu_dbg(oxu, "no dummy td\n");
 			oxu->qh_used[i] = 0;
-- 
1.9.1

