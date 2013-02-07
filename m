Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab3BGNF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:05:58 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:55945 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab3BGNF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:05:57 -0500
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <Vineet.Gupta1@synopsys.com>, <arnd@arndb.de>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: [PATCH] drivers/block/xsysace - revert "id" type from "u32" back to "int"
Date: Thu, 7 Feb 2013 17:05:31 +0400
Message-ID: <1360242331-17025-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.121.8.160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On addition of new device specified in devicetree device's "id" is set
by default to "-1" (it's in "of_device_add").

During probing of xsysace itself driver wants to determine his instance
number (used later for example for device naming). It is done simply by
reading "dev->id" (which is "-1" by default).

Then driver tries to get "id" from devicetree description reading
specific "port-number" property with "of_property_read_u32". And if no
property "port-number" was found "id" won't be changed (so if it was
"-1" it remains the same).

And later we check it with "if (id < 0) id = 0;" to escape negative
values.

But if "id" is "u32" it's always > 0 and later this value "-1" is used
for example for generation of device name. And instead of "xsa" it will
be "xs'" (ASCII "'" is "a" - 1). Which I believe is not expected.

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
---
 drivers/block/xsysace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 1f38643..32cc0a1 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1154,7 +1154,7 @@ static int ace_probe(struct platform_device *dev)
 {
 	resource_size_t physaddr = 0;
 	int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard coded */
-	u32 id = dev->id;
+	int id = dev->id;
 	int irq = 0;
 	int i;
 
-- 
1.7.10.4

