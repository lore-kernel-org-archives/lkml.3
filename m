Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3JCES4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:18:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3JCESx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:18:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Solomon Peachy <pizza@shaftnet.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 28/57] cw1200: Use a threaded oneshot irq handler for cw1200_spi
Date: Wed,  2 Oct 2013 21:08:54 -0700
Message-Id: <20131003040638.529911719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Solomon Peachy <pizza@shaftnet.org>

commit 87421cb6010a2f6494938fbe0a95e1b096b3b7af upstream.

This supercedes the older patch ("cw1200: Don't perform SPI transfers in
interrupt context") that badly attempted to fix this problem.

This is a far simpler solution, which has the added benefit of
actually working.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/cw1200/cw1200_spi.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -250,9 +250,10 @@ static int cw1200_spi_irq_subscribe(stru
 
 	pr_debug("SW IRQ subscribe\n");
 
-	ret = request_any_context_irq(self->func->irq, cw1200_spi_irq_handler,
-				      IRQF_TRIGGER_HIGH,
-				      "cw1200_wlan_irq", self);
+	ret = request_threaded_irq(self->func->irq, NULL,
+				   cw1200_spi_irq_handler,
+				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				   "cw1200_wlan_irq", self);
 	if (WARN_ON(ret < 0))
 		goto exit;
 


