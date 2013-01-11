Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3AKNQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:16:14 -0500
Received: from masquerade.micron.com ([137.201.242.130]:62442 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3AKNQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:16:12 -0500
Message-ID: <50F01094.4090103@micron.com>
Date: Fri, 11 Jan 2013 18:46:04 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 2/3] mtip32xx: fix for driver hang after a command timeout
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19546.007
X-TM-AS-Result: No--8.488800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If an I/O command times out when a PIO command is active,
MTIP_PF_EH_ACTIVE_BIT is not cleared. This results in I/O
hang in the driver. Fix is to clear this bit.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>

---
 drivers/block/mtip32xx/mtip32xx.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index b7e6631..a070a68 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -625,12 +625,13 @@ static void mtip_timeout_function(unsigned long int data)
 		}
 	}
 
-	if (cmdto_cnt && !test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags)) {
+	if (cmdto_cnt) {
 		print_tags(port->dd, "timed out", tagaccum, cmdto_cnt);
-
-		mtip_restart_port(port);
+		if (!test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags)) {
+			mtip_restart_port(port);
+			wake_up_interruptible(&port->svc_wait);
+		}
 		clear_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
-		wake_up_interruptible(&port->svc_wait);
 	}
 
 	if (port->ic_pause_timer) {
-- 
1.7.1

