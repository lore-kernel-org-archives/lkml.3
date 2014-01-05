Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaAEXpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:45:20 -0500
Received: from nm20-vm7.access.bullet.mail.bf1.yahoo.com ([216.109.115.118]:23252
	"HELO nm20-vm7.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751837AbaAEXpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:45:18 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jan 2014 18:45:18 EST
X-Yahoo-Newman-Id: 890542.17181.bm@smtp114.sbc.mail.bf1.yahoo.com
X-Rocket-Received: from localhost.localdomain (danielfsantos@99.70.244.137 with plain [98.139.221.42])
        by smtp114.sbc.mail.bf1.yahoo.com with SMTP; 05 Jan 2014 15:38:11 -0800 PST
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RVyFSAEVM1lzZl2jr6RAH_TFzBBRGf6cDhKdyyQZU4vZcnb
 cs6FLEm0_VBv_6iqzzP1Z_BP3GWjHy6dOE_InW_Ggr3U3PePNpeXWJrR0_dK
 a9qqoY25SvTdhLnLnG6NAE1O41bmQoU562SIP.OCFcwI38QmAjvmmpKP17Op
 54.5gZcZBcaYb_limdMjB_OJwZOzYWvrf244KM_U3PFLAZP1YDOvcvpJOm83
 AhFB6VA6WpS3fAqGgrbNIplXVzfcN5lGn5yo20oSU5PURk7o8e_.Q_zzAYh6
 wOWZ6Yk3.8Ces4AFBFqfsBjdPg9kUZZKv8Jtz9N0OTMtiTDSO1nYV7Jc0wTP
 Q4dRyFmfXSvAexHUBvlAPTPkMYHJA88n9KyweYGt8hJodWNCX1S611nI0Uu3
 CB4gIrmyyyi_V8DnhMYdSiuNILom3nRGhZi2cjIXyNg4EqINN.w08EM7LX20
 hxVmz8yGmQdEl3q_ikFwM3z4BP3dYc3WU1RTDGH1D4RRzLZoRcVOPacxFiSd
 kJA2Ld2XpbaYKS1fnXqCLf6rnYpverYr2
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: spidev: fix hang when transfer_one_message fails
Date: Sun,  5 Jan 2014 17:39:26 -0600
Message-Id: <1388965166-27334-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.8.3.2
Reply-To: Daniel Santos <daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 drivers/spi/spi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 98f4b77..907122e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -735,7 +735,9 @@ static void spi_pump_messages(struct kthread_work *work)
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
-- 
1.8.3.2

