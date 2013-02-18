Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3BRVTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 16:19:30 -0500
Received: from mail.tpi.com ([70.99.223.143]:1956 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab3BRVT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 16:19:29 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH linux-next] =?UTF-8?q?firewire:=20fw=5Fdevice=5Finit:=20=E2=80=98minor=E2?= =?UTF-8?q?=80=99=20may=20be=20used=20uninitialized?=
Date: Mon, 18 Feb 2013 14:19:03 -0700
Message-Id: <1361222343-112898-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'firewire: convert to idr_alloc()' accidentally orphaned 'minor'.

drivers/firewire/core-device.c: In function ‘fw_device_init’:
drivers/firewire/core-device.c:1029:24: warning: ‘minor’ may be used uninitialized in this function [-Wuninitialized]

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

If this patch is correct, then it also ought to go to stable
if it misses 3.8 final.

 drivers/firewire/core-device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index b946330..03ce7d9 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -1017,10 +1017,11 @@ static void fw_device_init(struct work_struct *work)
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	ret = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS, GFP_KERNEL);
+	minor = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS,
+			GFP_KERNEL);
 	up_write(&fw_device_rwsem);
 
-	if (ret < 0)
+	if (minor < 0)
 		goto error;
 
 	device->device.bus = &fw_bus_type;
-- 
1.7.9.5

