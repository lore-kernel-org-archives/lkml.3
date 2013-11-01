Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3KAWOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:14:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3KAWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Mosberger <davidm@egauge.net>,
        Solomon Peachy <pizza@shaftnet.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.11 62/66] wireless: cw1200: acquire hwbus lock around cw1200_irq_handler() call.
Date: Fri,  1 Nov 2013 15:07:38 -0700
Message-Id: <20131101220651.891105194@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Solomon Peachy <pizza@shaftnet.org>

commit 4978705d26149a629b9f50ff221caed6f1ae3048 upstream.

This fixes "lost interrupt" problems that occurred on SPI-based systems.
cw1200_irq_handler() expects the hwbus to be locked, but on the
SPI-path, that lock wasn't taken (unlike in the SDIO-path, where the
generic SDIO-code takes care of acquiring the lock).

Signed-off-by: David Mosberger <davidm@egauge.net>
Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/cw1200/cw1200_spi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -237,7 +237,9 @@ static irqreturn_t cw1200_spi_irq_handle
 	struct hwbus_priv *self = dev_id;
 
 	if (self->core) {
+		cw1200_spi_lock(self);
 		cw1200_irq_handler(self->core);
+		cw1200_spi_unlock(self);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;


