Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaBKTGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:06:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaBKTGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Santos <daniel.santos@pobox.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 037/107] spidev: fix hang when transfer_one_message fails
Date: Tue, 11 Feb 2014 11:05:03 -0800
Message-Id: <20140211184749.254574462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Santos <daniel.santos@pobox.com>

commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d upstream.

This corrects a problem in spi_pump_messages() that leads to an spi
message hanging forever when a call to transfer_one_message() fails.
This failure occurs in my MCP2210 driver when the cs_change bit is set
on the last transfer in a message, an operation which the hardware does
not support.

Rationale
Since the transfer_one_message() returns an int, we must presume that it
may fail.  If transfer_one_message() should never fail, it should return
void.  Thus, calls to transfer_one_message() should properly manage a
failure.

Fixes: ffbbdd21329f3 (spi: create a message queueing infrastructure)
Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -600,7 +600,9 @@ static void spi_pump_messages(struct kth
 	ret = master->transfer_one_message(master, master->cur_msg);
 	if (ret) {
 		dev_err(&master->dev,
-			"failed to transfer one message from queue\n");
+			"failed to transfer one message from queue: %d\n", ret);
+		master->cur_msg->status = ret;
+		spi_finalize_current_message(master);
 		return;
 	}
 }


