Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3KRVp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:45:56 -0500
Received: from mail.ispras.ru ([83.149.199.45]:47304 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3KRVpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:45:55 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "John W. Linville" <linville@tuxdriver.com>,
        Dan Williams <dcbw@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] libertas sdio: claim device before calling sdio_disable_func()
Date: Tue, 19 Nov 2013 01:45:08 +0400
Message-Id: <1384811108-28807-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a failure path in if_sdio_power_on(), where
sdio_disable_func() is called without claiming the device.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/libertas/if_sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 991238afd1b6..19c4477eb4c6 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -907,8 +907,8 @@ static int if_sdio_power_on(struct if_sdio_card *card)
 	sdio_release_host(func);
 	ret = if_sdio_prog_firmware(card);
 	if (ret) {
-		sdio_disable_func(func);
-		return ret;
+		sdio_claim_host(func);
+		goto disable;
 	}
 
 	return 0;
-- 
1.8.1.2

