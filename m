Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaK0R4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:56:13 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52328 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaK0Rzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:55:53 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org, andrew@lunn.ch,
        s.hauer@pengutronix.de
Subject: [PATCH v3 3/3] of: support passing console options with stdout-path
Date: Thu, 27 Nov 2014 17:56:07 +0000
Message-Id: <1417110967-16284-4-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support specifying console options (like with console=ttyXN,<options>)
by appending them to the stdout-path property after a separating ':'.

Example:
        stdout-path = "uart0:115200";

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/of/base.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7f0e5f7..6d2d45e 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -37,6 +37,7 @@ EXPORT_SYMBOL(of_allnodes);
 struct device_node *of_chosen;
 struct device_node *of_aliases;
 struct device_node *of_stdout;
+static const char *of_stdout_options;
 
 struct kset *of_kset;
 
@@ -1844,7 +1845,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 		if (IS_ENABLED(CONFIG_PPC) && !name)
 			name = of_get_property(of_aliases, "stdout", NULL);
 		if (name)
-			of_stdout = of_find_node_by_path(name);
+			of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
 	}
 
 	if (!of_aliases)
@@ -1968,9 +1969,13 @@ EXPORT_SYMBOL_GPL(of_prop_next_string);
  */
 bool of_console_check(struct device_node *dn, char *name, int index)
 {
+	char *console_options;
+
 	if (!dn || dn != of_stdout || console_set_on_cmdline)
 		return false;
-	return !add_preferred_console(name, index, NULL);
+
+	console_options = kstrdup(of_stdout_options, GFP_KERNEL);
+	return !add_preferred_console(name, index, console_options);
 }
 EXPORT_SYMBOL_GPL(of_console_check);
 
-- 
1.7.10.4

