Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaH0IJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:09:57 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60975 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaH0IJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:09:22 -0400
From: matwey@sai.msu.ru
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCHv5 2/2] parport: parport_pc: Implement architecture and device check to cut off false-positives
Date: Wed, 27 Aug 2014 12:07:44 +0400
Message-Id: <1409126864-2615-3-git-send-email-matwey@sai.msu.ru>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1409126864-2615-1-git-send-email-matwey@sai.msu.ru>
References: <1409126864-2615-1-git-send-email-matwey@sai.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>

We definitely know that only x86 (32-bit) architecture is affected by the issue, so implement a stub instead of the actual check for other architectures.

We also know that motherboard LPT chipset is affected, so the port is either come from
  parport_pc_init (when `io' module param is used) or
  parport_pc_find_isa_ports (when default LPT ports are probbed: 0x378, 0x278, 0x3bc).
In both cases the port considered as 'legacy' and `dev' member of struct parport is NULL. See also comments for `struct parport' in parport.h

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/parport/parport_pc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index fedc06b..5b27747 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1702,7 +1702,8 @@ static int parport_ECP_supported(struct parport *pb)
 }
 #endif
 
-static int intel_bug_present(struct parport *pb)
+#ifdef CONFIG_X86_32
+static int intel_bug_present_check_epp(struct parport *pb)
 {
 	const struct parport_pc_private *priv = pb->private_data;
 	int bug_present = 0;
@@ -1725,6 +1726,21 @@ static int intel_bug_present(struct parport *pb)
 
 	return bug_present;
 }
+static int intel_bug_present(struct parport *pb)
+{
+/* Check whether the device is legacy, not PCI or PCMCIA. Only legacy is known to be affected. */
+	if (pb->dev != NULL) {
+		return 0;
+	}
+
+	return intel_bug_present_check_epp(pb);
+}
+#else
+static int intel_bug_present(struct parport *pb)
+{
+	return 0;
+}
+#endif /* CONFIG_X86_32 */
 
 static int parport_ECPPS2_supported(struct parport *pb)
 {
-- 
1.8.1.4

