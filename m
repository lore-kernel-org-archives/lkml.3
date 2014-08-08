Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbaHHV0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:26:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaHHUu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:50:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 236/259] net: huawei_cdc_ncm: increase command buffer size
Date: Fri,  8 Aug 2014 13:40:59 -0700
Message-Id: <1407530482-4483-237-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 3acc74619b0175b7a154cf8dc54813f6faf97aa9 ]

Messages from the modem exceeding 256 bytes cause communication
failure.

The WDM protocol is strictly "read on demand", meaning that we only
poll for unread data after receiving a notification from the modem.
Since we have no way to know how much data the modem has to send,
we must make sure that the buffer we provide is "big enough".
Message truncation does not work. Truncated messages are left unread
until the modem has another message to send.  Which often won't
happen until the userspace application has given up waiting for the
final part of the last message, and therefore sends another command.

With a proper CDC WDM function there is a descriptor telling us
which buffer size the modem uses. But with this vendor specific
implementation there is no known way to calculate the exact "big
enough" number.  It is an unknown property of the modem firmware.
Experience has shown that 256 is too small.  The discussion of
this failure ended up concluding that 512 might be too small as
well. So 1024 seems like a reasonable value for now.

Fixes: 41c47d8cfd68 ("net: huawei_cdc_ncm: Introduce the huawei_cdc_ncm driver")
Cc: Enrico Mioso <mrkiko.rs@gmail.com>
Reported-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-By: Enrico Mioso <mrkiko.rs@gmail.com>
Tested-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/huawei_cdc_ncm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/huawei_cdc_ncm.c b/drivers/net/usb/huawei_cdc_ncm.c
index 312178d..75d9ee4 100644
--- a/drivers/net/usb/huawei_cdc_ncm.c
+++ b/drivers/net/usb/huawei_cdc_ncm.c
@@ -84,12 +84,13 @@ static int huawei_cdc_ncm_bind(struct usbnet *usbnet_dev,
 	ctx = drvstate->ctx;
 
 	if (usbnet_dev->status)
-		/* CDC-WMC r1.1 requires wMaxCommand to be "at least 256
-		 * decimal (0x100)"
+		/* The wMaxCommand buffer must be big enough to hold
+		 * any message from the modem. Experience has shown
+		 * that some replies are more than 256 bytes long
 		 */
 		subdriver = usb_cdc_wdm_register(ctx->control,
 						 &usbnet_dev->status->desc,
-						 256, /* wMaxCommand */
+						 1024, /* wMaxCommand */
 						 huawei_cdc_ncm_wdm_manage_power);
 	if (IS_ERR(subdriver)) {
 		ret = PTR_ERR(subdriver);
-- 
1.9.1

