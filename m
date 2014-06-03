Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaFCL7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:59:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbaFCLmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 087/138] target: Don't allow setting WC emulation if device doesn't support
Date: Tue,  3 Jun 2014 12:38:53 +0100
Message-Id: <1401795584-22664-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

commit 07b8dae38b09bcfede7e726f172e39b5ce8390d9 upstream.

Just like for pSCSI, if the transport sets get_write_cache, then it is
not valid to enable write cache emulation for it. Return an error.

see https://bugzilla.redhat.com/show_bug.cgi?id=1082675

Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 717d35b4d123..2640f2c65329 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -796,10 +796,10 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 		pr_err("emulate_write_cache not supported for pSCSI\n");
 		return -EINVAL;
 	}
-	if (dev->transport->get_write_cache) {
-		pr_warn("emulate_write_cache cannot be changed when underlying"
-			" HW reports WriteCacheEnabled, ignoring request\n");
-		return 0;
+	if (flag &&
+	    dev->transport->get_write_cache) {
+		pr_err("emulate_write_cache not supported for this device\n");
+		return -EINVAL;
 	}
 
 	dev->dev_attrib.emulate_write_cache = flag;
-- 
1.9.1

