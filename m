Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3GWJ0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:26:14 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52580 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3GWJ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:26:10 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6N9Q4HS029880, This message is accepted by code: ctaloc0852
From: hayeswang <hayeswang@realtek.com>
To: <gregkh@linuxfoundation.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH 1/3] net/usb/r815x: replace USB buffer from stack to DMA-able
Date: Tue, 23 Jul 2013 17:26:04 +0800
Message-ID: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac6HhMdOg1BBwFkoQluPEEf34daUng==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some USB buffers use stack which may not be DMA-able.
Use the buffers from kmalloc to replace those one.
 
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r815x.c | 44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)
 
diff --git a/drivers/net/usb/r815x.c b/drivers/net/usb/r815x.c
index 8523922..e9b99ba 100644
--- a/drivers/net/usb/r815x.c
+++ b/drivers/net/usb/r815x.c
@@ -24,34 +24,43 @@
 
 static int pla_read_word(struct usb_device *udev, u16 index)
 {
- int data, ret;
+ int ret;
  u8 shift = index & 2;
- __le32 ocp_data;
+ __le32 *tmp;
+
+ tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+ if (!tmp)
+  return -ENOMEM;
 
  index &= ~3;
 
  ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
          RTL815x_REQ_GET_REGS, RTL815x_REQT_READ,
-         index, MCU_TYPE_PLA, &ocp_data, sizeof(ocp_data),
-         500);
+         index, MCU_TYPE_PLA, tmp, sizeof(*tmp), 500);
  if (ret < 0)
-  return ret;
+  goto out2;
 
- data = __le32_to_cpu(ocp_data);
- data >>= (shift * 8);
- data &= 0xffff;
+ ret = __le32_to_cpu(*tmp);
+ ret >>= (shift * 8);
+ ret &= 0xffff;
 
- return data;
+out2:
+ kfree(tmp);
+ return ret;
 }
 
 static int pla_write_word(struct usb_device *udev, u16 index, u32 data)
 {
- __le32 ocp_data;
+ __le32 *tmp;
  u32 mask = 0xffff;
  u16 byen = BYTE_EN_WORD;
  u8 shift = index & 2;
  int ret;
 
+ tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+ if (!tmp)
+  return -ENOMEM;
+
  data &= mask;
 
  if (shift) {
@@ -63,19 +72,20 @@ static int pla_write_word(struct usb_device *udev, u16 index, u32 data)
 
  ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
          RTL815x_REQ_GET_REGS, RTL815x_REQT_READ,
-         index, MCU_TYPE_PLA, &ocp_data, sizeof(ocp_data),
-         500);
+         index, MCU_TYPE_PLA, tmp, sizeof(*tmp), 500);
  if (ret < 0)
-  return ret;
+  goto out3;
 
- data |= __le32_to_cpu(ocp_data) & ~mask;
- ocp_data = __cpu_to_le32(data);
+ data |= __le32_to_cpu(*tmp) & ~mask;
+ *tmp = __cpu_to_le32(data);
 
  ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
          RTL815x_REQ_SET_REGS, RTL815x_REQT_WRITE,
-         index, MCU_TYPE_PLA | byen, &ocp_data,
-         sizeof(ocp_data), 500);
+         index, MCU_TYPE_PLA | byen, tmp, sizeof(*tmp),
+         500);
 
+out3:
+ kfree(tmp);
  return ret;
 }
 
-- 
1.8.3.1
 

