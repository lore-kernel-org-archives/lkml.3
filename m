Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaBUArm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:47:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaBTXvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 16/66] spi: Fix crash with double message finalisation on error handling
Date: Thu, 20 Feb 2014 15:51:15 -0800
Message-Id: <20140220234909.947078513@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

commit 1f802f8249a0da536877842c43c7204064c4de8b upstream.

This reverts commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d.

It causes a NULL pointer dereference with drivers using the generic
spi_transfer_one_message(), which always calls
spi_finalize_current_message(), which zeroes master->cur_msg.

Drivers implementing transfer_one_message() theirselves must always call
spi_finalize_current_message(), even if the transfer failed:

 * @transfer_one_message: the subsystem calls the driver to transfer a single
 *      message while queuing transfers that arrive in the meantime. When the
 *      driver is finished with this message, it must call
 *      spi_finalize_current_message() so the subsystem can issue the next
 *      transfer

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -584,9 +584,7 @@ static void spi_pump_messages(struct kth
 	ret = master->transfer_one_message(master, master->cur_msg);
 	if (ret) {
 		dev_err(&master->dev,
-			"failed to transfer one message from queue: %d\n", ret);
-		master->cur_msg->status = ret;
-		spi_finalize_current_message(master);
+			"failed to transfer one message from queue\n");
 		return;
 	}
 }


