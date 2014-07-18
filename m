Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbaGRHOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:14:51 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:65519 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaGRHOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:14:49 -0400
From: matwey@sai.msu.ru
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, gnomes@lxorguk.ukuu.org.uk, matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCHv4 2/2] parport: parport_pc: Implement CPU model check to cut off false-positives
Date: Fri, 18 Jul 2014 11:12:55 +0400
Message-Id: <1405667575-3291-3-git-send-email-matwey@sai.msu.ru>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1405667575-3291-1-git-send-email-matwey@sai.msu.ru>
References: <1405667575-3291-1-git-send-email-matwey@sai.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>

The code in intel_bug_present is known to produce much false-positives.
It is believed that the affected by the bug hardware are used with either Intel 80486 or Pentium.

Perform the check only when the kernel configured as CONFIG_X86_32,
then use cpuinfo_x86 of the first available CPU to check the model
and run initial check code.

Suggested-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Tested-by: Heiko Andreas Sommer <hsommer@eso.org>
Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/parport/parport_pc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index a6eaafb..6b28f9f 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -65,6 +65,7 @@
 #include <linux/parport_pc.h>
 #include <linux/via.h>
 #include <asm/parport.h>
+#include <asm/processor.h>
 
 #define PARPORT_PC_MAX_PORTS PARPORT_MAX
 
@@ -1702,7 +1703,11 @@ static int parport_ECP_supported(struct parport *pb)
 }
 #endif
 
-static int intel_bug_present(struct parport *pb)
+/*  It is believed that CPU model correlates with buggy LPT chipset model.
+    Here we check that or CPU is elder than Pentium Pro: either 80486 or Pentium.
+    If it is then we perform The Check. */
+#ifdef CONFIG_X86_32
+static int intel_bug_present_check_epp(struct parport *pb)
 {
 	const struct parport_pc_private *priv = pb->private_data;
 	int bug_present = 0;
@@ -1725,6 +1730,20 @@ static int intel_bug_present(struct parport *pb)
 
 	return bug_present;
 }
+static int intel_bug_present(struct parport *pb)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (c->x86_vendor == X86_VENDOR_INTEL && (c->x86 == 4 || c->x86 == 5))
+		return intel_bug_present_check_epp(pb);
+	return 0;
+}
+#else
+static int intel_bug_present(struct parport *pb)
+{
+	return 0;
+}
+#endif
 
 static int parport_ECPPS2_supported(struct parport *pb)
 {
-- 
1.8.1.4

