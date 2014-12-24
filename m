Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaLXNM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 08:12:27 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48807 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaLXNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 08:12:26 -0500
Date: Wed, 24 Dec 2014 18:42:18 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        johannes.berg@intel.com, arend@broadcom.com
Subject: [PATCH] NFC: port100: Introduce the use of function
 put_unaligned_le16
Message-ID: <20141224131218.GA2578@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of function put_unaligned_le16.

This is done using Coccinelle and semantic patch used is as follows:

@a@
typedef u16, __le16;
{u16,__le16} e16;
identifier tmp;
expression ptr;
expression y,e;
type T;
@@

- tmp = cpu_to_le16(y);

  <+... when != tmp
(
- memcpy(ptr, (T)&tmp, \(2\|sizeof(u16)\|sizeof(__le16)\|sizeof(e16)\));
+ put_unaligned_le16(y,ptr);
|
- memcpy(ptr, (T)&tmp, ...);
+ put_unaligned_le16(y,ptr);
)
  ...+>
? tmp = e

@@ type T; identifier a.tmp; @@

- T tmp;
...when != tmp

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
Changes since v1:
	<asm/unaligned.h>  has arch-specific knowlege of which of
	the implementations needs to be used. So, include it instaed
	of <linux/unaligned/access_ok.h>.
Changes since v2:
	Fix typing mistake in subject

 drivers/nfc/port100.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 4ac4d31..440f0f3 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <net/nfc/digital.h>
+#include <asm/unaligned.h>
 
 #define VERSION "0.1"
 
@@ -1136,7 +1137,6 @@ static int port100_in_send_cmd(struct nfc_digital_dev *ddev,
 {
 	struct port100 *dev = nfc_digital_get_drvdata(ddev);
 	struct port100_cb_arg *cb_arg;
-	__le16 timeout;
 
 	cb_arg = kzalloc(sizeof(struct port100_cb_arg), GFP_KERNEL);
 	if (!cb_arg)
@@ -1145,9 +1145,7 @@ static int port100_in_send_cmd(struct nfc_digital_dev *ddev,
 	cb_arg->complete_cb = cb;
 	cb_arg->complete_arg = arg;
 
-	timeout = cpu_to_le16(_timeout * 10);
-
-	memcpy(skb_push(skb, sizeof(__le16)), &timeout, sizeof(__le16));
+	put_unaligned_le16(_timeout * 10, skb_push(skb, sizeof(__le16)));
 
 	return port100_send_cmd_async(dev, PORT100_CMD_IN_COMM_RF, skb,
 				      port100_in_comm_rf_complete, cb_arg);
-- 
1.9.1

